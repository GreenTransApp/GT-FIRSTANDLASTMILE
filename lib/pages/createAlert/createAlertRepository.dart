import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/pages/login/models/UpdatePasswordModel.dart';

import '../../common/commonResponse.dart' show CommonResponse;
import '../../service/connectionCheckService.dart';
import 'models/notificationDetailModel.dart';

class CreateAlertRepository extends BaseRepository {
  StreamController<List<NotificationDetailModel>> notiDetailListLiveData =
      StreamController();
  StreamController<CommonUpdateModel> addCommentLiveData = StreamController();

  Future<void> getNotificationDetail(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp =
          await apiGet("${bookingUrl}GetNotificationDetails", params);
      viewDialog.add(false);

      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        for (final entry in entries) {
          if (entry.key == "Table") {
            List<dynamic> list1 = entry.value;
            List<NotificationDetailModel> resultList = List.generate(
                list1.length,
                (index) => NotificationDetailModel.fromJson(list1[index]));
            notiDetailListLiveData.add(resultList);
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

  Future<void> addComment(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPost("${bookingUrl}CreateAlerts", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list = entry.value;
              List<CommonUpdateModel> resultList = List.generate(list.length,
                  (index) => CommonUpdateModel.fromJson(list[index]));
              if (resultList.isNotEmpty) {
                addCommentLiveData.add(resultList[0]);
              }
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
