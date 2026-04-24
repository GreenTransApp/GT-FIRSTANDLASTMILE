import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class PickupOtpRepository extends BaseRepository {
  StreamController<bool> isLoading = StreamController();
  StreamController<String> error = StreamController();
  StreamController<ValidateLoginwithOtpModel> validateOtp = StreamController();

  Future<void> validateLoginWithOtp(Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp =
          await apiGet("${lmdUrl}GetLoginOtpForValidate", params);

      if (resp.commandStatus != 1) {
        throw Exception(resp.commandMessage ?? "OTP validation failed");
      }

      Map<String, dynamic> table =
          await compute<String, dynamic>(jsonDecode, resp.dataSet.toString());
      List<dynamic> list = table.values.first;

      if (list.isEmpty) {
        error.add("Invalid response from server");
      }

      ValidateLoginwithOtpModel result =
          ValidateLoginwithOtpModel.fromJson(list[0]);

      if (result.commandstatus != 1) {
        throw Exception(result.commandmessage ?? "OTP validation failed");
      }

      validateOtp.add(result);
    } on SocketException {
      error.add("No Internet");
    } catch (err) {
      debugPrint('Error in validateLoginWithOtp: $err');
      error.add(err.toString());
    }
  }
}
