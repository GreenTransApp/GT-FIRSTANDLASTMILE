import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/home/isolates.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/Model/UpdateTripResponseModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/home/Model/validateDeviceModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class HomeRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  StreamController<List<AllotedRouteModel>> routeDashboardList =
      StreamController();
  StreamController<List<CurrentDeliveryModel>> deliveryDashboardList =
      StreamController();
  StreamController<List<CurrentDeliveryModel>> activeDrsList =
      StreamController();
  StreamController<AttendanceModel> attendanceList = StreamController();
  StreamController<ValidateDeviceModel> validateDeviceList = StreamController();
  StreamController<DrsDateTimeUpdateModel> drsDateTimeUpdate =
      StreamController();
  StreamController<List<TripModel>> tripsLiveData = StreamController();

  Future<void> getDashBoardDetails(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp =
            await apiGet("$lmdUrl/getDashboardDetailsV2", params);
        if (resp.commandStatus == 1) {
          final Map<String, dynamic> table = await compute(
              parseDashboardDetailIsolate, resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list1 = entry.value;
              List<AttendanceModel> resultList = List.generate(list1.length,
                  (index) => AttendanceModel.fromJson(list1[index]));
              attendanceList.add(resultList[0]);
            }
            // else if (entry.key == "Table1") {
            //   List<dynamic> list2 = entry.value;
            //   List<AllotedRouteModel> resultList = List.generate(list2.length,
            //       (index) => AllotedRouteModel.fromJson(list2[index]));
            //   if (resultList.isEmpty) {
            //     routeDashboardList.add([]);
            //   } else {
            //     routeDashboardList.add(resultList);
            //   }
            // }
            //  else if (entry.key == "Table2") {
            //   List<dynamic> list2 = entry.value;
            //   List<CurrentDeliveryModel> resultList = List.generate(
            //       list2.length,
            //       (index) => CurrentDeliveryModel.fromJson(list2[index]));

            //   if (resultList.isNotEmpty) {
            //     deliveryDashboardList.add(resultList);
            //   } else {
            //     deliveryDashboardList.add([]);
            //   }
            // }
            else if (entry.key == "Table1") {
              List<dynamic> list2 = entry.value;
              List<TripModel> resultList = List.generate(
                  list2.length, (index) => TripModel.fromJson(list2[index]));
              if (resultList.isNotEmpty) {
                tripsLiveData.add(resultList);
              } else {
                tripsLiveData.add([]);
              }
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

  Future<void> getValidateDevice(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPost("${loginBaseUrl}ValidateDevice", params);

        if (resp.commandStatus == 1) {
          // Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          // List<dynamic> list = table.values.first;
          // List<ValidateDeviceModel> resultList = List.generate(list.length,
          //     (index) => ValidateDeviceModel.fromJson(list[index]));
          // ValidateDeviceModel validateResponse = resultList[0];
          final Map<String, dynamic> rawMap = await compute(
              parseValidateDeviceIsolate, resp.dataSet.toString());
          final ValidateDeviceModel validateResponse =
              ValidateDeviceModel.fromJson(rawMap);
          executiveid = validateResponse.executiveid;
          employeeid = validateResponse.employeeid;
          // ValidateDeviceModel.fromJson(resultList[0]);
          if (validateResponse.commandstatus == 1) {
            validateDeviceList.add(validateResponse);
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

// NOT USED AS OF NOW IN NEW FIRST MILE LAST MILE
  void updateDrsDateTime(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPost("${lmdUrl}updateDispatchDateTime", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<DrsDateTimeUpdateModel> resultList = List.generate(list.length,
              (index) => DrsDateTimeUpdateModel.fromJson(list[index]));
          DrsDateTimeUpdateModel validateResponse = resultList[0];
          // ValidateDeviceModel.fromJson(resultList[0]);
          if (validateResponse.commandstatus == 1) {
            drsDateTimeUpdate.add(resultList[0]);
          } else {
            isErrorLiveData.add(validateResponse.commandmessage!);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage.toString());
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
}
