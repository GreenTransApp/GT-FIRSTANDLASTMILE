import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class ClosedDrsRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<CurrentDeliveryModel>> closedDrsList =
      StreamController();

  Future<void> getClosedDrsList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp = await apiGet("${lmdUrl}/GetClosedDrs", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list1 = entry.value;
              List<CurrentDeliveryModel> resultList = List.generate(
                  list1.length,
                  (index) => CurrentDeliveryModel.fromJson(list1[index]));
              closedDrsList.add(resultList);
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
