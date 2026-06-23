import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/attendance/models/punchInModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class RejectPickupRepository extends BaseRepository {
  StreamController<bool> isLoading = StreamController();
  StreamController<String> isError = StreamController();
  StreamController<PunchInModel> result = StreamController();
  StreamController<List<ReasonModel>> reasonLiveData =
      StreamController();
 Future<void> getReasons(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp = await apiGet("${lmdUrl}getPodLovs", params);
      viewDialog.add(false);

      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        for (final entry in entries) {
          if (entry.key == "Table2") {
            List<dynamic> list1 = entry.value;
            List<ReasonModel> resultList = List.generate(
                list1.length, (index) => ReasonModel.fromJson(list1[index]));
            reasonLiveData.add(resultList);
          }
        }
      } else {
        isErrorLiveData.add(resp.commandMessage!);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }


  Future<void> rejectPickup(Map<String, dynamic> params) async {
    isLoading.add(true);
    try {
      final response = await apiPostWithModel("${lmdUrl}RejectPickup", params);
      if (response.commandStatus != 1) {
        isError.add(isNullOrEmpty(response.commandMessage)
            ? "Something went wrong"
            : response.commandMessage.toString());
        return;
      }
      var decodedResponse = jsonDecode(response.dataSet.toString());
      var table = decodedResponse["Table"];
      var model = PunchInModel.fromJson(table[0]);
      result.add(model);
      isLoading.add(false);
    } catch (error) {
      isLoading.add(false);
      isError.add(error.toString());
    }
  }
}
