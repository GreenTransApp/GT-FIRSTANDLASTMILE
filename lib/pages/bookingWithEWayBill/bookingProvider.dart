import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/repository/lovRepository.dart';
import 'package:gtlmd/common/viewModel/lovViewModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBillRepository.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/EwayBillCredentialsModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/ewayBillModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';

class BookingProvider extends ChangeNotifier {
  final LovRepository _lovRepository = LovRepository();
  final BookingWithEwayBillRepository _repo = BookingWithEwayBillRepository();
  bool autoGr = false;
  BranchModel? _selectedOrigin;
  BranchModel? _selectedDestination;
  CustomerModel? _selectedCustomer;
  DepartmentModel? _selectedDept;
  CngrCngeModel? _selectedCngr;
  CngrCngeModel? _selectedCnge;
  ServiceTypeModel? _selectedServiceType;
  DeliveryTypeModel? _selectedDeliveryType;
  late EwayBillModel _firstEwayBill;
  late EwayBillCredentialsModel _ewaybillCreds;
  String selectedImagePath = "";

  List<EwayBillModel> _ewayBillList = [];
  List<BranchModel> _branchList = [];
  List<CustomerModel> _customerList = [];
  List<CngrCngeModel> _cngrList = [];
  List<CngrCngeModel> _cngeList = [];
  List<DepartmentModel> _departmentList = [];
  bool _isLoadingLov = false;

  final List<ServiceTypeModel> _serviceTypeList = [
    ServiceTypeModel(prodName: 'SURFACE'),
    ServiceTypeModel(prodName: 'AIR'),
    ServiceTypeModel(prodName: 'TRAIN'),
  ];
  List<DeliveryTypeModel> _deliveryTypeList = [
    DeliveryTypeModel(deliveryTypeName: 'GODOWN'),
    DeliveryTypeModel(deliveryTypeName: 'DOOR'),
    DeliveryTypeModel(deliveryTypeName: 'STATION'),
  ];

  fetchAllLov() async {
    // setState(() {
    _isLoadingLov = true;
    // });
    notifyListeners();
    final futures = [
      getBranchList(),
      getCustomerList(),
      getCngrCngeList('R'),
      getCngrCngeList('E'),
      getDepartmentList(),
      // getEwayBillCreds(),
    ];

    try {
      final results = await Future.wait(futures);

      // if (mounted) {
      //   setState(() {
      _branchList = results[0] as List<BranchModel>;
      _customerList = results[1] as List<CustomerModel>;
      _cngrList = results[2] as List<CngrCngeModel>;
      _cngeList = results[3] as List<CngrCngeModel>;
      _departmentList = results[4] as List<DepartmentModel>;
      _isLoadingLov = false;
      // });
      debugPrint('LOV DATA FETCHED SUCCESSFULLY');
      notifyListeners();
      // }
    } catch (e) {
      // if (mounted) {
      //   setState(() {
      _isLoadingLov = false;
      //   });
      // }
      debugPrint('API FAILED: $e');
    }
  }

  Future<List<BranchModel>> getBranchList() async {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      // "prmbranchcode": "00000",
      "prmusercode": savedUser.usercode.toString(),
      // "prmmenucode": 'GTAPP_BOOKINGWITHOUTINDENT',
      "prmsessionid": savedUser.sessionid.toString(),
      "prmcharstr": '',
    };

    return _lovRepository.getBranchList(params);
  }

  // Future<void> getGrDetail(String grno) async {
  //   Map<String, String> params = {
  //     "prmcompanyid": savedUser.companyid.toString(),
  //     "prmusercode": savedUser.usercode.toString(),
  //     "prmbranchcode": savedUser.loginbranchcode.toString(),
  //     "prmsessionid": savedUser.sessionid.toString(),
  //     "prmgrno": grno,
  //   };

  //   return _repo.getGrDetail(params);
  // }

  Future<List<CustomerModel>> getCustomerList() async {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmusercode": savedUser.usercode.toString(),
      // "prmmenucode": 'GTAPP_BOOKINGWITHOUTINDENT',
      "prmsessionid": savedUser.sessionid.toString(),
      "prmcharstr": '',
    };

    return _lovRepository.getCustomerList(params);
  }

  Future<List<CngrCngeModel>> getCngrCngeList(String type) async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      // "prmbranchcode": '00000',
      "prmgrtype": 'R',
      "prmcngrcnge": type,
      "prmcustcode": '',
      "prmcharstr": '',
    };

    return _lovRepository.getCngrCngeList(params, type);
  }

  Future<List<DepartmentModel>> getDepartmentList() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmcustcode": _selectedCustomer!.custCode.toString(),
      "prmorgcode": _selectedOrigin!.stnCode.toString(),
    };

    return _lovRepository.getDepartmentList(params);
  }

  Future<void> getEwayBillCreds() async {
    Map<String, String> params = {
      // "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmbookingbranchcode": '',
      "prmsessionid": savedUser.sessionid.toString(),
    };

    return _repo.getEwayBillCreds(params);
  }
}
