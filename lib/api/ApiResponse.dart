

import 'dart:convert';

import 'package:gtlmd/common/toast.dart';

import '../common/commonResponse.dart';
import 'Status.dart';

// class ApiResponse<T> {
//   //Coming from eum class
//   Status? status;
//   //Dynamic function to take the data
//   T? response;
//   //message
//   String? message;
//   //constructor
//   ApiResponse(this.status, this.response, this.message);

//   //If data is loading then it'll take loading from status enum
//   ApiResponse.loading() : status = Status.loading;
//   ApiResponse.completed(this.response) : status = Status.completed;
//   ApiResponse.error(this.message) : status = Status.error;
//   //Override method
//   @override
//   String toString() {
//     return "commandstatus : $status \n commandmessage : $message \n dataSet: $response";
//   }
// }

class ApiResponse {
  static ApiResult<Map<String, dynamic>> get(
    CommonResponse response, {
    bool showError = true,
  }) {
    if (response.commandStatus != 1) {
      final message = response.commandMessage?.isNotEmpty == true
          ? response.commandMessage!
          : "Something went wrong";

      if (showError) {
        failToast(message);
      }

      return ApiResult(
        success: false,
        errorMessage: message,
      );
    }

    try {
      if (response.dataSet == null ||
          response.dataSet.toString().isEmpty) {
        const message = "DATA NOT AVAILABLE";

        if (showError) {
          failToast(message);
        }

        return ApiResult(
          success: false,
          errorMessage: message,
        );
      }

      final Map<String, dynamic> resultData =
          jsonDecode(response.dataSet.toString());

      if (resultData.isEmpty) {
        const message = "DATA NOT AVAILABLE";

        if (showError) {
          failToast(message);
        }

        return ApiResult(
          success: false,
          errorMessage: message,
        );
      }

      // Check commandstatus inside Table
      final table = resultData["Table"];

      if (table is List && table.isNotEmpty) {
        final firstRow =
            Map<String, dynamic>.from(table.first);

        final commandStatus = firstRow["commandstatus"];

        if (commandStatus != 1 && commandStatus != null) {
          final message =
              firstRow["commandmessage"]?.toString() ??
                  "Something went wrong";

          if (showError) {
            failToast(message);
          }

          return ApiResult(
            success: false,
            errorMessage: message,
          );
        }
      }

      return ApiResult(
        success: true,
        data: resultData,
      );
    } catch (e) {
      const message = "Invalid server response";

      if (showError) {
        failToast(message);
      }

      return ApiResult(
        success: false,
        errorMessage: message,
      );
    }
  }
}


class ApiResult<T> {
  final bool success;
  final T? data;
  final String? errorMessage;

  ApiResult({
    required this.success,
    this.data,
    this.errorMessage,
  });
}