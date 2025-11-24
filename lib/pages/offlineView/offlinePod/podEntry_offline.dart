import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/SuccessAlert.dart';
import 'package:gtlmd/common/bottomSheet/signatureBottomSheet.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/pages/offlineView/dbHelper.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/model/podEntry_offlineModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:intl/intl.dart';

class PodEntryOffline extends StatefulWidget {
  const PodEntryOffline({super.key});

  @override
  State<PodEntryOffline> createState() => _PodEntryOfflineState();
}

class _PodEntryOfflineState extends State<PodEntryOffline> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _grNoController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _deliveryTimeController = TextEditingController();
  final TextEditingController _receivedByController = TextEditingController();

  final TextEditingController _receiverMobileByController =
      TextEditingController();
  // final TextEditingController _deliverByController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  final TextEditingController _deliverPckgsController = TextEditingController();
  final TextEditingController _damagedPckgsController = TextEditingController();
  String? _signatureFilePath;
  String? _podFilePath;

  bool isSignRequired = true;
  bool isStampRequired = true;
  late FocusNode consignmentNumberFocus;
  late FocusNode receivedByFocus;
  late FocusNode receiverMobileNumFocus;
  late FocusNode dlvPckgsFocus;
  late FocusNode dmgPckgsFocus;
  late FocusNode remarksFocus;
  ReasonModel? _selectedDamageReason;
  String? _damageImg1FilePath;
  String? _damageImg2FilePath;
  String? _selectedRelation;
  List<String> _damageImages = [];
  List<String> existingGrList = [];
  bool grPodExists = false;
  final List<String> _relations = [
    'SELF',
    'BROTHER',
    'FATHER',
    'SERVANT',
    'ASSISTANT',
    'NEIGHBOUR',
    'FRIEND',
    'UNCLE',
    'AUNTY',
  ];

  List<ReasonModel> _damageReason = [
    ReasonModel(reasoncode: "A0002", reasonname: "DUE TO RAIN"),
    ReasonModel(reasoncode: "A0003", reasonname: "ACCIDENT"),
    ReasonModel(reasoncode: "A0005", reasonname: "OPEN"),
    ReasonModel(reasoncode: "A0007", reasonname: "BREAKAGE"),
    ReasonModel(reasoncode: "A0009", reasonname: "LEAKAGE"),
    ReasonModel(reasoncode: "A0010", reasonname: "TESTING"),
  ];

  @override
  void initState() {
    super.initState();
    consignmentNumberFocus = FocusNode();
    receivedByFocus = FocusNode();
    receiverMobileNumFocus = FocusNode();
    dlvPckgsFocus = FocusNode();
    dmgPckgsFocus = FocusNode();
    remarksFocus = FocusNode();
    _deliveryDateController.text = /* formatDate(DateTime.now()); */
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    _deliveryTimeController.text = DateFormat('hh:mm').format(DateTime.now());
    fetchExistingGrList();
    // fetchPod();
  }

  void fetchPod() async {
    List<Map<String, dynamic>> pods = await DBHelper.getPodEntryDetail();
    for (int i = 0; i < pods.length; i++) {
      Map<String, dynamic> map = pods[i];
      map.entries.forEach((entry) {
        debugPrint("POD Entry: ${entry.key} ${entry.value}");
      });
    }
  }

  fetchExistingGrList() async {
    existingGrList = await DBHelper.getPodGrList();
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

  void validatePodForm() {
    if (_grNoController.text.isEmpty) {
      failToast("Please fill GR number");
      return;
    } else if (isNullOrEmpty(_deliveryDateController.text)) {
      failToast('Please enter date');
      return;
    } else if (isNullOrEmpty(_deliveryTimeController.text)) {
      failToast('Please enter time');
      return;
    } else if (isNullOrEmpty(_receivedByController.text)) {
      failToast('Please fill the Received by field');
      return;
    } else if (isNullOrEmpty(_receiverMobileByController.text)) {
      failToast('Please fill the receiver mobile number field');
      return;
    } else if (_receiverMobileByController.text.length != 10) {
      failToast("Please enter a valid mobile number");
    } else if (isNullOrEmpty(_relationController.text.toString())) {
      failToast('Please fill the relation field');
      return;
    } else if (isNullOrEmpty(_deliverPckgsController.text.toString())) {
      failToast('Please add delivered packages');
      return;
    } else if (isNullOrEmpty(_damagedPckgsController.text.toString())) {
      failToast('Please add damanged packages');
      return;
    } else if (int.parse(_damagedPckgsController.text) >
        int.parse(_deliverPckgsController.text.toString())) {
      failToast("Damaged packages cannot be greater than total packages");
      return;
    } else if (isNullOrEmpty(_signatureFilePath)) {
      failToast('Please add Signature');
      return;
    } else if (isNullOrEmpty(_podFilePath)) {
      failToast('Please add POD Image');
      return;
    } else if (int.parse(_damagedPckgsController.text.toString()) > 0 &&
        _selectedDamageReason == null) {
      failToast("Please select a damange reason");
      return;
    } else if (int.parse(_damagedPckgsController.text.toString()) > 0 &&
        _damageImg1FilePath == null) {
      failToast("Please select damange Image 1");
      return;
    }
    // else if (int.parse(_damagedPckgsController.text.toString()) > 0 &&
    //     _damageImages.isEmpty) {
    //   failToast("Please select damage images");
    //   return;
    // }
    else if (checkUniqueGr()) {
      showExistingGrAlert();
      return;
    } else {
      saveEntry();
    }
    //  else if (int.parse(_deliverPckgsController.text) >
    //     int.parse(model.pckgs.toString())) {
    //   failToast("Delivery packages cannot be greater than total packages");
    //   return;
    // }
    //  else if (int.parse(_damagedPckgsController.text) >
    //     int.parse(model.pckgs.toString())) {
    //   failToast("Damaged packages cannot be greater than total packages");
    //   return;
    // }
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
                  "The POD for GR ${_grNoController.text.toString()} already exists.",
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

  bool checkUniqueGr() {
    bool exists = false;
    for (String grno in existingGrList) {
      if (_grNoController.text.toString().trim() == grno) {
        exists = true;
      }
    }
    setState(() {
      grPodExists = exists;
    });
    return exists;
  }

  void saveEntry() async {
    try {
      // String damageImages = jsonEncode(_damageImages);
      PodEntryOfflineModel podOfflineModel = PodEntryOfflineModel(
        // "prmconnstring": savedLogin.companyid.toString(),
        // prmloginbranchcode: savedUser.loginbranchcode.toString(),
        prmgrno: _grNoController.text.toString().trim(),
        prmdlvdt:
            convert2SmallDateTime(_deliveryDateController.text.toString()),
        prmdlvtime: _deliveryTimeController.text.toString(),
        prmname: _receivedByController.text.toString(),
        prmrelation: _relationController.text.toString(),
        prmphno: _receiverMobileByController.text.toString(),
        prmdeliveryboy: savedUser.username.toString(),
        prmremarks: _remarksController.text.toUpperCase(),
        prmpodimageurl: _podFilePath,
        prmsighnimageurl: _signatureFilePath,
        prmdelayreason: "",
        prmmenucode: "GTAPP_PODENTRY",
        prmdeliverpckgs: isNullOrEmpty(_deliverPckgsController.text)
            ? 0
            : int.parse(_deliverPckgsController.text.toString()),
        prmdamagepckgs: isNullOrEmpty(_damagedPckgsController.text)
            ? 0
            : int.parse(_damagedPckgsController.text.toString()),
        prmdamagereasonid: _selectedDamageReason == null
            ? '0'
            : _selectedDamageReason!.reasoncode,
        // prmdamageimgstr: damageImages
        prmdamageimg1:
            isNullOrEmpty(_damageImg1FilePath) ? '' : _damageImg1FilePath,
        // prmdamageimg2:
        //     isNullOrEmpty(_damageImg2FilePath) ? '' : _damageImg2FilePath,
      );

      int result = await DBHelper.insertPod(podOfflineModel);
      debugPrint("Record Num: $result");
      if (result > 0) {
        debugPrint("Data inserted successfully. Row ID: $result");
        showSuccessAlert(
            context,
            "POD SUCCESSFULLY\n Consignment# -: ${_grNoController.text.toString()}",
            "",
            backCallBackForAlert);

        // saveDamageImages(podOfflineModel);
      } else {
        debugPrint("Data insertion failed. Result: $result");
      }
    } catch (e, stackTrace) {
      debugPrint("Error saving pod entry: $e");
      debugPrint("Stack trace: $stackTrace");
    }
  }

/* 
  void saveDamageImages(PodEntryOfflineModel podEntry) async {
    try {
      if (_damageImages.isNotEmpty) {
        int result = await DBHelper.insertPodDamageImage(
            _grNoController.text.toString(), _damageImages);
        if (result > 0) {
          debugPrint("Data inserted successfully. Row ID: $result");
          showSuccessAlert(
              context,
              "POD SUCCESSFULLY\n Consignment# -: ${_grNoController.text.toString()}",
              "",
              backCallBackForAlert);
        } else {
          DBHelper.deletePodEntry(
              podEntry); // Delete the pod entry if image save fails
          debugPrint("Data insertion failed. Result: $result");
          failToast("Something went wrong");
        }
      } else {
        failToast("No images selected");
      }
    } catch (e, stackTrace) {
      debugPrint("Error saving damage images: $e");
      debugPrint("Stack trace: $stackTrace");
      DBHelper.deletePodEntry(
          podEntry); // Delete the pod entry if image save fails
      failToast("Failed to save damage images");
    }
  }

 */
  clearDamagedValues() {
    _selectedDamageReason = null;
    _damageImg1FilePath = null;
    _damageImg2FilePath = null;
  }

  void backCallBackForAlert() {
    // Navigator.pop(context);
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'POD Entry',
          style: TextStyle(color: CommonColors.White),
        ),
        leading: InkWell(
          onTap: () => {Navigator.pop(context)},
          child: Icon(
            Icons.arrow_back,
            color: CommonColors.White,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
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
                          'Delivery Information',
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
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            label: "Consignment Number",
                            isRequired: false,
                            icon: Icons.inventory_2_outlined,
                            child: TextFormField(
                              focusNode: consignmentNumberFocus,
                              onTapOutside: (event) {
                                consignmentNumberFocus.unfocus();
                              },
                              onChanged: (value) => {checkUniqueGr()},
                              // enabled: false,
                              controller: _grNoController,
                              decoration:
                                  _inputDecoration("Consignment Number"),
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
                            visible: grPodExists,
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
                                  'Pod for GR number already exist.',
                                  style: TextStyle(
                                      color: CommonColors.dangerColor),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: grPodExists,
                            child: const SizedBox(height: 20),
                          ),

                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildFormField(
                                    label: "Delivery Date",
                                    isRequired: false,
                                    icon: Icons.calendar_today,
                                    child: InkWell(
                                      onTap: () async {
                                        DateTime? picketDate =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(2100),
                                          builder: (context, child) {
                                            return Theme(
                                                data: Theme.of(context)
                                                    .copyWith(
                                                        colorScheme:
                                                            ColorScheme.light(
                                                  primary: CommonColors
                                                      .colorPrimary!,
                                                )),
                                                child: child!);
                                          },
                                        );

                                        setState(() {
                                          _deliveryDateController.text =
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              _deliveryDateController.text
                                                  .toString(),
                                              style:
                                                  const TextStyle(fontSize: 16),
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
                                child: _buildFormField(
                                  label: 'Delivery Time',
                                  isRequired: true,
                                  icon: Icons.access_time,
                                  child: InkWell(
                                    onTap: () async {
                                      String time = await selectTime(context);
                                      setState(() {
                                        _deliveryTimeController.text = time;
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
                                            _deliveryTimeController.text
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Icon(Icons.access_time,
                                              color: CommonColors.black54),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildFormField(
                            label: 'Received By',
                            isRequired: true,
                            icon: Icons.person_outline,
                            child: TextFormField(
                              focusNode: receivedByFocus,
                              onTapOutside: (event) {
                                receivedByFocus.unfocus();
                              },
                              controller: _receivedByController,
                              decoration:
                                  _inputDecoration("Enter recipient's name"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter recipient name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildFormField(
                            label: 'Receiver Mobile Number',
                            isRequired: true,
                            icon: Icons.phone_android_outlined,
                            child: TextFormField(
                              maxLength: 10,
                              buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  required maxLength}) {
                                return Text(
                                  '$currentLength / $maxLength',
                                  style: TextStyle(
                                    color: currentLength > (maxLength ?? 0)
                                        ? Colors.red
                                        : Colors.grey,
                                  ),
                                );
                              },
                              focusNode: receiverMobileNumFocus,
                              onTapOutside: (event) {
                                receiverMobileNumFocus.unfocus();
                              },
                              controller: _receiverMobileByController,
                              keyboardType: TextInputType.phone,
                              decoration:
                                  _inputDecoration('Enter mobile number'),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length != 10) {
                                  return 'Please enter a valid mobile number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Relation
                          _buildFormField(
                            label: 'Relation',
                            isRequired: true,
                            icon: Icons.person_outline,
                            child: DropdownButtonFormField<String>(
                              value: _selectedRelation,
                              decoration: _inputDecoration('Select relation'),
                              items: _relations.map((String relation) {
                                return DropdownMenuItem<String>(
                                  value: relation,
                                  child: Text(relation),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRelation = newValue;
                                  _relationController.text =
                                      newValue.toString();
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a relation';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Delivery Person
                          // _buildFormField(
                          //   label: 'Delivery Person',
                          //   isRequired: true,
                          //   icon: Icons.delivery_dining_outlined,
                          //   child: TextFormField(
                          //     controller: _deliverByController,
                          //     keyboardType: TextInputType.text,
                          //     decoration: _inputDecoration('Delivery person'),
                          //   ),
                          // ),
                          // const SizedBox(height: 20),
                          // Delivery Packages
                          _buildFormField(
                            label: "Delivery Pckgs",
                            isRequired: true,
                            icon: Icons.delivery_dining_outlined,
                            child: TextFormField(
                              focusNode: dlvPckgsFocus,
                              onTapOutside: (event) {
                                dlvPckgsFocus.unfocus();
                              },
                              controller: _deliverPckgsController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration('Delivery Packages'),
                              validator: (value) {
                                if (isNullOrEmpty(value)) {
                                  return 'Please enter delivery packages';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Damage Packages
                          _buildFormField(
                            label: "Damaged Pckgs",
                            isRequired: true,
                            icon: Icons.delivery_dining_outlined,
                            child: TextFormField(
                              focusNode: dmgPckgsFocus,
                              onTapOutside: (event) {
                                dmgPckgsFocus.unfocus();
                              },
                              onChanged: (value) {
                                _damagedPckgsController.text = value;
                                setState(() {
                                  if (_damagedPckgsController.text
                                          .toString()
                                          .isNotEmpty &&
                                      int.parse(_damagedPckgsController.text
                                              .toString()) ==
                                          0) {
                                    // empty the damage reason, damage image 1 and damage image 2 variables
                                    clearDamagedValues();
                                  }
                                });
                              },
                              controller: _damagedPckgsController,
                              keyboardType: TextInputType.phone,
                              decoration: _inputDecoration('Damaged Packages'),
                              validator: (value) {
                                if (isNullOrEmpty(value)) {
                                  return 'Please enter damanged packages';
                                }
                                return null;
                              },
                            ),
                          ),
                          Visibility(
                              visible: _damagedPckgsController.text
                                      .toString()
                                      .isNotEmpty &&
                                  int.parse(_damagedPckgsController.text
                                          .toString()) >
                                      0,
                              child: const SizedBox(height: 20)),
                          Visibility(
                            visible: _damagedPckgsController.text
                                    .toString()
                                    .isNotEmpty &&
                                int.parse(_damagedPckgsController.text
                                        .toString()) >
                                    0,
                            child: _buildFormField(
                              label: 'Damage Reason',
                              isRequired: _damagedPckgsController.text
                                      .toString()
                                      .isNotEmpty &&
                                  int.parse(_damagedPckgsController.text
                                          .toString()) >
                                      0,
                              icon: Icons.people_outline,
                              child: DropdownButtonFormField<ReasonModel>(
                                value: _selectedDamageReason,
                                decoration: _inputDecoration('Select reason'),
                                items: _damageReason.map((ReasonModel reason) {
                                  return DropdownMenuItem<ReasonModel>(
                                    value: reason,
                                    child: Text(
                                        reason.reasonname.toString() ?? ''),
                                  );
                                }).toList(),
                                onChanged: (ReasonModel? newValue) {
                                  setState(() {
                                    _selectedDamageReason = newValue;
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
                          ),

                          const SizedBox(
                            height: 20,
                          ),

                          Visibility(
                            visible: _damagedPckgsController.text
                                    .toString()
                                    .isNotEmpty &&
                                int.parse(_damagedPckgsController.text
                                        .toString()) >
                                    0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                spacing: 8,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        showImagePickerDialog(context,
                                            (file) async {
                                          if (file != null) {
                                            debugPrint(
                                                'Damage Image 1 File data: ${file!.path}');
                                            setState(() {
                                              _damageImg1FilePath = file!.path;
                                            });
                                          } else {
                                            // model!.stamp = 'N';
                                            failToast("File not selected");
                                          }
                                        });

                                        // List<String> imagePaths =
                                        //     await showMultiImageBottomSheetDialog(
                                        //         context, _damageImages);
                                        // setState(() {
                                        //   _damageImages = imagePaths;
                                        // });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        decoration: BoxDecoration(
                                            color:
                                                CommonColors.primaryColorShade,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Text("Damage Image",
                                            style: TextStyle(
                                                color: CommonColors.White,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),

/* 
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        showImagePickerDialog(context,
                                            (file) async {
                                          if (file != null) {
                                            debugPrint(
                                                'Damage Image 2 File data: ${file!.path}');
                                            setState(() {
                                              _damageImg2FilePath = file!.path;
                                            });
                                          } else {
                                            // model!.stamp = 'N';
                                            failToast("File not selected");
                                          }
                                        });

                                        // List<String> imagePaths =
                                        //     await showMultiImageBottomSheetDialog(
                                        //         context, _damageImages);
                                        // setState(() {
                                        //   _damageImages = imagePaths;
                                        // });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        decoration: BoxDecoration(
                                            color:
                                                CommonColors.primaryColorShade,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Text("Upload Image 2",
                                            style: TextStyle(
                                                color: CommonColors.White,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),

 */
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: (_damagedPckgsController.text
                                    .toString()
                                    .isNotEmpty &&
                                int.parse(_damagedPckgsController.text
                                        .toString()) >
                                    0 &&
                                ((_damageImg1FilePath != null &&
                                        _damageImg1FilePath!.isNotEmpty) ||
                                    (_damageImg2FilePath != null &&
                                        _damageImg2FilePath!.isNotEmpty))),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // model.stamp = 'Y';
                                      showImagePickerDialog(context,
                                          (file) async {
                                        if (file != null) {
                                          debugPrint(
                                              'Damage Image 1 File data: ${file!.path}');
                                          setState(() {
                                            _damageImg1FilePath = file!.path;
                                          });
                                        } else {
                                          // model!.stamp = 'N';
                                          failToast("File not selected");
                                        }
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text.rich(TextSpan(
                                              text: 'Damage Image',
                                              children: <InlineSpan>[
                                                TextSpan(
                                                  text: '*',
                                                  style: TextStyle(
                                                      color: CommonColors
                                                          .dangerColor),
                                                )
                                              ])),
                                        ),
                                        Container(
                                            height: 150,
                                            width: MediaQuery.sizeOf(context)
                                                .width,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: CommonColors
                                                      .colorPrimary!),
                                            ),
                                            child: _damageImg1FilePath == null
                                                ? Center(
                                                    child: Text(
                                                      "Select Image",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: CommonColors
                                                              .colorPrimary),
                                                    ),
                                                  )
                                                : Image.file(
                                                    File(_damageImg1FilePath!),
                                                    fit: BoxFit.fill,
                                                  )),
                                      ],
                                    ),
                                  ),
                                ),
/* 
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      // model.stamp = 'Y';
                                      showImagePickerDialog(context,
                                          (file) async {
                                        if (file != null) {
                                          debugPrint(
                                              'Damage Image 2 File data: ${file!.path}');
                                          setState(() {
                                            _damageImg2FilePath = file!.path;
                                          });
                                        } else {
                                          // model!.stamp = 'N';
                                          failToast("File not selected");
                                        }
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text.rich(
                                            TextSpan(
                                              text: 'Image 2',
                                            ),
                                          ),
                                        ),
                                        Container(
                                            height: 150,
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(5)),
                                              border: Border.all(
                                                  width: 1,
                                                  color: CommonColors
                                                      .colorPrimary!),
                                            ),
                                            child: _damageImg2FilePath == null
                                                ? Center(
                                                    child: Text(
                                                      "Select Image",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          color: CommonColors
                                                              .colorPrimary),
                                                    ),
                                                  )
                                                : Image.file(
                                                    File(_damageImg2FilePath!),
                                                    fit: BoxFit.fill,
                                                  )),
                                      ],
                                    ),
                                  ),
                                ),

 */
                              ],
                            ),
                          ),
/* 
                          Visibility(
                            visible: _damagedPckgsController.text
                                    .toString()
                                    .isNotEmpty &&
                                int.parse(_damagedPckgsController.text
                                        .toString()) >
                                    0,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                spacing: 8,
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        // showImagePickerDialog(context,
                                        //     (file) async {
                                        //   if (file != null) {
                                        //     debugPrint(
                                        //         'Damage Image 1 File data: ${file!.path}');
                                        //     setState(() {
                                        //       _damageImg1FilePath = file!.path;
                                        //     });
                                        //   } else {
                                        //     // model!.stamp = 'N';
                                        //     failToast("File not selected");
                                        //   }
                                        // });

                                        List<String> imagePaths =
                                            await showMultiImageBottomSheetDialog(
                                                context, _damageImages);
                                        setState(() {
                                          _damageImages = imagePaths;
                                        });
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 15),
                                        decoration: BoxDecoration(
                                            color:
                                                CommonColors.primaryColorShade,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Text("Damage Images",
                                            style: TextStyle(
                                                color: CommonColors.White,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

 */
                          const SizedBox(
                            height: 20,
                          ),
                          // Remarks
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
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 8,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // model.sign = 'Y';

                              showSignatureBottomSheet(context,
                                  (path, base64Path) {
                                // if (path != null) {
                                //   debugPrint("Signature path: $path");
                                //   debugPrint("Signature Base 64 path: $base64Path");
                                // } else {
                                //   debugPrint("Path is null");
                                //   failToast("File path is null");
                                // };

                                if (path != null && path.isNotEmpty) {
                                  debugPrint('Signature file data: $path');
                                  setState(() {
                                    _signatureFilePath = path;
                                  });
                                } else {
                                  // model.sign = 'N';
                                  failToast(
                                      'Something went wrong. Please try again');
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  color: CommonColors.primaryColorShade,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text("Upload Signature",
                                  style: TextStyle(
                                      color: CommonColors.White,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // model.stamp = 'Y';
                              showImagePickerDialog(context, (file) async {
                                if (file != null) {
                                  debugPrint('POD File data: ${file!.path}');
                                  setState(() {
                                    _podFilePath = file!.path;
                                  });
                                } else {
                                  // model!.stamp = 'N';
                                  failToast("File not selected");
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  color: CommonColors.primaryColorShade,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text("Upload POD",
                                  style: TextStyle(
                                      color: CommonColors.White,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (_signatureFilePath != null &&
                            _signatureFilePath!.isNotEmpty) ||
                        (_podFilePath != null && _podFilePath!.isNotEmpty),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // model.sign = 'Y';

                              showSignatureBottomSheet(context,
                                  (path, base64Path) {
                                if (path != null && path.isNotEmpty) {
                                  debugPrint('Signature file data: $path');
                                  setState(() {
                                    _signatureFilePath = path;
                                  });
                                } else {
                                  // model.sign = 'N';
                                  failToast(
                                      'Something went wrong. Please try again');
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text.rich(TextSpan(
                                      text: 'Singnature Image',
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                              color: CommonColors.dangerColor),
                                        )
                                      ])),
                                ),
                                Container(
                                    height: 150,
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border: Border.all(
                                          width: 1,
                                          color: CommonColors.colorPrimary!),
                                    ),
                                    child: _signatureFilePath == null
                                        ? Center(
                                            child: Text(
                                              "Select Image",
                                              style: TextStyle(
                                                  color: CommonColors
                                                      .colorPrimary),
                                            ),
                                          )
                                        : Image.file(
                                            File(_signatureFilePath!),
                                            fit: BoxFit.fill,
                                          )),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              // model.stamp = 'Y';
                              showImagePickerDialog(context, (file) async {
                                if (file != null) {
                                  debugPrint('POD File data: ${file!.path}');
                                  setState(() {
                                    _podFilePath = file!.path;
                                  });
                                } else {
                                  // model!.stamp = 'N';
                                  failToast("File not selected");
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text.rich(TextSpan(
                                      text: 'POD Image',
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: '*',
                                          style: TextStyle(
                                              color: CommonColors.dangerColor),
                                        )
                                      ])),
                                ),
                                Container(
                                    height: 150,
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      border: Border.all(
                                          width: 1,
                                          color: CommonColors.colorPrimary!),
                                    ),
                                    child: _podFilePath == null
                                        ? Center(
                                            child: Text(
                                              "Select Image",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: CommonColors
                                                      .colorPrimary),
                                            ),
                                          )
                                        : Image.file(
                                            File(_podFilePath!),
                                            fit: BoxFit.fill,
                                          )),
                              ],
                            ),
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
                        validatePodForm();
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
                        'Submit POD',
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
      ),
    );
  }
}
