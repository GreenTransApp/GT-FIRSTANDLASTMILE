import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/common/bottomSheet/UpdateTripInfo/updateTripInfoRepository.dart';
import 'package:gtlmd/common/bottomSheet/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/pages/home/Model/UpdateTripResponseModel.dart';

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
