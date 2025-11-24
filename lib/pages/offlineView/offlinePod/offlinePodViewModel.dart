import 'dart:async';

import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/model/podEntryOfflineRespModel.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/offlinePodRepository.dart';
import 'package:gtlmd/pages/podEntry/podEntryRepository.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';

class OfflinePodViewModel extends BaseViewModel {
  // BaseRepository _repo = BaseRepository();
  OfflinePodRepository _repo = OfflinePodRepository();

  StreamController<UpdateDeliveryModel> savePodOfflineLiveData =
      StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<PodEntryOFflineRespModel>> existingGrList =
      StreamController();

  OfflinePodViewModel() {
    savePodOfflineLiveData = _repo.savePodOfflineLiveData;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    existingGrList = _repo.existingGr;
  }

  savePodEntryOffline(Map<String, dynamic> params) {
    _repo.savePodEntryOffline(params);
  }
}
