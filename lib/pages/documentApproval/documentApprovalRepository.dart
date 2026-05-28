import 'dart:async';
import 'dart:convert';

import 'package:gtlmd/base/BaseRepository.dart';

import 'package:gtlmd/pages/documentApproval/model/documentApprovalModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

import '../../api/HttpCalls.dart';
import '../../common/commonResponse.dart';

class DocumentApprovalRepository extends BaseRepository {
  StreamController<List<DocumentApprovalModel>> docApprovalLiveData =
      StreamController();

  Future<void> getDocApprovalList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp = await apiPostWithModel(
          "${jinniUrl}GTJI_DocApproval_SearchList", params);
      viewDialog.add(false);

      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        for (final entry in entries) {
          if (entry.key == "Table1") {
            List<dynamic> list1 = entry.value;
            List<DocumentApprovalModel> resultList = List.generate(list1.length,
                (index) => DocumentApprovalModel.fromJson(list1[index]));
            docApprovalLiveData.add(resultList);
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
