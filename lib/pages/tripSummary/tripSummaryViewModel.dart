import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/tripSummary/tripSummaryRepository.dart';

class TripSummaryViewModel extends BaseViewModel {
  TripSummaryRepository _repo = TripSummaryRepository();

  StreamController<List<CurrentDeliveryModel>> tripSummaryList =
      StreamController<List<CurrentDeliveryModel>>();
  StreamController<bool> viewDialog = StreamController<bool>();

  TripSummaryViewModel() {
    tripSummaryList = _repo.tripSummaryData;
    viewDialog = _repo.viewDialog;
  }

  void getTripSummary(Map<String, String> params) {
    _repo.getDeliveryDetails(params);
  }
}
