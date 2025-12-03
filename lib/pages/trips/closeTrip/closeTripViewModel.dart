import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/trips/closeTrip/closeTripRepository.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';



class CloseTripViewModel extends BaseViewModel {
  final CloseTripRepository _repo = CloseTripRepository();

  
  StreamController<List<TripModel>> closedTripLiveData =
      StreamController<List<TripModel>>();
  StreamController<bool> viewDialogLiveData = StreamController();

   CloseTripViewModel(){
    closedTripLiveData = _repo.closedtripList;
    viewDialogLiveData = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
   }

    getClosedTripList(params) {
    _repo.getClosedTripList(params);
  }
}