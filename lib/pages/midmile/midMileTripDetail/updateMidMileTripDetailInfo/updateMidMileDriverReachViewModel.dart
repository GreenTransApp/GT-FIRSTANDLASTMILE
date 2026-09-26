import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/updateMidMileTripDetailInfo/updateMidMileDriverReachRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

class UpdateMidMileDriverPositionViewModel extends BaseViewModel {
  final UpdateMidMileDriverPositionRepository _repo =
      UpdateMidMileDriverPositionRepository();
  StreamController<UpsertTripResponseModel> updateTripLiveData =
      StreamController();
  StreamController<PunchoutModel> arrivalWithOutstandingLiveData =
      StreamController();
  StreamController<UpsertTripResponseModel> updateStartTripLiveData =
      StreamController();

  StreamController<bool> loadingDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
  StreamController<PunchoutModel> arrivalLiveData = StreamController();

  UpdateMidMileDriverPositionViewModel() {
    updateStartTripLiveData = _repo.updateStartTripLiveData;
    loadingDialog = _repo.loadingDialog;
    errorDialog = _repo.errorDialog;
    arrivalLiveData = _repo.vehicleArrivalData;
    arrivalWithOutstandingLiveData = _repo.hubvehicleArrivalData;
  }

  void updateDriverReached(Map<String, String> params) {
    _repo.updateDriverReached(params);
  }

  Future<void> UpdateVehicleArrivalWithOutstanding(
      Map<String, dynamic> params) async {
    _repo.UpdateVehicleArrivalWithOutstanding(params);
  }

  Future<void> updateArrival(Map<String, dynamic> params) async {
    _repo.UpdateVehicleArrival(params);
  }
}
