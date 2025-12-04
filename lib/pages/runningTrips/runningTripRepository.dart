import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class RunningTripRepository extends BaseRepository {
  StreamController<List<TripModel>> tripsListData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  Future<void> getTripsList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp = await apiGet("${lmdUrl}getTripsList", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<TripModel> resultList = List.generate(
              list.length, (index) => TripModel.fromJson(list[index]));
          TripModel validateResponse = resultList[0];
          // ValidateDeviceModel.fromJson(resultList[0]);
          if (validateResponse.commandstatus == 1) {
            tripsListData.add(resultList);
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
}
