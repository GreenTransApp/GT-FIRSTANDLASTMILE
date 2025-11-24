import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/mapView/mapViewRepository.dart';
import 'package:gtlmd/pages/mapView/models/MapRouteModel.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigDetailModel.dart';

class MapRouteViewModel extends BaseViewModel {
  final MapViewRepository _repo = MapViewRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<MapRouteModel>> mapRouteLiveData = StreamController();
  StreamController<AllotedRouteModel> routeDetailLiveData = StreamController();
  StreamController<MapConfigDetailModel> mapConfigDetailLiveData =
      StreamController();
  MapRouteViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    mapRouteLiveData = _repo.mapRouteList;
    routeDetailLiveData = _repo.routeDetail;
    mapConfigDetailLiveData = _repo.mapConfigDetail;
  }

  getMapRouteDetails(Map<String, String> params) {
    _repo.getMapRouteDetails(params);
  }
}
