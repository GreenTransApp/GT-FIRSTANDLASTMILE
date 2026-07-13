import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/lastActiveTripModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class UpdateMidMileDriverPositionRepository extends BaseRepository {
  StreamController<UpsertTripResponseModel> updateTripInfoLiveData =
      StreamController();
  StreamController<UpsertTripResponseModel> updateStartTripLiveData =
      StreamController();
  StreamController<UpsertTripResponseModel> updateCloseTripLiveData =
      StreamController();
  StreamController<LastActiveTripModel> lastTripInfo = StreamController();
  StreamController<bool> loadingDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
StreamController<PunchoutModel> hubvehicleArrivalData = StreamController();

  void updateDriverReached(Map<String, String> params) async {
    loadingDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp = await apiPostWithModel(
            "${lmdUrl}UpdateMidMileDriverPosition", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          UpsertTripResponseModel validateResponse =
              UpsertTripResponseModel.fromJson(list[0]);
          if (validateResponse.commandstatus == 1) {
            updateStartTripLiveData.add(validateResponse);
          } else {
            errorDialog.add(validateResponse.commandmessage!);
          }
        } else {
          errorDialog.add(resp.commandMessage.toString());
        }
        loadingDialog.add(false);
      } on SocketException catch (error) {
        debugPrint(error.toString());
        errorDialog.add("No Internet");
        loadingDialog.add(false);
      } catch (err) {
        errorDialog.add(err.toString());
        loadingDialog.add(false);
      }
      loadingDialog.add(false);
    } else {
      loadingDialog.add(false);
      errorDialog.add("No Internet available");
    }
  }

 Future<void> UpdateVehicleArrivalWithOutstanding(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      CommonResponse resp = await apiPostWithModel(
          "${lmdUrl}VehicleArrivalWithOutstading", params);
      viewDialog.add(false);
      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        List<dynamic> list = table.values.first;
        List<PunchoutModel> resultList = List.generate(
            list.length, (index) => PunchoutModel.fromJson(list[index]));
        PunchoutModel response = resultList[0];

        if (response.commandstatus == 1) {
          hubvehicleArrivalData.add(resultList[0]);
        } else {
          viewDialog.add(false);
          isErrorLiveData.add(response.commandmessage ?? "Data Not Found");
        }
      } else {
        viewDialog.add(false);
        isErrorLiveData.add(resp.commandMessage.toString());
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
   
}
