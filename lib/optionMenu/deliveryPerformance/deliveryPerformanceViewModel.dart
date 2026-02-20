import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/deliveryPerformanceRepo.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/model/deliveryPerformanceModel.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/model/deliveryPerformanceSummaryModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryDetail.dart';

class DeliveryPerformanceViewModel extends BaseViewModel {
  DeliveryPerformanceRepository _repo = DeliveryPerformanceRepository();
  StreamController<DeliveryPerformanceModel> performanceData =
      StreamController<DeliveryPerformanceModel>();

  StreamController<List<DeliveryPerformanceSummaryModel>>
      performanceSummaryData =
      StreamController<List<DeliveryPerformanceSummaryModel>>();
  StreamController<bool> viewDialog = StreamController();
  DeliveryPerformanceViewModel() {
    performanceData = _repo.performanceLiveData;
    performanceSummaryData = _repo.performanceSummaryLiveData;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
  }

  void getPerformanceData(Map<String, dynamic> params) {
    _repo.getDeliveryPerformanceData(params);
  }
}
