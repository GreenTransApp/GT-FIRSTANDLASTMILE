import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/unDelivery/actionModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class UnDeliveryRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  // StreamController<UnDeliveryModel> unDeliveryLiveData = StreamController();
  StreamController<List<ReasonModel>> reasonLiveData = StreamController();
  StreamController<List<ActionModel>> actionLiveData = StreamController();

  StreamController<UpdateDeliveryModel> saveUnDeliveryList = StreamController();
  // StreamController<UpdateDeliveryModel> saveUnDeliveryOfflineList =
  //     StreamController();
  // StreamController<List<String>> drsWtihExistingPod = StreamController();

  void getReasons(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp =
          await apiGet("${manifestBaseUrl}GetReasonAndAction", params);
      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        List<ReasonModel> reasonList = [];
        List<ActionModel> actionList = [];

        for (final entry in entries) {
          if (entry.key == 'Table') {
            List<dynamic> reasonTable = entry.value;
            for (final reason in reasonTable) {
              debugPrint('Reason: ${reason}');
              reasonList.add(ReasonModel.fromJson(reason));
            }
          } else if (entry.key == 'Table1') {
            List<dynamic> actionTable = entry.value;
            for (final action in actionTable) {
              debugPrint('Action: ${action}');
              actionList.add(ActionModel.fromJson(action));
            }
          }
        }

        reasonLiveData.add(reasonList);
        actionLiveData.add(actionList);
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  // void updateDelivery(Map<String, String> params) {}

  Future<void> updateUndelivery(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp = await apiPost("${lmdUrl}UpdateUndelivery", params);
      viewDialog.add(false);
      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        List<dynamic> list = table.values.first;
        List<UpdateDeliveryModel> resultList = List.generate(
            list.length, (index) => UpdateDeliveryModel.fromJson(list[index]));
        UpdateDeliveryModel validateResponse = resultList[0];
        // ValidateDeviceModel.fromJson(resultList[0]);
        if (validateResponse.commandstatus == 1) {
          saveUnDeliveryList.add(resultList[0]);
        } else {
          isErrorLiveData.add(validateResponse.commandmessage!);
        }
      } else {
        isErrorLiveData.add(resp.commandMessage.toString());
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
    // saveUnDeliveryLiveData.add(resp);
  }

  // Future<void> updateUndeliveryOffline(Map<String, dynamic> params) async {
  //   viewDialog.add(true);
  //   CommonResponse resp =
  //       await apiPost("${lmdUrl}UpdateUndeliveryOffline", params);
  //   viewDialog.add(false);
  //   if (resp.commandStatus == 1) {
  //     Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
  //     // List<dynamic> list = table.values.first;
  //     Iterable<MapEntry<String, dynamic>> entries = table.entries;
  //     for (final entry in entries) {
  //       if (entry.key == "Table") {
  //         List<dynamic> list = entry.value;
  //         // List<UpdateDeliveryModel> resultList = List.generate(list.length,
  //         //     (index) => UpdateDeliveryModel.fromJson(list[index]));
  //         UpdateDeliveryModel result = UpdateDeliveryModel.fromJson(list[0]);
  //         saveUnDeliveryOfflineList.add(result);
  //         // print(resultList.length);
  //       } else if (entry.key == "Table1") {
  //         List<dynamic> list = entry.value;
  //         List<String> gr = [];
  //         List<String> resultList = List.generate(
  //             list.length, (index) => list[index]['grno'].toString());
  //         drsWtihExistingPod.add(resultList);
  //         print(resultList.length);
  //       }
  //     }

  //     // UpdateDeliveryModel validateResponse = resultList[0];
  //     // // ValidateDeviceModel.fromJson(resultList[0]);
  //     // if (validateResponse.commandstatus == 1) {
  //     //   saveUnDeliveryOfflineList.add(resultList[0]);
  //     // } else {
  //     //   isErrorLiveData.add(validateResponse.commandmessage!);
  //     // }
  //   } else {
  //     isErrorLiveData.add(resp.commandMessage.toString());
  //   }
  //   // saveUnDeliveryLiveData.add(resp);
  // }
}
