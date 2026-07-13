import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/midMileTripDetailModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class MidMileTripDetailRepository extends BaseRepository {
  final StreamController<List<MidMileTripDetailModel>> tripDetailList =
      StreamController();
  final StreamController<bool> loadingDialog = StreamController();
  final StreamController<String> errorDialog = StreamController();
  StreamController<PunchoutModel> departedPositionData = StreamController();
  StreamController<PunchoutModel> vehicleArrivalData = StreamController();
  

  getMidMileTripsDetailList(Map<String, String> params) async {
    loadingDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${lmdUrl}GetMidMileTripDetail", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<MidMileTripDetailModel> resultList = List.generate(list.length,
              (index) => MidMileTripDetailModel.fromJson(list[index]));
          if (resultList.isNotEmpty) {
            tripDetailList.add(resultList);
          } else {
            tripDetailList.add([]);
          }
        } else {
          errorDialog.add(resp.commandMessage!);
        }
        loadingDialog.add(false);
      } on SocketException catch (_) {
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
  Future<void> updateMidMileDepartedPosition(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      CommonResponse resp = await apiPostWithModel(
          "${lmdUrl}UpdateMidMileDepartedPosition", params);
      viewDialog.add(false);
      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        List<dynamic> list = table.values.first;
        List<PunchoutModel> resultList = List.generate(
            list.length, (index) => PunchoutModel.fromJson(list[index]));
        PunchoutModel response = resultList[0];

        if (response.commandstatus == 1) {
          departedPositionData.add(resultList[0]);
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

  Future<void> UpdateVehicleArrival(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      CommonResponse resp = await apiPostWithModel(
          "${lmdUrl}UpdateMidMileVehicleArrival", params);
      viewDialog.add(false);
      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        List<dynamic> list = table.values.first;
        List<PunchoutModel> resultList = List.generate(
            list.length, (index) => PunchoutModel.fromJson(list[index]));
        PunchoutModel response = resultList[0];

        if (response.commandstatus == 1) {
          vehicleArrivalData.add(resultList[0]);
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
