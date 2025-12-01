import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/tripOrderSummary/tripOrderSummaryModel.dart';
import 'package:gtlmd/pages/tripOrderSummary/tripOrderSummaryRepository.dart';

class TripOrderSummaryViewModel extends BaseViewModel {
  final TripOrderSummaryRepository _repository = TripOrderSummaryRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
  StreamController<List<TripOrderSummaryModel>> ordersList = StreamController();

  TripOrderSummaryViewModel() {
    viewDialog = _repository.viewDialog;
    errorDialog = _repository.errorDialog;
    ordersList = _repository.ordersList;
  }

  void getOrdersList(Map<String, String> params) {
    _repository.getOrdersList(params);
  }
}
