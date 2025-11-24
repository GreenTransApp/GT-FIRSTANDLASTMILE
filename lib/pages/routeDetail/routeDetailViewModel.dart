import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigDetailModel.dart';
import 'package:gtlmd/pages/routeDetail/Model/routeDetailModel.dart';
import 'package:gtlmd/pages/routeDetail/Model/routeDetailUpdateModel.dart';
import 'package:gtlmd/pages/routeDetail/routeDetailRepository.dart';
import 'package:gtlmd/pages/routeDetail/updateRoutePlanningModel.dart';

class RouteDetailviewModel extends BaseViewModel {
  final RouteDetailRepository _repo = RouteDetailRepository();
  StreamController<bool> viewDialog = StreamController();

  StreamController<List<RouteDetailModel>> routeDetailLiveData =
      StreamController<List<RouteDetailModel>>();
  StreamController<RouteUpdateModel> routeAcceptLiveData = StreamController();
  StreamController<RouteUpdateModel> routeRejectLiveData = StreamController();
  StreamController<AllotedRouteModel> routeDataLiveData = StreamController();
  StreamController<UpdateRoutePlanningModel> updateRoutePlanning =
      StreamController();
  StreamController<MapConfigDetailModel> mapConfigDetail = StreamController();
  RouteDetailviewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    routeDetailLiveData = _repo.routeDetailList;
    routeAcceptLiveData = _repo.routeAcceptList;
    routeRejectLiveData = _repo.routeRejectList;
    routeDataLiveData = _repo.routeData;
    updateRoutePlanning = _repo.updateRoutePlanning;
    mapConfigDetail = _repo.mapConfigDetail;
  }
  getRouteDetailData(Map<String, String> params) {
    _repo.getRouteDetails(params);
  }

  acceptRouteUpdate(Map<String, String> params) {
    _repo.updateDetailOnAccept(params);
  }

  rejectRouteUpdate(Map<String, String> params) {
    _repo.updateDetailOnReject(params);
  }

  void updateRoute(Map<String, dynamic> params) {
    _repo.updateRoute(params);
  }

  void getMapConfig(Map<String, String> params) {
    _repo.getMapConfig(params);
  }
}
