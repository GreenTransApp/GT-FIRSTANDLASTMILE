import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';

import 'package:gtlmd/optionMenu/deliveryPerformance/model/deliveryPerformanceModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

import '../../api/HttpCalls.dart';

class DeliveryPerformanceRepository extends BaseRepository {
  StreamController<DeliveryPerformanceModel> performanceLiveData =
      StreamController();
  StreamController<bool> viewDialog = StreamController();

  Future<void> getDeliveryPerformanceData(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPostWithModel("${lmdUrl}GetLMDLiveData", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list = entry.value;
              List<UpsertTripResponseModel> resultList = List.generate(
                  list.length,
                  (index) => UpsertTripResponseModel.fromJson(list[index]));
              if (resultList.isNotEmpty &&
                  resultList.first.commandstatus == -1) {
                isErrorLiveData.add(resultList.first.commandmessage.toString());
              }
            }
            if (entry.key == "Table7") {
              List<dynamic> list2 = entry.value;
              List<DeliveryPerformanceModel> resultList = List.generate(
                  list2.length,
                  (index) => DeliveryPerformanceModel.fromJson(list2[index]));

              if (resultList.isNotEmpty) {
                performanceLiveData.add(resultList[0]);
              }
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
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
}
