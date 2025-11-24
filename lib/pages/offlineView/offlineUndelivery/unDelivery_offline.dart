import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/alertBox/SuccessAlert.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/common/utils.dart';
import 'package:gtlmd/pages/offlineView/dbHelper.dart';
import 'package:gtlmd/pages/offlineView/offlineUndelivery/model/undelivery_offlineModel.dart';
import 'package:gtlmd/pages/unDelivery/actionModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:intl/intl.dart';

class UndeliveryOffline extends StatefulWidget {
  const UndeliveryOffline({super.key});

  @override
  State<UndeliveryOffline> createState() => _UndeliveryOfflineState();
}

class _UndeliveryOfflineState extends State<UndeliveryOffline> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _unDeliverDateController =
      TextEditingController();
  final TextEditingController _unDeliveryTimeController =
      TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _actionController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _drsNoController = TextEditingController();
  final TextEditingController _grNoController = TextEditingController();
  String? _imageFilePath;
  String? _imageFilePathBase64;
  List<String> existingGrList = [];
  bool grUnDeliveryExists = false;
  late DBHelper dbHelper = DBHelper();
  // ReasonModel? _selectedReason;
  // ActionModel? _selectedAction;
  String unDeliverDt = "";
  late DateTime todayDateTime;
  late String smallDateTime;
  ReasonModel? _selectedReason;
  ActionModel? _selectedAction;
  List<ReasonModel> reasonList = [
    ReasonModel(reasonname: "PARTY NOT AVAILABLE", reasoncode: "00001"),
    ReasonModel(reasonname: "GODOWN IS CLOSED", reasoncode: "00003"),
    ReasonModel(reasonname: "OTHER", reasoncode: "00004"),
    ReasonModel(reasonname: "REBOOKING", reasoncode: "00005"),
    ReasonModel(reasonname: "BILLING OTHER BRANCH", reasoncode: "00006"),
    ReasonModel(reasonname: "NA", reasoncode: "00008"),
    ReasonModel(reasonname: "PARTY UNDELIVER", reasoncode: "00009"),
    ReasonModel(reasonname: "TESTING REASON", reasoncode: "00010"),
    ReasonModel(reasonname: "TEST ENTRY", reasoncode: "00011"),
  ];
  List<ActionModel> actionList = [
    ActionModel(reasonname: "TESTING", reasoncode: "00002"),
    ActionModel(reasonname: "CREDIT NOTE ISSUED IN NEPAL", reasoncode: "00007"),
  ];

  late FocusNode consignmentNumberFocus;
  late FocusNode remarksFocus;
  @override
  void initState() {
    super.initState();
    consignmentNumberFocus = FocusNode();
    remarksFocus = FocusNode();
    _unDeliverDateController.text = /* formatDate(DateTime.now()); */
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    _unDeliveryTimeController.text = DateFormat('hh:mm').format(DateTime.now());
    fetchExistingGrList();
  }

  fetchExistingGrList() async {
    existingGrList = await DBHelper.getUndeliveryGrList();
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                primary: CommonColors.colorPrimary!,
              )),
              child: child!);
        });
    if (picked != null) {
      setState(() {
        _unDeliveryTimeController.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void validateUnDeliveryForm() {
    if (isNullOrEmpty(_unDeliverDateController.text.toString())) {
      failToast("Please select date");
      return;
    } else if (isNullOrEmpty(_unDeliveryTimeController.text.toString())) {
      failToast("Please select time");
      return;
    } else if (isNullOrEmpty(_grNoController.text.toString())) {
      failToast("Please Enter Consignment#");
      return;
    } else if (isNullOrEmpty(_reasonController.text.toString())) {
      failToast("Please enter reason");
      return;
    } else if (isNullOrEmpty(_actionController.text.toString())) {
      failToast("Please enter action");
      return;
    } else if (isNullOrEmpty(_imageFilePath.toString())) {
      failToast("Please select undelivery image");
    } else if (checkUniqueGr()) {
      showExistingGrAlert();
      return;
    } else {
      // Save data to database
      // successToast("Everything is fine");
      saveEntry();
      // loadUndeliveryData();
    }
  }

  showExistingGrAlert() {
    // commonAlertDialog(
    //     context,
    //     "GR Exist",
    //     "The pod for this GR already exists.",
    //     '',
    //     const Icon(Icons.warning_outlined),
    //     () {});

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Existing GR"),
            icon: const Icon(Icons.warning_amber_rounded),
            iconColor: CommonColors.dangerColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "The Undelivery for GR ${_grNoController.text.toString()} already exists.",
                ),
              ],
            ),
            actions: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text(
                            'Okay',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }

  void loadUndeliveryData() async {
    List<Map<String, dynamic>> data = await DBHelper.getUndeliveryDetail();

    print('Type of data: ${data.runtimeType}');
    print(
        'First item type: ${data.isNotEmpty ? data.first.runtimeType : "Empty"}');

    for (var row in data) {
      print(row); // each row is a Map<String, dynamic>
    }
  }

  bool checkUniqueGr() {
    bool exists = false;
    for (String grno in existingGrList) {
      if (_grNoController.text.toString().trim() == grno) {
        exists = true;
      }
    }
    setState(() {
      grUnDeliveryExists = exists;
    });
    return exists;
  }

  Future<void> saveEntry() async {
    try {
      final UnDeliveryOfflineModel unDeliveryOfflineModel =
          UnDeliveryOfflineModel(
        prmundeldt:
            convert2SmallDateTime(_unDeliverDateController.text.toString()),
        prmtime: _unDeliveryTimeController.text.toString(),
        prmgrno: _grNoController.text.toString(),
        prmreasoncode: _selectedReason!.reasoncode.toString(),
        prmactioncode: _selectedAction!.reasoncode.toString(),
        prmdrno: "",
        prmremarks: _remarksController.text.toString(),
        prmimagepath: _imageFilePath.toString(),
        prmreason: _selectedReason!.reasonname.toString(),
        prmaction: _selectedAction!.reasonname.toString(),
      );

      // DBHelper.insertUndelivery(unDeliveryOfflineModel);
      int result = await DBHelper.insertUndelivery(unDeliveryOfflineModel);

      if (result > 0) {
        debugPrint("Data inserted successfully. Row ID: $result");
        showSuccessAlert(
            context,
            "UNDELIVER SUCCESSFULLY\n Consignment# -: ${_grNoController.text.toString()}",
            "",
            backCallBackForAlert);
      } else {
        debugPrint("Data insertion failed. Result: $result");
      }
    } catch (e, stackTrace) {
      debugPrint("Error saving undelivery entry: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

  void backCallBackForAlert() {
    Navigator.pop(context);
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
                Row(
                  children: [
                    Expanded(
                      child:
                          // _buildFieldLabel('Undelivery Date', true),
                          _buildFormField(
                              label: "UnDelivery Date",
                              isRequired: true,
                              icon: Icons.calendar_today,
                              child: InkWell(
                                onTap: () async {
                                  DateTime? picketDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    builder: (context, child) {
                                      return Theme(
                                          data: Theme.of(context).copyWith(
                                              colorScheme: ColorScheme.light(
                                            primary: CommonColors.colorPrimary!,
                                          )),
                                          child: child!);
                                    },
                                  );

                                  setState(() {
                                    _unDeliverDateController.text =
                                        DateFormat('dd-MM-yyyy')
                                            .format(picketDate!);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 15),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: CommonColors.grey300!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        _unDeliverDateController.text
                                            .toString(),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      Icon(Icons.calendar_month,
                                          color: CommonColors.black54),
                                    ],
                                  ),
                                ),
                              )),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Expanded(
                        child: _buildFormField(
                          label: 'UnDelivery Time',
                          isRequired: true,
                          icon: Icons.access_time,
                          child: InkWell(
                            onTap: () {
                              _selectTime(context);
                            },
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
                                    _unDeliveryTimeController.text.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Icon(Icons.access_time,
                                      color: CommonColors.black54),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                _buildFormField(
                  label: "Consignment Number",
                  isRequired: true,
                  icon: Icons.inventory_2_outlined,
                  child: TextFormField(
                    focusNode: consignmentNumberFocus,
                    onTapOutside: (event) {
                      consignmentNumberFocus.unfocus();
                    },
                    onChanged: (context) => {checkUniqueGr()},
                    enabled: true,
                    controller: _grNoController,
                    decoration: _inputDecoration("Consignment Number"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter consignment number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 5),

                Visibility(
                  visible: grUnDeliveryExists,
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_outlined,
                        color: CommonColors.dangerColor,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Undelivery for GR number already exist.',
                        style: TextStyle(color: CommonColors.dangerColor),
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible: grUnDeliveryExists,
                  child: const SizedBox(height: 20),
                ),

                // Reason
                _buildFormField(
                  label: 'Reason',
                  isRequired: true,
                  icon: Icons.lightbulb_outline,
                  child: DropdownButtonFormField<ReasonModel>(
                    value: _selectedReason,
                    decoration: _inputDecoration('Select reason'),
                    items: reasonList.map((ReasonModel reason) {
                      return DropdownMenuItem<ReasonModel>(
                        value: reason,
                        child: Text(reason.reasonname.toString() ?? ''),
                      );
                    }).toList(),
                    onChanged: (ReasonModel? newValue) {
                      setState(() {
                        _selectedReason = newValue;
                        _reasonController.text = newValue.toString();
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
                    items: actionList.map((ActionModel action) {
                      return DropdownMenuItem<ActionModel>(
                        value: action,
                        child: Text(action.reasonname ?? ''),
                      );
                    }).toList(),
                    onChanged: (ActionModel? newValue) {
                      setState(() {
                        _selectedAction = newValue;
                        _actionController.text = newValue.toString();
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
                        padding: const EdgeInsets.all(8.0),
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
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
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
