 import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/directBooking/directBookingRepository.dart';
import 'package:gtlmd/pages/directBooking/model/directBookingModel.dart';

class DirectBookingViewModel extends BaseViewModel {
DirectBookingRepository _repo = DirectBookingRepository();
 StreamController<List<DirectBookingModel>> directBookingLiveData =
      StreamController();
StreamController<bool> viewDialog = StreamController();

DirectBookingViewModel(){
    directBookingLiveData = _repo.directBookingDataList;
     isErrorLiveData = _repo.isErrorLiveData;
       viewDialog = _repo.viewDialog;
}


  void getDirectBookingSearchList(Map<String, dynamic> params) {
    _repo.getDirectBookingSearchList(params);
  }
}
