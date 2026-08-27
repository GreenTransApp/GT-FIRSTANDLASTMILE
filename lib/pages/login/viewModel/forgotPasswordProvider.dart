import 'package:flutter/material.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/login/repository/loginRepository.dart';

enum ForgotPasswordStatus {
  initial,
  loading,
  mobileValidated,
  otpSent,
  passwordUpdated,
  error
}

class ForgotPasswordProvider extends ChangeNotifier {
  final Loginrepository _repo = Loginrepository();

  ForgotPasswordStatus _status = ForgotPasswordStatus.initial;
  ForgotPasswordStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  UserCredsModel? _userCredsResponse;
  UserCredsModel? get userCredsResponse => _userCredsResponse;

  ValidateLoginwithOtpModel? _otpResponse;
  ValidateLoginwithOtpModel? get otpResponse => _otpResponse;

  int? _updatePasswordResponse;
  int? get updatePasswordResponse => _updatePasswordResponse;

  void _setStatus(ForgotPasswordStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = ForgotPasswordStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    if (_status == ForgotPasswordStatus.error) {
      _status = ForgotPasswordStatus.initial;
    }
    notifyListeners();
  }

  void resetState() {
    _userCredsResponse = null;
    _otpResponse = null;
    _updatePasswordResponse = null;
    _errorMessage = null;
    _status = ForgotPasswordStatus.initial;
    notifyListeners();
  }

  Future<void> validateUserMobileFromD2D(Map<String, String> params) async {
    _setStatus(ForgotPasswordStatus.loading);
    _errorMessage = null;
    try {
      _userCredsResponse = await _repo.validateUserMobileFromD2D(params);
      _setStatus(ForgotPasswordStatus.mobileValidated);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> validateLoginWithOtp(Map<String, String> params) async {
    _setStatus(ForgotPasswordStatus.loading);
    _errorMessage = null;
    try {
      _otpResponse = await _repo.validateLoginWithOtp(params);
      _setStatus(ForgotPasswordStatus.otpSent);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> updatePassword(Map<String, String> params) async {
    _setStatus(ForgotPasswordStatus.loading);
    _errorMessage = null;
    try {
      _updatePasswordResponse = await _repo.updatePassword(params);
      _setStatus(ForgotPasswordStatus.passwordUpdated);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
