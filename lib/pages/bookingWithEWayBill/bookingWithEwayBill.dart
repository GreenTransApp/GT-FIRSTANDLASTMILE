import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/commonBottomSheets.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/common/viewModel/lovViewModel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/appFormField.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBillViewModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/EwayBillCredentialsModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/ewayBillModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

class BookingWithEwayBill extends StatefulWidget {
  const BookingWithEwayBill({super.key});

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
  CngrCngeModel? _selectedServiceType;
  CngrCngeModel? _selectedDeliveryType;
  late EwayBillModel _firstEwayBill;
  late EwayBillCredentialsModel _ewaybillCreds;
  String selectedImagePath = "";

  List<EwayBillModel> _ewayBillList = [];
  List<BranchModel> _branchList = [];
  List<CustomerModel> _customerList = [];
  List<CngrCngeModel> _cngrList = [];
  List<CngrCngeModel> _cngeList = [];
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    _firstEwayBill = EwayBillModel();
    _bookingDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    _bookingTimeController.text = DateFormat('HH:mm a').format(DateTime.now());
    fetchAllLov();
    setObserver();
    getEwayBillCreds();
  }

  fetchAllLov() async {
    setState(() {
      _isLoadingLov = true;
    });
    final futures = [
      getBranchList(),
      getCustomerList(),
      getCngrCngeList('R'),
      getCngrCngeList('E'),
      // getEwayBillCreds(),
    ];

    try {
      final results = await Future.wait(futures);

      if (mounted) {
        setState(() {
          _branchList = results[0] as List<BranchModel>;
          _customerList = results[1] as List<CustomerModel>;
          _cngrList = results[2] as List<CngrCngeModel>;
          _cngeList = results[3] as List<CngrCngeModel>;
          _isLoadingLov = false;
        });
        debugPrint('LOV DATA FETCHED SUCCESSFULLY');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingLov = false;
        });
      }
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

  setObserver() {
    viewModel.validateEwayBillList.stream.listen((data) {
      // debugPrint(data.toString());
      _ewaybillCreds = data.first;
      if (data.isNotEmpty && data.first.commandstatus == -1) {
        failToast(data.first.commandmessage.toString());
      }
    });

    viewModel.refreshEwb.stream.listen((data) {
      debugPrint(data.toString());
      if (data.containsKey('ewaybillno')) {
        String ewaybillno = data['ewaybillno'];
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
            model.ewaybilldateCtrl.text = data['ewbDate'] ?? '';
            model.validuptoCtrl.text = data['validUpto'] ?? '';
            model.invoicenoCtrl.text = data['docNo'] ?? '';
            model.invoicevalueCtrl.text = data['totalValue']?.toString() ?? '';
            model.invoicedateCtrl.text = data['docDate'] ?? '';
            model.isValidated = true;
            model.syncFromControllers();
          });
        }
      }
    });
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
    EwayBillModel eWayBill = _ewayBillList[index - 2];
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
                    controller: eWayBill.ewaybillnoCtrl,
                    focusNode: eWayBill.ewaybillnoFocus,
                    label: "EwayBill No",
                    isRequired: true,
                    icon: Icons.abc,
                    isInput: true,
                    keyboardType: TextInputType.text,
                    endIcon: Icons.check,
                    endIconColor: eWayBill.isValidated
                        ? Colors.green
                        : CommonColors.primaryColorShade,
                    endIconOnTap: () {
                      if (isNullOrEmpty(eWayBill.ewaybillnoCtrl.text)) {
                        failToast('EwayBill No requried');
                      } else {
                        validateEwayBill(
                            eWayBill.ewaybillnoCtrl.text, _ewaybillCreds);
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Expanded(
                  child: AppFormField(
                    controller: eWayBill.ewaybilldateCtrl,
                    focusNode: eWayBill.ewaybilldateFocus,
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
                    controller: eWayBill.validuptoCtrl,
                    focusNode: eWayBill.validuptoFocus,
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
                    controller: eWayBill.invoicenoCtrl,
                    focusNode: eWayBill.invoicenoFocus,
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
                    controller: eWayBill.invoicevalueCtrl,
                    focusNode: eWayBill.invoicevalueFocus,
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
                    controller: eWayBill.invoicedateCtrl,
                    focusNode: eWayBill.invoicedateFocus,
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
              visible: eWayBill.isValidated == false,
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
    String ewaybillnostr = _firstEwayBill.ewaybillnoCtrl.text.toString(),
        ewaybilldtstr = convert2SmallDateTime(
            _firstEwayBill.ewaybilldateCtrl.text.toString()),
        validuptostr =
            convert2SmallDateTime(_firstEwayBill.validuptoCtrl.text.toString()),
        invoicenostr = _firstEwayBill.invoicenoCtrl.text.toString(),
        invoicevaluestr = _firstEwayBill.invoicevalueCtrl.text.toString(),
        invoicedtstr = convert2SmallDateTime(
            _firstEwayBill.invoicedateCtrl.text.toString());
    for (int i = 0; i < _ewayBillList.length; i++) {
      EwayBillModel bill = _ewayBillList[i];
      ewaybillnostr += "${bill.ewaybillnoCtrl.text},";
      ewaybilldtstr += "${convert2SmallDateTime(bill.ewaybilldateCtrl.text)},";
      validuptostr += "${convert2SmallDateTime(bill.validuptoCtrl.text)},";
      invoicenostr += "${bill.invoicenoCtrl.text},";
      invoicevaluestr += "${bill.invoicevalueCtrl.text},";
      invoicedtstr += "${convert2SmallDateTime(bill.invoicedateCtrl.text)},";
    }
    Map<String, String> params = {
      'prmbookingdt': convert2SmallDateTime(_bookingDateController.text),
      'prmbookingtime': formatTimeString(_bookingTimeController.text),
      'prmgrno': autoGr ? '' : _grNoController.text,
      'prmautogr': autoGr ? 'Y' : 'N',
      'prmorgcode': _selectedOrigin!.stnCode.toString(),
      'prmdestcode': _selectedDestination!.stnCode.toString(),
      'prmcustcode': _selectedCustomer!.custCode.toString(),
      'prmcngr': _selectedCngr!.code.toString(),
      'prmcngrgst': _selectedCngr!.gstNo.toString(),
      'prmcnge': _selectedCnge!.code.toString(),
      'prmcngegst': _selectedCnge!.gstNo.toString(),
      'prmebillno': ewaybillnostr,
      'prmebilldt': ewaybilldtstr,
      'prmebillvalidupto': validuptostr,
      'prmebillinvoiceno': invoicenostr,
      'prmebillinvoicevalue': invoicevaluestr,
      'prmebillinvoicedt': invoicedtstr,
      // 'prmservicetype': _selectedServiceType!.code.toString(),
      // 'prmdlvtype': _selectedDeliveryType!.code.toString(),
      'prmnoofpckgs': _noofpckgsController.text.toString(),
      'prmgweight': _gweightController.text.toString(),
      'prmvweight': _vweightController.text.toString(),
      'prmcweight': _cweightController.text.toString(),
      'prmremarks': _remarksController.text.toString(),
      'prmimg': selectedImagePath,
    };

    debugPrint(params.toString());
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
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                        )
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
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        List<CommonDataModel<BranchModel>> commonList =
                            _branchList
                                .map((branch) => CommonDataModel<BranchModel>(
                                      branch.stnName ??
                                          branch.stnName ??
                                          'Unknown',
                                      branch,
                                    ))
                                .toList();
                        showCommonBottomSheet(context, 'Select Origin', (data) {
                          _selectedOrigin = data;
                          _originNameController.text = data.stnName;
                          _originNameFocusNode.unfocus();
                        }, commonList);
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
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        List<CommonDataModel<BranchModel>> commonList =
                            _branchList
                                .map((branch) => CommonDataModel<BranchModel>(
                                      branch.stnName ??
                                          branch.stnName ??
                                          'Unknown',
                                      branch,
                                    ))
                                .toList();
                        showCommonBottomSheet(context, 'Select Destination',
                            (data) {
                          _selectedDestination = data;
                          _destNameController.text = data.stnName;
                          _destNameFocusNode.unfocus();
                        }, commonList);
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
                        showCommonBottomSheet(context, 'Select Customer',
                            (data) {
                          _selectedCustomer = data;
                          _custNameController.text = data.custName;
                          _custNameFocusNode.unfocus();
                        }, commonList);
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
                              keyboardType: TextInputType.none,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                List<CommonDataModel<CngrCngeModel>>
                                    commonList = _cngrList
                                        .map((cngr) =>
                                            CommonDataModel<CngrCngeModel>(
                                              cngr.name ??
                                                  cngr.name ??
                                                  'Unknown',
                                              cngr,
                                            ))
                                        .toList();
                                showCommonBottomSheet(
                                    context, 'Select Consignor', (data) {
                                  _selectedCngr = data;
                                  _cngrNameController.text = data.name;
                                  _cngrGstController.text = data.gstNo;
                                  _cngrNameFocusNode.unfocus();
                                }, commonList);
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
                              validator: (value) {
                                if (isNullOrEmpty(value)) {
                                  return 'GST is required';
                                }
                                return null;
                              },
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
                              keyboardType: TextInputType.none,
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                List<CommonDataModel<CngrCngeModel>>
                                    commonList = _cngeList
                                        .map((cnge) =>
                                            CommonDataModel<CngrCngeModel>(
                                              cnge.name ??
                                                  cnge.name ??
                                                  'Unknown',
                                              cnge,
                                            ))
                                        .toList();
                                showCommonBottomSheet(
                                    context, 'Select Consignee', (data) {
                                  _selectedCnge = data;
                                  _cngeNameController.text = data.name;
                                  _cngeGstController.text = data.gstNo;
                                  _cngeNameFocusNode.unfocus();
                                }, commonList);
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
                              validator: (value) {
                                if (isNullOrEmpty(value)) {
                                  return 'GST is required';
                                }
                                return null;
                              },
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
                      keyboardType: TextInputType.none,
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
                      controller: _deliveryTypeController,
                      focusNode: _deliveryTypeFocusNode,
                      label: 'Delivery Type',
                      isRequired: true,
                      isInput: false,
                      icon: Icons.abc,
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
                    GestureDetector(
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
                          ),
                          SizedBox(
                            width: SizeConfig.extraSmallHorizontalSpacing,
                          ),
                          Text(
                            'Attach File',
                            style:
                                TextStyle(fontSize: SizeConfig.mediumTextSize),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.mediumHorizontalSpacing,
                    ),
                    selectedImagePath.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              showDialogWithImage(context, selectedImagePath,
                                  isLocal: true);
                            },
                            child: SizedBox(
                              height: SizeConfig.screenHeight * 0.2,
                              width: SizeConfig.screenWidth,
                              child: Image.file(
                                File(selectedImagePath),
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        : Container(),
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
              Opacity(
                opacity: 0,
                child: const Text("..."),
              ),
            ],
          ),
        );
      },
    );
  }
}
