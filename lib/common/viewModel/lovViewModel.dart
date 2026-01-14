import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/common/repository/lovRepository.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/validateEwayBillModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/pinCodeModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';

class LovViewModel extends BaseViewModel {
  final LovRepository repository = LovRepository();
  StreamController<bool> viewDialog = StreamController();
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

  LovViewModel() {
    viewDialog = repository.viewDialog;
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

  Future<List<DepartmentModel>> getDepartmentList(
      Map<String, String> params) async {
    return repository.getDepartmentList(params);
  }
}
