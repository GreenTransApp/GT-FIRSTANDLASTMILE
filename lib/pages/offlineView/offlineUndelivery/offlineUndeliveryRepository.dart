import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class OfflineUndeliveryRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<UpdateDeliveryModel> saveUnDeliveryOfflineList =
      StreamController();
  StreamController<List<String>> drsWtihExistingPod = StreamController();

  Future<void> updateUndeliveryOffline(Map<String, dynamic> params) async {
    viewDialog.add(true);

    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp =
          await apiPost("${lmdUrl}UpdateUndeliveryOffline", params);
      viewDialog.add(false);
      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        // List<dynamic> list = table.values.first;
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        for (final entry in entries) {
          if (entry.key == "Table") {
            List<dynamic> list = entry.value;
            // List<UpdateDeliveryModel> resultList = List.generate(list.length,
            //     (index) => UpdateDeliveryModel.fromJson(list[index]));
            UpdateDeliveryModel result = UpdateDeliveryModel.fromJson(list[0]);
            saveUnDeliveryOfflineList.add(result);
            // print(resultList.length);
          } else if (entry.key == "Table1") {
            List<dynamic> list = entry.value;
            List<String> gr = [];
            List<String> resultList = List.generate(
                list.length, (index) => list[index]['grno'].toString());
            drsWtihExistingPod.add(resultList);
            print(resultList.length);
          }
        }

        // UpdateDeliveryModel validateResponse = resultList[0];
        // // ValidateDeviceModel.fromJson(resultList[0]);
        // if (validateResponse.commandstatus == 1) {
        //   saveUnDeliveryOfflineList.add(resultList[0]);
        // } else {
        //   isErrorLiveData.add(validateResponse.commandmessage!);
        // }
      } else {
        isErrorLiveData.add(resp.commandMessage.toString());
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
    // saveUnDeliveryLiveData.add(resp);
  }
}
