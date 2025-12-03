import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';

import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/home/Model/UpdateTripResponseModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class UpdateTripInfoRepository extends BaseRepository {
  StreamController<UpsertTripResponseModel> updateTripInfoLiveData =
      StreamController();

  void updateTripInfo(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPost("${lmdUrl}updateTripStatus", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          // List<UpdateTripRespModel> resultList = List.generate(list.length,
          //     (index) => UpdateTripRespModel.fromJson(list[index]));

          UpsertTripResponseModel validateResponse =
              UpsertTripResponseModel.fromJson(list[0]);
          // ValidateDeviceModel.fromJson(resultList[0]);
          if (validateResponse.commandstatus == 1) {
            updateTripInfoLiveData.add(validateResponse);
          } else {
            isErrorLiveData.add(validateResponse.commandmessage!);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage.toString());
        }
        viewDialog.add(false);
      } on SocketException catch (error) {
        debugPrint(error.toString());
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
