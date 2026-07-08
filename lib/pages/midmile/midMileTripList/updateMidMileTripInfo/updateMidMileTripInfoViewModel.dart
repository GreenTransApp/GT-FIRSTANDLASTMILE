import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripList/updateMidMileTripInfo/updateMidMileTripRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

class UpdateMidMileTripInfoViewModel extends BaseViewModel {
  final UpdateMidMileTripInfoRepository _repo =
      UpdateMidMileTripInfoRepository();
  StreamController<UpsertTripResponseModel> updateTripLiveData =
      StreamController();

  StreamController<UpsertTripResponseModel> updateStartTripLiveData =
      StreamController();

  StreamController<bool> loadingDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
  UpdateMidMileTripInfoViewModel() {
    updateStartTripLiveData = _repo.updateStartTripLiveData;
    loadingDialog = _repo.loadingDialog;
    errorDialog = _repo.errorDialog;
  }

  void updateStartTrip(Map<String, String> params) {
    _repo.updateStartTrip(params);
  }
}
