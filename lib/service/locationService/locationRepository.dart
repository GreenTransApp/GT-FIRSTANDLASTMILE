 import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/login/models/UpdatePasswordModel.dart';

class LocationRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
 StreamController<CommonUpdateModel> updatedLocationLiveData =
      StreamController();

  Future<void> upsertDriverLocation(Map<String, String> params) async {
    viewDialog.add(true);
    try {
      CommonResponse response =
          await apiPost("${lmdUrl}UpdateDriverLiveLocation", params);
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
        List<CommonUpdateModel> resultList = List.generate(list.length,
            (index) => CommonUpdateModel.fromJson(list[index]));
         updatedLocationLiveData.add(resultList[0]);
      } catch (error) {
        isErrorLiveData.add(error.toString());
      }
    } catch (error) {
      isErrorLiveData.add(error.toString());
    }
  }

 }