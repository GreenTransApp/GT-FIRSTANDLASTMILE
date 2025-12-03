import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/tripDetailRepository.dart';


class TripDetailViewModel extends BaseViewModel {
  TripDetailRepository _repo = TripDetailRepository();

  StreamController<List<CurrentDeliveryModel>> tripSummaryList =
      StreamController<List<CurrentDeliveryModel>>();
  StreamController<bool> viewDialog = StreamController<bool>();

  TripDetailViewModel() {
    tripSummaryList = _repo.tripSummaryData;
    viewDialog = _repo.viewDialog;
  }

  void getTripDetail(Map<String, String> params) {
    _repo.getDeliveryDetails(params);
  }
}
