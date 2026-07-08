import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/mdiMileTripDetailRepository.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/midMileTripDetailModel.dart';

class MidMileTripDetailViewModel extends BaseViewModel {
  final MidMileTripDetailRepository _repository = MidMileTripDetailRepository();

  StreamController<List<MidMileTripDetailModel>> tripDetailList =
      StreamController();
  StreamController<bool> loadingDialog = StreamController<bool>();
  StreamController<String> errorDialog = StreamController<String>();

  MidMileTripDetailViewModel() {
    loadingDialog = _repository.loadingDialog;
    errorDialog = _repository.errorDialog;
    tripDetailList = _repository.tripDetailList;
  }

  Future<void> getMidMileTripsDetail(Map<String, String> params) async {
    await _repository.getMidMileTripsDetailList(params);
  }
}
