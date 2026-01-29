import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/signatureBottomSheet.dart';
import 'package:gtlmd/common/selectionBottomSheets/cngrCngeSelectionBottomSheet.dart';
import 'package:gtlmd/common/selectionBottomSheets/branchSelectionBottomSheet.dart';
import 'package:gtlmd/common/selectionBottomSheets/customerSelectionBottomSheet.dart';
import 'package:gtlmd/common/bottomSheet/commonBottomSheets.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/common/selectionBottomSheets/departmentSelectionBottomSheet.dart';
import 'package:gtlmd/common/selectionBottomSheets/vehicleSelectionBottomSheet.dart';
import 'package:gtlmd/common/viewModel/lovViewModel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/bookingList/bookingListScreen.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/appFormField.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBillViewModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/EwayBillCredentialsModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/ewayBillModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/grDetailsResponse.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/ewayBillRespModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/vehicleModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/grGoodsDimensionModel.dart';
import 'package:gtlmd/pages/dimensions/dimensions.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class BookingWithEwayBill extends StatefulWidget {
  String? grno;
  BookingWithEwayBill({super.key, this.grno});

  @override
  State<BookingWithEwayBill> createState() => _BookingWithEwayBillState();
}

class _BookingWithEwayBillState extends State<BookingWithEwayBill> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _bookingDateController = TextEditingController();
  final FocusNode _bookingDateFocusNode = FocusNode();
  final TextEditingController _bookingTimeController = TextEditingController();
  final FocusNode _bookingTimeFocusNode = FocusNode();
  final TextEditingController _grNoController = TextEditingController();
  final FocusNode _grNoFocusNode = FocusNode();
  final TextEditingController _originNameController = TextEditingController();
  final FocusNode _originNameFocusNode = FocusNode();
  final TextEditingController _destNameController = TextEditingController();
  final FocusNode _destNameFocusNode = FocusNode();
  final TextEditingController _custNameController = TextEditingController();
  final FocusNode _custNameFocusNode = FocusNode();
  final TextEditingController _deptNameController = TextEditingController();
  final FocusNode _deptNameFocusNode = FocusNode();
  final TextEditingController _cngrNameController = TextEditingController();
  final FocusNode _cngrNameFocusNode = FocusNode();
  final TextEditingController _cngrGstController = TextEditingController();
  final FocusNode _cngrGstFocusNode = FocusNode();
  final TextEditingController _cngeNameController = TextEditingController();
  final FocusNode _cngeNameFocusNode = FocusNode();
  final TextEditingController _cngeGstController = TextEditingController();
  final FocusNode _cngeGstFocusNode = FocusNode();
  final TextEditingController _serviceTypeController = TextEditingController();
  final FocusNode _servieTypeFocusNode = FocusNode();
  final TextEditingController _loadTypeController = TextEditingController();
  final FocusNode _loadTypeFocusNode = FocusNode();
  final TextEditingController _vehicleController = TextEditingController();
  final FocusNode _vehicleFocusNode = FocusNode();
  final TextEditingController _deliveryTypeController = TextEditingController();
  final FocusNode _deliveryTypeFocusNode = FocusNode();
  final TextEditingController _noofpckgsController = TextEditingController();
  final FocusNode _noofpckgsFocusNode = FocusNode();
  final TextEditingController _remarksController = TextEditingController();
  final FocusNode _remarksFocusNode = FocusNode();
  final TextEditingController _gweightController = TextEditingController();
  final FocusNode _gweightFocusNode = FocusNode();
  final TextEditingController _vweightController = TextEditingController();
  final FocusNode _vweightFocusNode = FocusNode();
  final TextEditingController _cweightController = TextEditingController();
  final FocusNode _cweightFocusNode = FocusNode();
  late LoadingAlertService loadingAlertService;
  final LovViewModel lovViewModel = LovViewModel();
  final BookingWithEwayBillViewModel viewModel = BookingWithEwayBillViewModel();

  bool autoGr = false;
  BranchModel? _selectedOrigin;
  BranchModel? _selectedDestination;
  CustomerModel? _selectedCustomer;
  DepartmentModel? _selectedDept;
  CngrCngeModel? _selectedCngr;
  CngrCngeModel? _selectedCnge;
  ServiceTypeModel? _selectedServiceType;
  DeliveryTypeModel? _selectedDeliveryType;
  LoadTypeModel? _selectedLoadType;
  VehicleModel? _selectedVehicle;
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
  String _selectedSignaturePath = '';

  final List<ServiceTypeModel> _serviceTypeList = [];
  final List<LoadTypeModel> _loadTypeList = [];
  final List<StreamSubscription> _subscriptions = [];
  String cngrgstno = '';
  String cngegstno = '';
  String lengthStr = '';
  String breadthStr = '';
  String heightStr = '';
  String piecesStr = '';
  String vWeightStr = '';
  String cftStr = '';
  // bool isCft = false;

  //  [
  //   ServiceTypeModel(prodName: 'SURFACE'),
  //   ServiceTypeModel(prodName: 'AIR'),
  //   ServiceTypeModel(prodName: 'TRAIN'),
  // ];
  List<DeliveryTypeModel> _deliveryTypeList = [];
  // [
  //   DeliveryTypeModel(deliveryTypeName: 'GODOWN'),
  //   DeliveryTypeModel(deliveryTypeName: 'DOOR'),
  //   DeliveryTypeModel(deliveryTypeName: 'STATION'),
  // ];

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _subscriptions.clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    _firstEwayBill = EwayBillModel();
    _ewaybillCreds = EwayBillCredentialsModel(
        commandmessage: 'Success',
        commandstatus: 1,
        compGst: "27AJEPK3488M1ZN",
        ewayEnabled: 'Y',
        ewayPassword: "Abcd@1234",
        ewayUserId: "8689835999",
        stateGst: "27AJEPK3488M1ZN");
    _bookingDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    _bookingTimeController.text = DateFormat('HH:mm a').format(DateTime.now());
    setObserver();
    fetchAllLov();

    if (!isNullOrEmpty(widget.grno)) {
      getGrDetailToEdit(widget.grno.toString());
    }
  }

  Future<void> getGrDetailToEdit(String grno) async {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmgrno": grno,
    };
    List<dynamic> result = await viewModel.getGrDetail(params);
    if (result.isNotEmpty) {
      populateGrData(result);
    }
  }

  void populateGrData(List<dynamic> dataList) {
    if (dataList.isEmpty) return;

    GrDetailsResponse? grData;
    List<EwayBillModelResponse> ewbDataList = [];
    List<GrGoodsDimensionModel> dimensionList = [];

    for (var item in dataList) {
      if (item is GrDetailsResponse) grData = item;
      if (item is EwayBillModelResponse) ewbDataList.add(item);
      if (item is GrGoodsDimensionModel) dimensionList.add(item);
    }

    debugPrint('ewaybill data length: ${ewbDataList.length}');
    debugPrint('dimension data length: ${dimensionList.length}');
    final gr = grData;
    if (gr != null) {
      setState(() {
        _grNoController.text = gr.grNo ?? '';
        _bookingDateController.text = gr.grDate != null
            ? DateFormat('dd-MM-yyyy').format(gr.grDate!)
            : '';
        _bookingTimeController.text = gr.pickTime ?? '';
        selectedImagePath = gr.bookingimg ?? '';
        _selectedSignaturePath = gr.signimg ?? '';
        // Update selected objects from lists if they are already fetched
        if (_branchList.isNotEmpty) {
          try {
            _selectedDestination = _branchList.firstWhere(
                (element) => element.stnCode == gr.destCode,
                orElse: () => BranchModel());
            _destNameController.text = _selectedDestination?.stnName ?? '';
          } catch (e) {}
        }

        if (_customerList.isNotEmpty) {
          try {
            _selectedCustomer = _customerList.firstWhere(
                (element) => element.custCode == gr.custCode,
                orElse: () => CustomerModel());
            _custNameController.text = _selectedCustomer?.custName ?? '';
          } catch (e) {}
        }

        _selectedCngr = CngrCngeModel(
          code: gr.consignorCode,
          name: gr.consignor,
          gstNo: gr.consignorGstNo,
        );
        _cngrNameController.text = gr.consignor ?? '';
        _cngrGstController.text = gr.consignorGstNo ?? '';

        _selectedCnge = CngrCngeModel(
          code: gr.consigneeCode,
          name: gr.consignee,
          gstNo: gr.consigneeGstNo,
        );
        _cngeNameController.text = gr.consignee ?? '';
        _cngeGstController.text = gr.consigneeGstNo ?? '';
        _noofpckgsController.text =
            double.parse(gr.totalPackages!.toString()).toInt().toString() ?? '';
        _gweightController.text = gr.actualWeight?.toString() ?? '';
        _vweightController.text = gr.volumetricWeight?.toString() ?? '';
        _cweightController.text = gr.chargedWeight?.toString() ?? '';
        _remarksController.text = gr.remarks ?? '';

        if (_serviceTypeList.isNotEmpty) {
          try {
            _selectedServiceType = _serviceTypeList.firstWhere(
                (element) => element.modeType == gr.productCode,
                orElse: () => ServiceTypeModel());
            _serviceTypeController.text = _selectedServiceType?.prodName ?? '';
            // isCft = _selectedServiceType?.isCft ?? false;
          } catch (e) {}
        }

        if (_loadTypeList.isNotEmpty) {
          try {
            _selectedLoadType = _loadTypeList.firstWhere(
                (element) => element.code == gr.loadType,
                orElse: () => LoadTypeModel());
            _loadTypeController.text = _selectedLoadType?.name ?? '';
          } catch (e) {}
        }

        _selectedOrigin = BranchModel(
          stnCode: gr.orgcode,
          stnName: gr.orgname,
        );
        _originNameController.text = gr.orgname ?? '';
        _selectedDestination =
            BranchModel(stnCode: gr.destCode, stnName: gr.destName);
        _destNameController.text = gr.destName ?? '';
        _selectedCustomer = CustomerModel(
          custCode: gr.custCode,
          custName: gr.custName,
        );
        _custNameController.text = gr.custName ?? '';

        _selectedDept = DepartmentModel(
          custDeptId: gr.custDeptId,
        );
      });
      _selectedDeliveryType = DeliveryTypeModel();
      if (_deliveryTypeList.isNotEmpty) {
        try {
          _selectedDeliveryType = _deliveryTypeList.firstWhere(
              (element) => element.deliveryType == gr.dlvtype,
              orElse: () => DeliveryTypeModel());
          _deliveryTypeController.text =
              _selectedDeliveryType?.deliveryTypeName ?? '';
        } catch (e) {}
      }

      _selectedVehicle = VehicleModel(
          commandStatus: 1,
          commandMessage: '',
          vehicleCode: gr.modeCode.toString(),
          regNo: gr.regNo.toString(),
          typeName: '',
          capacity: 0,
          modeType: '');
      _vehicleController.text = _selectedVehicle!.vehicleCode;
    }

    if (ewbDataList.isNotEmpty) {
      setState(() {
        for (int i = 0; i < ewbDataList.length; i++) {
          final ewb = ewbDataList[i];
          EwayBillModel targetModel;
          if (i == 0) {
            targetModel = _firstEwayBill;
          } else {
            targetModel = EwayBillModel();
            _ewayBillList.add(targetModel);
          }

          targetModel.ewaybillnoCtrl.text = ewb.ewayBill ?? '';
          targetModel.ewaybilldateCtrl.text = ewb.ewayBillDate != null
              ? DateFormat('dd-MM-yyyy').format(ewb.ewayBillDate!)
              : '';
          targetModel.validuptoCtrl.text = ewb.validUpto != null
              ? DateFormat('dd-MM-yyyy').format(ewb.validUpto!)
              : '';
          targetModel.invoicenoCtrl.text = ewb.invoiceNo ?? '';
          targetModel.invoicedateCtrl.text = ewb.invoiceDate != null
              ? DateFormat('dd-MM-yyyy').format(ewb.invoiceDate!)
              : '';
          targetModel.invoicevalueCtrl.text =
              ewb.invoiceValue?.toString() ?? '';
          targetModel.isValidated = true;
          targetModel.syncFromControllers();
        }
      });

      debugPrint('ewaybill list length: ${_ewayBillList.length}');
    }

    if (dimensionList.isNotEmpty) {
      setState(() {
        String pStr = '';
        String lStr = '';
        String bStr = '';
        String hStr = '';
        String vwStr = '';
        String cStr = '';
        double totalVWeightAccumulator = 0;

        for (var dim in dimensionList) {
          pStr += "${dim.pieces?.toInt() ?? 0},";
          lStr += "${dim.length?.toInt() ?? 0},";
          bStr += "${dim.breadth?.toInt() ?? 0},";
          hStr += "${dim.height?.toInt() ?? 0},";
          vwStr += "${dim.volumetricWeight?.toInt() ?? 0},";
          cStr += "10,"; // Defaulting to 10 as per DimensionScreen default
          totalVWeightAccumulator += dim.volumetricWeight ?? 0;
        }

        piecesStr = pStr;
        lengthStr = lStr;
        breadthStr = bStr;
        heightStr = hStr;
        vWeightStr = vwStr;
        cftStr = cStr;

        _vweightController.text = totalVWeightAccumulator.toInt().toString();
        manageChargableWeight();
      });
      debugPrint('dimension list length: ${dimensionList.length}');
    }
  }

  fetchAllLov() async {
    getBookingLovs();
    getEwayBillCreds();
    debugPrint('LOV DATA FETCHED SUCCESSFULLY');
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

    return lovViewModel.getBranchList(params);
  }

  Future<List<CustomerModel>> getCustomerList() async {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmusercode": savedUser.usercode.toString(),
      // "prmmenucode": 'GTAPP_BOOKINGWITHOUTINDENT',
      "prmsessionid": savedUser.sessionid.toString(),
      "prmcharstr": '',
    };

    return lovViewModel.getCustomerList(params);
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

    return lovViewModel.getCngrCngeList(params, type);
  }

  Future<List<DepartmentModel>> getDepartmentList() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmcustcode": _selectedCustomer!.custCode.toString(),
      "prmorgcode":
          _selectedOrigin == null ? "" : _selectedOrigin!.stnCode.toString(),
    };

    return lovViewModel.getDepartmentList(params);
  }

  Future<void> getEwayBillCreds() async {
    Map<String, String> params = {
      // "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmbookingbranchcode": '',
      "prmsessionid": savedUser.sessionid.toString(),
    };

    return viewModel.getEwayBillCreds(params);
  }

  Future<void> getBookingLovs() async {
    // Map<String, String> params = {
    //   "prmcompanyid": savedUser.companyid.toString(),
    //   "prmusercode": savedUser.usercode.toString(),
    //   "prmbranchcode": savedUser.loginbranchcode.toString(),
    //   "prmsessionid": savedUser.sessionid.toString(),
    // };
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmtransactionid": '0'
      // "prmusercode": savedUser.usercode.toString(),
      // "prmbranchcode": savedUser.loginbranchcode.toString(),
      // "prmsessionid": savedUser.sessionid.toString(),
    };

    return lovViewModel.getBookingLovs(params);
  }

  setObserver() {
    _subscriptions.add(viewModel.validateEwayBillList.stream.listen((data) {
      // debugPrint(data.toString());
      // _ewaybillCreds = data.first;
      if (data.isNotEmpty && data.first.commandstatus == -1) {
        failToast(data.first.commandmessage.toString());
      }
    }));

    _subscriptions.add(viewModel.refreshEwb.stream.listen((data) {
      debugPrint(data.toString());
      if (data.containsKey('ewbNo')) {
        String ewaybillno = data['ewbNo'];
        successToast('Ewaybill $ewaybillno verified successfully');
        EwayBillModel? targetModel;

        if (_firstEwayBill.ewaybillnoCtrl.text == ewaybillno) {
          targetModel = _firstEwayBill;
        } else {
          try {
            targetModel = _ewayBillList.firstWhere(
              (element) => element.ewaybillnoCtrl.text == ewaybillno,
            );
          } catch (e) {
            targetModel = null;
          }
        }

        if (targetModel != null) {
          final model = targetModel;
          setState(() {
            cngrgstno = data['fromGstin'].toString();
            cngegstno = data['toGstin'].toString();
            model.ewaybilldateCtrl.text =
                stringToDateTime(data['ewbDate'], 'dd/MM/yyyy HH:mm:ss a');
            model.validuptoCtrl.text =
                stringToDateTime(data['validUpto'], 'dd/MM/yyyy HH:mm:ss a');
            model.invoicenoCtrl.text = data['docNo'] ?? '';
            model.invoicevalueCtrl.text = data['totalValue']?.toString() ?? '';
            model.invoicedateCtrl.text = data['docDate'] ?? '';
            model.isValidated = true;
            model.syncFromControllers();
          });
          getCngrCngeCode(cngrgstno, cngegstno);
        }
      }
    }));

    _subscriptions.add(
      lovViewModel.serviceTypeList.stream.listen((data) {
        if (mounted) {
          setState(() {
            _serviceTypeList.clear();
            _serviceTypeList.addAll(data);
          });
        }
      }),
    );

    _subscriptions.add(
      lovViewModel.deliveryTypeList.stream.listen((data) {
        if (mounted) {
          setState(() {
            _deliveryTypeList.clear();
            _deliveryTypeList.addAll(data);
          });
        }
      }),
    );

    _subscriptions.add(
      lovViewModel.loadTypeList.stream.listen((data) {
        if (mounted) {
          setState(() {
            _loadTypeList.clear();
            _loadTypeList.addAll(data);
          });
        }
      }),
    );

    _subscriptions.add(viewModel.saveBookingLd.stream.listen((saveResponse) {
      if (saveResponse.commandStatus == 1) {
        successToast(
            saveResponse.commandMessage ?? "Booking saved successfully");
        Get.back();
      } else {
        failToast(saveResponse.commandMessage ?? "Something went wrong");
      }
    }));

    _subscriptions.add(viewModel.cngrCngeCodeLiveData.stream.listen((data) {
      if (data['commandstatus' == 1]) {
        _selectedCngr = CngrCngeModel(
          code: data['cngrcode'],
          name: data['cngrname'],
          city: data['cngrcity'],
          state: data['cngrstate'],
          zipCode: data['cngrzipcode'],
          telNo: data['cngrtelno'],
          address: data['cngraddress'],
          gstNo: cngrgstno,
        );

        _selectedCnge = CngrCngeModel(
          code: data['cngrcode'],
          name: data['cngrname'],
          city: data['cngrcity'],
          state: data['cngrstate'],
          zipCode: data['cngrzipcode'],
          telNo: data['cngrtelno'],
          address: data['cngraddress'],
          gstNo: cngegstno,
        );

        setState(() {});
      }
    }));

    _subscriptions.add(viewModel.viewDialog.stream.listen((show) {
      if (show) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    }));

    _subscriptions.add(viewModel.errorLiveData.stream.listen((data) {
      failToast(data);
    }));

    _subscriptions
        .add(viewModel.ewayBillDetailLiveData.stream.listen((show) {}));

    _subscriptions.add(viewModel.grDetailLiveData.stream.listen((show) {}));

    _subscriptions
        .add(viewModel.goodsDimensionDetailLiveData.stream.listen((show) {}));
  }

  addNewEWayBill() {
    EwayBillModel ewayBillModel = EwayBillModel();
    ewayBillModel.ewaybilldate =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    ewayBillModel.ewaybilldateCtrl.text = ewayBillModel.ewaybilldate!;
    ewayBillModel.validupto = DateFormat('dd-MM-yyyy').format(DateTime.now());
    ewayBillModel.validuptoCtrl.text = ewayBillModel.validupto!;
    ewayBillModel.invoicedate = DateFormat('dd-MM-yyyy').format(DateTime.now());
    ewayBillModel.invoicedateCtrl.text = ewayBillModel.invoicedate!;

    _ewayBillList.add(EwayBillModel());

    setState(() {});
  }

  deleteEwayBill(int index) {
    _ewayBillList.removeAt(index);
    setState(() {});
  }

  validateEwayBill(String ewaybillno, EwayBillCredentialsModel credentials) {
    if (credentials.ewayEnabled != 'Y') {
      failToast('Eway Bill API Not Allow To Login');
      return;
    }

    Map<String, String> params = {
      "userid": credentials.ewayUserId.toString(),
      "password": credentials.ewayPassword.toString(),
    };
    viewModel.ewayBillLogin(params, ewaybillno, credentials.compGst!);
  }

  void getCngrCngeCode(String cngrgstno, String cngegstno) {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmcngrgstno": cngrgstno,
      "prmcngegstno": cngegstno,
    };
    viewModel.getCngrCngeCode(params);
  }

  void changeChargableWeight() {
    if (!isNullOrEmpty(_gweightController.text.toString())) {
      if (double.tryParse(_gweightController.text.toString())! >
          double.tryParse(_cweightController.text.toString())!) {
        failToast('Chargable Weight Should Be Less Than Gross Weight');
        _cweightController.text = _gweightController.text.toString();
      }
    }
  }

  void manageChargableWeight() {
    // _cweightController.text = (max(
    //         double.tryParse(_vweightController.text.toString()) ?? 0,
    //         double.tryParse(_cweightController.text.toString()) ?? 0))
    //     .toString();

    double tempVWeight =
        double.tryParse(_vweightController.text.toString()) ?? 0;
    double tempGWeight =
        double.tryParse(_gweightController.text.toString()) ?? 0;

    if (tempVWeight > tempGWeight) {
      _cweightController.text = tempVWeight.toString();
    } else {
      _cweightController.text = tempGWeight.toString();
    }
  }

  Widget defaultEWayBillCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.verticalPadding,
            horizontal: SizeConfig.horizontalPadding),
        child: Column(
          children: [
            Text(
              "EwayBill #: 1",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.largeTextSize),
            ),
            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: AppFormField(
                    controller: _firstEwayBill.ewaybillnoCtrl,
                    focusNode: _firstEwayBill.ewaybillnoFocus,
                    label: "EwayBill No",
                    isRequired: true,
                    icon: Icons.abc,
                    keyboardType: TextInputType.text,
                    endIcon: Icons.check,
                    endIconColor: _firstEwayBill.isValidated
                        ? Colors.green
                        : CommonColors.primaryColorShade,
                    endIconOnTap: () {
                      if (isNullOrEmpty(_firstEwayBill.ewaybillnoCtrl.text)) {
                        failToast('EwayBill No requried');
                      } else {
                        validateEwayBill(
                            _firstEwayBill.ewaybillnoCtrl.text, _ewaybillCreds);
                      }
                    },
                    validator: (value) {
                      if (isNullOrEmpty(value)) {
                        return 'EwayBill No is required';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: AppFormField(
                    controller: _firstEwayBill.ewaybilldateCtrl,
                    focusNode: _firstEwayBill.ewaybilldateFocus,
                    label: "EwayBill Date",
                    isRequired: true,
                    icon: Icons.calendar_today,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: AppFormField(
                    controller: _firstEwayBill.validuptoCtrl,
                    focusNode: _firstEwayBill.validuptoFocus,
                    label: "Valid UpTo",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: AppFormField(
                    controller: _firstEwayBill.invoicenoCtrl,
                    focusNode: _firstEwayBill.invoicenoFocus,
                    label: "Invoice No",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: AppFormField(
                    controller: _firstEwayBill.invoicevalueCtrl,
                    focusNode: _firstEwayBill.invoicevalueFocus,
                    label: "Invoice Value",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: AppFormField(
                    controller: _firstEwayBill.invoicedateCtrl,
                    focusNode: _firstEwayBill.invoicedateFocus,
                    label: "Invoice Date",
                    isRequired: true,
                    icon: Icons.calendar_today,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.mediumVerticalSpacing,
            ),
            Visibility(
              visible: _firstEwayBill.isValidated == false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: CommonColors.red,
                    size: SizeConfig.largeIconSize,
                  ),
                  SizedBox(
                    width: SizeConfig.smallHorizontalSpacing,
                  ),
                  Text(
                    'EWAY Bill not validated',
                    style: TextStyle(
                        color: CommonColors.red,
                        fontSize: SizeConfig.mediumTextSize,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.mediumVerticalSpacing,
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    // addNewInvoice();
                    addNewEWayBill();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.colorPrimary,
                    foregroundColor: CommonColors.White,
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.smallVerticalSpacing),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add More",
                    style: TextStyle(
                      fontSize: SizeConfig.mediumTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget eWayBillCard(EwayBillModel model, int index) {
    // EwayBillModel eWayBill = _ewayBillList[index - 2];
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.verticalPadding,
            horizontal: SizeConfig.horizontalPadding),
        child: Column(
          children: [
            Text(
              "EwayBill #: $index",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.largeTextSize),
            ),
            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: AppFormField(
                    controller: model.ewaybillnoCtrl,
                    focusNode: model.ewaybillnoFocus,
                    label: "EwayBill No",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: true,
                    keyboardType: TextInputType.text,
                    endIcon: Icons.check,
                    endIconColor: model.isValidated
                        ? Colors.green
                        : CommonColors.primaryColorShade,
                    endIconOnTap: () {
                      // Focus.of(context).unfocus();
                      if (isNullOrEmpty(model.ewaybillnoCtrl.text)) {
                        failToast('EwayBill No requried');
                      } else {
                        validateEwayBill(
                            model.ewaybillnoCtrl.text, _ewaybillCreds);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: AppFormField(
                    controller: model.ewaybilldateCtrl,
                    focusNode: model.ewaybilldateFocus,
                    label: "EwayBill Date",
                    isRequired: true,
                    icon: Icons.calendar_today,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: AppFormField(
                    controller: model.validuptoCtrl,
                    focusNode: model.validuptoFocus,
                    label: "Valid UpTo",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: AppFormField(
                    controller: model.invoicenoCtrl,
                    focusNode: model.invoicenoFocus,
                    label: "Invoice No",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: AppFormField(
                    controller: model.invoicevalueCtrl,
                    focusNode: model.invoicevalueFocus,
                    label: "Invoice Value",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: AppFormField(
                    controller: model.invoicedateCtrl,
                    focusNode: model.invoicedateFocus,
                    label: "Invoice Date",
                    isRequired: true,
                    icon: Icons.calendar_today,
                    isInput: false,
                    keyboardType: TextInputType.none,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.mediumVerticalSpacing,
            ),
            Visibility(
              visible: model.isValidated == false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_outlined,
                    color: CommonColors.red,
                    size: SizeConfig.largeIconSize,
                  ),
                  SizedBox(
                    width: SizeConfig.smallHorizontalSpacing,
                  ),
                  Text(
                    'EWAY Bill not validated',
                    style: TextStyle(
                        color: CommonColors.red,
                        fontSize: SizeConfig.mediumTextSize,
                        fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.mediumVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          // addNewInvoice();
                          addNewEWayBill();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary,
                          foregroundColor: CommonColors.White,
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.smallVerticalSpacing),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Add More",
                          style: TextStyle(
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          // addNewInvoice();
                          deleteEwayBill(index - 2);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary,
                          foregroundColor: CommonColors.White,
                          padding: EdgeInsets.symmetric(
                              vertical: SizeConfig.smallVerticalSpacing),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool checkEwayBillValidation() {
    if (!_firstEwayBill.isValidated) {
      failToast("EwayBill #1 not validated");
      return false;
    }
    for (int i = 0; i < _ewayBillList.length; i++) {
      if (!_ewayBillList[i].isValidated) {
        failToast("EwayBill #${i + 2} not validated");
        return false;
      }
    }
    return true;
  }

  void validateForm() {
    if (!_formKey.currentState!.validate()) {
      failToast("Please fill all required fields");
      return;
    }
    if (!checkEwayBillValidation()) {
      return;
    }
    if (isNullOrEmpty(selectedImagePath)) {
      failToast("Booking image is required");
      return;
    } else {
      saveBooking();
    }
  }

  void saveBooking() {
    String ewaybillnostr = '${_firstEwayBill.ewaybillnoCtrl.text.toString()},',
        ewaybilldtstr =
            '${convert2SmallDateTime(_firstEwayBill.ewaybilldateCtrl.text)},',
        validuptostr =
            '${convert2SmallDateTime(_firstEwayBill.validuptoCtrl.text)},',
        invoicenostr = '${_firstEwayBill.invoicenoCtrl.text.toString()},',
        invoicevaluestr = '${_firstEwayBill.invoicevalueCtrl.text.toString()},',
        invoicedtstr =
            '${convert2SmallDateTime(_firstEwayBill.invoicedateCtrl.text)},';
    for (int i = 0; i < _ewayBillList.length; i++) {
      EwayBillModel bill = _ewayBillList[i];
      ewaybillnostr += "${bill.ewaybillnoCtrl.text},";
      ewaybilldtstr += '${convert2SmallDateTime(bill.ewaybilldateCtrl.text)},';
      validuptostr += '${convert2SmallDateTime(bill.validuptoCtrl.text)},';
      invoicenostr += "${bill.invoicenoCtrl.text},";
      invoicevaluestr += "${bill.invoicevalueCtrl.text},";
      invoicedtstr += "${convert2SmallDateTime(bill.invoicedateCtrl.text)},";
    }
    Map<String, String> params = {
      'prmconnstring': savedUser.companyid.toString(),
      'prmtransactionid': '0',
      'prmbranchcode': _selectedOrigin!.stnCode.toString(),
      'prmbranchname': _selectedOrigin!.stnName.toString(),
      'prmbookingdt': convert2SmallDateTime(_bookingDateController.text),
      'prmtime': formatTimeString(_bookingTimeController.text),
      'prmegrno': autoGr ? '' : _grNoController.text,
      'prmcustcode': _selectedCustomer!.custCode.toString(),
      'prmcustdeptid':
          _selectedDept == null ? '' : _selectedDept!.custDeptId.toString(),
      'prmdestcode': _selectedDestination!.stnCode.toString(),
      'prmdestname': _selectedDestination!.stnName.toString(),
      'prmproductcode': _selectedServiceType!.prodCode.toString(),
      'prmpckgs': _noofpckgsController.text.toString(),
      'prmaweight': _gweightController.text.toString(),
      'prmcweight': _cweightController.text.toString(),
      'prmvweight': _vweightController.text.toString(),
      'prmcngr': _selectedCngr!.name.toString(),
      'prmcngrcode': _selectedCngr!.code.toString(),
      'prmcngrgstno': isNullOrEmpty(_selectedCngr!.gstNo)
          ? ''
          : _selectedCngr!.gstNo.toString(),
      'prmcngrcountry': _selectedCngr!.country.toString(),
      'prmcngrstate': _selectedCngr!.state.toString(),
      'prmcngraddress': _selectedCngr!.address.toString(),
      'prmcngrzipcode': _selectedCngr!.zipCode.toString(),
      'prmcnge': _selectedCnge!.name.toString(),
      'prmcngecode': _selectedCnge!.code.toString(),
      'prmcngegstno': isNullOrEmpty(_selectedCnge!.gstNo)
          ? ''
          : _selectedCnge!.gstNo.toString(),
      'prmcngecountry': _selectedCnge!.country.toString(),
      'prmcngestate': _selectedCnge!.state.toString(),
      'prmcngeaddress': _selectedCnge!.address.toString(),
      'prmcngezipcode': _selectedCnge!.zipCode.toString(),
      'prmewaybillnostr': ewaybillnostr,
      'prmewaybilldtstr': ewaybilldtstr,
      'prmewaybillvaliduptostr': validuptostr,
      'prminvoicenostr': invoicenostr,
      'prminvoicedtstr': invoicedtstr,
      'prminvoicevaluestr': invoicevaluestr,
      'prmautogrno': autoGr ? 'Y' : 'N',
      'prmpckglengthstr': lengthStr,
      'prmpckgbreadthstr': breadthStr,
      'prmpckgheightstr': heightStr,
      'prmpckgsstr': piecesStr,
      'prmvweightstr': vWeightStr,
      'prmdeliverytype': _selectedDeliveryType!.deliveryType.toString(),
      'prmloadtype': _selectedLoadType!.code.toString(),
      'prmvehicle': _selectedVehicle == null
          ? ''
          : _selectedVehicle!.vehicleCode.toString(),
      'prmremarks': _remarksController.text.toString(),
      // 'prmbranchname': savedUser.loginbranchname.toString(),
      'prmbookingimgpath': convertFilePathToBase64(selectedImagePath),
      'prmsignimgpath': convertFilePathToBase64(_selectedSignaturePath),
      'prmdrivercode': savedUser.drivercode.toString(),
      'prmusercode': savedUser.usercode.toString(),
      'prmmenucode': 'GTLMD_BOOKING',
      'prmsessionid': savedUser.sessionid.toString(),
    };

    // debugPrint(params.toString());
    viewModel.saveBooking(params);
  }

  void changeChargeableWeight(String value) {
    double gross = double.tryParse(_gweightController.text) ?? 0;
    double chargeable = double.tryParse(value) ?? 0;

    if (chargeable < gross) {
      // Show toast
      // Fluttertoast.showToast(
      //   msg: "Chargeable Weight can't be less than Gross Weight",
      // );
      failToast("Chargeable Weight can't be less than Gross Weight");

      // Set chargeable weight equal to gross weight
      _cweightController.text = gross.toString();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        title: Text(
          "Booking With Eway-Bill",
          style: TextStyle(fontSize: SizeConfig.largeTextSize),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const BookingListScreen());
              },
              icon: const Icon(Symbols.view_list))
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              final focusScope = FocusScope.of(context);
              if (focusScope.hasFocus) {
                focusScope.unfocus();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalPadding,
                    vertical: SizeConfig.verticalPadding),
                child: Column(
                  children: [
                    if (_isLoadingLov) const AnimatedLoadingText(),
                    if (_isLoadingLov)
                      SizedBox(height: SizeConfig.smallVerticalSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField(
                            controller: _bookingDateController,
                            focusNode: _bookingDateFocusNode,
                            label: "Booking Date",
                            isRequired: true,
                            icon: Icons.calendar_today,
                            isInput: false,
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.none,
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.mediumHorizontalSpacing,
                        ),
                        Expanded(
                          child: AppFormField(
                            controller: _bookingTimeController,
                            focusNode: _bookingTimeFocusNode,
                            label: "Booking Time",
                            isRequired: true,
                            icon: Icons.calendar_today,
                            isInput: false,
                            keyboardType: TextInputType.none,
                            textInputAction: TextInputAction.none,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.mediumVerticalSpacing,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: AppFormField(
                            controller: _grNoController,
                            focusNode: _grNoFocusNode,
                            label: 'Consignment',
                            isRequired: autoGr ? false : true,
                            icon: Icons.code,
                            isInput: autoGr ? false : true,
                            keyboardType: TextInputType.text,
                            onSubmitted: () {
                              FocusScope.of(context)
                                  .requestFocus(_grNoFocusNode);
                            },
                            validator: (value) {
                              if (isNullOrEmpty(value) && !autoGr) {
                                return 'Consignment is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(
                          width: SizeConfig.smallHorizontalSpacing,
                        ),
                        Row(
                          children: [
                            Text(
                              "Auto ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: SizeConfig.mediumTextSize),
                            ),
                            Checkbox(
                              value: autoGr,
                              activeColor: CommonColors.colorPrimary,
                              onChanged: (bool? value) {
                                autoGr = value!;
                                if (autoGr) {
                                  _grNoController.text = '';
                                }
                                setState(() {});
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    AppFormField(
                      controller: _originNameController,
                      focusNode: _originNameFocusNode,
                      label: 'Origin',
                      isRequired: true,
                      icon: Icons.location_on,
                      isInput: false,
                      keyboardType: TextInputType.none,
                      endIcon: Icons.arrow_drop_down,
                      endIconColor: CommonColors.grey400,
                      validator: (value) {
                        if (isNullOrEmpty(value)) {
                          return 'Origin is required';
                        }
                        return null;
                      },
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        // List<CommonDataModel<BranchModel>> commonList =
                        //     _branchList
                        //         .map((branch) => CommonDataModel<BranchModel>(
                        //               branch.stnName ??
                        //                   branch.stnName ??
                        //                   'Unknown',
                        //               branch,
                        //             ))
                        //         .toList();
                        // showCommonBottomSheet(context, 'Select Origin', (data) {
                        //   _selectedOrigin = data;
                        //   _originNameController.text = data.stnName;
                        //   _originNameFocusNode.unfocus();
                        // }, commonList);
                        showBranchSelectionBottomSheet(context, 'Select Origin',
                            (data) {
                          _selectedOrigin = data;
                          _originNameController.text = data.stnName;
                          _originNameFocusNode.unfocus();
                        });
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    AppFormField(
                      controller: _destNameController,
                      focusNode: _destNameFocusNode,
                      label: 'Destination',
                      isRequired: true,
                      icon: Icons.location_on,
                      isInput: false,
                      keyboardType: TextInputType.none,
                      endIcon: Icons.arrow_drop_down,
                      endIconColor: CommonColors.grey400,
                      validator: (value) {
                        if (isNullOrEmpty(value)) {
                          return 'Destination is required';
                        }
                        return null;
                      },
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        // List<CommonDataModel<BranchModel>> commonList =
                        //     _branchList
                        //         .map((branch) => CommonDataModel<BranchModel>(
                        //               branch.stnName ??
                        //                   branch.stnName ??
                        //                   'Unknown',
                        //               branch,
                        //             ))
                        //         .toList();
                        // showCommonBottomSheet(context, 'Select Destination',
                        //     (data) {
                        //   _selectedDestination = data;
                        //   _destNameController.text = data.stnName;
                        //   _destNameFocusNode.unfocus();
                        // }, commonList);
                        showBranchSelectionBottomSheet(
                            context, 'Select Destination', (data) {
                          _selectedDestination = data;
                          _destNameController.text = data.stnName;
                          _destNameFocusNode.unfocus();
                        });
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    AppFormField(
                      controller: _custNameController,
                      focusNode: _custNameFocusNode,
                      label: 'Customer',
                      isRequired: true,
                      icon: Icons.person,
                      endIcon: Icons.arrow_drop_down,
                      endIconColor: CommonColors.grey400,
                      validator: (value) {
                        if (isNullOrEmpty(value)) {
                          return 'Customer is required';
                        }
                        return null;
                      },
                      isInput: false,
                      keyboardType: TextInputType.none,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        List<CommonDataModel<CustomerModel>> commonList =
                            _customerList
                                .map((customer) =>
                                    CommonDataModel<CustomerModel>(
                                      customer.custName ??
                                          customer.custName ??
                                          'Unknown',
                                      customer,
                                    ))
                                .toList();
                        debugPrint('User ${savedUser.companyid.toString()}');
                        showCustomerSelectionBottomSheet(
                          context,
                          (data) {
                            _selectedCustomer = data;
                            _custNameController.text = data.custName;
                            _custNameFocusNode.unfocus();
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    AppFormField(
                      controller: _deptNameController,
                      focusNode: _deptNameFocusNode,
                      label: 'Department',
                      isRequired: false,
                      icon: Icons.person,
                      endIcon: Icons.arrow_drop_down,
                      endIconColor: CommonColors.grey400,
                      isInput: false,
                      keyboardType: TextInputType.none,
                      onTap: () async {
                        if (_selectedCustomer == null) {
                          failToast('Please select customer first');
                        } else {
                          FocusScope.of(context).unfocus();
                          loadingAlertService.showLoading();
                          // _departmentList = await getDepartmentList();
                          loadingAlertService.hideLoading();
                          // List<CommonDataModel<DepartmentModel>> commonList =
                          //     _departmentList
                          //         .map((department) =>
                          //             CommonDataModel<DepartmentModel>(
                          //               department.custDeptName ??
                          //                   department.custDeptName ??
                          //                   'Unknown',
                          //               department,
                          //             ))
                          //         .toList();
                          // showCommonBottomSheet(context, 'Select Department',
                          //     (data) {
                          //   _selectedDept = data;
                          //   _deptNameController.text = data.custDeptName;
                          //   _deptNameFocusNode.unfocus();
                          // }, commonList);
                          showDepartmentSelectionBottomSheet(context, (data) {
                            _selectedDept = data;
                            _deptNameController.text = data.custDeptName;
                            _deptNameFocusNode.unfocus();
                          }, _selectedCustomer!.custCode.toString(),
                              _selectedOrigin!.stnCode.toString());
                        }
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.horizontalPadding,
                            vertical: SizeConfig.verticalPadding),
                        child: Column(
                          children: [
                            AppFormField(
                              controller: _cngrNameController,
                              focusNode: _cngrNameFocusNode,
                              label: 'Consignor',
                              isRequired: true,
                              icon: Icons.person,
                              isInput: false,
                              endIcon: Icons.arrow_drop_down,
                              endIconColor: CommonColors.grey400,
                              keyboardType: TextInputType.none,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // List<CommonDataModel<CngrCngeModel>>
                                //     commonList = _cngrList
                                //         .map((cngr) =>
                                //             CommonDataModel<CngrCngeModel>(
                                //               cngr.name ??
                                //                   cngr.name ??
                                //                   'Unknown',
                                //               cngr,
                                //             ))
                                //         .toList();
                                // showCommonBottomSheet(
                                //     context, 'Select Consignor', (data) {
                                //   _selectedCngr = data;
                                //   _cngrNameController.text =
                                //       isNullOrEmpty(data.name) ? '' : data.name;
                                //   _cngrGstController.text =
                                //       isNullOrEmpty(data.gstNo)
                                //           ? ''
                                //           : data.gstNo;
                                //   _cngrNameFocusNode.unfocus();
                                // }, commonList);

                                if (_selectedCustomer == null) {
                                  failToast('Please select customer first');
                                  return;
                                }
                                showCngeCngeSelectionBottomSheet(
                                  context,
                                  'Consignor',
                                  (data) {
                                    _selectedCngr = data;
                                    _cngrNameController.text =
                                        isNullOrEmpty(data.name)
                                            ? ''
                                            : data.name;
                                    _cngrGstController.text =
                                        isNullOrEmpty(data.gstNo)
                                            ? ''
                                            : data.gstNo;
                                    _cngrNameFocusNode.unfocus();
                                  },
                                  _selectedCustomer!.custCode.toString(),
                                  'R',
                                );
                              },
                              validator: (value) {
                                if (isNullOrEmpty(value)) {
                                  return 'Consignor is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.smallHorizontalSpacing,
                            ),
                            AppFormField(
                              controller: _cngrGstController,
                              focusNode: _cngrGstFocusNode,
                              label: 'GST',
                              isRequired: false,
                              icon: Icons.code,
                              keyboardType: TextInputType.none,
                              isInput: false,
                              textInputAction: TextInputAction.none,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.horizontalPadding,
                            vertical: SizeConfig.verticalPadding),
                        child: Column(
                          children: [
                            AppFormField(
                              controller: _cngeNameController,
                              focusNode: _cngeNameFocusNode,
                              label: 'Consignee',
                              isRequired: true,
                              icon: Icons.person,
                              isInput: false,
                              endIcon: Icons.arrow_drop_down,
                              endIconColor: CommonColors.grey400,
                              keyboardType: TextInputType.none,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                // List<CommonDataModel<CngrCngeModel>>
                                //     commonList = _cngeList
                                //         .map((cnge) =>
                                //             CommonDataModel<CngrCngeModel>(
                                //               cnge.name ??
                                //                   cnge.name ??
                                //                   'Unknown',
                                //               cnge,
                                //             ))
                                //         .toList();
                                // showCommonBottomSheet(
                                //     context, 'Select Consignee', (data) {
                                //   _selectedCnge = data;
                                //   _cngeNameController.text =
                                //       isNullOrEmpty(data.name) ? '' : data.name;
                                //   _cngeGstController.text =
                                //       isNullOrEmpty(data.gstNo)
                                //           ? ''
                                //           : data.gstNo;
                                //   _cngeNameFocusNode.unfocus();
                                // }, commonList);

                                if (_selectedDestination == null) {
                                  failToast('Please select destination first');
                                  return;
                                }
                                showCngeCngeSelectionBottomSheet(
                                  context,
                                  'Consignee',
                                  (data) {
                                    _selectedCnge = data;
                                    _cngeNameController.text =
                                        isNullOrEmpty(data.name)
                                            ? ''
                                            : data.name;
                                    _cngeGstController.text =
                                        isNullOrEmpty(data.gstNo)
                                            ? ''
                                            : data.gstNo;
                                    _cngeNameFocusNode.unfocus();
                                  },
                                  _selectedCustomer!.custCode.toString(),
                                  'E',
                                );
                              },
                              validator: (value) {
                                if (isNullOrEmpty(value)) {
                                  return 'Consignee is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: SizeConfig.smallHorizontalSpacing,
                            ),
                            AppFormField(
                              controller: _cngeGstController,
                              focusNode: _cngeGstFocusNode,
                              label: 'GST',
                              isRequired: false,
                              icon: Icons.code,
                              keyboardType: TextInputType.none,
                              isInput: false,
                              textInputAction: TextInputAction.none,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.mediumVerticalSpacing,
                    ),
                    defaultEWayBillCard(),
                    SizedBox(
                      height: SizeConfig.mediumVerticalSpacing,
                    ),
                    SizedBox(height: SizeConfig.mediumVerticalSpacing),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _ewayBillList.length,
                      itemBuilder: (context, index) {
                        return eWayBillCard(_ewayBillList[index], index + 2);
                      },
                    ),
                    AppFormField(
                      controller: _serviceTypeController,
                      focusNode: _servieTypeFocusNode,
                      label: 'Service Type',
                      isRequired: true,
                      isInput: false,
                      icon: Icons.abc,
                      endIcon: Icons.arrow_drop_down,
                      endIconColor: CommonColors.grey400,
                      keyboardType: TextInputType.none,
                      validator: (value) {
                        if (isNullOrEmpty(value)) {
                          return 'Service Type is required';
                        }
                        return null;
                      },
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        List<CommonDataModel<ServiceTypeModel>> commonList =
                            _serviceTypeList
                                .map((service) =>
                                    CommonDataModel<ServiceTypeModel>(
                                      service.prodName ??
                                          service.prodName ??
                                          'Unknown',
                                      service,
                                    ))
                                .toList();
                        showCommonBottomSheet(context, 'Service Type', (data) {
                          _selectedServiceType = data;
                          _serviceTypeController.text = data.prodName;
                          _servieTypeFocusNode.unfocus();
                        }, commonList);
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    AppFormField(
                      controller: _loadTypeController,
                      focusNode: _loadTypeFocusNode,
                      label: 'Load Type',
                      isRequired: true,
                      isInput: false,
                      icon: Icons.abc,
                      endIcon: Icons.arrow_drop_down,
                      endIconColor: CommonColors.grey400,
                      keyboardType: TextInputType.none,
                      validator: (value) {
                        if (isNullOrEmpty(value)) {
                          return 'Load Type is required';
                        }
                        return null;
                      },
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        List<CommonDataModel<LoadTypeModel>> commonList =
                            _loadTypeList
                                .map((load) => CommonDataModel<LoadTypeModel>(
                                      load.name ?? load.name ?? 'Unknown',
                                      load,
                                    ))
                                .toList();
                        showCommonBottomSheet(context, 'Load Type', (data) {
                          _selectedLoadType = data;
                          _loadTypeController.text = data.name;
                          _loadTypeFocusNode.unfocus();
                        }, commonList);
                      },
                    ),
                    Visibility(
                        visible: _selectedLoadType != null &&
                            _selectedLoadType!.code == 'F' &&
                            _selectedServiceType != null &&
                            _selectedServiceType!.modeType == 'S',
                        child: Column(children: [
                          SizedBox(
                            height: SizeConfig.mediumHorizontalSpacing,
                          ),
                          AppFormField(
                            controller: _vehicleController,
                            focusNode: _vehicleFocusNode,
                            label: 'Vehicle',
                            isRequired: true,
                            isInput: false,
                            icon: Icons.abc,
                            endIcon: Icons.arrow_drop_down,
                            endIconColor: CommonColors.grey400,
                            keyboardType: TextInputType.none,
                            validator: (value) {
                              if (_selectedServiceType!.modeType == 'S' &&
                                  _selectedLoadType!.code == 'F' &&
                                  isNullOrEmpty(value)) {
                                return 'Vehicle is required';
                              }
                              return null;
                            },
                            onTap: () async {
                              FocusScope.of(context).unfocus();
                              showVehicleSelectionBottomSheet(context, (data) {
                                _selectedVehicle = data;
                                _vehicleController.text = data.vehicleCode;
                                _vehicleFocusNode.unfocus();
                              });
                            },
                          ),
                        ])),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    AppFormField(
                      controller: _deliveryTypeController,
                      focusNode: _deliveryTypeFocusNode,
                      label: 'Delivery Type',
                      isRequired: true,
                      isInput: false,
                      icon: Icons.abc,
                      validator: (value) {
                        if (isNullOrEmpty(value)) {
                          return 'Delivery Type is required';
                        }
                        return null;
                      },
                      endIcon: Icons.arrow_drop_down,
                      endIconColor: CommonColors.grey400,
                      keyboardType: TextInputType.none,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        List<CommonDataModel<DeliveryTypeModel>> commonList =
                            _deliveryTypeList
                                .map((delivery) =>
                                    CommonDataModel<DeliveryTypeModel>(
                                      delivery.deliveryTypeName ?? 'Unknown',
                                      delivery,
                                    ))
                                .toList();
                        showCommonBottomSheet(context, 'Delivery Type', (data) {
                          _selectedDeliveryType = data;
                          _deliveryTypeController.text = data.deliveryTypeName;
                          _deliveryTypeFocusNode.unfocus();
                        }, commonList);
                      },
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField(
                            controller: _noofpckgsController,
                            focusNode: _noofpckgsFocusNode,
                            label: 'No of Pckgs',
                            isRequired: true,
                            keyboardType: TextInputType.number,
                            icon: Icons.abc,
                            validator: (value) {
                              if (isNullOrEmpty(value)) {
                                return 'No of Pckgs is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: SizeConfig.smallHorizontalSpacing),
                        Expanded(
                          child: AppFormField(
                            controller: _gweightController,
                            focusNode: _gweightFocusNode,
                            label: 'Gross Weight',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                            icon: Icons.abc,
                            onChanged: (value) {
                              manageChargableWeight();
                            },
                            validator: (value) {
                              if (isNullOrEmpty(value)) {
                                return 'Gross Weight is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AppFormField(
                            controller: _vweightController,
                            focusNode: _vweightFocusNode,
                            label: 'Vol Weight',
                            keyboardType: TextInputType.number,
                            isRequired: true,
                            icon: Icons.abc,
                            onChanged: (value) {
                              manageChargableWeight();
                            },
                            validator: (value) {
                              if (isNullOrEmpty(value)) {
                                return 'Vol Weight is required';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: SizeConfig.smallHorizontalSpacing),
                        Expanded(
                          child: AppFormField(
                            controller: _cweightController,
                            focusNode: _cweightFocusNode,
                            label: 'Chargeable Weight',
                            isRequired: true,
                            keyboardType: TextInputType.number,
                            icon: Icons.abc,
                            onChanged: (value) {
                              changeChargeableWeight(value);
                            },
                            validator: (value) {
                              if (isNullOrEmpty(value)) {
                                return 'Chargeable Weight is required';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.horizontalPadding,
                            right: SizeConfig.horizontalPadding,
                            top: 0,
                            bottom: SizeConfig.verticalPadding),
                        child: ElevatedButton(
                          onPressed: () {
                            if (isNullOrEmpty(
                                _noofpckgsController.text.toString())) {
                              failToast("No of Pckgs is required");
                              return;
                            }
                            if (_selectedServiceType == null) {
                              failToast("Select Service Type first");
                              return;
                            }
                            showDimensionsScreen(
                                    context,
                                    isNullOrEmpty(_noofpckgsController.text
                                            .toString())
                                        ? 0
                                        : int.parse(_noofpckgsController.text
                                                .toString())
                                            .toInt(),
                                    _serviceTypeList.isEmpty
                                        ? false
                                        : _serviceTypeList[0].isCft ?? false,
                                    _selectedServiceType!,
                                    pieces: piecesStr,
                                    length: lengthStr,
                                    breadth: breadthStr,
                                    height: heightStr,
                                    vweight: vWeightStr,
                                    cft: cftStr)
                                .then((value) {
                              if (value != null) {
                                manageChargableWeight();
                                _vweightController.text =
                                    value['totalVWeight'].toString();
                                piecesStr = value['pieces'];
                                lengthStr = value['length'];
                                breadthStr = value['breadth'];
                                heightStr = value['height'];
                                vWeightStr = value['vweight'];
                                cftStr = value['cft'];
                                setState(() {});
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CommonColors.colorPrimary,
                            foregroundColor: CommonColors.White,
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.smallVerticalSpacing),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Dimensions",
                            style: TextStyle(
                              fontSize: SizeConfig.mediumTextSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    AppFormField(
                        controller: _remarksController,
                        focusNode: _remarksFocusNode,
                        label: 'Remarks',
                        isRequired: false,
                        keyboardType: TextInputType.text,
                        icon: Icons.text_fields),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              showImagePickerDialog(context, (file) async {
                                if (file != null) {
                                  debugPrint('POD File data: ${file.path}');
                                  setState(() {
                                    selectedImagePath = file.path;
                                  });
                                } else {
                                  // model!.stamp = 'N';
                                  failToast("File not selected");
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.attach_file,
                                  size: SizeConfig.largeIconSize,
                                  weight: 700,
                                ),
                                SizedBox(
                                  width: SizeConfig.extraSmallHorizontalSpacing,
                                ),
                                Text(
                                  'Attach File',
                                  style: TextStyle(
                                      fontSize: SizeConfig.largeTextSize,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.dashed),
                                ),
                                // SizedBox(
                                //   width: SizeConfig.mediumHorizontalSpacing,
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              // showImagePickerDialog(context, (file) async {
                              //   if (file != null) {
                              //     debugPrint('POD File data: ${file.path}');
                              //     setState(() {
                              //       selectedImagePath = file.path;
                              //     });
                              //   } else {
                              //     // model!.stamp = 'N';
                              //     failToast("File not selected");
                              //   }
                              // });

                              showSignatureBottomSheet(context, (path, base64) {
                                if (!isNullOrEmpty(path)) {
                                  setState(() {
                                    _selectedSignaturePath = path;
                                  });
                                } else {
                                  failToast('Please input signature again.');
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.attach_file,
                                  size: SizeConfig.largeIconSize,
                                  weight: 700,
                                ),
                                SizedBox(
                                  width: SizeConfig.extraSmallHorizontalSpacing,
                                ),
                                Text(
                                  'Signature',
                                  style: TextStyle(
                                      fontSize: SizeConfig.largeTextSize,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      decorationStyle:
                                          TextDecorationStyle.dashed),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.mediumVerticalSpacing,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: selectedImagePath.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    showDialogWithImage(
                                        context, selectedImagePath,
                                        isLocal: !selectedImagePath
                                            .startsWith('http'));
                                  },
                                  child: SizedBox(
                                    height: SizeConfig.screenHeight * 0.2,
                                    width: SizeConfig.screenWidth,
                                    child: selectedImagePath.startsWith('http')
                                        ? Image.network(
                                            selectedImagePath,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          )
                                        : Image.file(
                                            File(selectedImagePath),
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                )
                              : Container(),
                        ),
                        Expanded(
                          child: _selectedSignaturePath.isNotEmpty
                              ? GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                    showDialogWithImage(
                                        context, _selectedSignaturePath,
                                        isLocal: !_selectedSignaturePath
                                            .startsWith('http'));
                                  },
                                  child: SizedBox(
                                    height: SizeConfig.screenHeight * 0.2,
                                    width: SizeConfig.screenWidth,
                                    child: _selectedSignaturePath
                                            .startsWith('http')
                                        ? Image.network(
                                            _selectedSignaturePath,
                                            fit: BoxFit.contain,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          )
                                        : Image.file(
                                            File(_selectedSignaturePath),
                                            fit: BoxFit.contain,
                                          ),
                                  ),
                                )
                              : Container(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.mediumVerticalSpacing,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: SizeConfig.horizontalPadding,
                            right: SizeConfig.horizontalPadding,
                            top: 0,
                            bottom: SizeConfig.verticalPadding),
                        child: ElevatedButton(
                          onPressed: () {
                            validateForm();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CommonColors.colorPrimary,
                            foregroundColor: CommonColors.White,
                            padding: EdgeInsets.symmetric(
                                vertical: SizeConfig.smallVerticalSpacing),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Save",
                            style: TextStyle(
                              fontSize: SizeConfig.mediumTextSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AnimatedLoadingText extends StatefulWidget {
  const AnimatedLoadingText({super.key});

  @override
  State<AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<AnimatedLoadingText> {
  int _dotCount = 0;
  late final Stream<int> _dotStream;

  @override
  void initState() {
    super.initState();
    _dotStream =
        Stream.periodic(const Duration(milliseconds: 500), (i) => i % 4);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _dotStream,
      initialData: 0,
      builder: (context, snapshot) {
        final dots = '.' * (snapshot.data ?? 0);
        return Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.extraSmallVerticalSpacing,
              horizontal: SizeConfig.smallHorizontalSpacing),
          decoration: BoxDecoration(
            color: CommonColors.primaryColorShade!.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(CommonColors.colorPrimary!),
                ),
              ),
              SizedBox(width: SizeConfig.smallHorizontalSpacing),
              Text(
                "Loading data$dots",
                style: TextStyle(
                  fontSize: SizeConfig.smallTextSize,
                  fontWeight: FontWeight.w500,
                  color: CommonColors.colorPrimary,
                ),
              ),
              // Empty space to prevent layout jump
              const Opacity(
                opacity: 0,
                child: Text("..."),
              ),
            ],
          ),
        );
      },
    );
  }
}
