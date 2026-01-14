import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/commonBottomSheets.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/invoiceModel.dart';
import 'package:gtlmd/pages/pickup/model/pickResp.dart';
import 'package:gtlmd/pages/pickup/model/pickupDetailModel.dart';
import 'package:gtlmd/pages/pickup/model/pinCodeModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';
import 'package:gtlmd/pages/pickup/pickupViewModel.dart';
import 'package:intl/intl.dart';

class Pickup extends StatefulWidget {
  DeliveryDetailModel details;
  Pickup({super.key, required this.details});

  @override
  State<Pickup> createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  final _formKey = GlobalKey<FormState>();

  late LoadingAlertService loadingAlertService;
  PickupViewModel viewModel = PickupViewModel();
  final TextEditingController _grController = TextEditingController();
  final TextEditingController _bookingdtController = TextEditingController();
  final TextEditingController _bookingtimeController = TextEditingController();
  final TextEditingController _orgPincodeController = TextEditingController();
  final TextEditingController _orgController = TextEditingController();
  final TextEditingController _destPincodeController = TextEditingController();
  final TextEditingController _destController = TextEditingController();
  // final  TextEditingController _imageController = TextEditingController();
  final TextEditingController _custController = TextEditingController();
  final TextEditingController _deptController = TextEditingController();
  final TextEditingController _cngrController = TextEditingController();
  final TextEditingController _cngeController = TextEditingController();
  // final TextEditingController _returnReasonController = TextEditingController();
  final TextEditingController _noofpckgsController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _gweightController = TextEditingController();
  final TextEditingController _vweightController = TextEditingController();
  final TextEditingController _cweightController = TextEditingController();
  final TextEditingController _freightController = TextEditingController();
  final TextEditingController _serviceController = TextEditingController();

  final TextEditingController _consignorNameController =
      TextEditingController();
  final TextEditingController _consignorAddressController =
      TextEditingController();
  final TextEditingController _consignorZipCodeController =
      TextEditingController();
  final TextEditingController _consignorCityController =
      TextEditingController();
  final TextEditingController _consignorMobileController =
      TextEditingController();

  final TextEditingController _consigneeNameController =
      TextEditingController();
  final TextEditingController _consigneeAddressController =
      TextEditingController();
  final TextEditingController _consigneeZipCodeController =
      TextEditingController();
  final TextEditingController _consigneeCityController =
      TextEditingController();
  final TextEditingController _consigneeMobileController =
      TextEditingController();
  final TextEditingController _orderNumberController = TextEditingController();

  PickupDetailModel? pickupDetail;
  List<ServiceTypeModel> serviceList = [];
  List<LoadTypeModel> loadTypeList = [];
  List<DeliveryTypeModel> deliveryTypeList = [];
  List<BookingTypeModel> bookingTypeList = [];
  List<PinCodeModel> pincodeList = [];
  List<BranchModel> branchList = [];
  List<CustomerModel> customerList = [];
  List<CngrCngeModel> cngrList = [];
  List<CngrCngeModel> cngeList = [];
  List<DepartmentModel> deptList = [];

  bool autoGr = false;
  bool canEditCnge = false;
  bool canEditCngr = false;
  bool canEditCust = false;
  String todayDate = DateFormat("dd-MM-yyyy").format(DateTime.now());
  BaseRepository baseRepo = BaseRepository();
  FocusNode remarksFocus = FocusNode();
  FocusNode returnCodeFocus = FocusNode();
  FocusNode skuFocus = FocusNode();

  ServiceTypeModel? _selectedServiceType;
  BookingTypeModel? _selectedBookingType;
  DeliveryTypeModel? _selectedDeliveryType;
  LoadTypeModel? _selectedLoadType;
  BranchModel? _selectedOrigin;
  BranchModel? _selectedDest;
  CustomerModel? _selectedCustomer;
  DepartmentModel? _selectedDept;
  CngrCngeModel? _selectedCngr;
  CngrCngeModel? _selectedCnge;

  // LoadTypeModel? _selectedLoadType;
  String? selected;
  String? _itemImagePath = "";

  // String? _itemImagePath;
  bool skuVerified = false;
  bool returnCodeValid = false;
  late InvoiceModel firstInvoiceModel;
  List<InvoiceModel> invoiceList = List.empty(growable: true);
  String autoGrLabel = "Consignment";
  bool _branchesLoaded = false;
  bool _customersLoaded = false;
  bool _cngrLoaded = false;
  bool _cngeLoaded = false;
  bool _serviceLoaded = false;
  bool _loadTypeLoaded = false;
  bool _deliveryLoaded = false;
  bool _deptLoaded = false;
  bool _pickupLoaded = false;
  bool _bookingLoaded = false;

  double screenWidth = 0;
  bool isSmallDevice = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    firstInvoiceModel = InvoiceModel(
        invoiceNo: '', date: todayDate, pckgs: '', invoiceValue: '');
    _bookingdtController.text = todayDate;
    _bookingtimeController.text = DateFormat("HH:mm").format(DateTime.now());

    setObservers();
    // getPinCodeList();
    // loadingAlertService.showLoading();

    getData();

    // getBranchList();
    // getCustomerList();
    // getCngrCngeList('R');
    // getCngrCngeList('E');
    // getDepartmentList();
  }

  getData() {
    getPickupDetails().then((data) => {
          loadingAlertService.showLoading(),
          pickupDetail = data.pickupList[0],
          deliveryTypeList = data.deliveryList,
          serviceList = data.serviceList,
          bookingTypeList = data.bookingList,
          loadTypeList = data.loadList,
          getBranchList().then((data) => {
                branchList = data,
                getCustomerList().then((data) => {
                      customerList = data,
                      getCngrCngeList('R').then((data) => {
                            cngrList = data,
                            getCngrCngeList('E').then((data) => {
                                  cngeList = data,
                                  getDepartmentList().then((data) => {
                                        deptList = data,
                                        setUiData(),
                                        loadingAlertService.hideLoading()
                                      })
                                })
                          })
                    })
              })
        });
  }

  void setObservers() {
    viewModel.pickupDetailsList.stream.listen((pickupDetail) {
      debugPrint('Pickup List Length: ${pickupDetail}');
      if (pickupDetail != null &&
          pickupDetail.length > 0 &&
          pickupDetail[0].commandStatus == -1) {
        failToast(pickupDetail[0].commandMessage ?? "Something went wrong");
        return;
      } else {
        setState(() {
          _pickupLoaded = true;
          this.pickupDetail = pickupDetail.first;
          // loadAllData();
          // trySetUiData();
        });
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.serviceTypeList.stream.listen((serviceTypeList) {
      debugPrint('Service Type List Length: ${serviceTypeList.length}');
      setState(() {
        serviceList = serviceTypeList;
        _serviceLoaded = true;
      });
      // trySetUiData();
      // _selectedServiceType = serviceList.first;
    });
    viewModel.loadTypeList.stream.listen((loadType) {
      debugPrint('Load Type List Length: $loadType');
      setState(() {
        loadTypeList = loadType;
        _loadTypeLoaded = true;
      });
      // trySetUiData();
      // _selectedLoadType = loadTypeList.first;
    });
    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.deliveryTypeList.stream.listen((deliveryData) {
      debugPrint('Delivery type list size: ${deliveryData.length}');
      setState(() {
        deliveryTypeList = deliveryData;
        _deliveryLoaded = true;
        // trySetUiData();
      });
    });

    viewModel.pinCodeList.stream.listen((pincodeData) {
      debugPrint('Delivery type list size: ${pincodeData.length}');
      setState(() {
        pincodeList = pincodeData;
        setUiData();
      });
    });

    viewModel.bookingTypeList.stream.listen((bookingData) {
      debugPrint('Delivery type list size: ${bookingData.length}');
      setState(() {
        bookingTypeList = bookingData;
        _bookingLoaded = true;
        // trySetUiData();
      });
    });

    viewModel.branchList.stream.listen((branchData) {
      debugPrint('Delivery type list size: ${branchData.length}');
      setState(() {
        branchList = branchData;
        _branchesLoaded = true;
        // trySetUiData();
      });
    });

    viewModel.customerList.stream.listen((customerData) {
      debugPrint('Delivery type list size: ${customerData.length}');
      setState(() {
        customerList = customerData;
        _customersLoaded = true;
        // trySetUiData();
      });
    });

    viewModel.cngrList.stream.listen((cngr) {
      debugPrint('Delivery type list size: ${cngr.length}');
      setState(() {
        cngrList = cngr;
        _cngrLoaded = true;
        // trySetUiData();
      });
    });
    viewModel.cngeList.stream.listen((cnge) {
      debugPrint('Delivery type list size: ${cnge.length}');
      setState(() {
        cngeList = cnge;
        _cngeLoaded = true;
        // trySetUiData();
      });
    });
    viewModel.deptList.stream.listen((list) {
      debugPrint('Delivery type list size: ${list.length}');
      setState(() {
        deptList = list;
        _deptLoaded = true;
        // trySetUiData();
      });
    });

    viewModel.savePickupLiveData.stream.listen((saveResponse) {
      if (saveResponse.commandStatus == 1) {
        successToast(
            saveResponse.commandMessage ?? "Pickup saved successfully");
        Get.back();
      } else {
        failToast(saveResponse.commandMessage ?? "Something went wrong");
      }
    });
  }

  Future<PickResp> getPickupDetails() async {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmtransactionid": widget.details.transactionid.toString(),
      "prmgrno": widget.details.grno.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    return viewModel.getPickupDetails(params);
  }

  void getPinCodeList() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": 'GTAPP_BOOKINGWITHOUTINDENT',
      "prmsessionid": savedUser.sessionid.toString(),
      "prmcharstr": '',
    };

    viewModel.getPinCodeList(params);
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

    return viewModel.getBranchList(params);
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

    return viewModel.getCustomerList(params);
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

    return viewModel.getCngrCngeList(params, type);
  }

  Future<List<DepartmentModel>> getDepartmentList() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmcustcode": pickupDetail!.custCode.toString(),
      "prmorgcode": pickupDetail!.orgCode.toString(),
    };

    return viewModel.getDepartmentList(params);
  }

  setUiData() {
    // _orgPincodeController.text = pickupDetail!.cngrZipCode.toString();
    // _orgController.text = pickupDetail!.orgName.toString();
    // _destPincodeController.text = pickupDetail!.cngeZipCo de.toString();
    // _destController.text = pickupDetail!.destName.toString();
    // loadingAlertService.showLoading();
    for (BranchModel branch in branchList) {
      if (branch.stnCode == pickupDetail!.orgCode) {
        _selectedOrigin = branch;
        _orgController.text = _selectedOrigin!.stnName.toString();
        // _orgPincodeController.text = _selectedOrigin!.zipCode.toString();
      }
    }

    for (BranchModel branch in branchList) {
      if (branch.stnCode == pickupDetail!.destCode) {
        _selectedDest = branch;
        _destController.text = _selectedDest!.stnName.toString();
        // _destPincodeController.text = _selectedDest!.zipCode.toString();
      }
    }

    for (CustomerModel customer in customerList) {
      if (customer.custCode == pickupDetail!.custCode) {
        _selectedCustomer = customer;
      }
    }

    for (CngrCngeModel cngr in cngrList) {
      if (cngr.code == pickupDetail!.cngrCode) {
        _selectedCngr = cngr;
      }
    }

    for (CngrCngeModel cnge in cngeList) {
      if (cnge.code == pickupDetail!.cngeCode) {
        _selectedCnge = cnge;
      }
    }

    for (ServiceTypeModel serviceType in serviceList) {
      if (serviceType.prodCode == pickupDetail!.productCode.toString()) {
        _selectedServiceType = serviceType;
        _serviceController.text = _selectedServiceType!.prodName.toString();
      }
    }

    for (LoadTypeModel loadType in loadTypeList) {
      if (loadType.code == 'P') {
        _selectedLoadType = loadType;
      }
    }

    for (DeliveryTypeModel dlvType in deliveryTypeList) {
      if (dlvType.deliveryType == 'D') {
        _selectedDeliveryType = dlvType;
      }
    }

    _orgPincodeController.text = pickupDetail!.cngrZipCode.toString();
    _destPincodeController.text = pickupDetail!.cngeZipCode.toString();
    _orgController.text = pickupDetail!.cngrCity.toString();
    _destController.text = pickupDetail!.cngeCity.toString();

    _custController.text = _selectedCustomer!.custName.toString();
    _deptController.text = isNullOrEmpty(pickupDetail!.custDeptId.toString())
        ? ""
        : pickupDetail!.custDeptId.toString();

    _consignorNameController.text = pickupDetail!.cngr.toString();
    _consignorAddressController.text = pickupDetail!.cngrAddress.toString();
    _consignorZipCodeController.text = pickupDetail!.cngrZipCode.toString();
    _consignorCityController.text = pickupDetail!.cngrCity.toString();
    _consignorMobileController.text = pickupDetail!.cngrMobileNo.toString();

    _consigneeNameController.text = pickupDetail!.cnge.toString();
    _consigneeAddressController.text = pickupDetail!.cngeAddress.toString();
    _consigneeZipCodeController.text = pickupDetail!.cngeZipCode.toString();
    _consigneeCityController.text = pickupDetail!.cngeCity.toString();
    _consigneeMobileController.text = pickupDetail!.cngeMobileNo.toString();

    _gweightController.text = isNullOrEmpty(pickupDetail!.weight.toString())
        ? '0'
        : pickupDetail!.weight.toString();

    _noofpckgsController.text = pickupDetail!.pckgs.toString();
    _orderNumberController.text = pickupDetail!.ordernumber.toString();
    setState(() {});
    // loadingAlertService.hideLoading();
  }

  Future<void> loadAllData() async {
    loadingAlertService.showLoading();
    await Future.wait([
      getBranchList(),
      getCustomerList(),
      getCngrCngeList('R'),
      getCngrCngeList('E'),
      getDepartmentList(),
    ]);

    // All data ready → update UI once
    setUiData();

    // setState(() {
    //   isUiReady = true;
    // });
  }

  void trySetUiData() {
    if (_branchesLoaded &&
        _customersLoaded &&
        _cngrLoaded &&
        _cngeLoaded &&
        _serviceLoaded &&
        _loadTypeLoaded &&
        _deliveryLoaded &&
        _deptLoaded &&
        _pickupLoaded) {
      setUiData(); // <-- Only once
    }
  }

  validateForm() {
    if (!_formKey.currentState!.validate()) {
      failToast("Please fill all required fields");
      return;
    }
    if (isNullOrEmpty(_itemImagePath)) {
      failToast("Document Image Required");
      return;
    } else {
      saveBooking();
    }
  }

  addNewInvoice() {
    setState(() {
      invoiceList.add(InvoiceModel(
          invoiceNo: '', date: todayDate, pckgs: '', invoiceValue: ''));
    });

    // Wait for UI to rebuild, then scroll
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 400),
    //     curve: Curves.easeOut,
    //   );
    // });
  }

  deleteInvoice(int index) {
    setState(() {
      invoiceList.removeAt(index);
    });
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 400),
    //     curve: Curves.easeOut,
    //   );
    // });
  }

  Widget defaultInvoiceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // heading
            Text(
              "Invoice #: 1",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.largeTextSize),
            ),
            const SizedBox(
              height: 8,
            ),
            // first row
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice No.',
                  isRequired: false,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                        firstInvoiceModel.invoiceNo =
                            firstInvoiceModel.invoiceNoController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: firstInvoiceModel.invoiceNoController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Invoice No",
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter Invoice No.';
                    //   }
                    //   return null;
                    // },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    String date = await selectDate(context);
                    firstInvoiceModel.dateController.text = date;
                    firstInvoiceModel.date = date;
                    setState(() {});
                  },
                  child: _buildFormField(
                    label: 'Invoice Date.',
                    isRequired: false,
                    icon: Icons.numbers,
                    child: TextFormField(
                      // focusNode: skuFocus,
                      onTapOutside: (event) {
                        // skuFocus.unfocus();
                      },
                      autofocus: false,
                      enabled: false,
                      textInputAction: TextInputAction.done,
                      controller: firstInvoiceModel.dateController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: CommonColors.appBarColor,
                          fontSize: isSmallDevice ? 13 : 14),
                      decoration: _inputDecoration(
                        "Invoice Date",
                      ),
                      // validator: (value) {
                      //   if (value == null || value.isEmpty) {
                      //     return 'Please enter invoice date';
                      //   }
                      //   return null;
                      // },
                    ),
                  ),
                ))
              ],
            ),
            // second row
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Packages.',
                  isRequired: false,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        firstInvoiceModel.pckgs =
                            firstInvoiceModel.pckgsController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: firstInvoiceModel.pckgsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, // ✅ allows only 0–9
                    ],
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Invoice No",
                    ),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter Invoice No';
                    //   }
                    //   return null;
                    // },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice Value.',
                  isRequired: false,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        firstInvoiceModel.invoiceValue =
                            firstInvoiceModel.invoiceValueController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: firstInvoiceModel.invoiceValueController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice Value"),
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter invoice date';
                    //   }
                    //   return null;
                    // },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //         child: _buildFormField(
            //       label: 'Content',
            //       isRequired: true,
            //       icon: Icons.numbers,
            //       child: TextFormField(
            //         // focusNode: skuFocus,
            //         onTap: () {
            //           showContentSelectionBs(context, "Select Content", (data) {
            //             debugPrint(data);
            //           });
            //         },
            //         onTapOutside: (event) {
            //           // skuFocus.unfocus();
            //         },
            //         autofocus: false,
            //         onEditingComplete: () {
            //           setState(() {
            //             // _skuController.text =
            //             //     _skuController.text.trim();
            //           });
            //           // skuFocus.unfocus();
            //           // verifySku();
            //         },
            //         // textInputAction: TextInputAction.done,
            //         // controller: model.invoiceValueController,
            //         // keyboardType: TextInputType.text,
            //         enabled: true,
            //         style: const TextStyle(color: CommonColors.appBarColor),
            //         decoration: _inputDecoration(" Content"),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return 'Please select content';
            //           }
            //           return null;
            //         },
            //       ),
            //     ))
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //         child: _buildFormField(
            //       label: 'Packing',
            //       isRequired: true,
            //       icon: Icons.numbers,
            //       child: TextFormField(
            //         onTap: () {},
            //         enabled: false,
            //         // focusNode: skuFocus,
            //         onTapOutside: (event) {
            //           // skuFocus.unfocus();
            //         },
            //         autofocus: false,
            //         onEditingComplete: () {
            //           setState(() {
            //             // _skuController.text =
            //             //     _skuController.text.trim();
            //             // model.invoiceValue = model.invoiceValueController.text;
            //           });
            //           // skuFocus.unfocus();
            //           // verifySku();
            //         },
            //         // textInputAction: TextInputAction.done,
            //         // controller: model.invoiceValueController,
            //         // keyboardType: TextInputType.text,
            //         style: const TextStyle(color: CommonColors.appBarColor),
            //         decoration: _inputDecoration("Packing"),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return 'Please select packing';
            //           }
            //           return null;
            //         },
            //       ),
            //     ))
            //   ],
            // ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: () {
                    addNewInvoice();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.colorPrimary,
                    foregroundColor: CommonColors.White,
                    padding:
                        EdgeInsets.symmetric(vertical: isSmallDevice ? 12 : 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Add More",
                    style: TextStyle(
                      fontSize: isSmallDevice ? 13 : 14,
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

  Widget invoiceCard(InvoiceModel model, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // heading
            Text(
              "Invoice #: $index",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 8,
            ),
            // first row
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice No.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,

                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        model.invoiceNo = model.invoiceNoController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: model.invoiceNoController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Invoice No",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice no';
                      }
                      return null;
                    },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: InkWell(
                  onTap: () async {
                    String date = await selectDate(context);
                    model.dateController.text = date;
                    model.date = date;
                    setState(() {});
                  },
                  child: _buildFormField(
                    label: 'Invoice Date.',
                    isRequired: true,
                    icon: Icons.numbers,
                    child: TextFormField(
                      // focusNode: skuFocus,
                      onTapOutside: (event) {
                        // skuFocus.unfocus();
                      },
                      autofocus: false,
                      enabled: false,
                      textInputAction: TextInputAction.done,
                      controller: model.dateController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: CommonColors.appBarColor,
                          fontSize: isSmallDevice ? 13 : 14),
                      decoration: _inputDecoration(
                        "Invoice Date",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter invoice date';
                        }
                        return null;
                      },
                    ),
                  ),
                ))
              ],
            ),
            // second row
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Packages.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        model.pckgs = model.pckgsController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: model.pckgsController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Invoice No",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter packages';
                      }
                      return null;
                    },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice Value.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                        model.invoiceValue = model.invoiceValueController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: model.invoiceValueController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Invoice Date",
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice value';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            // Row(
            //   children: [
            //     Expanded(
            //         child: _buildFormField(
            //       label: 'Content',
            //       isRequired: true,
            //       icon: Icons.numbers,
            //       child: TextFormField(
            //         // focusNode: skuFocus,
            //         onTap: () {},
            //         onTapOutside: (event) {
            //           // skuFocus.unfocus();
            //         },
            //         autofocus: false,
            //         onEditingComplete: () {
            //           setState(() {
            //             // _skuController.text =
            //             //     _skuController.text.trim();
            //           });
            //           // skuFocus.unfocus();
            //           // verifySku();
            //         },
            //         // textInputAction: TextInputAction.done,
            //         // controller: model.invoiceValueController,
            //         // keyboardType: TextInputType.text,
            //         enabled: false,
            //         style: const TextStyle(color: CommonColors.appBarColor),
            //         decoration: _inputDecoration(" Content"),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return 'Please select content';
            //           }
            //           return null;
            //         },
            //       ),
            //     ))
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            // Row(
            //   children: [
            //     Expanded(
            //         child: _buildFormField(
            //       label: 'Packing',
            //       isRequired: true,
            //       icon: Icons.numbers,
            //       child: TextFormField(
            //         onTap: () {},
            //         enabled: false,
            //         // focusNode: skuFocus,
            //         onTapOutside: (event) {
            //           // skuFocus.unfocus();
            //         },
            //         autofocus: false,
            //         onEditingComplete: () {
            //           setState(() {
            //             // _skuController.text =
            //             //     _skuController.text.trim();
            //             // model.invoiceValue = model.invoiceValueController.text;
            //           });
            //           // skuFocus.unfocus();
            //           // verifySku();
            //         },
            //         // textInputAction: TextInputAction.done,
            //         // controller: model.invoiceValueController,
            //         // keyboardType: TextInputType.text,
            //         style: const TextStyle(color: CommonColors.appBarColor),
            //         decoration: _inputDecoration("Packing"),
            //         validator: (value) {
            //           if (value == null || value.isEmpty) {
            //             return 'Please select packing';
            //           }
            //           return null;
            //         },
            //       ),
            //     ))
            //   ],
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          addNewInvoice();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary,
                          foregroundColor: CommonColors.White,
                          padding: EdgeInsets.symmetric(
                              vertical: isSmallDevice ? 12 : 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Add More",
                          style: TextStyle(
                            fontSize: isSmallDevice ? 13 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          deleteInvoice(index - 2);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary,
                          foregroundColor: CommonColors.White,
                          padding: EdgeInsets.symmetric(
                              vertical: isSmallDevice ? 12 : 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Delete",
                          style: TextStyle(
                            fontSize: isSmallDevice ? 13 : 14,
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

  Widget consignorDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          enabled: canEditCngr,
          initiallyExpanded: true,
          leading: const Icon(Icons.person),
          title: Text(
            "Consignor Details",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: isSmallDevice ? 18 : 20),
          ),
          children: [
            // heading
            // const Text(
            //   "Consignor Details",
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Consignor',
                    isRequired: true,
                    icon: Icons.numbers,
                    child: TextFormField(
                      // focusNode: skuFocus,
                      readOnly: true,
                      onTap: () {
                        List<CommonDataModel<CngrCngeModel>> commonList =
                            cngrList
                                .map((cngr) => CommonDataModel<CngrCngeModel>(
                                      cngr.name ?? cngr.name ?? 'Unknown',
                                      cngr,
                                    ))
                                .toList();

                        showCommonBottomSheet(
                          context,
                          "Select Cnginor",
                          (data) {
                            _selectedCngr = data;
                            _consignorNameController.text =
                                _selectedCngr!.name.toString();
                            _consignorMobileController.text =
                                _selectedCngr!.telNo.toString();
                            _consignorCityController.text =
                                _selectedCngr!.city.toString();
                            _consignorAddressController.text =
                                _selectedCngr!.address.toString();
                            _consignorZipCodeController.text =
                                _selectedCngr!.zipCode.toString();
                            setState(() {});
                          },
                          commonList,
                        );
                      },
                      onTapOutside: (event) {
                        // skuFocus.unfocus();
                      },
                      enabled: canEditCngr,
                      autofocus: false,
                      onEditingComplete: () {
                        setState(() {
                          // _skuController.text =
                          //     _skuController.text.trim();
                        });
                        // skuFocus.unfocus();
                        // verifySku();
                      },
                      textInputAction: TextInputAction.done,
                      controller: _consignorNameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: CommonColors.appBarColor,
                          fontSize: isSmallDevice ? 13 : 14),
                      decoration: _inputDecoration(
                        "Consignor",
                      ),
                      validator: (value) {
                        if (canEditCngr) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Consignor';
                          }
                          return null;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
            // first row
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Address',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    enabled: false,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: _consignorAddressController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Address",
                    ),
                    validator: (value) {
                      if (canEditCngr) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignor address';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _buildFormField(
                  label: 'Zip Code',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    controller: _consignorZipCodeController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Zip Code",
                    ),
                    validator: (value) {
                      if (canEditCngr) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignor zip code';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                ))
              ],
            ),
            // second row
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'City',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    controller: _consignorCityController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "City",
                    ),
                    validator: (value) {
                      if (canEditCngr) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignor city';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _buildFormField(
                  label: 'Mobile',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    controller: _consignorMobileController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Mobile",
                    ),
                    validator: (value) {
                      if (canEditCngr) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignor mobile';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  Widget consigneeDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          enabled: canEditCnge,
          initiallyExpanded: true,
          leading: const Icon(Icons.person),
          title: Text(
            "Consignee Details",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: isSmallDevice ? 18 : 20),
          ),
          children: [
            // heading
            // const Text(
            //   "Consignee Details",
            //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            // ),
            // const SizedBox(
            //   height: 8,
            // ),
            Row(
              children: [
                Expanded(
                  child: _buildFormField(
                    label: 'Consignee',
                    isRequired: true,
                    icon: Icons.numbers,
                    child: TextFormField(
                      // focusNode: skuFocus,
                      enabled: canEditCnge,
                      onTapOutside: (event) {
                        // skuFocus.unfocus();
                      },
                      onTap: () {
                        List<CommonDataModel<CngrCngeModel>> commonList =
                            cngrList
                                .map((cnge) => CommonDataModel<CngrCngeModel>(
                                      cnge.name ?? cnge.name ?? 'Unknown',
                                      cnge,
                                    ))
                                .toList();

                        showCommonBottomSheet(
                          context,
                          "Select Cnginee",
                          (data) {
                            _selectedCnge = data;
                            _consigneeNameController.text =
                                _selectedCnge!.name.toString();
                            _consigneeMobileController.text =
                                _selectedCnge!.telNo.toString();
                            _consigneeCityController.text =
                                _selectedCnge!.city.toString();
                            _consigneeAddressController.text =
                                _selectedCnge!.address.toString();
                            _consigneeZipCodeController.text =
                                _selectedCnge!.zipCode.toString();
                            setState(() {});
                          },
                          commonList,
                        );
                      },
                      autofocus: false,
                      onEditingComplete: () {
                        setState(() {
                          // _skuController.text =
                          //     _skuController.text.trim();
                        });
                        // skuFocus.unfocus();
                        // verifySku();
                      },
                      textInputAction: TextInputAction.done,
                      controller: _consigneeNameController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          color: CommonColors.appBarColor,
                          fontSize: SizeConfig.mediumTextSize),
                      decoration: _inputDecoration(
                        "Consignee",
                      ),
                      validator: (value) {
                        if (canEditCnge) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Consignee';
                          }
                          return null;
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                )
              ],
            ),
            // first row
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Address',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    enabled: false,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: _consigneeAddressController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: SizeConfig.mediumTextSize),
                    decoration: _inputDecoration(
                      "Address",
                    ),
                    validator: (value) {
                      if (canEditCnge) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignee address';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _buildFormField(
                  label: 'Zip Code',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    enabled: false,
                    textInputAction: TextInputAction.done,
                    controller: _consigneeZipCodeController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Zip Code",
                    ),
                    validator: (value) {
                      if (canEditCnge) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignee zip code';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                ))
              ],
            ),
            // second row
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'City',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    enabled: false,
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: _consigneeCityController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "City",
                    ),
                    validator: (value) {
                      if (canEditCnge) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignee city';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: _buildFormField(
                  label: 'Mobile',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    enabled: false,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: false,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: _consigneeMobileController,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                        color: CommonColors.appBarColor,
                        fontSize: isSmallDevice ? 13 : 14),
                    decoration: _inputDecoration(
                      "Mobile",
                    ),
                    validator: (value) {
                      if (canEditCnge) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter consignee mobile';
                        }
                        return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
          ],
        ),
      ),
    );
  }

  void changeBookingType() {
    if (_selectedBookingType!.code == 'T') {
      // TO PAY
      canEditCnge = true;
      canEditCngr = false;
      canEditCust = false;
    } else if (_selectedBookingType!.code == 'R') {
      // TBB
      canEditCnge = false;
      canEditCngr = false;
      canEditCust = true;
    } else if (_selectedBookingType!.code == 'C') {
      // PAID
      canEditCnge = false;
      canEditCngr = true;
      canEditCust = false;
    } else if (_selectedBookingType!.code == 'F') {
      canEditCnge = true;
      canEditCngr = true;
      canEditCust = true;
    }
    setState(() {});
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

  manageChargableWeight() {
    if (double.parse(_vweightController.text.toString()) >
        double.parse(_gweightController.text.toString())) {
      _cweightController.text = _vweightController.text.toString();
    } else {
      _cweightController.text = _gweightController.text.toString();
    }
  }

  void saveBooking() {
    String invoicenostr = "${firstInvoiceModel.invoiceNoController.text},";
    String invoicedtstr =
        "${convert2SmallDateTime(firstInvoiceModel.dateController.text)},";
    String invoicePckgsstr = "${firstInvoiceModel.pckgsController.text},";
    String invoiceValuestr =
        "${firstInvoiceModel.invoiceValueController.text},";
    for (InvoiceModel invoice in invoiceList) {
      invoicenostr += "${invoice.invoiceNoController.text},";
      invoicedtstr +=
          "${convert2SmallDateTime(invoice.dateController.text.toString())},";
      invoicePckgsstr += "${invoice.pckgsController.text},";
      invoiceValuestr += "${invoice.invoiceValueController.text},";
    }
    debugPrint("Invoice No ${invoicenostr}");
    debugPrint("Invoice Date ${invoicedtstr}");
    debugPrint("Invoice Pckgs ${invoicePckgsstr}");
    debugPrint("Invoice Value ${invoiceValuestr}");

    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmtransactionid": widget.details.transactionid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmbookingdt":
          convert2SmallDateTime(_bookingdtController.text.toString()),
      "prmtime": _bookingtimeController.text.toString(),
      "prmegrno": autoGr ? '' : _grController.text.toString(),
      "prmcustcode": _selectedCustomer!.custCode.toString(),
      "prmcustdeptid":
          _selectedDept == null ? "" : _selectedDept!.custDeptId.toString(),
      "prmdestcode": _selectedDest!.stnCode.toString(),
      "prmdestname": _selectedDest!.stnName.toString(),
      "prmorgcode": _selectedOrigin!.stnCode.toString(),
      "prmorgname": _selectedOrigin!.stnName.toString(),
      "prmproductcode": _selectedServiceType!.prodCode.toString(),
      "prmpckgs": _noofpckgsController.text.toString(),
      "prmaweight": _gweightController.text.toString(),
      "prmcweight": _cweightController.text.toString(),
      "prmvweight": _vweightController.text.toString(),
      "prmfreight": _freightController.text.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmcngr": _selectedCngr!.name.toString(),
      "prmcngrcode": _selectedCngr!.code.toString(),
      "prmcngrcountry": _selectedCngr!.country.toString(),
      "prmcngrstate": _selectedCngr!.state.toString(),
      "prmcngraddress": _selectedCngr!.address.toString(),
      "prmcngrzipcode": _selectedCngr!.zipCode.toString(),
      "prmcnge": _selectedCnge!.name.toString(),
      "prmcngecode": _selectedCnge!.code.toString(),
      "prmcngecountry": _selectedCnge!.country.toString(),
      "prmcngestate": _selectedCnge!.state.toString(),
      "prmcngeaddress": _selectedCnge!.address.toString(),
      "prmcngezipcode": _selectedCnge!.zipCode.toString(),
      "prminvoicenostr": invoicenostr,
      "prminvoicedtstr": invoicedtstr,
      "prminvoicevaluestr": invoiceValuestr,
      "prminvoicecpkgstr": invoicePckgsstr,
      "prmautogrno": autoGr ? 'Y' : 'N',
      "prmdeliverytype": _selectedDeliveryType!.deliveryType.toString(),
      "prmloadtype": _selectedLoadType!.code.toString(),
      "prmremarks": _remarksController.text.toString(),
      "prmorgpincode": _selectedOrigin!.zipCode.toString(),
      "prmdestpincode": _selectedDest!.zipCode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmmenucode": "GTLMD_PICKUP",
      "prmbookingimgpath": convertFilePathToBase64(_itemImagePath),
    };

    debugPrint(params.toString());
    viewModel.savePickup(params);
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.sizeOf(context).width;
    isSmallDevice = screenWidth <= 360;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          title: Text(
            'Pickup',
            style: TextStyle(
                color: CommonColors.White, fontSize: SizeConfig.mediumTextSize),
          ),
          leading: InkWell(
            onTap: () => {Navigator.pop(context)},
            child: Icon(
              Icons.arrow_back,
              color: CommonColors.White,
              size: SizeConfig.largeIconSize,
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.smallVerticalPadding,
              horizontal: SizeConfig.smallHorizontalPadding),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(SizeConfig.mediumHorizontalSpacing),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SizeConfig.largeRadius),
                      topRight: Radius.circular(SizeConfig.largeRadius),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: CommonColors.primaryColorShade!,
                        size: SizeConfig.mediumTextSize,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Pickup Information',
                        style: TextStyle(
                          fontSize: SizeConfig.mediumTextSize,
                          fontWeight: FontWeight.w600,
                          color: CommonColors.primaryColorShade!,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: SizeConfig.mediumVerticalSpacing,
                      horizontal: SizeConfig.mediumHorizontalSpacing),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: "Consignment#",
                                isRequired: true,
                                icon: Icons.label_outline,
                                child: TextFormField(
                                  enabled: !autoGr,
                                  focusNode: skuFocus,
                                  onTapOutside: (event) {},
                                  autofocus: false,
                                  onEditingComplete: () {
                                    setState(() {});

                                    // verifySku();
                                  },
                                  textInputAction: TextInputAction.done,
                                  controller: _grController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      color: CommonColors.appBarColor,
                                      fontSize: SizeConfig.mediumTextSize),
                                  decoration: autoGr
                                      ? _inputDecoration(
                                          autoGrLabel,
                                        )
                                      : _inputDecoration(
                                          "Enter Consignment#",
                                        ),
                                  validator: (value) {
                                    if (autoGr) {
                                      return null;
                                    } else {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter Consignment#';
                                      }
                                      return null;
                                    }
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: SizeConfig.mediumVerticalSpacing),
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
                                    setState(() {
                                      autoGr = value!;
                                    });
                                  },
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: SizeConfig.mediumVerticalSpacing),
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(SizeConfig.smallTextSize),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: CommonColors.grey600!),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.largeRadius))),
                              child: Column(
                                children: [
                                  // const SizedBox(height: 20),

                                  // const SizedBox(width: 12),
                                  // Row(
                                  //   children: [consigneeDetailsCard()],
                                  // ),
                                  SizedBox(width: SizeConfig.mediumTextSize),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            String date =
                                                await selectDate(context);
                                            setState(() {
                                              _bookingdtController.text = date;
                                            });
                                          },
                                          child: _buildFormField(
                                            label: "Booking Date",
                                            labelColor:
                                                CommonColors.appBarColor!,
                                            isRequired: true,
                                            icon: Icons.calendar_today_outlined,
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _bookingdtController,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  color:
                                                      CommonColors.appBarColor,
                                                  fontSize: SizeConfig
                                                      .mediumTextSize),
                                              decoration: _inputDecoration(
                                                "Booking Date",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Booking Date';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width:
                                              SizeConfig.mediumVerticalSpacing),
                                      Expanded(
                                        child: InkWell(
                                          onTap: () async {
                                            String time =
                                                await selectTime(context);
                                            setState(() {
                                              _bookingtimeController.text =
                                                  time;
                                            });
                                          },
                                          child: _buildFormField(
                                            label: "Booking Time",
                                            labelColor:
                                                CommonColors.appBarColor!,
                                            isRequired: false,
                                            icon: Icons.access_time_outlined,
                                            child: TextFormField(
                                              enabled: false,
                                              controller:
                                                  _bookingtimeController,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  color:
                                                      CommonColors.appBarColor,
                                                  fontSize: SizeConfig
                                                      .mediumTextSize),
                                              decoration: _inputDecoration(
                                                "Booking Time",
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Booking Time';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),

                                  Card(
                                    // elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.largeRadius),
                                        side: BorderSide(
                                            color: CommonColors.grey400!,
                                            width: 1)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: SizeConfig.verticalPadding,
                                          horizontal:
                                              SizeConfig.horizontalPadding),
                                      child: Column(
                                        children: [
                                          // _buildFormField(
                                          //   label: 'Origin Pincode',
                                          //   isRequired: true,
                                          //   icon: Icons.people_outline,
                                          //   child: DropdownButtonFormField<
                                          //       PinCodeModel>(
                                          //     value: _selectedOrigin,
                                          //     decoration: _inputDecoration(
                                          //         'Select origin pincode'),
                                          //     items: pincodeList
                                          //         .map((PinCodeModel origin) {
                                          //       return DropdownMenuItem<
                                          //           PinCodeModel>(
                                          //         value: origin,
                                          //         child: Text(
                                          //             origin.code.toString() ??
                                          //                 ''),
                                          //       );
                                          //     }).toList(),
                                          //     onChanged:
                                          //         (PinCodeModel? newValue) {
                                          //       setState(() {
                                          //         _selectedOrigin = newValue;
                                          //       });
                                          //     },
                                          //     validator: (value) {
                                          //       if (value == null) {
                                          //         return 'Please select a origin pincode';
                                          //       }
                                          //       return null;
                                          //     },
                                          //   ),
                                          // ),
                                          _buildFormField(
                                            label: "Origin Pincode",
                                            labelColor:
                                                CommonColors.appBarColor!,
                                            isRequired: true,
                                            icon: Icons.location_city,
                                            child: TextFormField(
                                              // enabled: false,
                                              readOnly: true,
                                              onTap: () {
                                                List<
                                                        CommonDataModel<
                                                            BranchModel>>
                                                    commonList = branchList
                                                        .map((branch) =>
                                                            CommonDataModel<
                                                                BranchModel>(
                                                              branch.zipCode ??
                                                                  branch
                                                                      .zipCode ??
                                                                  'Unknown',
                                                              branch,
                                                            ))
                                                        .toList();

                                                showCommonBottomSheet(
                                                  context,
                                                  "Select Origin Pincode",
                                                  (data) {
                                                    _selectedOrigin = data;
                                                    _orgPincodeController.text =
                                                        _selectedOrigin!.zipCode
                                                            .toString();

                                                    _orgController.text =
                                                        _selectedOrigin!.stnName
                                                            .toString();
                                                    setState(() {});
                                                  },
                                                  commonList,
                                                );
                                              },
                                              controller: _orgPincodeController,
                                              keyboardType: TextInputType.text,
                                              decoration: _inputDecoration(
                                                  "Origin Pincode"),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select Origin Picode';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                              height: SizeConfig
                                                  .mediumVerticalSpacing),
                                          // _buildFormField(
                                          //   label: 'Origin',
                                          //   isRequired: true,
                                          //   icon: Icons.people_outline,
                                          //   child: DropdownButtonFormField<
                                          //       PinCodeModel>(
                                          //     value: _selectedOrigin,
                                          //     decoration: _inputDecoration(
                                          //         'Select origin'),
                                          //     items: pincodeList
                                          //         .map((PinCodeModel origin) {
                                          //       return DropdownMenuItem<
                                          //           PinCodeModel>(
                                          //         value: origin,
                                          //         child: Text(origin.amount
                                          //                 .toString() ??
                                          //             ''),
                                          //       );
                                          //     }).toList(),
                                          //     onChanged:
                                          //         (PinCodeModel? newValue) {
                                          //       setState(() {
                                          //         _selectedOrigin = newValue;
                                          //       });
                                          //     },
                                          //     validator: (value) {
                                          //       if (value == null) {
                                          //         return 'Please select a origin';
                                          //       }
                                          //       return null;
                                          //     },
                                          //   ),
                                          // )
                                          _buildFormField(
                                            label: "Origin",
                                            labelColor:
                                                CommonColors.appBarColor!,
                                            isRequired: true,
                                            icon: Icons.location_city,
                                            child: TextFormField(
                                              enabled: true,
                                              readOnly: true,
                                              onTap: () {
                                                List<
                                                        CommonDataModel<
                                                            BranchModel>>
                                                    commonList = branchList
                                                        .map((branch) =>
                                                            CommonDataModel<
                                                                BranchModel>(
                                                              branch.stnName ??
                                                                  branch
                                                                      .stnName ??
                                                                  'Unknown',
                                                              branch,
                                                            ))
                                                        .toList();

                                                showCommonBottomSheet(
                                                  context,
                                                  "Select Origin",
                                                  (data) {
                                                    _selectedOrigin = data;
                                                    _orgController.text =
                                                        _selectedOrigin!.stnName
                                                            .toString();
                                                    _orgPincodeController.text =
                                                        _selectedOrigin!.zipCode
                                                            .toString();
                                                    setState(() {});
                                                  },
                                                  commonList,
                                                );
                                              },
                                              controller: _orgController,
                                              keyboardType: TextInputType.text,
                                              decoration:
                                                  _inputDecoration("Origin"),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select Origin';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  Card(
                                      // elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig
                                                .largeRadius), // Adjust corner radius as needed
                                        side: BorderSide(
                                          color: CommonColors
                                              .grey400!, // Border color
                                          width: 1.0, // Border thickness
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(
                                            SizeConfig.mediumVerticalSpacing),
                                        child: Column(children: [
                                          // _buildFormField(
                                          //   label: 'Destination Pincode',
                                          //   isRequired: true,
                                          //   icon: Icons.people_outline,
                                          //   child: DropdownButtonFormField<
                                          //       PinCodeModel>(
                                          //     value: _selectedDest,
                                          //     decoration: _inputDecoration(
                                          //         'Select destination'),
                                          //     items: pincodeList
                                          //         .map((PinCodeModel dest) {
                                          //       return DropdownMenuItem<
                                          //           PinCodeModel>(
                                          //         value: dest,
                                          //         child: Text(
                                          //             dest.code.toString() ??
                                          //                 ''),
                                          //       );
                                          //     }).toList(),
                                          //     onChanged:
                                          //         (PinCodeModel? newValue) {
                                          //       setState(() {
                                          //         _selectedDest = newValue;
                                          //       });
                                          //     },
                                          //     validator: (value) {
                                          //       if (value == null) {
                                          //         return 'Please select a destination';
                                          //       }
                                          //       return null;
                                          //     },
                                          //   ),
                                          // ),
                                          _buildFormField(
                                            label: "Destination Pincode",
                                            labelColor:
                                                CommonColors.appBarColor!,
                                            isRequired: true,
                                            icon: Icons.location_city,
                                            child: TextFormField(
                                              readOnly: true,
                                              onTap: () {
                                                List<
                                                        CommonDataModel<
                                                            BranchModel>>
                                                    commonList = branchList
                                                        .map((branch) =>
                                                            CommonDataModel<
                                                                BranchModel>(
                                                              branch.zipCode ??
                                                                  branch
                                                                      .zipCode ??
                                                                  'Unknown',
                                                              branch,
                                                            ))
                                                        .toList();

                                                showCommonBottomSheet(
                                                  context,
                                                  "Select Destination Pincode",
                                                  (data) {
                                                    _selectedDest = data;
                                                    _destController.text =
                                                        _selectedDest!.stnName
                                                            .toString();
                                                    _destPincodeController
                                                            .text =
                                                        _selectedDest!.stnCode
                                                            .toString();
                                                    setState(() {});
                                                  },
                                                  commonList,
                                                );
                                              },
                                              enabled: true,
                                              controller:
                                                  _destPincodeController,
                                              keyboardType: TextInputType.text,
                                              decoration: _inputDecoration(
                                                  "Destination Pincode"),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Select Destination Pincode';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                              height: SizeConfig
                                                  .mediumVerticalSpacing),
                                          // _buildFormField(
                                          //   label: 'Destionation',
                                          //   isRequired: true,
                                          //   icon: Icons.people_outline,
                                          //   child: DropdownButtonFormField<
                                          //       PinCodeModel>(
                                          //     value: _selectedDest,
                                          //     decoration: _inputDecoration(
                                          //         'Select destination'),
                                          //     items: pincodeList
                                          //         .map((PinCodeModel dest) {
                                          //       return DropdownMenuItem<
                                          //           PinCodeModel>(
                                          //         value: dest,
                                          //         child: Text(
                                          //             dest.amount.toString() ??
                                          //                 ''),
                                          //       );
                                          //     }).toList(),
                                          //     onChanged:
                                          //         (PinCodeModel? newValue) {
                                          //       setState(() {
                                          //         _selectedDest = newValue;
                                          //       });
                                          //     },
                                          //     validator: (value) {
                                          //       if (value == null) {
                                          //         return 'Please select a destination';
                                          //       }
                                          //       return null;
                                          //     },
                                          //   ),
                                          // )
                                          _buildFormField(
                                            label: "Destination",
                                            labelColor:
                                                CommonColors.appBarColor!,
                                            isRequired: true,
                                            icon: Icons.location_city,
                                            child: TextFormField(
                                              readOnly: true,
                                              enabled: true,
                                              onTap: () {
                                                List<
                                                        CommonDataModel<
                                                            BranchModel>>
                                                    commonList = branchList
                                                        .map((branch) =>
                                                            CommonDataModel<
                                                                BranchModel>(
                                                              branch.stnName ??
                                                                  branch
                                                                      .stnName ??
                                                                  'Unknown',
                                                              branch,
                                                            ))
                                                        .toList();

                                                showCommonBottomSheet(
                                                  context,
                                                  "Select Destination",
                                                  (data) {
                                                    _selectedDest = data;
                                                    _destController.text =
                                                        _selectedDest!.stnName
                                                            .toString();
                                                    _destPincodeController
                                                            .text =
                                                        _selectedDest!.zipCode
                                                            .toString();
                                                    setState(() {});
                                                  },
                                                  commonList,
                                                );
                                              },
                                              controller: _destController,
                                              keyboardType: TextInputType.text,
                                              decoration: _inputDecoration(
                                                  "Destination"),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please Select Destination';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ]),
                                      )),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFormField(
                                          label: "Order Number",
                                          labelColor: CommonColors.appBarColor!,
                                          isRequired: true,
                                          icon: Icons.calendar_today_outlined,
                                          child: TextFormField(
                                            enabled: false,
                                            controller: _orderNumberController,
                                            keyboardType: TextInputType.text,
                                            decoration: _inputDecoration(
                                                "Order Number"),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter order number';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFormField(
                                          label: 'Booking Type',
                                          isRequired: true,
                                          icon: Icons.people_outline,
                                          child: DropdownButtonFormField<
                                              BookingTypeModel>(
                                            isExpanded: true,
                                            value: _selectedBookingType,
                                            decoration: _inputDecoration(
                                                'Select booking type'),
                                            items: bookingTypeList.map(
                                                (BookingTypeModel booking) {
                                              return DropdownMenuItem<
                                                  BookingTypeModel>(
                                                value: booking,
                                                child: Text(
                                                    booking.name.toString() ??
                                                        ''),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (BookingTypeModel? newValue) {
                                              setState(() {
                                                _selectedBookingType = newValue;
                                                changeBookingType();
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select a booking type';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  _buildFormField(
                                    label: "Bill To Customer",
                                    labelColor: CommonColors.appBarColor!,
                                    isRequired: true,
                                    icon: Icons.person,
                                    child: TextFormField(
                                      enabled: canEditCust,
                                      controller: _custController,
                                      readOnly: true,
                                      onTap: () {
                                        List<CommonDataModel<CustomerModel>>
                                            commonList = customerList
                                                .map((customer) =>
                                                    CommonDataModel<
                                                        CustomerModel>(
                                                      customer.custName ??
                                                          customer.custName ??
                                                          'Unknown',
                                                      customer,
                                                    ))
                                                .toList();

                                        showCommonBottomSheet(
                                          context,
                                          "Select Customer",
                                          (data) {
                                            _selectedCustomer = data;
                                            _custController.text =
                                                _selectedCustomer!.custName
                                                    .toString();
                                            setState(() {});
                                          },
                                          commonList,
                                        );
                                      },
                                      keyboardType: TextInputType.text,
                                      decoration: _inputDecoration("Customer"),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please Select Customer';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  _buildFormField(
                                    label: "Department",
                                    labelColor: CommonColors.appBarColor!,
                                    isRequired: false,
                                    icon: Icons.person,
                                    child: TextFormField(
                                      enabled: (canEditCust &&
                                          _selectedCustomer != null),
                                      readOnly: true,
                                      controller: _deptController,
                                      keyboardType: TextInputType.text,
                                      onTap: () {
                                        List<CommonDataModel<DepartmentModel>>
                                            commonList = deptList
                                                .map((customer) =>
                                                    CommonDataModel<
                                                        DepartmentModel>(
                                                      customer.custDeptName ??
                                                          customer
                                                              .custDeptName ??
                                                          'Unknown',
                                                      customer,
                                                    ))
                                                .toList();

                                        showCommonBottomSheet(
                                          context,
                                          "Select Department",
                                          (data) {
                                            _selectedDept = data;
                                            _deptController.text =
                                                _selectedDept!.custDeptName
                                                    .toString();
                                            setState(() {});
                                          },
                                          commonList,
                                        );
                                      },
                                      decoration:
                                          _inputDecoration("Department"),
                                    ),
                                  ),

                                  consignorDetailsCard(),
                                  SizedBox(
                                    width: SizeConfig.smallHorizontalSpacing,
                                  ),
                                  consigneeDetailsCard(),

                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFormField(
                                          label: 'Service Type',
                                          isRequired: true,
                                          icon: Icons.people_outline,
                                          child: DropdownButtonFormField<
                                              ServiceTypeModel>(
                                            isExpanded: true,
                                            value: _selectedServiceType,
                                            decoration: _inputDecoration(
                                                'Select Service Type'),
                                            items: serviceList.map(
                                                (ServiceTypeModel service) {
                                              return DropdownMenuItem<
                                                  ServiceTypeModel>(
                                                value: service,
                                                child: Text(service.prodName
                                                        .toString() ??
                                                    ''),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (ServiceTypeModel? newValue) {
                                              setState(() {
                                                _selectedServiceType = newValue;
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select a service type';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                        //  _buildFormField(
                                        //   label: 'Service Type',
                                        //   isRequired: true,
                                        //   icon: Icons.check_circle_outline,
                                        //   child: DropdownButtonFormField<
                                        //       ServiceTypeModel>(
                                        //     value: _selectedServiceType,
                                        //     decoration: _inputDecoration(
                                        //         'Select service'),
                                        //     items: serviceList
                                        //         .map((ServiceTypeModel status) {
                                        //       return DropdownMenuItem<
                                        //           ServiceTypeModel>(
                                        //         value: status,
                                        //         child: Text(status.prodName!
                                        //             .toString()),
                                        //       );
                                        //     }).toList(),
                                        //     onChanged:
                                        //         (ServiceTypeModel? newValue) {
                                        //       setState(() {
                                        //         _selectedServiceType = newValue;
                                        //         _serviceController.text =
                                        //             newValue.toString();
                                        //       });
                                        //     },
                                        //     validator: (value) {
                                        //       if (_selectedServiceType == null)
                                        //         return "Please select service type";

                                        //       return null;
                                        //       // if (value == null ||
                                        //       //     value.isEmpty) {
                                        //       //   return 'Please select a Service';
                                        //       // }
                                        //       // return null;
                                        //     },
                                        //   ),
                                        // ),
                                      ),
                                      SizedBox(
                                          width: SizeConfig
                                              .smallHorizontalSpacing),
                                      Expanded(
                                        child: _buildFormField(
                                          label: 'Load Type',
                                          isRequired: true,
                                          icon: Icons.check_circle_outline,
                                          child: DropdownButtonFormField<
                                              LoadTypeModel>(
                                            isExpanded: true,
                                            value: _selectedLoadType,
                                            decoration:
                                                _inputDecoration('Select Load'),
                                            items: loadTypeList
                                                .map((LoadTypeModel status) {
                                              return DropdownMenuItem<
                                                  LoadTypeModel>(
                                                value: status,
                                                child: Text(status.name!),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (LoadTypeModel? newValue) {
                                              setState(() {
                                                _selectedLoadType = newValue;
                                                // _serviceController.text =
                                                //     newValue.toString();
                                              });
                                            },
                                            validator: (value) {
                                              if (_selectedLoadType == null)
                                                return "Please select service type";

                                              return null;
                                              // if (value == null ||
                                              //     value.isEmpty) {
                                              //   return 'Please select a Service';
                                              // }
                                              // return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFormField(
                                          label: "No. of Pckgs",
                                          labelColor: CommonColors.appBarColor!,
                                          isRequired: true,
                                          icon: Icons.numbers,
                                          child: TextFormField(
                                            enabled: true,
                                            controller: _noofpckgsController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly, // ✅ allows only 0–9
                                            ],
                                            decoration:
                                                _inputDecoration("No.Of Pckgs"),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Pckgs';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: SizeConfig
                                              .smallHorizontalSpacing),
                                      Expanded(
                                        child: _buildFormField(
                                          label: 'Delivery Type',
                                          isRequired: true,
                                          icon: Icons.label_outline,
                                          child: DropdownButtonFormField<
                                              DeliveryTypeModel>(
                                            isExpanded: true,
                                            value: _selectedDeliveryType,
                                            decoration: _inputDecoration(
                                                'Select Delivery Type'),
                                            items: deliveryTypeList.map(
                                                (DeliveryTypeModel reason) {
                                              return DropdownMenuItem<
                                                  DeliveryTypeModel>(
                                                value: reason,
                                                child: Text(
                                                    reason.deliveryTypeName ??
                                                        ''),
                                              );
                                            }).toList(),
                                            onChanged:
                                                (DeliveryTypeModel? newValue) {
                                              setState(() {
                                                _selectedDeliveryType =
                                                    newValue;
                                                // _reasonController.text = newValue.toString();
                                              });
                                            },
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select a Delivery Type';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  defaultInvoiceCard(),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: invoiceList.length,
                                    itemBuilder: (context, index) {
                                      return invoiceCard(
                                          invoiceList[index], index + 2);
                                    },
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFormField(
                                          label: "Gross Weight",
                                          labelColor: CommonColors.appBarColor!,
                                          isRequired: true,
                                          icon: Icons.label_outline,
                                          child: TextFormField(
                                            enabled: true,
                                            controller: _gweightController,
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^\d+\.?\d{0,2}$')), // ✅ allows only 0–9 and decimals
                                            ],
                                            decoration: _inputDecoration(
                                                "Gross Weight"),
                                            onChanged: (value) {
                                              manageChargableWeight();
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Gross Weight';
                                              } else if (double.parse(
                                                      value.toString()) ==
                                                  0) {
                                                return 'Weight cannot be zero';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          width: SizeConfig
                                              .mediumHorizontalSpacing),
                                      Expanded(
                                        child: _buildFormField(
                                          label: "Vol. Weight",
                                          labelColor: CommonColors.appBarColor!,
                                          isRequired: true,
                                          icon: Icons.label_outline,
                                          child: TextFormField(
                                            enabled: true,
                                            controller: _vweightController,
                                            keyboardType: TextInputType.number,
                                            decoration:
                                                _inputDecoration("Vol. Weight"),
                                            onChanged: (value) {
                                              manageChargableWeight();
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^\d+\.?\d{0,2}$')), // ✅ allows only 0–9 and decimals
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Vol.Weight';
                                              } else if (double.parse(
                                                      value.toString()) ==
                                                  0) {
                                                return 'Weight cannot be zero';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFormField(
                                          label: "Chargeable Weight",
                                          labelColor: CommonColors.appBarColor!,
                                          isRequired: true,
                                          icon: Icons.label_outline,
                                          child: TextFormField(
                                            enabled: true,
                                            controller: _cweightController,
                                            keyboardType: TextInputType.number,
                                            decoration: _inputDecoration(
                                                "Chargeable Weight"),
                                            onChanged: (value) {
                                              changeChargeableWeight(value);
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^\d+\.?\d{0,2}$')), // ✅ allows only 0–9 and decimals
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Chargeable Weight';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFormField(
                                          label: "Freight",
                                          labelColor: CommonColors.appBarColor!,
                                          isRequired: true,
                                          icon: Icons.label_outline,
                                          child: TextFormField(
                                            enabled: true,
                                            controller: _freightController,
                                            keyboardType: TextInputType.number,
                                            decoration:
                                                _inputDecoration("Freight"),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(
                                                      r'^\d+\.?\d{0,2}$')), // ✅ allows only 0–9 and decimals
                                            ],
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please Enter Freight';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  _buildFormField(
                                    label: 'Remarks',
                                    isRequired: false,
                                    icon: Icons.comment_outlined,
                                    child: TextFormField(
                                      focusNode: remarksFocus,
                                      onTapOutside: (event) {
                                        remarksFocus.unfocus();
                                      },
                                      controller: _remarksController,
                                      decoration: _inputDecoration(
                                          'Enter any additional notes (optional)'),
                                      maxLines: 3,
                                    ),
                                  ),
                                  SizedBox(
                                      height: SizeConfig.mediumVerticalSpacing),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.verticalPadding,
                                        horizontal:
                                            SizeConfig.horizontalPadding),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: CommonColors.grey400!,
                                            width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.largeRadius))),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.camera_alt_outlined,
                                              color: Colors.black54,
                                            ),
                                            SizedBox(
                                              width: SizeConfig
                                                  .mediumHorizontalSpacing,
                                            ),
                                            const Text(
                                              "DOCUMENT UPLOAD",
                                              style: TextStyle(
                                                  color: Colors.black87),
                                            ),
                                            Expanded(
                                                child: Align(
                                              alignment:
                                                  AlignmentGeometry.centerRight,
                                              child: InkWell(
                                                child: const Icon(
                                                  Icons.file_upload_outlined,
                                                  color: Colors.black54,
                                                  // size: 24,
                                                ),
                                                onTap: () {
                                                  showImagePickerDialog(context,
                                                      (file) async {
                                                    if (file != null) {
                                                      debugPrint(
                                                          ' data: ${file.path}');
                                                      setState(() {
                                                        _itemImagePath =
                                                            file.path;
                                                      });
                                                    } else {
                                                      failToast(
                                                          "File not selected");
                                                    }
                                                  });
                                                },
                                              ),
                                            ))
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(
                                              SizeConfig.mediumVerticalSpacing),
                                          child: SizedBox(
                                            height: 200,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: CommonColors.grey300,
                                                  borderRadius: BorderRadius
                                                      .all(Radius.circular(
                                                          SizeConfig
                                                              .largeIconSize))),
                                              child: isNullOrEmpty(
                                                      _itemImagePath)
                                                  ? InkWell(
                                                      child: const Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons
                                                                .file_upload_outlined,
                                                            color:
                                                                Colors.black54,
                                                          ),
                                                          Text(
                                                            "Upload Image",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87),
                                                          ),
                                                          Text(
                                                            "Click the upload button above",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black87),
                                                          )
                                                        ],
                                                      ),
                                                      onTap: () {
                                                        showImagePickerDialog(
                                                            context,
                                                            (file) async {
                                                          if (file != null) {
                                                            debugPrint(
                                                                ' data: ${file.path}');
                                                            setState(() {
                                                              _itemImagePath =
                                                                  file.path;
                                                            });
                                                          } else {
                                                            failToast(
                                                                "File not selected");
                                                          }
                                                        });
                                                      },
                                                    )
                                                  : Image.file(
                                                      File(_itemImagePath!),
                                                      fit: BoxFit.contain,
                                                    ),
                                            ),
                                          ),
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
                                      padding: EdgeInsets.symmetric(
                                          vertical:
                                              SizeConfig.mediumVerticalSpacing),
                                      child: CommonButton(
                                        color: CommonColors.colorPrimary!,
                                        onTap: () {
                                          validateForm();
                                        },
                                        title: "Save",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hint: Text(
        hint,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          color: CommonColors.grey400!,
          fontSize: SizeConfig.smallTextSize,
        ),
      ),
      // hintText: hint,
      // hintMaxLines: 1,
      // hintStyle: TextStyle(
      //   color: CommonColors.grey400!,
      //   overflow: TextOverflow.ellipsis,
      // ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.mediumHorizontalSpacing,
          vertical: SizeConfig.mediumVerticalSpacing),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
        borderSide: const BorderSide(color: CommonColors.appBarColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
        borderSide: const BorderSide(color: CommonColors.appBarColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
        borderSide:
            BorderSide(color: CommonColors.primaryColorShade!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1.5),
      ),
    );
  }
}

Widget _buildFormField({
  required String label,
  required bool isRequired,
  required IconData icon,
  required Widget child,
  Color labelColor = const Color(0xFF334155),
  // bool isSmallDevice = false,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon,
              size: SizeConfig.largeIconSize, color: const Color(0xFF64748B)),
          SizedBox(width: SizeConfig.extraSmallHorizontalSpacing),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                      overflow: TextOverflow.ellipsis),
                ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: CommonColors.red!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: SizeConfig.smallVerticalSpacing),
      child,
    ],
  );
}
