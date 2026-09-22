import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/midmile/midMileTripList/midMileTripListModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class MidMileTripListRepository extends BaseRepository {
  final StreamController<List<MidMileTripListModel>> midMileTripsList =
      StreamController();
  final StreamController<PunchoutModel> updateTripStart = StreamController();
  final StreamController<bool> loadingDialog = StreamController();
  final StreamController<String> errorDialog = StreamController();
    StreamController<MidMileTripListModel> validateTripData =
      StreamController();

  getMidMileTripsList(Map<String, String> params) async {
    loadingDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("$lmdUrl/getMidMileTripsList", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list1 = entry.value;
              List<MidMileTripListModel> resultList = List.generate(
                  list1.length,
                  (index) => MidMileTripListModel.fromJson(list1[index]));
              if (resultList.isNotEmpty) {
                midMileTripsList.add(resultList);
              } else {
                midMileTripsList.add([]);
              }
            }
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

  void ValidateTripBeforeStart(Map<String, String> params) async {
    loadingDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp = await apiPostWithModel("${lmdUrl}ValidateMidMileTripBeforeStartTrip", params);

        loadingDialog.add(false);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          MidMileTripListModel validateResponse =
              MidMileTripListModel.fromJson(list[0]);
          if (validateResponse.commandstatus == 1) {
            validateTripData.add(validateResponse);
          } else {
            errorDialog.add(validateResponse.commandmessage!);
          }
        } else {
          errorDialog.add(resp.commandMessage.toString());
        }
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
}
