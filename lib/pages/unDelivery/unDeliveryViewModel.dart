import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/unDelivery/actionModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';
import 'package:gtlmd/pages/unDelivery/unDeliveryRepository.dart';

class UnDeliveryViewModel extends BaseViewModel {
  final UnDeliveryRepository _repo = UnDeliveryRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<ReasonModel>> reasonListLiveData = StreamController();
  StreamController<List<ActionModel>> actionListLiveData = StreamController();
  StreamController<UpdateDeliveryModel> saveUnDeliveryLiveData =
      StreamController();

  UnDeliveryViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    reasonListLiveData = _repo.reasonLiveData;
    actionListLiveData = _repo.actionLiveData;
    saveUnDeliveryLiveData = _repo.saveUnDeliveryList;
  }

  void getReasons(Map<String, String> params) {
    _repo.getReasons(params);
  }

  void saveUnDelivery(Map<String, String> params) {
    _repo.updateUndelivery(params);
  }
}
