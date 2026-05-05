import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/reminderList/models/reminderLIstModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

import '../../api/HttpCalls.dart';

class ReminderListRepository extends BaseRepository {
  StreamController<List<ReminderListModel>> reminderListLiveData =
      StreamController();

  Future<void> getReminderList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp =
          await apiGet("${bookingUrl}GetDashbordNotification", params);
      viewDialog.add(false);

      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        for (final entry in entries) {
          if (entry.key == "Table1") {
            List<dynamic> list1 = entry.value;
            List<ReminderListModel> resultList = List.generate(list1.length,
                (index) => ReminderListModel.fromJson(list1[index]));
            reminderListLiveData.add(resultList);
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
}
