import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBillRepository.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/EwayBillCredentialsModel.dart';
import 'package:gtlmd/pages/pickup/model/savePickupRespModel.dart';

class BookingWithEwayBillViewModel extends BaseViewModel {
  final BookingWithEwayBillRepository repository =
      BookingWithEwayBillRepository();
  StreamController<String> errorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<EwayBillCredentialsModel>> validateEwayBillList =
      StreamController();
  StreamController<Map<String, dynamic>> refreshEwb = StreamController();
  StreamController<SavePickupRespModel> saveBookingLd = StreamController();
  StreamController<Map<String, dynamic>> cngrCngeCodeLiveData =
      StreamController();

  BookingWithEwayBillViewModel() {
    errorLiveData = repository.isErrorLiveData;
    viewDialog = repository.viewDialog;
    validateEwayBillList = repository.validateEwayBillList;
    refreshEwb = repository.refreshEwbLiveData;
    saveBookingLd = repository.saveBookingLiveData;
    cngrCngeCodeLiveData = repository.cngrCngeCodeLiveData;
  }

  Future<void> getEwayBillCreds(Map<String, String> params) async {
    return repository.getEwayBillCreds(params);
  }

  Future<void> ewayBillLogin(
      Map<String, String> params, String ewaybillno, String compGst) {
    return repository.ewaybilllogin(params, ewaybillno, compGst);
  }

  Future<void> getCngrCngeCode(Map<String, String> params) {
    return repository.getCngrCngeCode(params);
  }

  Future<void> saveBooking(Map<String, String> params) {
    return repository.saveBooking(params);
  }
}
