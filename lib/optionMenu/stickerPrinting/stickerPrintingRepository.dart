import 'package:flutter/foundation.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/isolates.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/GrListModel.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/StickerModel.dart';

import 'package:gtlmd/service/connectionCheckService.dart';

class StickerPrintingRepository {
  Future<List<GrListModel>> GetGrList(Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp = await apiGet("${lmdUrl}GetAllocatedGrList", params);
      if (resp.commandStatus != 1) {
        throw Exception(resp.commandMessage ?? "List failed");
      }

      if (resp.commandStatus == 1 && resp.dataSet != null) {
        List<GrListModel> resultList =
            await compute(parseGrListIsolate, resp.dataSet!);
        return resultList;
      } else {
        return [];
      }
    } catch (err) {
      debugPrint('Error in Gr List: $err');
      rethrow;
    }
  }

  Future<List<StickerListModel>> GetStickerList(
      Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp = await apiGet("${lmdUrl}GetStickerList", params);
      if (resp.commandStatus != 1) {
        throw Exception(resp.commandMessage ?? "List failed");
      }

      if (resp.commandStatus == 1 && resp.dataSet != null) {
        List<StickerListModel> resultList =
            await compute(parseStickerListIsolate, resp.dataSet!);
        return resultList;
      } else {
        return [];
      }
    } catch (err) {
      debugPrint('Error in Sticker: $err');
      rethrow;
    }
  }
}
