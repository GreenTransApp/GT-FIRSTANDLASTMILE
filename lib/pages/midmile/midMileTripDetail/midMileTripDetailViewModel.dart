import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/mdiMileTripDetailRepository.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/midMileTripDetailModel.dart';

class MidMileTripDetailViewModel extends BaseViewModel {
  final MidMileTripDetailRepository _repository = MidMileTripDetailRepository();

  StreamController<List<MidMileTripDetailModel>> tripDetailList =
      StreamController();
  StreamController<bool> loadingDialog = StreamController<bool>();
  StreamController<String> errorDialog = StreamController<String>();
  StreamController<PunchoutModel> departedPositionLiveData = StreamController();
  StreamController<PunchoutModel> arrivalLiveData = StreamController();


  MidMileTripDetailViewModel() {
    loadingDialog = _repository.loadingDialog;
    errorDialog = _repository.errorDialog;
    tripDetailList = _repository.tripDetailList;
        departedPositionLiveData = _repository.departedPositionData;
        arrivalLiveData = _repository.vehicleArrivalData;
        
  }

  Future<void> getMidMileTripsDetail(Map<String, String> params) async {
    await _repository.getMidMileTripsDetailList(params);
  }
  Future<void>  updateDepartLocation(Map<String, String> params) async {
    _repository.updateMidMileDepartedPosition(params);
  }
     Future<void>  updateArrival(Map<String, dynamic> params) async {
    _repository.UpdateVehicleArrival(params);
  }
    
}
