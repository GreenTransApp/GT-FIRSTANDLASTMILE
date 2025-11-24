import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';

import 'package:gtlmd/pages/home/Model/UpdateTripResponseModel.dart';
import 'package:gtlmd/pages/home/Model/menuModel.dart';
import 'package:gtlmd/pages/home/Model/moduleModel.dart';
import 'package:gtlmd/pages/home/Model/validateDeviceModel.dart';
import 'package:gtlmd/pages/home/homeRepository.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/tripModel.dart';

class HomeViewModel extends BaseViewModel {
  final HomeRepository _repo = HomeRepository();

  StreamController<List<AllotedRouteModel>> routeDashboardLiveData =
      StreamController<List<AllotedRouteModel>>();
  StreamController<List<CurrentDeliveryModel>> deliveryDashboardLiveData =
      StreamController<List<CurrentDeliveryModel>>();
  StreamController<List<CurrentDeliveryModel>> activeDrsLiveData =
      StreamController<List<CurrentDeliveryModel>>();
  StreamController<List<TripModel>> tripsListData =
      StreamController<List<TripModel>>();
  StreamController<AttendanceModel> attendanceLiveData =
      StreamController<AttendanceModel>();

  StreamController<ValidateDeviceModel> validateDeviceLiveData =
      StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<DrsDateTimeUpdateModel> drsDateTimeUpdateLiveData =
      StreamController();

  HomeViewModel() {
    validateDeviceLiveData = _repo.validateDeviceList;
    routeDashboardLiveData = _repo.routeDashboardList;
    deliveryDashboardLiveData = _repo.deliveryDashboardList;
    attendanceLiveData = _repo.attendanceList;
    drsDateTimeUpdateLiveData = _repo.drsDateTimeUpdate;
    activeDrsLiveData = _repo.activeDrsList;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    tripsListData = _repo.tripsLiveData;
  }

  callDashboardDetail(Map<String, String> params) {
    _repo.getDashBoardDetails(params);
  }

  callValidateDeviceData(Map<String, String> params) {
    _repo.getValidateDevice(params);
  }

  callDrsDateTimeUpdate(Map<String, String> params) {
    _repo.updateDrsDateTime(params);
  }
}
