import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/alertBox/SuccessAlert.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/multiImageBottomSheet.dart';
import 'package:gtlmd/common/bottomSheet/signatureBottomSheet.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/common/utils.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/podEntry/Model/podEntryModel.dart';
import 'package:gtlmd/pages/podEntry/Model/stickerModel.dart';
import 'package:gtlmd/pages/podEntry/podEntryViewModel.dart';
import 'package:gtlmd/pages/podEntry/podRelationModel.dart';
import 'package:gtlmd/pages/podEntry/scanAndDeliver.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:permission_handler/permission_handler.dart';

class PodEntry extends StatefulWidget {
  final DeliveryDetailModel deliveryDetailModel;
  const PodEntry({super.key, required this.deliveryDetailModel});
  @override
  State<PodEntry> createState() => _PodEntryState();
}

class _PodEntryState extends State<PodEntry> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _podDate;
  TimeOfDay? _podTime;
  bool _isLoading = true;
  late LoadingAlertService loadingAlertService;
  PodEntryViewModel viewModel = PodEntryViewModel();
  DeliveryDetailModel modelDetail = DeliveryDetailModel();
  final TextEditingController _podDateController = TextEditingController();
  final TextEditingController _podTimeController = TextEditingController();
  final TextEditingController _grNoController = TextEditingController();
  final TextEditingController _originNameController = TextEditingController();
  final TextEditingController _destinationNameController =
      TextEditingController();
  final TextEditingController _bookingDateController = TextEditingController();
  final TextEditingController _bookingTimeController = TextEditingController();
  final TextEditingController _deliveryDateController = TextEditingController();
  final TextEditingController _deliveryTimeController = TextEditingController();
  final TextEditingController _receivedByController = TextEditingController();

  final TextEditingController _receiverMobileByController =
      TextEditingController();
  // final TextEditingController _deliverByController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();
  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final TextEditingController _deliverPckgsController = TextEditingController();
  final TextEditingController _damagedPckgsController = TextEditingController();
  final TextEditingController _totalWeightController = TextEditingController();
  final TextEditingController _damagedReasonController =
      TextEditingController();
  String? _selectedRelation;
  ReasonModel? _selectedDamageReason;
  String? _signatureFilePath;
  String? _podFilePath;
  String? _damageImg1FilePath;
  String? _damageImg2FilePath;
  // List<String> _damageImages = [];
  List<String> _damageImages = List.empty(growable: true);
  bool isSignRequired = true;
  bool isStampRequired = true;
  PodEntryModel model = PodEntryModel();
  // List<PodRelationsModel> _relations = [];
  // List<ReasonModel> _damageReason = [];
  List<PodRelationsModel> _relations = List.empty(growable: true);
  List<ReasonModel> _damageReason = List.empty(growable: true);
  List<PodStickerModel> _stickerList = List.empty(growable: true);

  late FocusNode receivedByFocus;
  late FocusNode receiverMobileNumFocus;
  late FocusNode dlvPckgsFocus;
  late FocusNode dmgPckgsFocus;
  late FocusNode remarksFocus;

  @override
  void initState() {
    super.initState();
    receivedByFocus = FocusNode();
    receiverMobileNumFocus = FocusNode();
    dlvPckgsFocus = FocusNode();
    dmgPckgsFocus = FocusNode();
    remarksFocus = FocusNode();
    modelDetail = widget.deliveryDetailModel;
    _grNoController.text = modelDetail.grno.toString();

    _podDateController.text = /* formatDate(DateTime.now()); */
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    _podTimeController.text = DateFormat('hh:mm').format(DateTime.now());
    _deliveryDateController.text = /* formatDate(DateTime.now()); */
        DateFormat('dd-MM-yyyy').format(DateTime.now());
    // _deliverPckgsController.text = modelDetail.pcs.toString();
    // _damagedPckgsController.text = "0";
    _deliveryTimeController.text = DateFormat('h:mm a').format(DateTime.now());
    // _deliverByController.text = savedUser.username.toString();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    getLoginPrefs();
  }

  getLoginPrefs() {
    try {
      getLoginData().then((login) => {
            if (login.commandstatus == null || login.commandstatus == -1)
              {debugPrint("Unale to Get LoginData")}
            else
              {
                companyId = login.companyid.toString(),
                getUserData().then((user) => {
                      if (user.commandstatus == null ||
                          user.commandstatus == -1)
                        throw Exception("")
                      else
                        {setObservers(), getGrDetail(), getPodLovs()}
                    })
              }
          });
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  setPodData(PodEntryModel pod) {
    _originNameController.text = isNullOrEmpty(pod.origin.toString()) == true
        ? "Data Not Found"
        : pod.origin.toString();
    _destinationNameController.text =
        isNullOrEmpty(pod.destname.toString()) == true
            ? "Data Not Found"
            : pod.destname.toString();
    _bookingDateController.text =
        isNullOrEmpty(pod.grdt.toString()) == true ? "" : pod.grdt.toString();
    _bookingTimeController.text = isNullOrEmpty(pod.picktime.toString()) == true
        ? ""
        : pod.picktime.toString();
    _arrivalDateController.text = pod.receivedt == null
        ? DateFormat('dd-MM-yyyy').format(DateTime.now())
        : pod.receivedt.toString();
    _arrivalTimeController.text = pod.receivetime == null
        ? "${TimeOfDay.now().hour}:${TimeOfDay.now().minute}"
        : pod.receivetime.toString();
    _destinationNameController.text = pod.destname.toString();
    _receivedByController.text = pod.cnge.toString();

    isSignRequired = pod.sign == "Y" ? true : false;
    isStampRequired = pod.stamp == "Y" ? true : false;
    model.sign = 'N';
    model.stamp = 'N';
    _totalWeightController.text = '${pod.cweight.toString()} Kg';

    _deliverPckgsController.text = pod.deliverpckgs.toString() ?? "0";
    _damagedPckgsController.text = pod.damagepckgs.toString() ?? "0";
  }

  setObservers() {
    viewModel.podEntryLiveData.stream.listen((pod) {
      if (pod.commandstatus == 1) {
        setState(() {
          model = pod;
          setPodData(model);
        });
      } else {
        if (pod.commandmessage != null) {
          failToast(pod.commandmessage!);
        } else {
          failToast("Something went wrong");
        }
        Get.back();
      }
    });

    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      if (isNullOrEmpty(errMsg)) {
        failToast(errMsg.toString());
      } else {
        failToast("Something went wrong");
      }
    });

    viewModel.podRelationLiveData.stream.listen((list) {
      if (list != null) {
        setState(() {
          _relations = list;
          _selectedRelation = 'SELF';
          _relationController.text = 'SELF';
        });
        // _showRelationDialog(context, _relations);
      }
    });
    viewModel.podDamageReasonLiveData.stream.listen((list) {
      if (list != null) {
        setState(() {
          _damageReason = list;
        });
        // _showRelationDialog(context, _relations);
      }
    });
    viewModel.podStickerLiveData.stream.listen((list) {
      setState(() {
        _stickerList = list;
      });
    });

    viewModel.savePodLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        successToast("POD Upload successful");
        showSuccessAlert(
            context,
            // "POD SUCCESSFULLY\n Consignment# -: ${resp.grNo}",
            "POD SUCCESSFULLY\n Consignment# -: ${modelDetail.grno}",
            "",
            backCallBackForAlert);
      } else {
        failToast(resp.commandmessage!.toString() ?? "Something went wrong");
      }
    });

    viewModel.savePodCommonLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        successToast("POD Upload successful");
        showSuccessAlert(
            context,
            // "POD SUCCESSFULLY\n Consignment# -: ${resp.grNo}",
            "POD SUCCESSFULLY\n Consignment# -: ${modelDetail.grno}",
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

  getPodLovs() {
    Map<String, String> params = {
      "prmconnstring": savedLogin.companyid.toString()
    };
    viewModel.getPodLovs(params);
  }

  getGrDetail() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmgrno": modelDetail.grno.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString()
    };

    viewModel.getPodEntry(params);
  }

  validatePod() {
    if (_grNoController.text.isEmpty) {
      failToast("Please fill GR number");
      return;
    } else if (_receivedByController.text.isEmpty) {
      failToast('Please fill the Received by field');
      return;
    } else if (_receiverMobileByController.text.isEmpty) {
      failToast('Please fill the receiver mobile number field');
      return;
    } else if (_receiverMobileByController.text.length != 10) {
      failToast("Please enter a valid mobile number");
      return;
    } else if (isNullOrEmpty(_relationController.text.toString())) {
      failToast('Please fill the relation field');
      return;
    }
/*     else if (_deliverByController.text.isEmpty) {
      failToast('Please fill the delivery boy field');
      return;
    } */
    else if (model!.sign == 'N' ||
        _signatureFilePath == null ||
        _signatureFilePath!.isEmpty) {
      failToast('Please add Signature');
      return;
    } else if (model!.stamp == 'N' ||
        _podFilePath == null ||
        _podFilePath!.isEmpty) {
      failToast('Please add POD Image');
      return;
    } else if (isNullOrEmpty(_deliverPckgsController.text)) {
      failToast("Please enter delivery packages");
      return;
    } else if (isNullOrEmpty(_damagedPckgsController.text)) {
      failToast("Please enter damaged packages");
      return;
    } else if (int.parse(_deliverPckgsController.text) >
        int.parse(model.pckgs.toString())) {
      failToast("Delivery packages cannot be greater than total packages");
      return;
    } else if (int.parse(_damagedPckgsController.text) >
        int.parse(model.pckgs.toString())) {
      failToast("Damaged packages cannot be greater than total packages");
      return;
    } else if (int.parse(_damagedPckgsController.text.toString()) > 0 &&
        _selectedDamageReason == null) {
      failToast("Please select a damange reason");
      return;
    }
    // else if (int.parse(_damagedPckgsController.text.toString()) > 0 &&
    //     _damageImg1FilePath == null) {
    //   failToast("Please select damange Image 1");
    //   return;
    // }
    else if (int.parse(_damagedPckgsController.text.toString()) > 0 &&
        _damageImages.isEmpty) {
      failToast("Please select damage images");
      return;
    } else {
      submitPodForm();
    }
  }

  void submitPodForm() {
    List<String> damageImageList = List.empty(growable: true);
    for (String image in _damageImages) {
      damageImageList.add(convertFilePathToBase64(image));
    }
    Map<String, dynamic> params = {
      "prmconnstring": savedLogin.companyid.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmgrno": _grNoController.text.toString(),
      "prmdlvdt":
          convert2SmallDateTime(_deliveryDateController.text.toString()),
      "prmdlvtime": formatTimeString(_deliveryTimeController.text.toString()),
      "prmname": _receivedByController.text.toString(),
      "prmrelation": _relationController.text.toString(),
      "prmphno": _receiverMobileByController.text.toString(),
      "prmsign": model!.sign.toString(),
      "prmstamp": model!.stamp.toString(),
      "prmremarks": _remarksController.text.toUpperCase(),
      "prmusercode": savedUser.usercode.toString(),
      "prmpodimage": convertFilePathToBase64(_podFilePath),
      "prmsignimage": convertFilePathToBase64(_signatureFilePath),
      "prmsessionid": savedUser.sessionid.toString(),
      // "prmdelayreason": ",",
      "prmdeliveryboy": savedUser.username.toString(),
      "prmmenucode": "GTAPP_PODENTRY",
      "prmpoddt": convert2SmallDateTime(_podDateController.text.toString()),
      "prmdrsno": model.drsno.toString(),
      "prmboyid": isNullOrEmpty(savedUser.executiveid.toString()) ? "0" : '',
      "prmdeliverpckgs": isNullOrEmpty(_deliverPckgsController.text)
          ? "0"
          : _deliverPckgsController.text.toString(),
      "prmdamagepckgs": isNullOrEmpty(_damagedPckgsController.text)
          ? "0"
          : _damagedPckgsController.text.toString(),
      "prmdamagereasonid": _selectedDamageReason == null
          ? '0'
          : _selectedDamageReason!.reasoncode,
      "prmdamageimgstr": damageImageList
      // "prmdamageimg1": isNullOrEmpty(_damageImg1FilePath)
      //     ? ''
      //     : convertFilePathToBase64(_damageImg1FilePath),
      // "prmdamageimg2": isNullOrEmpty(_damageImg2FilePath)
      //     ? ''
      //     : convertFilePathToBase64(_damageImg2FilePath),
      // "prmsign": isSignRequired == true ? "Y" : "N",
      // "prmstamp": isStampRequired == true ? "Y" : "N",
      // "prmpckgs": this.pckgs,
      // "prmpckgstr": enteredQtyStr,
      // "prmdataidstr": dataIdStr
    };

    // loadingAlertService.showLoading();

    viewModel.savePodEntry(params);
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
              suffixIcon: Icon(
                Icons.calendar_month,
              ),
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
      controller.text = DateFormat('dd-MM-yyyy').format(pickedDate!);
    });
  }

  String formatDate(DateTime? date) {
    String result = "";
    result = date != null
        ? "${date.toLocal()}".split(' ')[0].toString()
        : _podDateController.text;
    return result;
  }

  Future<void> _pickTime(TextEditingController controller) async {
    final TimeOfDay? selectedTime = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );

    setState(() {
      controller.text = selectedTime != null
          ? "${selectedTime.hour}:${selectedTime.minute}"
          : controller.text;
    });
  }

/*   Future<String?> _showRelationDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return _relationSelectionDialog();
      },
    );
  }
 */ /* 
  _relationSelectionDialog() {
    return AlertDialog(
      title: Text('Relation'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: _relations.map((relation) {
            return RadioListTile<String>(
              title: Text(relation),
              value: relation,
              groupValue: _selectedRelation,
              onChanged: (String? value) {
                setState(() {
                  _selectedRelation = value;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop(_selectedRelation);
          },
        ),
      ],
    );
  }
 */

  Future<String?> _getStoragePermission() async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      return _pickFile();
    }
    final photosPermission = await Permission.photos.request();
    if (photosPermission.isGranted) {
      return _pickFile();
    }
  }

  Future<String?> _pickFile() async {
    FilePickerResult? result;
    try {
      result = await FilePicker.platform.pickFiles();
    } catch (e) {
      print('Error picking file: $e');
    }
    return result == null ? "" : result.files[0].path;
  }

  void _showRelationDialog(
      BuildContext context, List<PodRelationsModel> _relations) async {
    String? _selectionResult;

    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: const Text(
                'Relation',
                style: TextStyle(
                  color: Color(0xFF2934AB), // Your primary color
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: _relations.map((relation) {
                    return RadioListTile<String>(
                      activeColor: Color(0xFF2934AB),
                      title: Text(relation.relations.toString()),
                      value: relation.relations.toString(),
                      groupValue: _selectedRelation,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRelation = value;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xFF2934AB), // Apply primary color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Color(0xFF2934AB), // Apply primary color
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    Get.back(result: _selectedRelation);
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      print('Selected Relation: $result');
      setState(() {
        _relationController.text = result.toString();
      });
    }
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
            Icon(icon,
                size: SizeConfig.mediumIconSize,
                color: const Color(0xFF64748B)),
            SizedBox(width: SizeConfig.smallHorizontalSpacing),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: SizeConfig.smallTextSize,
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
        SizedBox(height: SizeConfig.smallVerticalSpacing),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(
    String hint,
  ) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: CommonColors.grey400!, fontSize: SizeConfig.mediumTextSize),
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide:
            BorderSide(color: CommonColors.primaryColorShade!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1.5),
      ),
    );
  }

  clearDamagedValues() {
    _selectedDamageReason = null;
    _damageImg1FilePath = null;
    _damageImg2FilePath = null;
  }

  @override
  void dispose() {
    _grNoController.dispose();
    _podDateController.dispose();
    _podTimeController.dispose();
    _originNameController.dispose();
    _destinationNameController.dispose();
    _bookingDateController.dispose();
    _bookingTimeController.dispose();
    _deliveryDateController.dispose();
    _deliveryTimeController.dispose();
    _receivedByController.dispose();
    _receiverMobileByController.dispose();
    _relationController.dispose();
    _remarksController.dispose();
    _arrivalDateController.dispose();
    _arrivalTimeController.dispose();
    _deliverPckgsController.dispose();
    _damagedPckgsController.dispose();
    _totalWeightController.dispose();
    _damagedReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'POD Entry',
          style: TextStyle(
              color: CommonColors.White, fontSize: SizeConfig.largeTextSize),
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
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.mediumRadius)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: CommonColors.primaryColorShade!,
                              size: SizeConfig.extraLargeIconSize,
                            ),
                            SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                            Text(
                              'Delivery Information',
                              style: TextStyle(
                                fontSize: SizeConfig.mediumTextSize,
                                fontWeight: FontWeight.w600,
                                color: CommonColors.primaryColorShade!,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: _stickerList.isNotEmpty,
                          child: GestureDetector(
                            onTap: () {
                              Get.to(ScanAndLoad(
                                stickersList: _stickerList,
                                deliveryDetailModel: modelDetail,
                              ));
                            },
                            child: const Icon(
                              Symbols.qr_code_scanner_rounded,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
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
                              enabled: false,
                              controller: _grNoController,
                              style: TextStyle(
                                  color: CommonColors.appBarColor,
                                  fontSize: SizeConfig.mediumTextSize),
                              decoration: _inputDecoration(
                                "Consignment Number",
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter consignment number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildFormField(
                            label: "Total Weight",
                            isRequired: false,
                            icon: Icons.inventory_2_outlined,
                            child: TextFormField(
                              enabled: false,
                              style: TextStyle(
                                  color: CommonColors.appBarColor,
                                  fontSize: SizeConfig.mediumTextSize),
                              controller: _totalWeightController,
                              decoration: _inputDecoration("Total Weight"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter total weight';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: SizeConfig.mediumVerticalSpacing),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _buildFormField(
                                    label: "Delivery Date",
                                    isRequired: true,
                                    icon: Icons.calendar_today,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal:
                                              SizeConfig.horizontalPadding,
                                          vertical: SizeConfig.verticalPadding),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: CommonColors.grey300!),
                                        borderRadius: BorderRadius.circular(
                                            SizeConfig.mediumRadius),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _deliveryDateController.text
                                                .toString(),
                                            style: TextStyle(
                                                fontSize:
                                                    SizeConfig.mediumTextSize),
                                          ),
                                          Icon(Icons.calendar_month,
                                              size: SizeConfig.mediumIconSize,
                                              color: CommonColors.grey),
                                        ],
                                      ),
                                    )),
                              ),
                              SizedBox(
                                  width: SizeConfig.mediumHorizontalSpacing),
                              Expanded(
                                child: _buildFormField(
                                  label: 'Delivery Time',
                                  isRequired: true,
                                  icon: Icons.access_time,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.horizontalPadding,
                                        vertical: SizeConfig.verticalPadding),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: CommonColors.grey300!),
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.mediumRadius),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          _deliveryTimeController.text
                                              .toString(),
                                          style: TextStyle(
                                              fontSize:
                                                  SizeConfig.mediumTextSize),
                                        ),
                                        Icon(Icons.access_time,
                                            size: SizeConfig.mediumIconSize,
                                            color: CommonColors.grey),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SizeConfig.mediumVerticalSpacing),
                          _buildFormField(
                            label: 'Received By',
                            isRequired: true,
                            icon: Icons.person_outline,
                            child: TextFormField(
                              controller: _receivedByController,
                              style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize),
                              focusNode: receivedByFocus,
                              onTapOutside: (event) {
                                receivedByFocus.unfocus();
                              },
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
                          SizedBox(height: SizeConfig.mediumVerticalSpacing),
                          _buildFormField(
                            label: 'Receiver Mobile Number',
                            isRequired: true,
                            icon: Icons.phone_android_outlined,
                            child: TextFormField(
                              maxLength: 10,
                              style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize),
                              buildCounter: (context,
                                  {required currentLength,
                                  required isFocused,
                                  required maxLength}) {
                                return Text(
                                  '$currentLength / $maxLength',
                                  style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize,
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
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
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
                          SizedBox(height: SizeConfig.mediumVerticalSpacing),
                          // Relation
                          _buildFormField(
                            label: 'Relation',
                            isRequired: true,
                            icon: Icons.people_outline,
                            child: DropdownButtonFormField<String>(
                              value: _selectedRelation,
                              style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
                                  color: Colors.black),
                              decoration: _inputDecoration('Select relation'),
                              items:
                                  _relations.map((PodRelationsModel relation) {
                                return DropdownMenuItem<String>(
                                  value: relation.relations,
                                  child: Text(relation.relations.toString()),
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
                          SizedBox(height: SizeConfig.mediumVerticalSpacing),
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
                            label: "Deliver Pckgs",
                            isRequired: true,
                            icon: Icons.delivery_dining_outlined,
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize),
                              focusNode: dlvPckgsFocus,
                              onTapOutside: (event) {
                                dlvPckgsFocus.unfocus();
                              },
                              controller: _deliverPckgsController,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              decoration: _inputDecoration('Delivery Packages'),
                              validator: (value) {
                                if (isNullOrEmpty(value)) {
                                  return 'Please enter delivery packages';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.mediumVerticalSpacing,
                          ),
                          // Damage Packages
                          _buildFormField(
                            label: "Damaged Pckgs",
                            isRequired: true,
                            icon: Icons.delivery_dining_outlined,
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
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
                              // keyboardType: TextInputType.phone,
                              decoration: _inputDecoration('Damaged Packages'),
                              // validator: (value) {
                              //   if (isNullOrEmpty(value)) {
                              //     return 'Please enter damanged packages';
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          SizedBox(
                            height: SizeConfig.mediumVerticalSpacing,
                          ),
                          Visibility(
                              visible: _damagedPckgsController.text
                                      .toString()
                                      .isNotEmpty &&
                                  int.parse(_damagedPckgsController.text
                                          .toString()) >
                                      0,
                              child: SizedBox(
                                  height: SizeConfig.mediumVerticalSpacing)),
                          // Damage Reason
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
                                style: TextStyle(
                                    fontSize: SizeConfig.mediumTextSize,
                                    color: Colors.black),
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

                          SizedBox(
                            height: SizeConfig.mediumVerticalSpacing,
                          ),
                          Visibility(
                            visible: _damagedPckgsController.text
                                    .toString()
                                    .isNotEmpty &&
                                int.parse(_damagedPckgsController.text
                                        .toString()) >
                                    0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      SizeConfig.mediumHorizontalSpacing),
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: SizeConfig
                                                .smallHorizontalSpacing,
                                            vertical: SizeConfig
                                                .smallVerticalSpacing),
                                        decoration: BoxDecoration(
                                            color:
                                                CommonColors.primaryColorShade,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    SizeConfig.largeRadius))),
                                        child: Text("Damage Images",
                                            style: TextStyle(
                                                color: CommonColors.White,
                                                fontWeight: FontWeight.bold)),
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
                                                'Damage Img 2 File data: ${file!.path}');
                                            setState(() {
                                              _damageImg2FilePath = file!.path;
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
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                  .smallHorizontalSpacing,
                                              vertical: SizeConfig
                                                  .smallVerticalSpacing),
                                          child: Text.rich(TextSpan(
                                              text: 'Image 1',
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
                                            height:
                                                SizeConfig.largeVerticalSpacing,
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
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: SizeConfig
                                                  .smallHorizontalPadding!,
                                              vertical: SizeConfig
                                                  .smallVerticalPadding!),
                                          child: const Text.rich(
                                            TextSpan(
                                              text: 'Image 2',
                                            ),
                                          ),
                                        ),
                                        Container(
                                            height: SizeConfig
                                                .largeHorizontalSpacing,
                                            width: MediaQuery.sizeOf(context)
                                                    .width /
                                                2,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: SizeConfig
                                                    .smallHorizontalPadding),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: SizeConfig
                                                    .smallVerticalPadding),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(
                                                      SizeConfig.smallRadius)),
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
                              ],
                            ),
                          ),
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
                              style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize),
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
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      spacing: 8,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              model.sign = 'Y';
                              // showImagePickerDialog(
                              //   context,
                              //   (file) {
                              //     if (file != null) {
                              //       debugPrint('Signature file data: ${file!.path}');
                              //       setState(() {
                              //         _signatureFilePath = file.path;
                              //       });
                              //     } else {
                              //       model!.sign = 'N';
                              //       failToast('File not selected');
                              //     }
                              //   },
                              // );

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
                                  model.sign = 'N';
                                  failToast(
                                      'Something went wrong. Please try again');
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.horizontalPadding,
                                  vertical: SizeConfig.verticalPadding),
                              decoration: BoxDecoration(
                                  color: CommonColors.primaryColorShade,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.largeRadius))),
                              child: Text("Upload Signature",
                                  style: TextStyle(
                                      fontSize: SizeConfig.smallTextSize,
                                      color: CommonColors.White,
                                      fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              model.stamp = 'Y';
                              showImagePickerDialog(context, (file) async {
                                if (file != null) {
                                  debugPrint('POD File data: ${file!.path}');
                                  setState(() {
                                    _podFilePath = file!.path;
                                  });
                                } else {
                                  model!.stamp = 'N';
                                  failToast("File not selected");
                                }
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.horizontalPadding,
                                  vertical: SizeConfig.verticalPadding),
                              decoration: BoxDecoration(
                                  color: CommonColors.primaryColorShade,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.largeRadius))),
                              child: Text("Upload POD",
                                  style: TextStyle(
                                      fontSize: SizeConfig.smallTextSize,
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
                              model.sign = 'Y';
                              showSignatureBottomSheet(context,
                                  (path, base64Path) {
                                if (path != null && path.isNotEmpty) {
                                  debugPrint('Signature file data: $path');
                                  setState(() {
                                    _signatureFilePath = path;
                                  });
                                } else {
                                  model.sign = 'N';
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.horizontalPadding,
                                      vertical:
                                          SizeConfig.extraSmallVerticalPadding),
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
                                    height: isSmallDevice ? 120 : 150,
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig
                                            .extraSmallHorizontalPadding,
                                        vertical: SizeConfig
                                            .extraSmallVerticalPadding),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: SizeConfig
                                            .extraSmallHorizontalSpacing,
                                        vertical: SizeConfig
                                            .extraSmallVerticalSpacing),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              SizeConfig.mediumRadius)),
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
                              model.stamp = 'Y';
                              showImagePickerDialog(context, (file) async {
                                if (file != null) {
                                  debugPrint('POD File data: ${file!.path}');
                                  setState(() {
                                    _podFilePath = file!.path;
                                  });
                                } else {
                                  model!.stamp = 'N';
                                  failToast("File not selected");
                                }
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.horizontalPadding,
                                      vertical:
                                          SizeConfig.extraSmallVerticalPadding),
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
                                    height: isSmallDevice ? 120 : 150,
                                    width: MediaQuery.sizeOf(context).width / 2,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: SizeConfig
                                            .extraSmallHorizontalPadding,
                                        vertical: SizeConfig
                                            .extraSmallVerticalPadding),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: SizeConfig
                                            .extraSmallHorizontalSpacing,
                                        vertical: SizeConfig
                                            .extraSmallVerticalSpacing),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              SizeConfig.mediumRadius)),
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
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: CommonColors.whiteShade,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(SizeConfig.largeRadius),
                        bottomRight: Radius.circular(SizeConfig.largeRadius),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        validatePod();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CommonColors.primaryColorShade,
                        foregroundColor: CommonColors.White,
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.horizontalPadding,
                            vertical: SizeConfig.verticalPadding),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.largeRadius),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Submit POD',
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
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
