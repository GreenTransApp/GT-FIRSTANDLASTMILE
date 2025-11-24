import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/reversePickup/model/reversePickupModel.dart';
import 'package:gtlmd/pages/reversePickup/model/reversePickupResultModel.dart';
import 'package:gtlmd/pages/reversePickup/reversePickupRepository.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';

class ReversePickupViewModel extends BaseViewModel {
  final ReversePickupRepository _repo = ReversePickupRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<ReversePickupModel> reversePickupLiveData =
      StreamController();
  StreamController<ReversePickupResultModel> saveReversePickupLiveData =
      StreamController();
  StreamController<String> verifySkuLiveData = StreamController();
  StreamController<List<ReasonModel>> reasonLiveData = StreamController();

  ReversePickupViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    reversePickupLiveData = _repo.reversePickupLiveData;
    saveReversePickupLiveData = _repo.saveReversePickupLiveData;
    verifySkuLiveData = _repo.verifySkuLiveData;
    reasonLiveData = _repo.reasonLiveData;
  }

  getReversePickup(Map<String, String> params) {
    // Implement the logic to fetch reverse pickup data
    // and add it to reversePickupLiveData stream.
    _repo.getReversePickup(params);
  }

  saveReversePickup(Map<String, String> params) {
    // Implement the logic to save reverse pickup data
    // and handle the response accordingly.
    _repo.saveReversePickup(params);
  }

  verifySku(Map<String, dynamic> params) {
    // _repo.verifySku(params);
  }

  getReasonList(Map<String, String> params) {
    // Implement the logic to fetch reason list
    // and add it to reversePickupLiveData stream.
    _repo.getReasonList(params);
  }
}
