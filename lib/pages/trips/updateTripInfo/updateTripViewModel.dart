import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';

import 'package:gtlmd/pages/home/Model/UpdateTripResponseModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfoRepository.dart';

class UpdateTripInfoViewModel extends BaseViewModel {
  UpdateTripInfoRepository _repo = UpdateTripInfoRepository();
  StreamController<UpsertTripResponseModel> updateTripLiveData =
      StreamController();
  StreamController<bool> viewDialogLiveData = StreamController();

  UpdateTripInfoViewModel() {
    updateTripLiveData = _repo.updateTripInfoLiveData;
    viewDialogLiveData = _repo.viewDialog;
  }

  void updateTripInfo(Map<String, String> params) {
    _repo.updateTripInfo(params);
  }
}
