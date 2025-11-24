import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/login/models/companySelectionModel.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/pages/login/repository/loginRepository.dart';

class LoginViewModel extends BaseViewModel {
  final Loginrepository _repo = Loginrepository();
  StreamController<LoginModel> loginResponseLiveData =
      StreamController<LoginModel>();
  StreamController<List<CompanySelectionModel>> companyListLiveData =
      StreamController();
  StreamController<UserModel> userResponse = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<UserModel> validateUserLoginLiveData = StreamController();
  StreamController<ValidateLoginwithOtpModel> validateOtpLiveData =
      StreamController();
  StreamController<UserCredsModel> userCredsLiveData = StreamController();
  StreamController<int> updatePasswordLiveData = StreamController();
  LoginViewModel() {
    isErrorLiveData = _repo.isErrorLiveData;
    viewDialog = _repo.viewDialog;
    loginResponseLiveData = _repo.loginResponseLiveData;
    validateUserLoginLiveData = _repo.validateUserLiveData;
    // validateLiveData = _repo.validateUserLiveData;
    validateOtpLiveData = _repo.validateOtp;
    userCredsLiveData = _repo.userCredsList;
    // companyListLiveData = _repo.companyList;
    updatePasswordLiveData = _repo.updatePasswordList;
  }

  loginUser(Map<String, String> params) {
    _repo.userLogin(params);
  }

  loginUserAtStart(Map<String, String> params) {
    _repo.userLogin(params);
  }

  validateUserForLogin(Map<String, String> params) async {
    _repo.validateUserLogin(params);
    // UserModel apiResponse = await _repo.validateUserLogin(params);
  }

  validateLoginWithOtp(Map<String, String> params) async {
    debugPrint("validate login with otp called view model");
    _repo.validateLoginWithOtp(params);
  }

  validateUserMobileFromD2D(Map<String, String> params) async {
    _repo.validateUserMobileFromD2D(params);
  }

  UpdatePassword(Map<String, String> params) async {
    _repo.UpdatePassword(params);
  }
}
