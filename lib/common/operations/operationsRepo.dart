import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/operations/isolates.dart';
import 'package:gtlmd/common/operations/models/operationsModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class OperationsRepository extends BaseRepository {
  Future<List<OperationsModel>> getOperationsList(
      Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp = await apiGet("${lmdUrl}OperationsMenu", params);
      if (resp.commandStatus != 1) {
        throw Exception(resp.commandMessage ?? "Operations fetch failed");
      }

      if (resp.commandStatus == 1 && resp.dataSet != null) {
        List<OperationsModel> resultList =
            await compute(parseOperationsListIsolate, resp.dataSet!);
        return resultList;
      } else {
        return [];
      }
    } catch (err) {
      debugPrint('Error in OperationsRepo: $err');
      rethrow;
    }
  }

  Future<OperationsModel?> getSingleOperation(
      Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp = await apiGet("${lmdUrl}GetPageLink", params);
      if (resp.commandStatus != 1) {
        throw Exception(resp.commandMessage ?? "Single Operation fetch failed");
      }

      if (resp.commandStatus == 1 && resp.dataSet != null) {
        // OperationsModel? result =
        //     await compute(parseSingleOperationIsolate, resp.dataSet!);
        Map<String, dynamic> table =
            await compute<String, dynamic>(jsonDecode, resp.dataSet.toString());
        List<dynamic> list = table.values.first;
        OperationsModel result = OperationsModel.fromJson(list[0]);

        return result;
      } else {
        return null;
      }
    } catch (err) {
      debugPrint('Error in getSingleOperation: $err');
      rethrow;
    }
  }
}
