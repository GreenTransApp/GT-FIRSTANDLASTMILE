import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/closedDrs/closedDrsRepository.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';

class ClosedDrsViewModel extends BaseViewModel {
  final ClosedDrsRepository _repo = ClosedDrsRepository();

  StreamController<List<CurrentDeliveryModel>> closedDrsLiveData =
      StreamController<List<CurrentDeliveryModel>>();
  StreamController<bool> viewDialogLiveData = StreamController();

  ClosedDrsViewModel() {
    closedDrsLiveData = _repo.closedDrsList;
    viewDialogLiveData = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
  }

  getClosedDrsList(params) {
    _repo.getClosedDrsList(params);
  }
}
