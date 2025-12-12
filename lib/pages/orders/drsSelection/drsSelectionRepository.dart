import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/ApiResponse.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Utils.dart';

import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/orders/drsSelection/model/DrsListModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';
import 'package:http/http.dart';

class DrsSelectionRepository extends BaseRepository {
  StreamController<UpsertTripResponseModel> upsertTripLiveData =
      StreamController();

  StreamController<List<DrsListModel>> drsListLiveData = StreamController();

  Future<void> upsertTrip(Map<String, String> params) async {
    viewDialog.add(true);
    try {
      CommonResponse response =
          await apiPost("${lmdUrl}UpsertTripDetail", params);
      viewDialog.add(false);
      if (response.commandStatus != 1) {
        isErrorLiveData.add(isNullOrEmpty(response.commandMessage)
            ? "Something went wrong"
            : response.commandMessage!);
        return;
      }

      // List<dynamic> table = jsonDecode(response.dataSet.toString());
      try {
        Map<String, dynamic> table = jsonDecode(response.dataSet.toString());
        List<dynamic> list = table.values.first;
        List<UpsertTripResponseModel> resultList = List.generate(list.length,
            (index) => UpsertTripResponseModel.fromJson(list[index]));

        upsertTripLiveData.add(resultList[0]);
      } catch (error) {
        isErrorLiveData.add(error.toString());
      }
    } catch (error) {
      isErrorLiveData.add(error.toString());
    }
  }

  Future<void> getDrsListV2(Map<String, String> params) async {
    // viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        // CommonResponse resp = await apiGet("${lmdUrl}/GetDrsListV2", params);
        CommonResponse resp = await apiGet("$lmdUrl/GetDrsListV2", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list2 = entry.value;
              List<DrsListModel> resultList = List.generate(
                  list2.length, (index) => DrsListModel.fromJson(list2[index]));
              drsListLiveData.add(resultList);
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
}
