import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';

import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class DeliveryRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<DeliveryDetailModel>> deliveryDetailList =
      StreamController();
  StreamController<CurrentDeliveryModel> deliveryData = StreamController();
  Future<void> getDeliveryDetails(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp =
            await apiGet("${lmdUrl}/getDeliveryDetail", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list1 = entry.value;
              List<DeliveryDetailModel> resultList = List.generate(list1.length,
                  (index) => DeliveryDetailModel.fromJson(list1[index]));
              deliveryDetailList.add(resultList);
            } else if (entry.key == "Table1") {
              List<dynamic> list2 = entry.value;
              List<CurrentDeliveryModel> resultList = List.generate(
                  list2.length,
                  (index) => CurrentDeliveryModel.fromJson(list2[index]));
              deliveryData.add(resultList[0]);
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
