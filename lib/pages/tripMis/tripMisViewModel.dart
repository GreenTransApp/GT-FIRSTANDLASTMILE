import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/tripMis/Model/tripMisModel.dart';
import 'package:gtlmd/pages/tripMis/tripMisRepository.dart';
import 'package:gtlmd/pages/trips/tripDetail/tripDetailRepository.dart';

class TripMisViewModel extends BaseViewModel {
  TripMisRepository _repo = TripMisRepository();
  StreamController<List<TripMisModel>> tripsListData =
      StreamController<List<TripMisModel>>();
  StreamController<bool> viewDialog = StreamController();
  TripMisViewModel() {
    tripsListData = _repo.tripsListData;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
  }

  void getTripMIS(Map<String, dynamic> params) {
    _repo.getTripMIS(params);
  }
}
