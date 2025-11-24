import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryRepository.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';

class DeliveryViewModel extends BaseViewModel {
  final DeliveryRepository _repo = DeliveryRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<DeliveryDetailModel>> deliveryDetailLiveData =
      StreamController<List<DeliveryDetailModel>>();
  StreamController<CurrentDeliveryModel> deliveryDataLiveData =
      StreamController();
  DeliveryViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    deliveryDetailLiveData = _repo.deliveryDetailList;
    deliveryDataLiveData = _repo.deliveryData;
  }

  getDeliveryDetail(Map<String, String> params) {
    _repo.getDeliveryDetails(params);
  }
}
