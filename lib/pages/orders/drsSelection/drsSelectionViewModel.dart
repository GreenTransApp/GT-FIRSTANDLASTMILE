import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

class DrsSelectionViewModel extends BaseViewModel {
  final DrsSelectionRepository _repository = DrsSelectionRepository();

  StreamController<UpsertTripResponseModel> upsertTripLiveData =
      StreamController<UpsertTripResponseModel>();

  DrsSelectionViewModel() {
    upsertTripLiveData = _repository.upsertTripLiveData;
  }

  void upsertTrip(Map<String, String> params) {
    _repository.upsertTrip(params);
  }

  void getDrsList(Map<String, String> params) {
    _repository.getDrsList(params);
  }
}
