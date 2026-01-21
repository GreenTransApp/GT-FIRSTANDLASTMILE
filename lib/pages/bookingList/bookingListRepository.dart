import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/bookingList/isolates.dart';
import 'package:gtlmd/pages/bookingList/model/BookingListModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class BookingListRepository {
  Future<List<BookingListModel>> GetBookingList(
      Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp = await apiGet("${lmdUrl}BookingSearchList", params);
      if (resp.commandStatus != 1) {
        throw Exception(resp.commandMessage ?? "List failed");
      }

      if (resp.commandStatus == 1 && resp.dataSet != null) {
        List<BookingListModel> resultList =
            await compute(parseBookingListIsolate, resp.dataSet!);
        return resultList;
      } else {
        return [];
      }
    } catch (err) {
      debugPrint('Error in Booking SearchList: $err');
      rethrow;
    }
  }
}
