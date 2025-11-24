import 'dart:async';

import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/offlineView/offlineUndelivery/offlineUndeliveryRepository.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';
import 'package:gtlmd/pages/unDelivery/unDeliveryRepository.dart';

class OfflineUndeliveryViewModel extends BaseViewModel {
  final OfflineUndeliveryRepository _repo = OfflineUndeliveryRepository();

  StreamController<UpdateDeliveryModel> saveUnDeliveryOfflineList =
      StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<String>> drsWithExistingPods = StreamController();

  OfflineUndeliveryViewModel() {
    saveUnDeliveryOfflineList = _repo.saveUnDeliveryOfflineList;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    drsWithExistingPods = _repo.drsWtihExistingPod;
  }

  saveUndeliveryOffline(Map<String, dynamic> params) {
    _repo.updateUndeliveryOffline(params);
  }
}
