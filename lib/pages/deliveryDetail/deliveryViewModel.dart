import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/lmdMenuModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryRepository.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/home/Model/menuModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';

class DeliveryViewModel extends BaseViewModel {
  final DeliveryRepository _repo = DeliveryRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<DeliveryDetailModel>> deliveryDetailLiveData =
      StreamController<List<DeliveryDetailModel>>();
  StreamController<CurrentDeliveryModel> deliveryDataLiveData =
      StreamController();
  StreamController<List<LmdMenuModel>> getMenuLiveData = StreamController();
  StreamController<PunchoutModel> updateDriverReachedLD = StreamController();
  StreamController<PunchoutModel> driverReachedDlvPoint = StreamController();
  DeliveryViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    deliveryDetailLiveData = _repo.deliveryDetailList;
    deliveryDataLiveData = _repo.deliveryData;
    getMenuLiveData = _repo.menuList;
    updateDriverReachedLD = _repo.updateDriverPosition;
    driverReachedDlvPoint = _repo.driverReachedDlvPoint;
  }

  getDeliveryDetail(Map<String, String> params) {
    _repo.getDeliveryDetails(params);
  }

  getMenu(Map<String, String> params) {
    _repo.getMenu(params);
  }

  updateDriverReached(Map<String, String> params) {
    _repo.updateDriverReached(params);
  }

  updateDriverReachedDlvPoint(Map<String, String> params) {
    _repo.updateDriverReachedDlvPoint(params);
  }
}
