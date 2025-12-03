import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/SuccessAlert.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';


import 'package:gtlmd/pages/unDelivery/actionModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:gtlmd/pages/unDelivery/unDeliveryViewModel.dart';
import 'package:intl/intl.dart';

class UnDelivery extends StatefulWidget {
  final DeliveryDetailModel deliveryDetailModel;
  final CurrentDeliveryModel currentDeliveryModel;

  const UnDelivery({
    super.key,
    required this.deliveryDetailModel,
    required this.currentDeliveryModel,
  });

  @override
  State<UnDelivery> createState() => _UnDeliveryState();
}

class _UnDeliveryState extends State<UnDelivery> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool imageRequired = false;
  DeliveryDetailModel deliveryDetailModel = DeliveryDetailModel();
  CurrentDeliveryModel currentDeliveryModel = CurrentDeliveryModel();
  late LoadingAlertService loadingAlertService;
  UnDeliveryViewModel viewModel = UnDeliveryViewModel();
  final TextEditingController _unDeliverDateController =
      TextEditingController();
  final TextEditingController _unDeliveryTimeController =
      TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _actionController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _grNoController = TextEditingController();

  List<ReasonModel> _reasonList = List.empty(growable: true);
  List<ActionModel> _actionList = List.empty(growable: true);
  String? _imageFilePath;
  String? _imageFilePathBase64;
  ReasonModel? _selectedReason;
  ActionModel? _selectedAction;
  String unDeliverDt = "";
  late DateTime todayDateTime;
  late String smallDateTime;
  late FocusNode remarksFocus;
  @override
  void initState() {
    super.initState();
    remarksFocus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    deliveryDetailModel = widget.deliveryDetailModel;
    currentDeliveryModel = widget.currentDeliveryModel;
    _grNoController.text = deliveryDetailModel.grno.toString();
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    unDeliverDt = smallDateTime;
    DateTime date = DateTime.parse(unDeliverDt);
    _unDeliverDateController.text = DateFormat('dd-MM-yyyy').format(date);

    // _unDeliverDateController.text = formatDate(DateTime.now());
    _unDeliveryTimeController.text =
        DateFormat('h:mm a').format(DateTime.now());
    getReasons();
    setObservers();
  }

  setObservers() {
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

    viewModel.reasonListLiveData.stream.listen((reasonList) async {
      setState(() {
        _reasonList = reasonList;
      });
/*       ReasonModel? result = await _showGenericDialog(
        context,
        _reasonList,
        (reason) => reason.reasonname.toString(),
      );

      if (result != null) {
        _reasonController.text = result.reasonname.toString();
        _selectedReason = result;
        imageRequired = _selectedReason!.imagerequired.toString() == 'Y';
      }
 */
    });

    viewModel.actionListLiveData.stream.listen((actionList) {
      setState(() {
        _actionList = actionList;
      });
    });

    viewModel.saveUnDeliveryLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        successToast("Undelivery successful");

        showSuccessAlert(
            context,
            // "UNDELIVER SUCCESSFULLY\n Consignment# -: ${resp.grNo}",
            "UNDELIVER SUCCESSFULLY\n Consignment# -: ${deliveryDetailModel.grno}",
            "",
            backCallBackForAlert);
      } else {
        failToast(resp.commandmessage!.toString() ?? "Something went wrong");
      }
    });
  }

  void backCallBackForAlert() {
    Navigator.pop(context);
  }

  void validateUnDeliveryForm() {
    // if (_selectedReason == null) {
    //   failToast('Please select reason');
    // } else if (isNullOrEmpty(_selectedAction!.reasoncode)) {
    //   failToast('Please select action');
    // } else if (isNullOrEmpty(_imageFilePath)) {
    //   failToast("Please select an image");
    //   return;
    // } else {
    //   // everything is okay
    //   saveUndelivery();
    // }

    if (_formKey.currentState!.validate()) {
      if (isNullOrEmpty(_imageFilePath)) {
        failToast("Please select an image");
        return;
      }
      saveUndelivery();
    }
  }

  _inputFieldWithHeading(
    TextInputType inputType,
    TextEditingController controller,
    String label,
    Icon? prefixIcon,
    Icon? suffixIcon,
    String heading,
    bool isRequired,
    bool isEnabled,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: MediaQuery.sizeOf(context).width * 0.02,
            right: MediaQuery.sizeOf(context).width * 0.02,
            top: MediaQuery.sizeOf(context).height * 0.02,
            bottom: MediaQuery.sizeOf(context).height * 0.01,
          ),
          child: isRequired == true
              ? RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    style: const TextStyle(),
                    children: <TextSpan>[
                      TextSpan(
                        text: heading,
                        style: const TextStyle(color: CommonColors.appBarColor),
                      ),
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: CommonColors.dangerColor),
                      ),
                    ],
                  ),
                )
              : Text(heading),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.02,
          ),
          child: inputField(inputType, controller, label, suffixIcon,
              prefixIcon, isEnabled, 32),
        )
      ],
    );
  }

  _datePicker(
      String heading, TextEditingController controller, bool isEnabled) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.sizeOf(context).width * 0.02,
              vertical: MediaQuery.sizeOf(context).height * 0.01,
            ),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: const TextStyle(),
                children: <TextSpan>[
                  TextSpan(
                    text: heading,
                    style: const TextStyle(color: CommonColors.appBarColor),
                  ),
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: CommonColors.dangerColor),
                  ),
                ],
              ),
            ),
          ),
          TextField(
            enabled: isEnabled,
            readOnly: true,
            controller: TextEditingController(
              text: controller.text,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              hintText: 'Select date',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              suffixIcon: Icon(Icons.calendar_month),
            ),
            onTap: () {
              _pickDate(controller);
            },
          ),
        ],
      ),
    );
  }

  _timePicker(
      String heading, TextEditingController controller, bool isEnabled) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.sizeOf(context).width * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.02,
                vertical: MediaQuery.sizeOf(context).height * 0.01),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: const TextStyle(),
                children: <TextSpan>[
                  TextSpan(
                    text: heading,
                    style: const TextStyle(color: CommonColors.appBarColor),
                  ),
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: CommonColors.dangerColor),
                  ),
                ],
              ),
            ),
          ),
          TextField(
            enabled: isEnabled,
            readOnly: true,
            controller: TextEditingController(
              text: controller.text,
            ),
            decoration: const InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              hintText: 'Select time',
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
              suffixIcon: Icon(Icons.alarm_rounded),
            ),
            onTap: () {
              debugPrint('Field');
              _pickTime(controller);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    debugPrint("Selected date: $pickedDate");
    setState(() {
      unDeliverDt = DateFormat('yyyy-MM-dd').format(pickedDate!);
      DateTime date = DateTime.parse(unDeliverDt);
      controller.text = DateFormat('dd-MM-yyyy').format(date);

      // controller.text = formatDate(pickedDate!);
    });
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
  }

  getReasons() {
    Map<String, String> params = {
      'prmconnstring': savedLogin.companyid.toString()
    };
    viewModel.getReasons(params);
  }

/* 
  void _showReasonDialog(
      BuildContext context, List<ReasonModel> _reasonList) async {
    String? _selectionResult;

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Relation'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _reasonList.map((reason) {
                    return RadioListTile<ReasonModel>(
                      title: Text(reason.reasonname.toString()),
                      value: reason,
                      groupValue: _selectedReason,
                      onChanged: (ReasonModel? value) {
                        setState(() {
                          _selectedReason = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    // Navigator.of(context).pop(_selectedRelation);
                    Get.back(result: _selectedReason!.reasonname);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _reasonController.text = result.toString();
      });
    }
  }

 */

  void saveUndelivery() {
    Map<String, String> params = {
      "prmconnstring": savedLogin.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmundeldt":
          convert2SmallDateTime(_unDeliverDateController.text.toString()),
      "prmtime": formatTimeString(_unDeliveryTimeController.text),
      "prmdlvtripsheetno": currentDeliveryModel.drsno.toString(),
      "prmgrno": deliveryDetailModel.grno.toString(),
      "prmreasoncode": _selectedReason!.reasoncode.toString(),
      "prmactioncode": _selectedAction!.reasoncode.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmmenucode": 'GTAPP_DRS',
      "prmremarks": _remarksController.text.toUpperCase(),
      "prmdrno": "",
      "prmimagepath": _imageFilePathBase64.toString()
    };

    debugPrint("Test");
    viewModel.saveUnDelivery(params);
  }

  Widget _buildFieldLabel(String label, bool isRequired) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: CommonColors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isRequired)
          Text(
            ' *',
            style: TextStyle(
              color: CommonColors.dangerColor,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }

/* 
  Widget _buildDateField(BuildContext context) {
    final formattedDate = _selectedDate != null
        ? DateFormat('dd-MM-yyyy').format(_selectedDate!)
        : 'Select date';
    
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: CommonColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CommonColors.aliceBlue!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                formattedDate,
                style: TextStyle(
                  color: _selectedDate != null
                      ? CommonColors.White
                      : CommonColors.grey,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today,
              color: CommonColors.colorPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

 */
/* 
  Widget _buildTimeField(BuildContext context) {
    final formattedTime = _selectedTime != null
        ? _selectedTime!.format(context)
        : 'Select time';
    
    return InkWell(
      onTap: () => _selectTime(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: CommonColors.White,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: CommonColors.aliceBlue!),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                formattedTime,
                style: TextStyle(
                  color: _selectedTime != null
                      ? CommonColors.White
                      : CommonColors.aliceBlue,
                  fontSize: 15,
                ),
              ),
            ),
            Icon(
              Icons.access_time,
              color: CommonColors.colorPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

 */
  Widget _buildDropdownField({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
    required String? Function(String?) validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      hint: Text(
        hint,
        style: TextStyle(
          color: CommonColors.grey,
          fontSize: 14,
        ),
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: CommonColors.White,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CommonColors.aliceBlue!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CommonColors.aliceBlue!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: CommonColors.colorPrimary!, width: 2),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: CommonColors.colorPrimary,
      ),
      isExpanded: true,
      onChanged: onChanged,
      validator: validator,
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              color: CommonColors.White,
              fontSize: 15,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFormField({
    required String label,
    required bool isRequired,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: CommonColors.darkCyanBlue!,
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
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: CommonColors.grey400!),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        elevation: 0,
        title: const Text(
          'Report Undelivery',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
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
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'UnDelivery Information',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: CommonColors.primaryColorShade!,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                const SizedBox(height: 20),
                // Date and Time row
                _buildFormField(
                  label: "Consignment Number",
                  isRequired: false,
                  icon: Icons.inventory_2_outlined,
                  child: TextFormField(
                    enabled: false,
                    controller: _grNoController,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Consignment Number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter consignment number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child:
                          // _buildFieldLabel('Undelivery Date', true),
                          _buildFormField(
                              label: "UnDelivery Date",
                              isRequired: true,
                              icon: Icons.calendar_today,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 15),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: CommonColors.grey300!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _unDeliverDateController.text.toString(),
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Icon(Icons.calendar_month,
                                        color: CommonColors.grey),
                                  ],
                                ),
                              )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Expanded(
                        child: _buildFormField(
                          label: 'Delivery Time',
                          isRequired: true,
                          icon: Icons.access_time,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color: CommonColors.grey300!),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _unDeliveryTimeController.text.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                Icon(Icons.access_time,
                                    color: CommonColors.grey),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Reason
                _buildFormField(
                  label: 'Reason',
                  isRequired: true,
                  icon: Icons.lightbulb_outline,
                  child: DropdownButtonFormField<ReasonModel>(
                    value: _selectedReason,
                    decoration: _inputDecoration('Select reason'),
                    items: _reasonList.map((ReasonModel reason) {
                      return DropdownMenuItem<ReasonModel>(
                        value: reason,
                        child: Text(reason.reasonname.toString() ?? ''),
                      );
                    }).toList(),
                    onChanged: (ReasonModel? newValue) {
                      setState(() {
                        _selectedReason = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a reason';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 20),
                // Action
                _buildFormField(
                  label: 'Action',
                  isRequired: true,
                  icon: Icons.call_to_action,
                  child: DropdownButtonFormField<ActionModel>(
                    value: _selectedAction,
                    decoration: _inputDecoration('Select action'),
                    items: _actionList.map((ActionModel action) {
                      return DropdownMenuItem<ActionModel>(
                        value: action,
                        child: Text(action.reasonname ?? ''),
                      );
                    }).toList(),
                    onChanged: (ActionModel? newValue) {
                      setState(() {
                        _selectedAction = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a action';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      showImagePickerDialog(
                        context,
                        (file) {
                          if (file != null) {
                            setState(() {
                              _imageFilePath = file.path;
                              _imageFilePathBase64 =
                                  convertFilePathToBase64(_imageFilePath!);
                            });
                          } else {
                            failToast('File not selected');
                          }
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      decoration: BoxDecoration(
                          color: CommonColors.primaryColorShade,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Text("Upload UnDelivery Image",
                          style: TextStyle(
                              color: CommonColors.White,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),

                Visibility(
                  visible: _imageFilePath != null && _imageFilePath!.isNotEmpty,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "UnDelivery Image",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: CommonColors.darkCyanBlue!,
                                ),
                              ),
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
                      ),
                      Container(
                        height: 150,
                        width: MediaQuery.sizeOf(context).width,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(
                              width: 1, color: CommonColors.colorPrimary!),
                        ),
                        child: _imageFilePath == null
                            ? Center(
                                child: Text(
                                "Add Image",
                                style:
                                    TextStyle(color: CommonColors.colorPrimary),
                              ))
                            : Image.file(
                                fit: BoxFit.fill,
                                File(_imageFilePath!),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
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
                      validateUnDeliveryForm();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.primaryColorShade,
                      foregroundColor: CommonColors.White,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Submit Undelivery',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      // persistentFooterButtons: [
      //   InkWell(
      //     onTap: () {
      //       validateUnDeliveryForm();
      //     },
      //     child: Container(
      //       alignment: Alignment.center,
      //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //       decoration: BoxDecoration(
      //           color: CommonColors.colorPrimary,
      //           borderRadius: const BorderRadius.all(Radius.circular(10))),
      //       child: Text("SUBMIT", style: TextStyle(color: CommonColors.White)),
      //     ),
      //   )
      // ],
    );
  }
}
