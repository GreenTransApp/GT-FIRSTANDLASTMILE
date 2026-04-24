import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/models/punchInModel.dart';
import 'package:gtlmd/pages/rejectPickup/rejectPickupRepository.dart';

class RejectPickupViewModel extends BaseViewModel {
  RejectPickupRepository repository = RejectPickupRepository();
  StreamController<bool> isLoading = StreamController();
  StreamController<String> isError = StreamController();
  StreamController<PunchInModel> result = StreamController();

  RejectPickupViewModel() {
    isLoading = repository.isLoading;
    isError = repository.isError;
    result = repository.result;
  }

  Future<void> rejectPickup(Map<String, dynamic> params) async {
    await repository.rejectPickup(params);
  }
}
