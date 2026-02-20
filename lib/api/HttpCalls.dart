import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/api/model/ApiCallParametersModel.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/debug.dart';
import 'package:gtlmd/common/utils.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:http/http.dart' as http;

String companyId = "71727374";
const imageBaseUrl = URL.imageBaseUrl;
const baseUrl = URL.baseUrl;
// const imageBaseUrl = "https://greentrans.in:446/";
// const baseUrl = "https://greentrans.in:444/API";
// const baseUrl = "http://192.168.1.226:45459/API";
// const baseUrl = "http://192.168.1.226:45473/API";
const pwaBaseUrl = "$baseUrl/PWAAPI/";
const loginBaseUrl = "$baseUrl/Home/";
const homeBaseUrl = "$baseUrl/HomeAPI/";
const reportUrl = "$baseUrl/ReportsAPI/";
const bookingUrl = "$baseUrl/BookingAPI/";
const manifestBaseUrl = "$baseUrl/ManifestAPI/";
const podBaseUrl = "$baseUrl/PODAPI/";
const dashboardBaseUrl = "$baseUrl/GreenTransDashBoard/";
const hrBaseUrl = "$baseUrl/HR/";
const inScanBaseUrl = "$baseUrl/InscanAPI/";
const deliveryDashboardBaseUrl = "$baseUrl/DeliveryDashboard/";
const misBaseUrl = "$baseUrl/MIS/";
const fleetBaseUrl = "$baseUrl/FLEET/";
const accountUrl = "$baseUrl/Account/";
const voucherEntryUrl = "$baseUrl/VoucherEntryAPI/";
const customerAppUrl = "$baseUrl/LxCustomerApp/";
const jeenaAPIUrl = "$baseUrl/JeenaAPI/";
const bikerUrl = "$baseUrl/Biker/";
const crmUrl = "$baseUrl/CRMPORTALAPI/";
const lmdUrl = "$baseUrl/LMDAPI/";

/// Service class to handle API interactions
class ApiService {
  // Singleton instance
  static final ApiService _instance = ApiService._internal();

  static ApiService get instance => _instance;

  ApiService._internal();

  // Timeout duration for API calls
  static const Duration _timeout = Duration(seconds: 120);

  /// Performs a GET request
  Future<CommonResponse> get(String apiName, Map<String, String> params) async {
    debugPrint('ApiService.get Called: $apiName');

    try {
      // Use Uri constructor for safe parameter encoding
      final uri = Uri.parse(apiName).replace(queryParameters: params);

      final response = await http.get(uri).timeout(_timeout);

      if (response.statusCode == 200) {
        // Offload JSON decoding to a background isolate
        final json = await compute(_parseJson, response.body);
        return CommonResponse.fromJson(json);
      } else {
        throw Exception(
            'Failed to Get Data: StatusCode ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService.get Error: $e');
      rethrow;
    }
  }

  /// Performs a POST request
  Future<CommonResponse> post(
      String apiName, Map<String, dynamic> params) async {
    debugPrint('ApiService.post Called: $apiName');

    try {
      final response = await http
          .post(
            Uri.parse(apiName),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            // jsonEncode is relatively fast, but for very large bodies could also be computed.
            // Keeping it on main thread for now as it's usually smaller than response.
            body: jsonEncode(params),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        // Offload JSON decoding to a background isolate
        final json = await compute(_parseJson, response.body);
        return CommonResponse.fromJson(json);
      } else {
        throw Exception(
            'Failed to Post Data: StatusCode ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('ApiService.post Error: $e');
      rethrow;
    }
  }

  Future<CommonResponse> postWithCommonModel(
    String url,
    Map<String, dynamic> params, {
    String spNameToCall = "",
  }) async {
    try {
      final UserModel userData = await getUserData();
      final LoginModel userLoginData = await getLoginData();

      final ApiCallParametersModel parameters = ApiCallParametersModel(
        companyId: userData.companyid.toString(),
        parameters: params,
        userCode: userData.usercode ?? "",
        loginBranchCode: userData.loginbranchcode ?? "",
        sessionId: userData.sessionid,
        spName: spNameToCall,
      );

      final apiResponse = await post(url, parameters.toJson());
      return apiResponse;
    } catch (e) {
      rethrow;
    }
  }

  // Static function for compute to call
  static dynamic _parseJson(String jsonString) {
    return jsonDecode(jsonString);
  }
}

// ---------------------------------------------------------------------------
// Legacy Wrappers (Backward Compatibility)
// ---------------------------------------------------------------------------

Future<CommonResponse> apiGet(
    String apiName, Map<String, String> params) async {
  return ApiService.instance.get(apiName, params);
}

Future<CommonResponse> apiPost(
    String apiName, Map<String, dynamic> params) async {
  return ApiService.instance.post(apiName, params);
}

Future<CommonResponse> apiPostWithModel(
    String apiName, Map<String, dynamic> params) async {
  return ApiService.instance.postWithCommonModel(apiName, params);
}

// Example
/*  GET REQUEST
    Map<String, String> params = {
      "prmconnstring": "71727374",
      "prmmobileno": "789789797987"
    };
    CommonResponse resp = await apiGet(homeBaseUrl+"getUserLastLocation", params);
*/
/* POST REQUEST
    Map<String, String> params = {
      "prmusername": usernameController.text,
      "prmpassword": passwordController.text,
      "prmappversion": appVersion,
      "prmappversiondt": appVersionDate,
      "prmdevicedt": appVersionDate,
      "prmdeviceid": ""
    };
    CommonResponse resp = await apiPost("${loginBaseUrl}ValidateLogin", params);
*/
