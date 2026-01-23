import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/grList_old/model/grListModel_old.dart';

class GrListRepository_old {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<GrListModel_old>> grListLiveData = StreamController();

  Future<void> getGrList(Map<String, String> params) async {
    viewDialog.add(true);
    CommonResponse resp = await apiGet("${homeBaseUrl}pendingForDrs", params);
    viewDialog.add(false);
    if (resp.commandStatus == 1) {
      Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<GrListModel_old> resultList = List.generate(
          list.length, (index) => GrListModel_old.fromJson(list[index]));
      GrListModel_old validateResponse = resultList[0];
      if (validateResponse.commandstatus == 1) {
        // storagePush(ENV.userPrefTag, saveInStorageUser!);
        // debugPrint("Saved In Storage as ' User '");
        // savedUser = validateduserResp;
        grListLiveData.add(resultList);
      } else {
        isErrorLiveData.add(validateResponse.commandmessage!);
      }
    } else {
      isErrorLiveData.add(resp.commandMessage!);
    }
  }
}
