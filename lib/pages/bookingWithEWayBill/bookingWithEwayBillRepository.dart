import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/validateEwayBillModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class BookingWithEwayBillRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<ValidateEwayBillModel>> validateEwayBillList =
      StreamController();
  Future<void> getEwayBillCreds(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPostWithModel("${lmdUrl}GetEwayBillCreds", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          try {
            for (final entry in entries) {
              if (entry.key == "Table") {
                List<dynamic> list = entry.value;
                List<ValidateEwayBillModel> resultList = List.generate(
                    list.length,
                    (index) => ValidateEwayBillModel.fromJson(list[index]));
                if (resultList.isNotEmpty &&
                    resultList.first.commandstatus == -1) {
                  isErrorLiveData
                      .add(resultList.first.commandmessage.toString());
                  validateEwayBillList.add(resultList);
                }
              }
            }
          } catch (err) {
            isErrorLiveData.add(err.toString());
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
