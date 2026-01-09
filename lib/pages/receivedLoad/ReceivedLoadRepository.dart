import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailUpdateModel.dart';

import 'package:gtlmd/service/connectionCheckService.dart';

import 'package:gtlmd/api/HttpCalls.dart';

import '../../base/BaseRepository.dart';

class ReceivedLoadRepository extends BaseRepository {
  StreamController<RouteUpdateModel> routeAcceptList = StreamController();
  StreamController<bool> loadingDialog = StreamController();

  Future<void> updateDetailOnAccept(Map<String, String> params) async {
    loadingDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPost("${lmdUrl}AcceptRouteWithConsignmentNo", params);
        loadingDialog.add(false);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<RouteUpdateModel> resultList = List.generate(
              list.length, (index) => RouteUpdateModel.fromJson(list[index]));
          RouteUpdateModel response = resultList[0];

          if (response.commandstatus == 1) {
            routeAcceptList.add(resultList[0]);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        loadingDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        loadingDialog.add(false);
      }
      // loadingDialog.add(false);
    } else {
      loadingDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
}
