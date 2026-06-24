import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/pages/consignmentEnquiry/model/consignmentEnquiryModel.dart';
import 'package:gtlmd/pages/consignmentEnquiry/model/consignmentImageModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

import '../../common/commonResponse.dart' show CommonResponse;

class  ConsignmentEnquiryRepository  extends BaseRepository {
    StreamController<ConsignmentEnquiryModel> consignData = StreamController();
    StreamController<List<ConsignmentImageModel>> consignImgData = StreamController();


     Future<void> consignmentEnquiry(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPostWithModel("${lmdUrl}ConsignmentEnquiry", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          try {
            for (final entry in entries) {
              if (entry.key == "Table") {
                List<dynamic> list2 = entry.value;
                List<ConsignmentEnquiryModel> resultList = List.generate(list2.length,
                    (index) => ConsignmentEnquiryModel.fromJson(list2[index]));
                consignData.add(resultList[0]);
              } else if (entry.key == "Table1") {
                List<dynamic> list2 = entry.value;
                List<ConsignmentImageModel> resultList = List.generate(list2.length,
                    (index) => ConsignmentImageModel.fromJson(list2[index]));
                consignImgData.add(resultList);
              }
            }
          } catch (err) {
            isErrorLiveData.add(err.toString());
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