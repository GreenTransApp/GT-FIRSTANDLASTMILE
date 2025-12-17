import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/commonResponse.dart';
// import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/login/models/companySelectionModel.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/service/authenticationService.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class Loginrepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<LoginModel> loginResponseLiveData = StreamController();
  StreamController<UserModel> validateUserLiveData = StreamController();
  StreamController<ValidateLoginwithOtpModel> validateOtp = StreamController();
  StreamController<UserCredsModel> userCredsList = StreamController();
  StreamController<int> updatePasswordList = StreamController();

  StreamController<List<CompanySelectionModel>> companyList =
      StreamController();
  // final authService = AuthenticationService();
  Future<void> userLogin(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        debugPrint('userLogin');
        debugPrint('API Called');
        CommonResponse response =
            await apiPost("${loginBaseUrl}ValidateLogin", params);
        if (response.commandStatus == 1) {
          List<dynamic> table = await compute<String, dynamic>(
              jsonDecode, response.dataSet.toString());
          debugPrint('JSON Decode completed:');
          LoginModel loginResponse = LoginModel.fromJson(table[0]);
          debugPrint('Login resp - ${jsonEncode(loginResponse)}');
          if (loginResponse.commandstatus == 1) {
            debugPrint('Login Response code is 1');
            saveInStorageLogin = jsonEncode(table[0]);
            authService.storagePush(ENV.loginPrefTag, saveInStorageLogin!);
            authService.isAuthenticated.add(true);
            debugPrint('Login creds saved in local storage');
            savedLogin = loginResponse;
            debugPrint('live data updated');
            Map<String, String> offlineCreds = {
              ENV.offlineLoginIdTag: loginResponse.username.toString(),
              ENV.offlineLoginPassTag: loginResponse.password.toString(),
            };
            authService.storagePush(
                ENV.offlineLoginCredsTag, jsonEncode(offlineCreds));
            loginResponseLiveData.add(loginResponse);
          } else {
            isErrorLiveData.add(loginResponse.commandmessage!);
          }
        } else {
          isErrorLiveData.add(response.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (_) {
        isErrorLiveData.add("No internet connection");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> validateUserLogin(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      CommonResponse resp =
          await apiPost("${loginBaseUrl}ValidateUserLogin", params);
      viewDialog.add(false);
      if (resp.commandStatus == 1) {
        List<dynamic> table =
            await compute<String, dynamic>(jsonDecode, resp.dataSet.toString());
        UserModel validateduserResp = UserModel.fromJson(table[0]);
        saveInStorageUser = jsonEncode(table[0]);
        if (validateduserResp.commandstatus == 1) {
          authService.storagePush(ENV.userPrefTag, saveInStorageUser!);
          debugPrint("Saved In Storage as ' User '");
          savedUser = validateduserResp;
          validateUserLiveData.add(validateduserResp);
        } else {
          isErrorLiveData.add(validateduserResp.commandmessage!);
        }
      } else {
        isErrorLiveData.add(resp.commandMessage!);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> validateLoginWithOtp(Map<String, String> params) async {
    debugPrint("validate login with otp login repo ${params}");
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);
        debugPrint("validate login with otp api called");
        CommonResponse resp =
            await apiGet("${lmdUrl}GetLoginOtpForValidate", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = await compute<String, dynamic>(
              jsonDecode, resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          debugPrint("validate login with otp list: ${list}");
          List<ValidateLoginwithOtpModel> resultList = List.generate(
              list.length,
              (index) => ValidateLoginwithOtpModel.fromJson(list[index]));
          ValidateLoginwithOtpModel validateResponse = resultList[0];

          if (validateResponse.commandstatus == 1) {
            validateOtp.add(resultList[0]);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (err) {
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

  Future<void> validateUserMobileFromD2D(Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiPost("${loginBaseUrl}ValidatedUserMobileNoFomD2d", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = await compute<String, dynamic>(
              jsonDecode, resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<UserCredsModel> resultList = List.generate(
              list.length, (index) => UserCredsModel.fromJson(list[index]));
          UserCredsModel validateResponse = resultList[0];
          // ValidateDeviceModel.fromJson(resultList[0]);
          if (validateResponse.commandstatus == 1) {
            userCredsList.add(resultList[0]);
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (err) {
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

  Future<void> UpdatePassword(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiPost("${loginBaseUrl}ChangePassword", params);
        viewDialog.add(false);
        if (resp.commandStatus == 1) {
          updatePasswordList.add(resp.commandStatus!.toInt());
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
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
