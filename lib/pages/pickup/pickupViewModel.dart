import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/pickup/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/branchModel.dart';
import 'package:gtlmd/pages/pickup/customerModel.dart';
import 'package:gtlmd/pages/pickup/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/departmentModel.dart';
import 'package:gtlmd/pages/pickup/pickResp.dart';

import 'package:gtlmd/pages/pickup/pickup.dart';
import 'package:gtlmd/pages/pickup/pickupDetailModel.dart';
import 'package:gtlmd/pages/pickup/pickupRepository.dart';
import 'package:gtlmd/pages/pickup/pinCodeModel.dart';
import 'package:gtlmd/pages/pickup/savePickupRespModel.dart';
import 'package:gtlmd/pages/pickup/serviceTypeModel.dart';

class PickupViewModel extends BaseViewModel {
  final PickupRepository repository = PickupRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<PickupDetailModel>> pickupDetailsList =
      StreamController();
  StreamController<List<ServiceTypeModel>> serviceTypeList = StreamController();
  StreamController<List<LoadTypeModel>> loadTypeList = StreamController();
  StreamController<List<DeliveryTypeModel>> deliveryTypeList =
      StreamController();
  StreamController<List<BookingTypeModel>> bookingTypeList = StreamController();
  StreamController<List<PinCodeModel>> pinCodeList = StreamController();
  StreamController<List<BranchModel>> branchList = StreamController();
  StreamController<List<CustomerModel>> customerList = StreamController();
  StreamController<List<CngrCngeModel>> cngrList = StreamController();
  StreamController<List<CngrCngeModel>> cngeList = StreamController();
  StreamController<List<DepartmentModel>> deptList = StreamController();
  StreamController<SavePickupRespModel> savePickupLiveData = StreamController();

  PickupViewModel() {
    viewDialog = repository.viewDialog;
    isErrorLiveData = repository.isErrorLiveData;
    pickupDetailsList = repository.pickupDetailsList;
    serviceTypeList = repository.serviceTypeList;
    loadTypeList = repository.loadTypeList;
    deliveryTypeList = repository.deliveryTypeList;
    bookingTypeList = repository.bookingTypeList;
    pinCodeList = repository.pinCodeList;
    branchList = repository.branchList;
    customerList = repository.customerList;
    cngrList = repository.cngrList;
    cngeList = repository.cngeList;
    deptList = repository.departmentList;
    savePickupLiveData = repository.savePickupResp;
  }

  Future<PickResp> getPickupDetails(Map<String, String> params) async {
    return repository.getPickupDetails(params);
  }

  void getPinCodeList(Map<String, String> params) {
    repository.getPincodeList(params);
  }

  Future<List<BranchModel>> getBranchList(Map<String, String> params) async {
    return repository.getBranchList(params);
  }

  Future<List<CustomerModel>> getCustomerList(
      Map<String, String> params) async {
    return repository.getCustomerList(params);
  }

  Future<List<CngrCngeModel>> getCngrCngeList(
      Map<String, String> params, String type) async {
    return repository.getCngrCngeList(params, type);
  }

  void savePickup(Map<String, String> params) {
    repository.savePickup(params);
  }

  Future<List<DepartmentModel>> getDepartmentList(
      Map<String, String> params) async {
    return repository.getDepartmentList(params);
  }
}
