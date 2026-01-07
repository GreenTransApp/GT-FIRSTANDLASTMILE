import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';

import 'package:gtlmd/optionMenu/tripMis/Model/tripMisModel.dart';
import 'package:gtlmd/optionMenu/tripMis/tripMis.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

import '../../common/commonResponse.dart';

class TripMisRepository extends BaseRepository {
  StreamController<List<TripMisModel>> tripsListData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  Future<void> getTripMIS(Map<String, dynamic> params) async {
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
            if (entry.key == "Table4") {
              List<dynamic> list2 = entry.value;
              List<TripMisModel> resultList = List.generate(
                  list2.length, (index) => TripMisModel.fromJson(list2[index]));

              // var data = resultList;
              tripsListData.add(resultList);
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
