import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

class DrsSelectionViewModel extends BaseViewModel {
  final DrsSelectionRepository _repository = DrsSelectionRepository();

  StreamController<UpsertTripResponseModel> upsertTripLiveData =
      StreamController<UpsertTripResponseModel>();
  StreamController<String> isErrorLiveData = StreamController<String>();

  DrsSelectionViewModel() {
    upsertTripLiveData = _repository.upsertTripLiveData;
    isErrorLiveData = _repository.isErrorLiveData;
  }

  void upsertTrip(Map<String, String> params) {
    _repository.upsertTrip(params);
  }

  void getDrsList(Map<String, String> params) {
    _repository.getDrsList(params);
  }
}
