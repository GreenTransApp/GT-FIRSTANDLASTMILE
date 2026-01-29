import 'package:flutter/material.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/pages/login/repository/loginRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

enum LoginStatus { initial, loading, success, error }

class LoginProvider extends ChangeNotifier {
  final Loginrepository _repo = Loginrepository();

  LoginStatus _status = LoginStatus.initial;
  LoginStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  LoginModel? _loginResponse;
  LoginModel? get loginResponse => _loginResponse;

  UserModel? _userResponse;
  UserModel? get userResponse => _userResponse;

  UpsertTripResponseModel? _divisionResponse;
  UpsertTripResponseModel? get divisionResponse => _divisionResponse;

  ValidateLoginwithOtpModel? _otpResponse;
  ValidateLoginwithOtpModel? get otpResponse => _otpResponse;

  UserCredsModel? _userCredsResponse;
  UserCredsModel? get userCredsResponse => _userCredsResponse;

  int? _updatePasswordResponse;
  int? get updatePasswordResponse => _updatePasswordResponse;

  dynamic selectedDivision;

  void _clearResults() {
    _loginResponse = null;
    _userResponse = null;
    _otpResponse = null;
    _userCredsResponse = null;
    _updatePasswordResponse = null;
    _divisionResponse = null;
  }

  void _setStatus(LoginStatus status) {
    if (status == LoginStatus.loading) {
      _clearResults();
      _errorMessage = null;
    }
    _status = status;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    if (message != null) {
      _status = LoginStatus.error;
    }
    notifyListeners();
  }

  Future<void> loginUser(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    try {
      _loginResponse = await _repo.userLogin(params);
      _setStatus(LoginStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateUserForLogin(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    try {
      _userResponse = await _repo.validateUserLogin(params);
      _setStatus(LoginStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateLoginWithOtp(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    try {
      _otpResponse = await _repo.validateLoginWithOtp(params);
      _setStatus(LoginStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateUserMobileFromD2D(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    try {
      _userCredsResponse = await _repo.validateUserMobileFromD2D(params);
      _setStatus(LoginStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updatePassword(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    try {
      _updatePasswordResponse = await _repo.updatePassword(params);
      _setStatus(LoginStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateDivision(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    try {
      _divisionResponse = await _repo.validateDivision(params);
      _setStatus(LoginStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void clearError() {
    _errorMessage = null;
    if (_status == LoginStatus.error) {
      _status = LoginStatus.initial;
    }
    notifyListeners();
  }

  void resetState() {
    _clearResults();
    _errorMessage = null;
    _status = LoginStatus.initial;
    notifyListeners();
  }

  void clearUserResponse() {
    _userResponse = null;
    notifyListeners();
  }

  void clearDivisionResponse() {
    _divisionResponse = null;
    notifyListeners();
  }

  void clearLoginResponse() {
    _loginResponse = null;
    notifyListeners();
  }

  void clearUserCredsResponse() {
    _userCredsResponse = null;
    notifyListeners();
  }
}
