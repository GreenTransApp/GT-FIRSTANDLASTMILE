import 'package:flutter/material.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/pages/login/repository/loginRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

enum LoginWithOtpStatus {
  initial,
  loading,
  mobileValidated,
  otpSent,
  otpVerified,
  validatedFromD2d,
  companyValidated,
  divisionValidated,
  error
}

class LoginWithOtpProvider extends ChangeNotifier {
  final Loginrepository _repo = Loginrepository();

  LoginWithOtpStatus _status = LoginWithOtpStatus.initial;
  LoginWithOtpStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ValidateLoginwithOtpModel? _otpResponse;
  ValidateLoginwithOtpModel? get otpResponse => _otpResponse;

  UserCredsModel? _userCredsResponse;
  UserCredsModel? get userCredsResponse => _userCredsResponse;

  UpsertTripResponseModel? _divisionResponse;
  UpsertTripResponseModel? get divisionResponse => _divisionResponse;

  LoginModel? _loginResponse;
  LoginModel? get loginResponse => _loginResponse;

  UserModel? _userResponse;
  UserModel? get userResponse => _userResponse;

  void _setStatus(LoginWithOtpStatus status) {
    _status = status;
    notifyListeners();
  }

  void clearStatus() {
    _otpResponse = null;
    _errorMessage = null;
    _userCredsResponse = null;
    _status = LoginWithOtpStatus.initial;
    notifyListeners();
  }

  void _setError(String? errorMessage) {
    _errorMessage = errorMessage;
    _status = LoginWithOtpStatus.error;
    notifyListeners();
  }

  Future<void> validateUserMobileFromD2D(Map<String, String> params) async {
    _setStatus(LoginWithOtpStatus.loading);
    _errorMessage = null;
    try {
      _userCredsResponse = await _repo.validateUserMobileFromD2D(params);
      _setStatus(LoginWithOtpStatus.mobileValidated);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateLoginWithOtp(Map<String, String> params) async {
    _setStatus(LoginWithOtpStatus.loading);
    _errorMessage = null;
    try {
      _otpResponse = await _repo.validateLoginWithOtp(params);
      _setStatus(LoginWithOtpStatus.otpSent);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> loginUser(Map<String, String> params) async {
    _setStatus(LoginWithOtpStatus.loading);
    try {
      _loginResponse = await _repo.userLogin(params);
      _setStatus(LoginWithOtpStatus.validatedFromD2d);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateUserForLogin(Map<String, String> params) async {
    _setStatus(LoginWithOtpStatus.loading);
    try {
      _userResponse = await _repo.validateUserLogin(params);
      _setStatus(LoginWithOtpStatus.companyValidated);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateDivision(Map<String, String> params) async {
    _setStatus(LoginWithOtpStatus.loading);
    try {
      _divisionResponse = await _repo.validateDivision(params);
      _setStatus(LoginWithOtpStatus.divisionValidated);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
