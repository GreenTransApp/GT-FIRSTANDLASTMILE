import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/mapView/models/MapRouteModel.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigDetailModel.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigJsonModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class MapViewRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<MapRouteModel>> mapRouteList = StreamController();
  StreamController<AllotedRouteModel> routeDetail = StreamController();
  StreamController<MapConfigDetailModel> mapConfigDetail = StreamController();

  Future<void> getMapRouteDetails(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp =
            await apiGet("${lmdUrl}/getMapRouteDetails", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list1 = entry.value;
              List<MapRouteModel> resultList = List.generate(list1.length,
                  (index) => MapRouteModel.fromJson(list1[index]));
              mapRouteList.add(resultList);
            } else if (entry.key == "Table1") {
              List<dynamic> list2 = entry.value;
              List<AllotedRouteModel> resultList = List.generate(list2.length,
                  (index) => AllotedRouteModel.fromJson(list2[index]));
              routeDetail.add(resultList[0]);
            } else if (entry.key == "Table2") {
              try {
                List<dynamic> list2 = entry.value;
                List<MapConfigDetailModel> resultList = List.generate(
                    list2.length,
                    (index) => MapConfigDetailModel.fromJson(list2[index]));

                // var data = resultList;
                mapConfigDetail.add(resultList[0]);
              } catch (e) {
                debugPrint("Error parsing Table2: $e");
              }
            }
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
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
