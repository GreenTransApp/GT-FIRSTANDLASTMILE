import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/podEntry/Model/podEntryModel.dart';
import 'package:gtlmd/pages/podEntry/podRelationModel.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class PodEntryRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<PodEntryModel> podEntryLiveData = StreamController();
  StreamController<List<PodRelationsModel>> podRelationLiveData =
      StreamController();
  StreamController<List<ReasonModel>> podDamageReasonLiveData =
      StreamController();

  StreamController<UpdateDeliveryModel> savePodLiveData = StreamController();
  // StreamController<UpdateDeliveryModel> savePodOfflineLiveData =
  //     StreamController();

  Future<void> getPodEntry(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${lmdUrl}getPodEntryDetail", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;

          List<PodEntryModel> resultList = List.generate(
              list.length, (index) => PodEntryModel.fromJson(list[index]));
          PodEntryModel response = resultList[0];

          if (response.commandstatus == 1) {
            podEntryLiveData.add(resultList[0]);
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

  Future<void> savePodEntry(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp = await apiPost("${lmdUrl}SavePod", params);
      viewDialog.add(false);
      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        List<dynamic> list = table.values.first;
        List<UpdateDeliveryModel> resultList = List.generate(
            list.length, (index) => UpdateDeliveryModel.fromJson(list[index]));
        UpdateDeliveryModel response = resultList[0];

        if (response.commandstatus == 1) {
          savePodLiveData.add(resultList[0]);
        } else {
          viewDialog.add(false);
          isErrorLiveData.add(resp.commandMessage!);
        }
      } else {
        viewDialog.add(false);
        isErrorLiveData.add(resp.commandMessage.toString());
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getPodLovs(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      CommonResponse resp = await apiGet("${lmdUrl}getPodLovs", params);
      viewDialog.add(false);

      if (resp.commandStatus == 1) {
        Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
        Iterable<MapEntry<String, dynamic>> entries = table.entries;
        for (final entry in entries) {
          if (entry.key == "Table") {
            List<dynamic> list1 = entry.value;
            List<PodRelationsModel> resultList = List.generate(list1.length,
                (index) => PodRelationsModel.fromJson(list1[index]));
            podRelationLiveData.add(resultList);
          } else if (entry.key == "Table1") {
            List<dynamic> list1 = entry.value;
            List<ReasonModel> resultList = List.generate(
                list1.length, (index) => ReasonModel.fromJson(list1[index]));
            podDamageReasonLiveData.add(resultList);
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
