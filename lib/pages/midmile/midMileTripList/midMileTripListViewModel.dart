import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/midmile/midMileTripList/midMileTripListModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripList/midMileTripListRepository.dart';

class MidMileTripListViewModel extends BaseViewModel {
  final MidMileTripListRepository _repository = MidMileTripListRepository();

  StreamController<List<MidMileTripListModel>> midMileTripsList =
      StreamController();
  StreamController<MidMileTripListModel> validateTripLiveData =
      StreamController();
  StreamController<PunchoutModel> get updateTripStart =>
      _repository.updateTripStart;
  StreamController<bool> loadingDialog = StreamController<bool>();
  StreamController<String> errorDialog = StreamController<String>();

  MidMileTripListViewModel() {
    loadingDialog = _repository.loadingDialog;
    errorDialog = _repository.errorDialog;
    midMileTripsList = _repository.midMileTripsList;
    validateTripLiveData = _repository.validateTripData;
  }

  Future<void> getMidMileTripsList(Map<String, String> params) async {
    await _repository.getMidMileTripsList(params);
  }
  
   void ValidateTripBeforeStart(Map<String, String> params) {
    _repository.ValidateTripBeforeStart(params);
  }
}
