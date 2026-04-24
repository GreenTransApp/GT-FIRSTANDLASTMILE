import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/pickupOtp/pickupOtpRepository.dart';

class PickupOtpViewModel extends BaseViewModel {
  final PickupOtpRepository _repo = PickupOtpRepository();
  StreamController<bool> isLoading = StreamController();
  StreamController<String> error = StreamController();
  StreamController<ValidateLoginwithOtpModel> validateOtp = StreamController();

  PickupOtpViewModel() {
    validateOtp = _repo.validateOtp;
    error = _repo.error;
    isLoading = _repo.isLoading;
  }

  void validateLoginWithOtp(Map<String, String> params) {
    _repo.validateLoginWithOtp(params);
  }
}
