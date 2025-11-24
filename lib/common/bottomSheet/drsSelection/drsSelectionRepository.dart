import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/ApiResponse.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/bottomSheet/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:http/http.dart';

class DrsSelectionRepository extends BaseRepository {
  StreamController<UpsertTripResponseModel> upsertTripLiveData =
      StreamController();

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
}
