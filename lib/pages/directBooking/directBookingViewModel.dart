 import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/directBooking/directBookingRepository.dart';
import 'package:gtlmd/pages/directBooking/model/directBookingModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';

class DirectBookingViewModel extends BaseViewModel {
DirectBookingRepository _repo = DirectBookingRepository();
 StreamController<List<DeliveryDetailModel>> directBookingLiveData =
      StreamController();
 StreamController<UpsertTripResponseModel> updateDispatchLiveData =
      StreamController();
StreamController<bool> viewDialog = StreamController();

DirectBookingViewModel(){
    directBookingLiveData = _repo.directBookingDataList;
    updateDispatchLiveData = _repo.updateDispatchLiveData;
     isErrorLiveData = _repo.isErrorLiveData;
       viewDialog = _repo.viewDialog;
}


  void getDirectBookingSearchList(Map<String, dynamic> params) {
    _repo.getDirectBookingSearchList(params);
  }
  void UpdateDispatchDetail(Map<String, dynamic> params) {
    _repo.UpdateDispatchDetail(params);
  }
}
