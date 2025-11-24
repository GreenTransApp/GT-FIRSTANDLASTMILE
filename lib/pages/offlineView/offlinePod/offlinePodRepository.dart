import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/model/podEntryOfflineRespModel.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class OfflinePodRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  StreamController<UpdateDeliveryModel> savePodOfflineLiveData =
      StreamController();
  StreamController<List<PodEntryOFflineRespModel>> existingGr =
      StreamController();

  Future<void> savePodEntryOffline(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp = await apiPost("${lmdUrl}SavePodOffline", params);
        viewDialog.add(false);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              // List<dynamic> list = table.values.first;
              List<dynamic> list = entry.value;
              List<UpdateDeliveryModel> resultList = List.generate(list.length,
                  (index) => UpdateDeliveryModel.fromJson(list[index]));
              // UpdateDeliveryModel response = resultList[0];
              // if (response.commandstatus == 1) {
              savePodOfflineLiveData.add(resultList[0]);
              // } else {
              //   isErrorLiveData.add(resp.commandMessage!);
              // }
            } else if (entry.key == "Table1") {
              List<dynamic> list = entry.value;
              List<PodEntryOFflineRespModel> response = List.generate(
                  list.length,
                  (index) => PodEntryOFflineRespModel.fromJson(list[index]));
              existingGr.add(response);
            }
          }
        } else {
          isErrorLiveData.add(resp.commandMessage.toString());
        }
      } catch (err) {
        viewDialog.add(false);
        isErrorLiveData.add(err.toString());
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
}
