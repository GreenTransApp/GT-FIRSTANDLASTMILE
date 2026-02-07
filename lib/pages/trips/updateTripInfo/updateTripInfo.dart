import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripViewModel.dart';
import 'package:gtlmd/service/fireBaseService/firebaseLocationUpload.dart';
import 'package:gtlmd/service/locationService/appLocationService.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:intl/intl.dart';

class UpdateTripInfo extends StatefulWidget {
  TripModel model;
  // final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  final TripStatus status;
  Future<void> Function()? refresh;
  UpdateTripInfo({
    super.key,
    required this.model,
    // this.onUpdate,
    required this.status,
    this.refresh,
  });

  @override
  _UpdateTripInfoState createState() => _UpdateTripInfoState();
}

class _UpdateTripInfoState extends State<UpdateTripInfo> {
  final TextEditingController _dispatchDateController = TextEditingController();
  final TextEditingController _dispatchTimeController = TextEditingController();
  final TextEditingController _startReadingController = TextEditingController();
  final TextEditingController _closeDateController = TextEditingController();
  final TextEditingController _closeTimeController = TextEditingController();
  final TextEditingController _closeReadingController = TextEditingController();
  // String _selectedDate = "";
  // String _selectedTime = "";
  bool showCamera = false;
  String? _startReadingImagePath;
  String? _closeReadingImagePath;
  String totalTime = "";
  String totaldistance = "";
  String currentAddress = '';

  UpdateTripInfoViewModel viewModel = UpdateTripInfoViewModel();
  late LoadingAlertService loadingAlertService;
  @override
  void initState() {
    super.initState();
    // _dateController.text = widget.model.manifestdate;
    if (widget.status == TripStatus.open) {
      _dispatchDateController.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
      _dispatchTimeController.text = DateFormat('HH:mm').format(DateTime.now());
      _startReadingController.text = "0";
    } else {
      // _dispatchTimeController.text = widget.model!.tripdispatchtime!;
      _dispatchTimeController.text = widget.model.tripdispatchtime!;
      _dispatchDateController.text = widget.model.tripdispatchdate!;

      _closeDateController.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
      _closeTimeController.text = DateFormat('HH:mm a').format(DateTime.now());

      _startReadingController.text =
          widget.model!.startreadingkm?.toString() ?? "0";
      _startReadingImagePath = widget.model!.startreadingimg;
      calculateTotalTime(widget.model!.tripdispatchtime!,
          _closeTimeController.text.toString());
    }
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
  }

  void setObservers() {
    viewModel.isErrorLiveData.stream.listen((error) {
      failToast(error);
    });

    viewModel.viewDialogLiveData.stream.listen((showDialog) {
      if (showDialog) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.updateTripLiveData.stream.listen((model) async {
      if (model.commandstatus == 1) {
        successToast(model.commandmessage!);

        if (model.tripstatus == "C") {
          await FirebaseLocationUpload().deleteLocation(executiveid!.toString(),
              savedLogin.companyid.toString(), widget.model.tripid.toString());
        }

        if (widget.refresh != null) {
          widget.refresh!();
        }
        // Get.back(result: true);
        Get.back();
      } else {
        failToast(model.commandmessage!);
      }
    });
    viewModel.updateStartTripLiveData.stream.listen((model) async {
      if (model.commandstatus == 1) {
        successToast(model.commandmessage!);
        if (widget.refresh != null) {
          widget.refresh!();
        }
        Get.back();
      } else {
        failToast(model.commandmessage!);
      }
    });
    viewModel.updateCloseTripLiveData.stream.listen((model) async {
      if (model.commandstatus == 1) {
        try {
          successToast(model.commandmessage!);
          await FirebaseLocationUpload().deleteLocation(executiveid!.toString(),
              savedLogin.companyid.toString(), widget.model.tripid.toString());
          if (widget.refresh != null) {
            widget.refresh!();
          }
          Get.back();
        } catch (err) {
          debugPrint("Toast Error: ${err.toString()}");
        }
      } else {
        failToast(model.commandmessage!);
      }
    });
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                primary: CommonColors.colorPrimary!,
              )),
              child: child!);
        });
    if (pickedDate != null) {
      setState(() {
        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        // print(formattedDate);
        setState(() {
          controller.text = formattedDate;
        });
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController controller) async {
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
        controller.text =
            '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      });
    }
  }

  void odoMeterChange(String value) {
    setState(() {
      if (value != "0" && value.isNotEmpty) {
        showCamera = true;
      } else {
        showCamera = false;
        _startReadingImagePath = null;
      }
    });
  }

  void changeCloseReading(String value) {
    setState(() {
      if (value != "0" && value.isNotEmpty) {
        showCamera = true;
        calculateTotalDistance();
        _closeReadingImagePath = null;
      } else {
        showCamera = false;
      }
    });
  }

  void changeStartReading(String value) {
    setState(() {
      if (value.isNotEmpty) {
        _startReadingImagePath = null;
      }
    });
  }

  validateBeforeUpdate() {
    if (widget.status == TripStatus.close) {
      if (isNullOrEmpty(_closeDateController.text)) {
        failToast("Please Select Close Data.");
        return;
      } else if (isNullOrEmpty(_closeTimeController.text)) {
        failToast("Please Select Close Time");
        return;
      } else if (isNullOrEmpty(_closeReadingController.text)) {
        failToast("Please Enter Close Reading Value");
        return;
      } else if (int.parse(_closeReadingController.text)! <= 0) {
        failToast("Close Reading Value Can't be Zero");
        return;
      } else if (int.parse(_closeReadingController.text) <=
          int.parse(widget.model!.startreadingkm.toString())) {
        failToast("Close Reading Value Can't be less than Start Reading Value");
        return;
      } else if (isNullOrEmpty(_closeReadingImagePath)) {
        failToast("Close Reading meter image is required");
        return;
      }

      widget.model.endtripdate = _closeDateController.text;
      widget.model.endtriptime = _closeTimeController.text;
      widget.model.endreadingkm = int.tryParse(_closeReadingController.text);
      widget.model.endreadingimg = _closeReadingImagePath;
      // updateCloseTrip();
    } else {
      if (isNullOrEmpty(_dispatchDateController.text)) {
        failToast("Please Select Dispatch Data.");
        return;
      } else if (isNullOrEmpty(_dispatchTimeController.text)) {
        failToast("Please Select Dispatch Time");
        return;
      } else if (isNullOrEmpty(_startReadingController.text)) {
        failToast("Please Enter Odometer Value");
        return;
      } else if (int.tryParse(_startReadingController.text)! <= 0) {
        failToast("Odometer Value Can't be Zero");
        return;
      } else if (isNullOrEmpty(_startReadingImagePath)) {
        failToast("Reading meter image path is required");
        return;
      }
      widget.model.tripdispatchdate = _dispatchDateController.text;
      widget.model.tripdispatchdatetime = _dispatchTimeController.text;
      widget.model.startreadingkm = int.tryParse(_startReadingController.text);
      widget.model.startreadingimg = _startReadingImagePath;
      // updateStartTrip();
    }
    fetchLocationAndSubmit();
  }

  Future<void> fetchLocationAndSubmit() async {
    loadingAlertService.showLoading();
    String? address = await AppLocationService().getCurrentAddress();
    loadingAlertService.hideLoading();

    if (address != null) {
      currentAddress = address;
      debugPrint("Current Address: $currentAddress");
      if (widget.status == TripStatus.close) {
        updateCloseTrip();
      } else {
        updateStartTrip();
      }
    } else {
      failToast("Could not get your location.");
    }
  }

  void updateStartTrip() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmtripid": widget.model.tripid.toString(),
      "prmdispatchdt":
          convert2SmallDateTime(widget.model.tripdispatchdate.toString()),
      "prmdispatchtime": widget.model.tripdispatchdatetime.toString(),
      "prmstartreading": widget.model.startreadingkm.toString(),
      "prmstartreadimgpath": widget.status == TripStatus.open
          ? convertFilePathToBase64(widget.model.startreadingimg)
          : isNullOrEmpty(widget.model.startreadingimg)
              ? ""
              : widget.model.startreadingimg!,
      "prmsessionid": savedUser.sessionid.toString(),
      'prmentrylocation': currentAddress,
    };

    viewModel.updateStartTrip(params);
  }

  void updateCloseTrip() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmtripid": widget.model.tripid.toString(),
      "prmclosetripdt": convert2SmallDateTime(widget.model.endtripdate!),
      "prmclosetriptime":
          formatTimeString(_closeTimeController.text.toString()),
      "prmclosetripreading": widget.model.endreadingkm.toString(),
      "prmendreadimgpath": widget.status == TripStatus.open
          ? ""
          : convertFilePathToBase64(widget.model.endreadingimg),
      "prmsessionid": savedUser.sessionid.toString(),
      'prmentrylocation': currentAddress,
    };

    viewModel.updateCloseTrip(params);
  }

  // void updateTripInfo() {
  //   Map<String, String> params = {
  //     "prmcompanyid": savedUser.companyid.toString(),
  //     "prmemployeeid": savedUser.employeeid.toString(),
  //     "prmdispatchdt":convert2SmallDateTime(widget.model.tripdispatchdate.toString()),
  //     "prmdispatchtime": widget.model.tripdispatchdatetime.toString(),
  //     "prmusercode": savedUser.usercode.toString(),
  //     "prmsessionid": savedUser.sessionid.toString(),
  //     "prmstartreading": widget.model.startreadingkm.toString(),
  //     "prmstartreadimgpath": widget.status == TripStatus.open
  //         ? convertFilePathToBase64(widget.model.startreadingimgpath)
  //         : isNullOrEmpty(widget.model.startreadingimgpath)
  //             ? ""
  //             : widget.model.startreadingimgpath!,
  //     "prmendreadimgpath": widget.status == TripStatus.open
  //         ? ""
  //         : convertFilePathToBase64(widget.model.endreadingimg),
  //     "prmclosetripdt": widget.status == TripStatus.open
  //         ? ""
  //         : convert2SmallDateTime(widget.model.endtripdate!),
  //     "prmclosetriptime":
  //         widget.status == TripStatus.open ? "" : _closeTimeController.text,
  //     "prmclosetripreading": widget.status == TripStatus.open
  //         ? ""
  //         : widget.model.endreadingkm.toString(),
  //     "prmdrsstatus": widget.status == TripStatus.open ? 'O' : 'C',
  //     "prmtripid": widget.model.tripid.toString()
  //   };

  //   viewModel.updateTripInfo(params);
  // }

  Widget closeTrip() {
    return Column(
      children: [
        Card(
          elevation: 2,
          color: CommonColors.grey300,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.horizontalPadding,
                                vertical: SizeConfig.verticalPadding),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.largeRadius)),
                                border: Border.all(
                                    color: CommonColors.grey400!, width: 1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: SizeConfig.smallIconSize,
                                      color: CommonColors.appBarColor,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.smallHorizontalSpacing,
                                    ),
                                    Text(
                                      "DISPATCH DATE",
                                      style: TextStyle(
                                          color: CommonColors.appBarColor,
                                          fontSize: SizeConfig.smallTextSize,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.mediumHorizontalSpacing,
                                    ),
                                    Text(
                                      _dispatchDateController.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: CommonColors.appBarColor,
                                          fontSize: SizeConfig.smallTextSize),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.horizontalPadding,
                                vertical: SizeConfig.verticalPadding),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.largeRadius)),
                                border: Border.all(
                                    color: CommonColors.grey400!, width: 1)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: SizeConfig.smallIconSize,
                                      color: CommonColors.appBarColor,
                                    ),
                                    SizedBox(
                                      width: SizeConfig.smallHorizontalSpacing,
                                    ),
                                    Text(
                                      "DISPATCH TIME",
                                      style: TextStyle(
                                          color: CommonColors.appBarColor,
                                          fontSize: SizeConfig.smallTextSize,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: SizeConfig.mediumHorizontalSpacing,
                                    ),
                                    Text(
                                      _dispatchTimeController.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: CommonColors.appBarColor,
                                          fontSize: SizeConfig.smallTextSize),
                                    )
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.mediumVerticalSpacing,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "START ODOMETER READING",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SizeConfig.mediumTextSize),
                    ),
                    TextField(
                      enabled: false,
                      controller: _startReadingController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: CommonColors.appBarColor,
                          fontSize: SizeConfig.mediumTextSize),
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: CommonColors.appBarColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1, color: CommonColors.appBarColor),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.smallVerticalSpacing),
                Container(
                  height: 150,
                  width: MediaQuery.sizeOf(context).width,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding),
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.largeRadius)),
                    border:
                        Border.all(width: 1, color: CommonColors.colorPrimary!),
                  ),
                  alignment: Alignment.center,
                  child: widget.model!.startreadingimg != null
                      ? Image.network(
                          widget.model!.startreadingimg!,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 30),
                            );
                          },
                        )
                      : Column(
                          children: [
                            Image.asset(
                              'assets/images/error.png',
                              height: 70,
                              width: 70,
                            ),
                            const Text('Error loading image'),
                          ],
                        ),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        const Divider(
          height: 1,
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalPadding,
                    vertical: SizeConfig.verticalPadding),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(SizeConfig.largeRadius)),
                  border: Border.all(color: CommonColors.grey400!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: SizeConfig.smallIconSize,
                          color: Colors.black54,
                        ),
                        SizedBox(
                          width: SizeConfig.smallHorizontalSpacing,
                        ),
                        Text(
                          "CLOSE DATE",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: SizeConfig.smallTextSize,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 24,
                        ),
                        Text(
                          _closeDateController.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: CommonColors.appBarColor,
                              fontSize: SizeConfig.smallTextSize),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: SizeConfig.mediumHorizontalSpacing),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalPadding,
                    vertical: SizeConfig.verticalPadding),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                      Radius.circular(SizeConfig.largeIconSize)),
                  border: Border.all(color: CommonColors.grey400!, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: SizeConfig.smallIconSize,
                          color: CommonColors.appBarColor,
                        ),
                        SizedBox(
                          width: SizeConfig.smallHorizontalSpacing,
                        ),
                        Text(
                          " CLOSE TIME",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: SizeConfig.smallTextSize,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: SizeConfig.mediumHorizontalSpacing,
                        ),
                        Text(
                          _closeTimeController.text,
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: CommonColors.appBarColor,
                              fontSize: SizeConfig.smallTextSize),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.speed_rounded,
                  color: CommonColors.appBarColor,
                  size: SizeConfig.largeIconSize,
                ),
                SizedBox(
                  width: SizeConfig.smallHorizontalSpacing,
                ),
                Text(
                  "CLOSE ODOMETER READING",
                  style: TextStyle(
                      color: CommonColors.appBarColor,
                      fontSize: SizeConfig.mediumTextSize),
                )
              ],
            ),
            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  child: TextField(
                    controller: _closeReadingController,
                    onChanged: changeCloseReading,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    cursorColor: CommonColors.colorPrimary,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SizeConfig.smallTextSize),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.largeRadius)),
                        borderSide:
                            BorderSide(width: 1, color: CommonColors.grey400!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.largeRadius)),
                        borderSide:
                            BorderSide(width: 1, color: CommonColors.grey400!),
                      ),
                    ),
                  ),
                )),
                const Text(
                  "km",
                  style: TextStyle(color: CommonColors.appBarColor),
                )
              ],
            ),
          ],
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.verticalPadding,
              horizontal: SizeConfig.horizontalPadding),
          decoration: BoxDecoration(
              border: Border.all(color: CommonColors.grey400!, width: 1),
              borderRadius:
                  BorderRadius.all(Radius.circular(SizeConfig.largeRadius))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.camera_alt_outlined,
                    color: CommonColors.appBarColor,
                    size: SizeConfig.largeIconSize,
                  ),
                  SizedBox(
                    width: SizeConfig.mediumHorizontalSpacing,
                  ),
                  const Text(
                    "CLOSE READING IMAGE",
                    style: TextStyle(color: CommonColors.appBarColor),
                  ),
                  Expanded(
                      child: Align(
                    alignment: AlignmentGeometry.centerRight,
                    child: InkWell(
                      child: Icon(
                        Icons.file_upload_outlined,
                        color: CommonColors.appBarColor,
                        size: SizeConfig.largeIconSize,
                        // size: 24,
                      ),
                      onTap: () {
                        showImagePickerDialog(context, (file) async {
                          if (file != null) {
                            debugPrint(' data: ${file.path}');
                            setState(() {
                              _closeReadingImagePath = file.path;
                            });
                          } else {
                            failToast("File not selected");
                          }
                        });
                      },
                    ),
                  ))
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.verticalPadding,
                    horizontal: SizeConfig.horizontalPadding),
                child: SizedBox(
                  height: 200,
                  width: MediaQuery.sizeOf(context).width,
                  child: Container(
                    decoration: BoxDecoration(
                        color: CommonColors.grey300,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.largeRadius))),
                    child: isNullOrEmpty(_closeReadingImagePath)
                        ? InkWell(
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.file_upload_outlined,
                                  color: Colors.black54,
                                ),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(color: Colors.black87),
                                ),
                                Text(
                                  "Click the upload button above",
                                  style: TextStyle(color: Colors.black87),
                                )
                              ],
                            ),
                            onTap: () {
                              showImagePickerDialog(context, (file) async {
                                if (file != null) {
                                  debugPrint(' data: ${file.path}');
                                  setState(() {
                                    _closeReadingImagePath = file.path;
                                  });
                                } else {
                                  failToast("File not selected");
                                }
                              });
                            },
                          )
                        : Image.file(
                            File(_closeReadingImagePath!),
                            fit: BoxFit.contain,
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
        // Visibility(
        //   visible: isNullOrEmpty(_closeReadingImagePath) == true ? false : true,
        //   child: Container(
        //       height: 150,
        //       width: MediaQuery.sizeOf(context).width,
        //       padding: const EdgeInsets.symmetric(horizontal: 10),
        //       margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        //       decoration: BoxDecoration(
        //         borderRadius: const BorderRadius.all(Radius.circular(5)),
        //         border: Border.all(width: 1, color: CommonColors.colorPrimary!),
        //       ),
        //       child: _closeReadingImagePath == null
        //           ? Center(
        //               child: Text(
        //                 "",
        //                 style: TextStyle(color: CommonColors.colorPrimary),
        //               ),
        //             )
        //           : Image.file(
        //               File(_closeReadingImagePath!),
        //               fit: BoxFit.fill,
        //             )),
        // ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        Row(
          children: [
            const Text("Total Time:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: SizeConfig.smallHorizontalSpacing),
            Text(totalTime.toString()),
          ],
        ),
        Row(
          children: [
            const Text("Total KM:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: SizeConfig.smallHorizontalSpacing),
            Text(totaldistance),
          ],
        )
      ],
    );
  }

  calculateTotalTime(String fromDate, String toDate) {
    // Implement your logic to calculate total time
    // List<String> startDateParts = widget.model.dispatchdt.split("-");
    // List<String> startTimeParts = widget.model.dispatchtime.split(":");
    // List<String> endDateParts = _closeDateController.text.toString().split("-");
    // List<String> endTimeParts = _closeTimeController.text.toString().split(":");
    // DateTime startDate = DateTime(
    //   int.parse(startDateParts[2]),
    //   int.parse(startDateParts[1]),
    //   int.parse(startDateParts[0]),
    //   int.parse(startTimeParts[0]),
    //   int.parse(startTimeParts[1]),
    // );
    // DateTime endDate = DateTime(
    //   int.parse(endDateParts[2]),
    //   int.parse(endDateParts[1]),
    //   int.parse(endDateParts[0]),
    //   int.parse(endTimeParts[0]),
    //   int.parse(endTimeParts[1]),
    // );
    // Duration duration = endDate.difference(startDate);
    // return duration.inHours;

    DateFormat format = DateFormat("HH:mm");

    DateTime from = format.parse(fromDate);
    DateTime to = format.parse(toDate);

    if (to.isBefore(from)) {
      to = to.add(const Duration(days: 1));
    }

    Duration diff = to.difference(from);

    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;

    print("Difference: $hours hours $minutes minutes");

    totalTime = " $hours Hour $minutes Minutes";
  }

  calculateTotalDistance() {
    if (_closeReadingController.text.isNotEmpty) {
      int? diff = (int.tryParse(_closeReadingController.text)! -
          widget.model!.startreadingkm!) as int?;
      totaldistance = diff! > 0 ? diff.toString() : "0";
    } else {
      totaldistance = "0";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CommonColors.colorPrimary,
        // title: Text("DRS NUMBER: ${widget.model.ma}",
        //     style: TextStyle(color: CommonColors.White)),
        title: Text("Trip ID: ${widget.model.tripid.toString()}",
            style: TextStyle(color: CommonColors.White)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CommonColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.only(
              left: MediaQuery.sizeOf(context).width * 0.02,
              right: MediaQuery.sizeOf(context).width * 0.02,
              top: MediaQuery.sizeOf(context).height * 0.01,
              bottom: MediaQuery.of(context).viewInsets.bottom +
                  16, // Keyboard padding
            ),
            child: widget.status == TripStatus.close
                ? closeTrip()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.horizontalPadding,
                                      vertical: SizeConfig.verticalPadding),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            SizeConfig.largeRadius)),
                                    border: Border.all(
                                        color: CommonColors.grey400!, width: 1),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            size: SizeConfig.largeIconSize,
                                            color: CommonColors.appBarColor,
                                          ),
                                          SizedBox(
                                            width: SizeConfig
                                                .smallHorizontalSpacing,
                                          ),
                                          Text(
                                            "DISPATCH DATE",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    SizeConfig.smallTextSize,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: SizeConfig
                                                .mediumHorizontalSpacing,
                                          ),
                                          Text(
                                            _dispatchDateController.text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: CommonColors.appBarColor,
                                                fontSize:
                                                    SizeConfig.smallTextSize),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: SizeConfig.horizontalPadding,
                                      vertical: SizeConfig.verticalPadding),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              SizeConfig.largeRadius)),
                                      border: Border.all(
                                          color: CommonColors.grey400!,
                                          width: 1)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.calendar_today_rounded,
                                            size: SizeConfig.largeIconSize,
                                            color: CommonColors.appBarColor,
                                          ),
                                          SizedBox(
                                            width: SizeConfig
                                                .smallHorizontalSpacing,
                                          ),
                                          Text(
                                            "DISPATCH TIME",
                                            style: TextStyle(
                                              color: CommonColors.appBarColor,
                                              fontSize:
                                                  SizeConfig.smallTextSize,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: SizeConfig
                                                .mediumHorizontalSpacing,
                                          ),
                                          Text(
                                            _dispatchTimeController.text,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: CommonColors.appBarColor,
                                                fontSize:
                                                    SizeConfig.smallTextSize),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.horizontalPadding,
                            vertical: SizeConfig.verticalPadding),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CommonColors.grey400!, width: 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(SizeConfig.largeRadius))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.speed_rounded,
                                  color: CommonColors.appBarColor,
                                  size: SizeConfig.largeIconSize,
                                ),
                                SizedBox(
                                  width: SizeConfig.smallHorizontalSpacing,
                                ),
                                Text(
                                  "ODOMETER READING",
                                  style: TextStyle(
                                      color: CommonColors.appBarColor,
                                      fontSize: SizeConfig.smallTextSize),
                                )
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.smallVerticalSpacing,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.horizontalPadding,
                                        vertical: SizeConfig.verticalPadding),
                                    child: TextField(
                                      controller: _startReadingController,
                                      onChanged: changeStartReading,
                                      cursorColor: CommonColors.colorPrimary,
                                      textInputAction: TextInputAction.done,
                                      keyboardType: TextInputType.number,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: SizeConfig.smallTextSize),
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                  SizeConfig.largeRadius)),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: CommonColors.grey400!),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(
                                                SizeConfig.largeRadius),
                                          ),
                                          borderSide: BorderSide(
                                              width: 1,
                                              color: CommonColors.grey400!),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Text(
                                  "km",
                                  style: TextStyle(
                                      color: CommonColors.appBarColor),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.horizontalPadding,
                            vertical: SizeConfig.verticalPadding),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: CommonColors.grey400!, width: 1),
                            borderRadius: BorderRadius.all(
                                Radius.circular(SizeConfig.largeRadius))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: CommonColors.appBarColor,
                                  size: SizeConfig.largeIconSize,
                                ),
                                SizedBox(
                                  width: SizeConfig.mediumHorizontalSpacing,
                                ),
                                Text(
                                  "START READING IMAGE",
                                  style: TextStyle(
                                      color: CommonColors.appBarColor,
                                      fontSize: SizeConfig.smallTextSize),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: AlignmentGeometry.centerRight,
                                    child: InkWell(
                                      child: Icon(
                                        Icons.file_upload_outlined,
                                        color: CommonColors.appBarColor,
                                        size: SizeConfig.largeIconSize,
                                        // size: 24,
                                      ),
                                      onTap: () {
                                        showImagePickerDialog(context,
                                            (file) async {
                                          if (file != null) {
                                            debugPrint(' data: ${file.path}');
                                            setState(() {
                                              _startReadingImagePath =
                                                  file.path;
                                            });
                                          } else {
                                            failToast("File not selected");
                                          }
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.horizontalPadding,
                                  vertical: SizeConfig.verticalPadding),
                              child: SizedBox(
                                height: 200,
                                width: MediaQuery.sizeOf(context).width,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: CommonColors.grey300,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              SizeConfig.largeRadius))),
                                  child: isNullOrEmpty(_startReadingImagePath)
                                      ? InkWell(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.file_upload_outlined,
                                                color: CommonColors.appBarColor,
                                                size: SizeConfig
                                                    .extraLargeIconSize,
                                              ),
                                              Text(
                                                "Upload Image",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: SizeConfig
                                                        .mediumTextSize),
                                              ),
                                              Text(
                                                "Click the upload button above",
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: SizeConfig
                                                        .smallTextSize),
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
                                                    _startReadingImagePath =
                                                        file.path;
                                                  });
                                                } else {
                                                  failToast(
                                                      "File not selected");
                                                }
                                              },
                                            );
                                          },
                                        )
                                      : Image.file(
                                          File(_startReadingImagePath!),
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
          );
        },
      ),
      persistentFooterButtons: [
        SizedBox(
          width: double.infinity,
          child: CommonButton(
            color: CommonColors.colorPrimary!,
            onTap: () {
              validateBeforeUpdate();
              // String selectedDate = _dateController.text;
              // String selectedTime = _timeController.text;
            },
            title: "Update",
          ),
        ),
      ],
    );
  }
}

Future<void> openUpdateTripInfo(BuildContext context, TripModel model,
    TripStatus status, Future<void> Function()? onRefresh) {
  DraggableScrollableController controller = DraggableScrollableController();
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) {
        return ClipRRect(
          child: DraggableScrollableSheet(
            initialChildSize: 0.85,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            expand: false,
            controller: controller,
            builder: (context, scrollController) {
              return Container(
                color: Colors.white,
                child: UpdateTripInfo(
                    model: model, status: status, refresh: onRefresh),
              );
            },
          ),
        );
      });
}
