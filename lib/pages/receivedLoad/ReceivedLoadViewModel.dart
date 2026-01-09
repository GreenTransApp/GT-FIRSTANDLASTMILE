import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/receivedLoad/ReceivedLoadRepository.dart';
import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailUpdateModel.dart';

class ReceivedLoadViewModel extends BaseViewModel {
  final ReceivedLoadRepository _repo = ReceivedLoadRepository();
  StreamController<RouteUpdateModel> routeAcceptLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  ReceivedLoadViewModel() {
    isErrorLiveData = _repo.isErrorLiveData;
    viewDialog = _repo.loadingDialog;
    routeAcceptLiveData = _repo.routeAcceptList;
  }

  acceptRouteUpdate(Map<String, String> params) {
    _repo.updateDetailOnAccept(params);
  }
}
