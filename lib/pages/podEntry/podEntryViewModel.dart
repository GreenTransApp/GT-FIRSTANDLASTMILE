import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/podEntry/Model/podEntryModel.dart';
import 'package:gtlmd/pages/podEntry/podEntryRepository.dart';
import 'package:gtlmd/pages/podEntry/podRelationModel.dart';
import 'package:gtlmd/pages/unDelivery/Model/unDeliveryModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';

class PodEntryViewModel extends BaseViewModel {
  final _repo = PodEntryRepository();
  StreamController<PodEntryModel> podEntryLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<PodRelationsModel>> podRelationLiveData =
      StreamController();
  StreamController<List<ReasonModel>> podDamageReasonLiveData =
      StreamController();

  StreamController<UpdateDeliveryModel> savePodLiveData = StreamController();
  StreamController<UpdateDeliveryModel> savePodCommonLiveData =
      StreamController();

  PodEntryViewModel() {
    podEntryLiveData = _repo.podEntryLiveData;
    podRelationLiveData = _repo.podRelationLiveData;
    viewDialog = _repo.viewDialog;
    savePodLiveData = _repo.savePodLiveData;
    isErrorLiveData = _repo.isErrorLiveData;
    // savePodCommonLiveData = _repo.savePodOfflineLiveData;
    podDamageReasonLiveData = _repo.podDamageReasonLiveData;
  }

  getPodEntry(Map<String, String> params) {
    _repo.getPodEntry(params);
  }

  savePodEntry(Map<String, dynamic> params) {
    _repo.savePodEntry(params);
  }

  // savePodEntryOffline(Map<String, dynamic> params) {
  //   _repo.savePodEntryOffline(params);
  // }

  getPodLovs(Map<String, String> params) {
    _repo.getPodLovs(params);
  }
}
