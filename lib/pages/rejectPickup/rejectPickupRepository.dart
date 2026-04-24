import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/attendance/models/punchInModel.dart';

class RejectPickupRepository extends BaseRepository {
  StreamController<bool> isLoading = StreamController();
  StreamController<String> isError = StreamController();
  StreamController<PunchInModel> result = StreamController();

  Future<void> rejectPickup(Map<String, dynamic> params) async {
    isLoading.add(true);
    try {
      final response = await apiPost("${lmdUrl}RejectPickup", params);
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
