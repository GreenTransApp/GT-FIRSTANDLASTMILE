import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/runningTrips/runningTripRepository.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';

class RunningTripsViewModel extends BaseViewModel {
  RunningTripRepository _repo = RunningTripRepository();
  StreamController<List<TripModel>> tripsListData =
      StreamController<List<TripModel>>();
  StreamController<bool> viewDialog = StreamController();
    StreamController<TripModel> validateTripLiveData =
      StreamController();

  RunningTripsViewModel() {
    tripsListData = _repo.tripsListData;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    validateTripLiveData = _repo.validateTripData;
  }

  void getTripsList(Map<String, String> params) {
    _repo.getTripsList(params);
  }

    void ValidateTripBeforeStart(Map<String, String> params) {
    _repo.ValidateTripBeforeStart(params);
  }

}
