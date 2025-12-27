import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/SuccessAlert.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';

import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/reversePickup/model/reversePickupModel.dart';
import 'package:gtlmd/pages/reversePickup/reversePickupViewModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:intl/intl.dart';

class ReversePickup extends StatefulWidget {
  final DeliveryDetailModel deliveryDetailModel;
  const ReversePickup({super.key, required this.deliveryDetailModel});

  @override
  State<ReversePickup> createState() => _ReversePickupState();
}

class _ReversePickupState extends State<ReversePickup> {
  final _formKey = GlobalKey<FormState>();
  ReversePickupViewModel viewModel = ReversePickupViewModel();
  late LoadingAlertService loadingAlertService;
  ReversePickupModel reversePickupDetails =
      ReversePickupModel(); // Initialize with an empty model

  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _orderController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _itemController = TextEditingController();
  final TextEditingController _skuCodeController = TextEditingController();
  // final  TextEditingController _imageController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _shipperController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  // final TextEditingController _returnReasonController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _returnCodeController = TextEditingController();
  String? _selectedOrderImgPath;
  BaseRepository baseRepo = BaseRepository();
  FocusNode remarksFocus = FocusNode();
  FocusNode returnCodeFocus = FocusNode();
  FocusNode skuFocus = FocusNode();
  final List<String> _statusList = [
    "Matched",
    "Not Matched",
  ];

  List<ReasonModel> _reasonList = [];
  String? _selectedStatus;
  ReasonModel? _selectedReturnReason;
  String? _itemImagePath = "";

  // String? _itemImagePath;
  bool skuVerified = false;
  bool returnCodeValid = false;

  // static const platform = MethodChannel('scan_channel');
  // String _barcode = "Waiting for scan...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));

    _selectedStatus = _statusList[0];
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _timeController.text = DateFormat('hh:mm').format(DateTime.now());
    if (ENV.isDebugging) {
      _skuController.text = "001050000125-0001";
    }
    baseRepo.scanBarcode();
    setObservers();
  }

  void setObservers() {
    baseRepo.scannedCode.stream.listen((scannedCode) {
      setState(() {
        _skuController.text = scannedCode;
      });
      debugPrint("Scanned Code: $scannedCode");
    });

    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      if (errMsg != null) {
        failToast(errMsg.toString());
      } else {
        failToast("Something went wrong");
      }
    });

    viewModel.reversePickupLiveData.stream.listen((reversePickupModel) {
      setState(() {
        reversePickupDetails = reversePickupModel;
        if (reversePickupDetails.skucode == _skuController.text.trim()) {
          skuVerified = true;
          getReasonList();
          setUiDetails();
        }
      });
    });

    viewModel.saveReversePickupLiveData.stream.listen((reversePickupModel) {
      showSuccessAlert(context, "Pickup Successful",
          reversePickupModel.commandmessage!, navigateBack);
    });

    viewModel.verifySkuLiveData.stream.listen((sku) {});

    viewModel.reasonLiveData.stream.listen((reasonList) {
      debugPrint("Reason List: $reasonList");
      setState(() {
        _reasonList = reasonList;
        // _returnReasonList.clear();
        // _returnReasonList.addAll(_reasonList.map((e) => e.reasonName!));
        // _selectedReason = _returnReasonList.first;
      });
    });
  }

  void navigateBack() {
    Get.back();
  }

  setUiDetails() {
    _orderController.text = reversePickupDetails.orderno ?? '';
    _deliveryDateController.text = reversePickupDetails.orderdt != null
        ? DateFormat('dd-MM-yyyy')
            .format(DateTime.parse(reversePickupDetails.orderdt!))
        : '';
    _itemController.text = reversePickupDetails.itemname ?? '';
    _skuCodeController.text = reversePickupDetails.skucode ?? '';
    _itemImagePath = reversePickupDetails.articalimgpath;
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    _timeController.text = DateFormat('hh:mm').format(DateTime.now());
    _shipperController.text = reversePickupDetails.shippername ?? '';
    _mobileController.text = reversePickupDetails.mobileno ?? '';
    _statusController.text = _selectedStatus!;
  }

  validateForm() {
    // if (!_formKey.currentState!.validate()) {
    //   failToast("Please fill all required fields");
    //   return;
    // }
    if (_selectedReturnReason == null) {
      failToast("Select return reason");
      return;
    } else if (_selectedStatus == null) {
      failToast("Select Image status");
      return;
    } else if (!returnCodeValid) {
      failToast("Invalid Return code");
      return;
    } else if (isNullOrEmpty(_selectedOrderImgPath)) {
      failToast("Plese select order image");
      return;
    } else {
      saveReversePickup();
    }
  }

  getReasonList() {
    Map<String, String> params = {
      "prmconnstring": savedLogin.companyid.toString(),
    };
    viewModel.getReasonList(params);
  }

  saveReversePickup() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmgrno": widget.deliveryDetailModel.transactionid.toString(),
      "prmreasoncode": _selectedReturnReason!.reasoncode.toString(),
      "prmremarks": _remarksController.text.toString(),
      "prmimgmatchstatus": _selectedStatus == "Matched" ? 'Y' : 'N',
      "prmarticaleimgpath": convertFilePathToBase64(_selectedOrderImgPath),
      "prmtransactionid": widget.deliveryDetailModel.transactionid.toString()
    };
    viewModel.saveReversePickup(params);
  }

  getReversePickupData() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "skucode": _skuController.text.trim(),
      "prmgrno": widget.deliveryDetailModel.transactionid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };
    viewModel.getReversePickup(params);
  }

  verifySku() {
    Map<String, dynamic> params = {
      "sku": _skuController.text.trim(),
    };
    viewModel.verifySku(params);
  }

  Widget _buildFormField({
    required String label,
    required bool isRequired,
    required IconData icon,
    required Widget child,
    required bool isSmallDevice,
    Color labelColor = const Color(0xFF334155),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                size: isSmallDevice ? 14 : 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: isSmallDevice ? 12 : 14,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
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
        SizedBox(height: isSmallDevice ? 4 : 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, bool isSmallDevice) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: CommonColors.grey400!, fontSize: isSmallDevice ? 13 : 14),
      contentPadding: EdgeInsets.symmetric(
          horizontal: 12, vertical: isSmallDevice ? 12 : 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: CommonColors.primaryColorShade!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.red!, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.red!, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          title: Text(
            'Reverse Pickup',
            style: TextStyle(
                color: CommonColors.White, fontSize: isSmallDevice ? 16 : 18),
          ),
          leading: InkWell(
            onTap: () => {Navigator.pop(context)},
            child: Icon(
              Icons.arrow_back,
              color: CommonColors.White,
              size: isSmallDevice ? 20 : 24,
            ),
          ),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallDevice ? 12 : 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_shipping_outlined,
                        color: CommonColors.primaryColorShade!,
                        size: isSmallDevice ? 18 : 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Reverse Pickup Information',
                        style: TextStyle(
                          fontSize: isSmallDevice ? 14 : 16,
                          fontWeight: FontWeight.w600,
                          color: CommonColors.primaryColorShade!,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Padding(
                  padding: const EdgeInsets.all(16),
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
                                label: "SKU",
                                isRequired: false,
                                icon: Icons.label_outline,
                                isSmallDevice: isSmallDevice,
                                child: TextFormField(
                                  focusNode: skuFocus,
                                  onTapOutside: (event) {
                                    skuFocus.unfocus();
                                  },
                                  autofocus: true,
                                  onEditingComplete: () {
                                    setState(() {
                                      _skuController.text =
                                          _skuController.text.trim();
                                    });
                                    skuFocus.unfocus();
                                    // verifySku();
                                  },
                                  textInputAction: TextInputAction.done,
                                  controller: _skuController,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      color: CommonColors.appBarColor,
                                      fontSize: isSmallDevice ? 13 : 14),
                                  decoration:
                                      _inputDecoration("SKU", isSmallDevice),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter SKU';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Visibility(
                              visible: !skuVerified,
                              child: SizedBox(
                                width: MediaQuery.sizeOf(context).width * 0.25,
                                child: Container(
                                  // padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: CommonColors.whiteShade,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(12),
                                      bottomRight: Radius.circular(12),
                                    ),
                                  ),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_skuController.text.isEmpty) {
                                        failToast("Please enter SKU");
                                        return;
                                      } else {
                                        getReversePickupData();
                                        ();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          CommonColors.primaryColorShade,
                                      foregroundColor: CommonColors.White,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Text(
                                      'Submit',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   width: 43,
                            //   height: 43,
                            //   child: Container(
                            //     decoration: BoxDecoration(
                            //       shape: BoxShape.circle,
                            //       border: Border.all(
                            //         color: CommonColors.primaryColorShade!,
                            //         width: 2,
                            //       ),
                            //     ),
                            //     child: Center(
                            //       child: IconButton(
                            //         icon: Icon(
                            //           Icons.submitted_outlined,
                            //           color: CommonColors.primaryColorShade!,
                            //         ),
                            //         onPressed: () {
                            //           // verifySku();
                            //         },
                            //       ),
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Visibility(
                          visible: skuVerified,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CommonColors.grey600!),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(12))),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildFormField(
                                            label: "Order #",
                                            isRequired: false,
                                            icon: Icons.receipt_long_outlined,
                                            labelColor: CommonColors.grey400!,
                                            isSmallDevice: isSmallDevice,
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _orderController,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  fontSize:
                                                      isSmallDevice ? 13 : 14),
                                              decoration: _inputDecoration(
                                                  "Order #", isSmallDevice),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Order #';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _buildFormField(
                                            label: "Delivery Date",
                                            isRequired: false,
                                            icon: Icons.calendar_today_outlined,
                                            labelColor: CommonColors.grey400!,
                                            isSmallDevice: isSmallDevice,
                                            child: TextFormField(
                                              enabled: false,
                                              controller:
                                                  _deliveryDateController,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  fontSize:
                                                      isSmallDevice ? 13 : 14),
                                              decoration: _inputDecoration(
                                                  "Delivery Date",
                                                  isSmallDevice),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Delivery Date';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _buildFormField(
                                      label: "Item",
                                      isRequired: false,
                                      icon: Icons.inventory_2_outlined,
                                      labelColor: CommonColors.grey400!,
                                      isSmallDevice: isSmallDevice,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _itemController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            fontSize: isSmallDevice ? 13 : 14),
                                        decoration: _inputDecoration(
                                            "Item", isSmallDevice),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Item';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildFormField(
                                      label: "SKU Code",
                                      isRequired: false,
                                      icon: Icons.code_outlined,
                                      labelColor: CommonColors.grey400!,
                                      isSmallDevice: isSmallDevice,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _skuCodeController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            fontSize: isSmallDevice ? 13 : 14),
                                        decoration: _inputDecoration(
                                            "SKU Code", isSmallDevice),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter SKU Code';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildFormField(
                                            label: "Date",
                                            labelColor: CommonColors.grey400!,
                                            isRequired: false,
                                            icon: Icons.calendar_today_outlined,
                                            isSmallDevice: isSmallDevice,
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _dateController,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  fontSize:
                                                      isSmallDevice ? 13 : 14),
                                              decoration: _inputDecoration(
                                                  "Date", isSmallDevice),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Date';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: _buildFormField(
                                            label: "Time",
                                            labelColor: CommonColors.grey400!,
                                            isRequired: false,
                                            icon: Icons.access_time_outlined,
                                            isSmallDevice: isSmallDevice,
                                            child: TextFormField(
                                              enabled: false,
                                              controller: _timeController,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                  fontSize:
                                                      isSmallDevice ? 13 : 14),
                                              decoration: _inputDecoration(
                                                  "Time", isSmallDevice),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please enter Time';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    _buildFormField(
                                      label: "Shipper",
                                      labelColor: CommonColors.grey400!,
                                      isRequired: false,
                                      icon: Icons.person_outline,
                                      isSmallDevice: isSmallDevice,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _shipperController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            fontSize: isSmallDevice ? 13 : 14),
                                        decoration: _inputDecoration(
                                            "Shipper", isSmallDevice),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Shipper';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    _buildFormField(
                                      label: "Mobile",
                                      labelColor: CommonColors.grey400!,
                                      isRequired: false,
                                      icon: Icons.phone_android_outlined,
                                      isSmallDevice: isSmallDevice,
                                      child: TextFormField(
                                        enabled: false,
                                        controller: _mobileController,
                                        keyboardType: TextInputType.text,
                                        style: TextStyle(
                                            fontSize: isSmallDevice ? 13 : 14),
                                        decoration: _inputDecoration(
                                            "Mobile", isSmallDevice),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter Mobile';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        const SizedBox(height: 20),
                                        _buildFormField(
                                          isSmallDevice: isSmallDevice,
                                          label: "Image",
                                          labelColor: CommonColors.grey400!,
                                          isRequired: false,
                                          icon: Icons.image_outlined,
                                          child: Container(
                                              height: 150,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: CommonColors.grey300!,
                                                  width: 1,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: _itemImagePath == null ||
                                                      _itemImagePath!.isEmpty
                                                  ? Center(
                                                      child: Text(
                                                        'No Image Found',
                                                        style: TextStyle(
                                                          color: CommonColors
                                                              .grey600!,
                                                        ),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        // Implement image selection logic here
                                                        showDialogWithImage(
                                                            context,
                                                            _itemImagePath!,
                                                            isLocal: false);
                                                      },
                                                      child: Image.network(
                                                        _itemImagePath!,
                                                        fit: BoxFit.cover,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return Center(
                                                            child: Text(
                                                              'Something went wrong',
                                                              style: TextStyle(
                                                                  color: CommonColors
                                                                      .grey600!),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    )),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          showImagePickerDialog(context,
                                              (file) async {
                                            if (file != null) {
                                              debugPrint(': ${file!.path}');
                                              setState(() {
                                                _selectedOrderImgPath =
                                                    file!.path;
                                              });
                                            } else {
                                              failToast("File not selected");
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              CommonColors.primaryColorShade,
                                          foregroundColor: CommonColors.White,
                                          padding: EdgeInsets.symmetric(
                                              vertical:
                                                  isSmallDevice ? 12 : 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          "Select Order Image",
                                          style: TextStyle(
                                            fontSize: isSmallDevice ? 13 : 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible:
                                        isNullOrEmpty(_selectedOrderImgPath) ==
                                                true
                                            ? false
                                            : true,
                                    child: Container(
                                        height: isSmallDevice ? 120 : 150,
                                        width: MediaQuery.sizeOf(context).width,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              width: 1,
                                              color:
                                                  CommonColors.colorPrimary!),
                                        ),
                                        child: _selectedOrderImgPath == null
                                            ? Center(
                                                child: Text(
                                                  "",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: CommonColors
                                                          .colorPrimary),
                                                ),
                                              )
                                            : Image.file(
                                                File(_selectedOrderImgPath!),
                                                fit: BoxFit.fill,
                                              )),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildFormField(
                                label: 'Status',
                                isRequired: true,
                                icon: Icons.check_circle_outline,
                                isSmallDevice: isSmallDevice,
                                child: DropdownButtonFormField<String>(
                                  value: _selectedStatus,
                                  decoration: _inputDecoration(
                                      'Select Status', isSmallDevice),
                                  items: _statusList.map((String status) {
                                    return DropdownMenuItem<String>(
                                      value: status,
                                      child: Text(status),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _selectedStatus = newValue;
                                      _statusController.text =
                                          newValue.toString();
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a status';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildFormField(
                                label: 'Return Reason',
                                isRequired: true,
                                icon: Icons.label_outline,
                                isSmallDevice: isSmallDevice,
                                child: DropdownButtonFormField<ReasonModel>(
                                  value: _selectedReturnReason,
                                  decoration: _inputDecoration(
                                      'Select Reason', isSmallDevice),
                                  items: _reasonList.map((ReasonModel reason) {
                                    return DropdownMenuItem<ReasonModel>(
                                      value: reason,
                                      child: Text(
                                        reason.reasonname ?? '',
                                        style: TextStyle(
                                            fontSize: isSmallDevice ? 13 : 14),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (ReasonModel? newValue) {
                                    setState(() {
                                      _selectedReturnReason = newValue;
                                      // _reasonController.text = newValue.toString();
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'Please select a status';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildFormField(
                                label: "Return Code",
                                isRequired: true,
                                icon: Icons.code,
                                isSmallDevice: isSmallDevice,
                                child: TextFormField(
                                  focusNode: returnCodeFocus,
                                  onTapOutside: (event) {
                                    returnCodeFocus.unfocus();
                                  },
                                  controller: _returnCodeController,
                                  style: TextStyle(
                                      fontSize: isSmallDevice ? 13 : 14),
                                  decoration: _inputDecoration(
                                      "Return Code", isSmallDevice),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Return Code';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) => setState(
                                    () {
                                      if (reversePickupDetails.returncode !=
                                              null &&
                                          reversePickupDetails.returncode ==
                                              value.trim()) {
                                        setState(() {
                                          returnCodeValid = true;
                                        });
                                      } else {
                                        setState(() {
                                          returnCodeValid = false;
                                        });
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                  visible:
                                      _returnCodeController.text.isNotEmpty,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 5),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          returnCodeValid
                                              ? "Return Code Valid"
                                              : "Invalid Return Code",
                                          style: TextStyle(
                                              color: returnCodeValid
                                                  ? CommonColors.green600
                                                  : CommonColors.red),
                                        ),
                                      ),
                                    ],
                                  )),
                              const SizedBox(height: 20),
                              _buildFormField(
                                label: 'Remarks',
                                isRequired: false,
                                icon: Icons.comment_outlined,
                                isSmallDevice: isSmallDevice,
                                child: TextFormField(
                                  focusNode: remarksFocus,
                                  onTapOutside: (event) {
                                    remarksFocus.unfocus();
                                  },
                                  controller: _remarksController,
                                  style: TextStyle(
                                      fontSize: isSmallDevice ? 13 : 14),
                                  decoration: _inputDecoration(
                                      'Enter any additional notes (optional)',
                                      isSmallDevice),
                                  maxLines: 3,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: skuVerified,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CommonColors.whiteShade,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        validateForm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.primaryColorShade,
                        foregroundColor: CommonColors.White,
                        padding: EdgeInsets.symmetric(
                            vertical: isSmallDevice ? 12 : 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )));
  }
}
