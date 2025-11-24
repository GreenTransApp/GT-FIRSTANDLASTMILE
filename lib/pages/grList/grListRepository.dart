import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/grList/model/grListModel.dart';

class GrListRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<GrListModel>> grListLiveData = StreamController();

  Future<void> getGrList(Map<String, String> params) async {
    viewDialog.add(true);
    CommonResponse resp = await apiGet("${homeBaseUrl}pendingForDrs", params);
    viewDialog.add(false);
    if (resp.commandStatus == 1) {
      Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<GrListModel> resultList = List.generate(
          list.length, (index) => GrListModel.fromJson(list[index]));
      GrListModel validateResponse = resultList[0];
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
