import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/model/consignmentModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/model/manifestModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/model/tripOrderSummaryModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';
import 'package:retrofit/retrofit.dart';

class TripOrderSummaryRepository extends BaseRepository {
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
  StreamController<TripOrderSummaryModel> tripOrderSummary = StreamController();

  Future<void> getOrdersList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp = await apiGet("${lmdUrl}getOrderSummary", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          List<dynamic> list = table.values.first;
          TripOrderSummaryModel tripOrderSummaryModel = TripOrderSummaryModel();
          for (final entry in entries) {
            if (entry.key == 'Table') {
              List<dynamic> list = entry.value;
              List<ConsignmentModel> resultList = List.generate(list.length,
                  (index) => ConsignmentModel.fromJson(list[index]));
              tripOrderSummaryModel.consignments = resultList;
            } else if (entry.key == 'Table1') {
              List<dynamic> list = entry.value;
              List<ManifestModel> resultList = List.generate(
                  list.length, (index) => ManifestModel.fromJson(list[index]));
              tripOrderSummaryModel.manifests = resultList;
            }
          }

          // ConsignmentModel tripOrdersList = resultList[0];

          // if () {
          tripOrderSummary.add(tripOrderSummaryModel);
          // }
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
