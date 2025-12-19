import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/model/DrsListModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

class DrsSelectionViewModel extends BaseViewModel {
  final DrsSelectionRepository _repository = DrsSelectionRepository();

  StreamController<UpsertTripResponseModel> upsertTripLiveData =
      StreamController<UpsertTripResponseModel>();
  StreamController<List<DrsListModel>> drsListLiveData =
      StreamController<List<DrsListModel>>();
  StreamController<String> isErrorLiveData = StreamController<String>();
  StreamController<bool> viewDialog = StreamController<bool>();

  DrsSelectionViewModel() {
    upsertTripLiveData = _repository.upsertTripLiveData;
    isErrorLiveData = _repository.isErrorLiveData;
    drsListLiveData = _repository.drsListLiveData;
    viewDialog = _repository.viewDialog;
  }

  void upsertTrip(Map<String, String> params) {
    _repository.upsertTrip(params);
  }

  void getDrsList(Map<String, String> params) {
    _repository.getDrsListV2(params);
  }
}
