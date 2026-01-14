import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBillRepository.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/validateEwayBillModel.dart';

class BookingWithEwayBillViewModel extends BaseViewModel {
  final BookingWithEwayBillRepository repository =
      BookingWithEwayBillRepository();
  StreamController<String> errorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<ValidateEwayBillModel>> validateEwayBillList =
      StreamController();
  BookingWithEwayBillViewModel() {
    errorLiveData = repository.isErrorLiveData;
    viewDialog = repository.viewDialog;
    validateEwayBillList = repository.validateEwayBillList;
  }

  Future<void> getEwayBillCreds(Map<String, String> params) async {
    return repository.getEwayBillCreds(params);
  }
}
