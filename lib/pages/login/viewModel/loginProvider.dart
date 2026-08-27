import 'package:flutter/material.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/pages/login/repository/loginRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

enum LoginStatus {
  initial,
  loading,
  validatedFromD2d,
  companyValidated,
  divisionValidated,
  error
}

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

  dynamic selectedDivision;

  void _setStatus(LoginStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    _status = LoginStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == LoginStatus.error) {
      _status = LoginStatus.initial;
    }
    notifyListeners();
  }

  void resetState() {
    _loginResponse = null;
    _userResponse = null;
    _divisionResponse = null;
    selectedDivision = null;
    _errorMessage = null;
    _status = LoginStatus.initial;
    notifyListeners();
  }

  Future<void> loginUser(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    _errorMessage = null;
    try {
      _loginResponse = await _repo.userLogin(params);
      _setStatus(LoginStatus.validatedFromD2d);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateUserForLogin(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    _errorMessage = null;
    try {
      _userResponse = await _repo.validateUserLogin(params);
      _setStatus(LoginStatus.companyValidated);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateDivision(Map<String, String> params) async {
    _setStatus(LoginStatus.loading);
    _errorMessage = null;
    try {
      _divisionResponse = await _repo.validateDivision(params);
      _setStatus(LoginStatus.divisionValidated);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
