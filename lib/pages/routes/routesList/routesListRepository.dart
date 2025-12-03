import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class RouteslistRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<AllotedRouteModel>> routesListLiveData =
      StreamController();

  Future<void> getRoutesList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        CommonResponse resp = await apiGet("${lmdUrl}getRoutesList", params);
        viewDialog.add(false);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          // for (final entry in entries) {

          List<AllotedRouteModel> resultList = List.generate(
              list.length, (index) => AllotedRouteModel.fromJson(list[index]));
          if (resultList.isEmpty) {
            routesListLiveData.add([]);
          } else {
            routesListLiveData.add(resultList);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
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
