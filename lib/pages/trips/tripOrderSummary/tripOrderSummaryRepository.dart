import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummaryModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class TripOrderSummaryRepository extends BaseRepository {
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
  StreamController<List<TripOrderSummaryModel>> ordersList = StreamController();

  Future<void> getOrdersList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${lmdUrl}GetOrdersForTripSummary", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<TripOrderSummaryModel> resultList = List.generate(list.length,
              (index) => TripOrderSummaryModel.fromJson(list[index]));
          TripOrderSummaryModel tripOrdersList = resultList[0];
          if (tripOrdersList.commandstatus == 1) {
            ordersList.add(resultList);
          }
        } else {
          errorDialog.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (_) {
        errorDialog.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        errorDialog.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      errorDialog.add("No Internet available");
    }
  }
}
