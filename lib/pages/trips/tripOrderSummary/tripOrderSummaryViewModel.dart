import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/model/consignmentModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/model/tripOrderSummaryModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummaryRepository.dart';

class TripOrderSummaryViewModel extends BaseViewModel {
  final TripOrderSummaryRepository _repository = TripOrderSummaryRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
  StreamController<TripOrderSummaryModel> tripOrderSummary = StreamController();

  TripOrderSummaryViewModel() {
    viewDialog = _repository.viewDialog;
    errorDialog = _repository.errorDialog;
    tripOrderSummary = _repository.tripOrderSummary;
  }

  void getOrdersList(Map<String, String> params) {
    _repository.getOrdersList(params);
  }
}
