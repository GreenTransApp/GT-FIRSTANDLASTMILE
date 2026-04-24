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

// ignore: must_be_immutable
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
  // ignore: library_private_types_in_public_api
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
  String? _startReadingError;
  bool? isOdometerUnAvailable = false;

  UpdateTripInfoViewModel viewModel = UpdateTripInfoViewModel();
  late LoadingAlertService loadingAlertService;
  TripModel? lastTripInfo;
  @override
  void initState() {
    super.initState();
    if (widget.status == TripStatus.open) {
      _dispatchDateController.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
      _dispatchTimeController.text = DateFormat('HH:mm').format(DateTime.now());
      _startReadingController.text = "0";
    } else {
      _dispatchTimeController.text = widget.model.tripdispatchtime!;
      _dispatchDateController.text = widget.model.tripdispatchdate!;

      _closeDateController.text =
          DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
      _closeTimeController.text = DateFormat('HH:mm a').format(DateTime.now());

      _startReadingController.text =
          widget.model!.startreadingkm?.toString() ?? "0";
      _startReadingImagePath = widget.model.startreadingimg;
      calculateTotalTime(
          widget.model.tripdispatchtime!, _closeTimeController.text.toString());
    }
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    getLastTripInfo();
  }

  void getLastTripInfo() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };
    viewModel.getLastTripInfo(params);
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

    viewModel.lastTripInfo.stream.listen((data) {
      if (data.commandstatus == 1) {
        setState(() {
          lastTripInfo = data;
        });
      }
    });
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
        if (lastTripInfo != null &&
            int.parse(value) <=
                int.parse(lastTripInfo!.endreadingkm.toString())) {
          _startReadingError =
              "Start Reading Value Can't be less than Last Trip's End Reading ${lastTripInfo!.endreadingkm}";
          debugPrint(_startReadingError);
        } else {
          _startReadingError = null;
        }
        _startReadingImagePath = null;
      } else {
        _startReadingError = null;
      }
    });
  }

  validateBeforeUpdate() {
    if (widget.status == TripStatus.close) {
      if (isOdometerUnAvailable == false) {
        if (isNullOrEmpty(_closeDateController.text)) {
          failToast("Please Select Close Data.");
          return;
        } else if (isNullOrEmpty(_closeTimeController.text)) {
          failToast("Please Select Close Time");
          return;
        } else if (isNullOrEmpty(_closeReadingController.text)) {
          failToast("Please Enter Close Reading Value");
          return;
        } else if (int.parse(_closeReadingController.text) <= 0) {
          failToast("Close Reading Value Can't be Zero");
          return;
        } else if (int.parse(_closeReadingController.text) <=
            int.parse(widget.model!.startreadingkm.toString())) {
          failToast(
              "Close Reading Value Can't be less than Start Reading Value");
          return;
        }
        widget.model.endreadingkm = int.tryParse(_closeReadingController.text);
        widget.model.endreadingimg = _closeReadingImagePath;
      }
      widget.model.endtripdate = _closeDateController.text;
      widget.model.endtriptime = _closeTimeController.text;
    } else {
      if (isOdometerUnAvailable == false) {
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
        } else if (_startReadingError != null) {
          failToast(_startReadingError!);
          return;
        }
        widget.model.startreadingkm =
            int.tryParse(_startReadingController.text);
        widget.model.startreadingimg = _startReadingImagePath;
      }
      widget.model.tripdispatchdate = _dispatchDateController.text;
      widget.model.tripdispatchdatetime = _dispatchTimeController.text;
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
          ? isNullOrEmpty(widget.model.startreadingimg)
              ? ""
              : convertFilePathToBase64(widget.model.startreadingimg)
          : isNullOrEmpty(widget.model.startreadingimg)
              ? ""
              : widget.model.startreadingimg!,
      "prmsessionid": savedUser.sessionid.toString(),
      'prmentrylocation': currentAddress,
      'prmisodometerunavailable': isOdometerUnAvailable == true ? 'Y' : 'N',
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
          : isNullOrEmpty(widget.model.endreadingimg)
              ? ""
              : convertFilePathToBase64(widget.model.endreadingimg),
      "prmsessionid": savedUser.sessionid.toString(),
      'prmentrylocation': currentAddress,
      'prmisodometerunavailable': isOdometerUnAvailable == true ? 'Y' : 'N',
    };

    viewModel.updateCloseTrip(params);
  }

  Widget odoMeterUnAvailable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Odometer un-available?",
              style: TextStyle(
                color: CommonColors.appBarColor,
                fontSize: SizeConfig.smallTextSize,
                fontWeight: FontWeight.w400,
              ),
            ),
            Checkbox(
                checkColor: CommonColors.White,
                activeColor: CommonColors.colorPrimary,
                value: isOdometerUnAvailable,
                onChanged: (value) {
                  isOdometerUnAvailable = value;
                  setState(() {});
                }),
          ],
        ),
        Visibility(
          visible: isOdometerUnAvailable == true,
          child: Text(
            "(You can submit the form without filling it.)",
            style: TextStyle(color: CommonColors.green500),
          ),
        )
      ],
    );
  }

  Widget closeTrip() {
    return Column(
      children: [
        Opacity(
          opacity: 0.4,
          child: Card(
            elevation: 2,
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
                                        width:
                                            SizeConfig.smallHorizontalSpacing,
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
                                        width:
                                            SizeConfig.mediumHorizontalSpacing,
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
                                        width:
                                            SizeConfig.smallHorizontalSpacing,
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
                                        width:
                                            SizeConfig.mediumHorizontalSpacing,
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
                      border: Border.all(
                          width: 1, color: CommonColors.colorPrimary!),
                    ),
                    alignment: Alignment.center,
                    child: widget.model.startreadingimg != null
                        ? Image.network(
                            widget.model.startreadingimg!,
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
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        const Divider(
          height: 1,
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        Opacity(
          opacity: isOdometerUnAvailable == true ? 0.4 : 1,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                        Radius.circular(SizeConfig.largeRadius)),
                    border: Border.all(color: CommonColors.grey400!, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Opacity(
                        opacity: isOdometerUnAvailable == true ? 0.4 : 1.0,
                        child: Row(
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
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        odoMeterUnAvailable(),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        Opacity(
          opacity: isOdometerUnAvailable == true ? 0.4 : 1,
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
                      enabled: isOdometerUnAvailable == true ? false : true,
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
                          borderSide: BorderSide(
                              width: 1, color: CommonColors.grey400!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(SizeConfig.largeRadius)),
                          borderSide: BorderSide(
                              width: 1, color: CommonColors.grey400!),
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
        ),
        SizedBox(height: SizeConfig.mediumVerticalSpacing),
        Opacity(
          opacity: isOdometerUnAvailable == true ? 0.4 : 1,
          child: Container(
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
                        onTap: isOdometerUnAvailable == true
                            ? null
                            : () {
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
                        child: Icon(
                          Icons.file_upload_outlined,
                          color: CommonColors.appBarColor,
                          size: SizeConfig.largeIconSize,
                          // size: 24,
                        ),
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
                              onTap: isOdometerUnAvailable == true
                                  ? null
                                  : () {
                                      showImagePickerDialog(context,
                                          (file) async {
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
        ),
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
    if (_closeReadingController.text.isNotEmpty &&
        widget.model.startreadingkm.toString().isNotEmpty &&
        widget.model.startreadingkm.toString() != '0') {
      int? diff = (int.tryParse(_closeReadingController.text)! -
          widget.model.startreadingkm!) as int?;
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
                      Opacity(
                        opacity: isOdometerUnAvailable == true ? 0.4 : 1.0,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            SizeConfig.horizontalPadding,
                                        vertical: SizeConfig.verticalPadding),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(
                                              SizeConfig.largeRadius)),
                                      border: Border.all(
                                          color: CommonColors.grey400!,
                                          width: 1),
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
                                                  color:
                                                      CommonColors.appBarColor,
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
                                        horizontal:
                                            SizeConfig.horizontalPadding,
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
                                                  color:
                                                      CommonColors.appBarColor,
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
                      ),
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      odoMeterUnAvailable(),
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      Opacity(
                        opacity: isOdometerUnAvailable == true ? 0.4 : 1.0,
                        child: Container(
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
                                        enabled: isOdometerUnAvailable == false,
                                        controller: _startReadingController,
                                        onChanged: changeStartReading,
                                        cursorColor: CommonColors.colorPrimary,
                                        textInputAction: TextInputAction.done,
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: SizeConfig.smallTextSize),
                                        decoration: InputDecoration(
                                          errorText: _startReadingError,
                                          errorStyle: const TextStyle(
                                              color: Colors.red),
                                          helperText: lastTripInfo != null
                                              ? "Must be > last trip reading (${lastTripInfo!.endreadingkm})"
                                              : "Enter start reading",
                                          helperStyle: TextStyle(
                                              color: CommonColors.dangerColor),
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
                      ),
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      Opacity(
                        opacity: isOdometerUnAvailable == true ? 0.4 : 1.0,
                        child: Container(
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
                                        onTap: isOdometerUnAvailable == true
                                            ? null
                                            : () {
                                                showImagePickerDialog(context,
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
                                                });
                                              },
                                        child: Icon(
                                          Icons.file_upload_outlined,
                                          color: CommonColors.appBarColor,
                                          size: SizeConfig.largeIconSize,
                                          // size: 24,
                                        ),
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
                                            onTap: isOdometerUnAvailable == true
                                                ? null
                                                : () {
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
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.file_upload_outlined,
                                                  color:
                                                      CommonColors.appBarColor,
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
