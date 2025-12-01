import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/routesList/routesListRepository.dart';

class RoutesListViewModel extends BaseViewModel {
  final RouteslistRepository _repository = RouteslistRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> errorDialog = StreamController();
  StreamController<List<AllotedRouteModel>> routesList = StreamController();

  RoutesListViewModel() {
    viewDialog = _repository.viewDialog;
    errorDialog = _repository.isErrorLiveData;
    routesList = _repository.routesListLiveData;
  }

  void getRoutesList(Map<String, String> params) {
    _repository.getRoutesList(params);
  }
}
