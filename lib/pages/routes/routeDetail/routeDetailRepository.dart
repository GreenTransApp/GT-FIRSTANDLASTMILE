import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigDetailModel.dart';
import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailModel.dart';
import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailUpdateModel.dart';
import 'package:gtlmd/pages/routes/routeDetail/updateRoutePlanningModel.dart';

import 'package:gtlmd/service/connectionCheckService.dart';

class RouteDetailRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  StreamController<List<RouteDetailModel>> routeDetailList = StreamController();
  StreamController<RouteUpdateModel> routeAcceptList = StreamController();
  StreamController<RouteUpdateModel> routeRejectList = StreamController();
  StreamController<AllotedRouteModel> routeData = StreamController();
  StreamController<UpdateRoutePlanningModel> updateRoutePlanning =
      StreamController();
  StreamController<MapConfigDetailModel> mapConfigDetail = StreamController();
  
  Future<void> getRouteDetails(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp =
            await apiGet("${lmdUrl}/GetDlvRouteDetails", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list1 = entry.value;
              List<RouteDetailModel> resultList = List.generate(list1.length,
                  (index) => RouteDetailModel.fromJson(list1[index]));
              routeDetailList.add(resultList);
            } else if (entry.key == "Table1") {
              List<dynamic> list2 = entry.value;
              List<AllotedRouteModel> resultList = List.generate(list2.length,
                  (index) => AllotedRouteModel.fromJson(list2[index]));
              routeData.add(resultList[0]);
            }
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> updateDetailOnAccept(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPost("${lmdUrl}UpdateRouteOnAccept", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<RouteUpdateModel> resultList = List.generate(
              list.length, (index) => RouteUpdateModel.fromJson(list[index]));
          RouteUpdateModel response = resultList[0];

          if (response.commandstatus == 1) {
            routeAcceptList.add(resultList[0]);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> updateDetailOnReject(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPost("${lmdUrl}UpdateRouteOnReject", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<RouteUpdateModel> resultList = List.generate(
              list.length, (index) => RouteUpdateModel.fromJson(list[index]));
          RouteUpdateModel response = resultList[0];

          if (response.commandstatus == 1) {
            routeRejectList.add(resultList[0]);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> updateRoute(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp =
          await apiPost("${lmdUrl}updateRoutePlanning", params);
      viewDialog.add(false);
      try {
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<UpdateRoutePlanningModel> resultList = List.generate(list.length,
              (index) => UpdateRoutePlanningModel.fromJson(list[index]));
          UpdateRoutePlanningModel response = resultList[0];

          if (response.commandstatus == 1) {
            updateRoutePlanning.add(resultList[0]);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getMapConfig(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp = await apiGet("${lmdUrl}/getMapConfig", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list2 = entry.value;
              List<MapConfigDetailModel> resultList = List.generate(
                  list2.length,
                  (index) => MapConfigDetailModel.fromJson(list2[index]));

              // var data = resultList;
              mapConfigDetail.add(resultList[0]);
            }
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
}
