import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/reversePickup/model/reversePickupModel.dart';
import 'package:gtlmd/pages/reversePickup/model/reversePickupResultModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class ReversePickupRepository extends BaseRepository {
  StreamController<ReversePickupModel> reversePickupLiveData =
      StreamController();
  StreamController<ReversePickupResultModel> saveReversePickupLiveData =
      StreamController();
  StreamController<String> verifySkuLiveData = StreamController();
  StreamController<List<ReasonModel>> reasonLiveData = StreamController();

  Future<void> getReversePickup(Map<String, String> params) async {
    // Implement the logic to fetch reverse pickup data
    // and return the result.
    // You can use http requests or any other method to get the data.
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${lmdUrl}GetReversePickupDetail", params);
        debugPrint("Response: ${resp.dataSet}");
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;

          List<ReversePickupModel> resultList = List.generate(
              list.length, (index) => ReversePickupModel.fromJson(list[index]));
          if (resultList.isEmpty) {
            isErrorLiveData.add("No Data Found");
          } else {
            if (resultList.first.commandstatus == -1) {
              isErrorLiveData.add(resultList.first.commandmessage!);
            } else {
              reversePickupLiveData.add(resultList.first);
            }
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } catch (e) {
        isErrorLiveData.add(e.toString());
      } finally {
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> saveReversePickup(Map<String, String> params) async {
    // Implement the logic to save reverse pickup data
    // and return the result.
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        CommonResponse resp = await apiPost("${lmdUrl}SaveReversePickup",
            params); // SP Name : GTLMD_updateReversePickup
        viewDialog.add(false);
        debugPrint("Response: $resp");
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<ReversePickupResultModel> resultList = List.generate(list.length,
              (index) => ReversePickupResultModel.fromJson(list[index]));
          ReversePickupResultModel result = resultList.first;
          if (result.commandstatus == 1) {
            saveReversePickupLiveData.add(result);
          } else {
            isErrorLiveData.add(result.commandmessage.toString());
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } catch (e) {
        isErrorLiveData.add(e.toString());
      } finally {
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getReasonList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp = await apiGet("${lmdUrl}getPodLovs", params);
      viewDialog.add(false);

      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        for (final entry in entries) {
          if (entry.key == "Table1") {
            List<dynamic> list1 = entry.value;
            List<ReasonModel> resultList = List.generate(
                list1.length, (index) => ReasonModel.fromJson(list1[index]));
            reasonLiveData.add(resultList);
          }
        }
      } else {
        isErrorLiveData.add(resp.commandMessage!);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
}
