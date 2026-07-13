import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/midmile/midMileTripList/midMileTripListModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripList/updateMidMileTripInfo/updateMidMileTripInfoViewModel.dart';
import 'package:gtlmd/service/locationService/appLocationService.dart';
import 'package:gtlmd/service/locationService/locationService.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UpdateMidMileTripInfo extends StatefulWidget {
  MidMileTripListModel model;
  // final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  Future<void> Function() refresh;
  UpdateMidMileTripInfo({
    super.key,
    required this.model,
    // this.onUpdate,
    required this.refresh,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateMidMileTripInfoState createState() => _UpdateMidMileTripInfoState();
}

class _UpdateMidMileTripInfoState extends State<UpdateMidMileTripInfo> {
  final TextEditingController _dispatchDateController = TextEditingController();
  final TextEditingController _dispatchTimeController = TextEditingController();
  final TextEditingController _startReadingController = TextEditingController();
  bool showCamera = false;
  String? _startReadingImagePath;
  String totalTime = "";
  String totaldistance = "";
  String currentAddress = '';
  String? _startReadingError;
  bool? isOdometerUnAvailable = false;

  UpdateMidMileTripInfoViewModel viewModel = UpdateMidMileTripInfoViewModel();
  late LoadingAlertService loadingAlertService;
  // LastActiveTripModel? lastTripInfo;
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();

    _dispatchDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    _dispatchTimeController.text = DateFormat('HH:mm').format(DateTime.now());
    _startReadingController.text = "0";

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
  }

  void setObservers() {
    viewModel.errorDialog.stream.listen((error) {
      failToast(error);
    });

    viewModel.loadingDialog.stream.listen((showDialog) {
      if (showDialog) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.updateStartTripLiveData.stream.listen((model) async {
      if (model.commandstatus == 1) {
        successToast(model.commandmessage?? '');
        if (widget.refresh != null) {
          widget.refresh();
        }
        Get.back();
      } else {
        failToast(model.commandmessage?? '');
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

  void changeStartReading(String value) {
    setState(() {
      // int currentReading = int.tryParse(value.trim()) ?? 0;
      // int lastReading = lastTripInfo?.lastendreadingkm ?? 0;
      // if (value.isNotEmpty) {
      //   if (lastTripInfo != null && currentReading <= lastReading) {
      //     _startReadingError =
      //         "Start Reading Value Can't be less than Last Trip's End Reading ${lastTripInfo!.lastendreadingkm}";
      //     debugPrint(_startReadingError);
      //   } else if (currentReading - lastReading >
      //       int.parse(lastTripInfo!.readingdiff.toString())) {
      //     commonAlertDialog(
      //         context,
      //         "ALERT!",
      //         "Start and last close reading difference cannot exceed ${lastTripInfo!.readingdiff} KM.",
      //         "",
      //         const Icon(Icons.info),
      //         okayCallBackForAlert,
      //         cancelCallBack: () {});
      //   } else {
      //     _startReadingError = null;
      //   }
      _startReadingImagePath = null;
      // } else {
      //   _startReadingError = null;
      // }
    });
  }

  void okayCallBackForAlert() {
    _startReadingController.text = "";
  }

  validateBeforeUpdate() {
    int currentReading = int.tryParse(_startReadingController.text.trim()) ?? 0;
    // int lastReading = lastTripInfo?.lastendreadingkm ?? 0;
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
      //  else if (lastReading > 0 &&
      //     currentReading - lastReading >
      //         int.parse(lastTripInfo!.readingdiff.toString())) {
      //   failToast(
      //       "Reading difference exceeds ${lastTripInfo!.readingdiff} KM. Check entry.");
      //   return;
      // }
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
      updateStartTrip();
    } else {
      failToast("Could not get your location.");
    }
  }

  Future<void> updateStartTrip() async {
    // _currentPosition = await Geolocator.getCurrentPosition();
    _currentPosition = _currentPosition = await LocationService().getCurrentLocation();;
    Map<String, String> params = {
      // "prmcompanyid": savedUser.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmmenucode": '',
      "prmdivisionid": savedUser.logindivisionid.toString(),
      "prmtripid": widget.model.tripid.toString(),
      "prmtripdetailid": widget.model.tripdetailid.toString(),
      "prmstartdt": convert2SmallDateTime(_dispatchDateController.text),
      "prmstarttime": _dispatchTimeController.text,
      "prmvehiclestartkm": isNullOrEmpty(_startReadingController.text)
          ? ''
          : _startReadingController.text,
      "prmstartreadingimage": isNullOrEmpty(_startReadingImagePath)
          ? ""
          : convertFilePathToBase64(_startReadingImagePath.toString()),
      'prmvehiclestartlocation': currentAddress,
      // 'prmisodometerunavailable': isOdometerUnAvailable == true ? 'Y' : 'N',
      'prmpickuplatposition': _currentPosition?.latitude.toString() ?? '',
      'prmpickuplongposition': _currentPosition?.longitude.toString() ?? '',
    };

    viewModel.updateStartTrip(params);
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
              // onChanged: (value) {
              //   isOdometerUnAvailable = value;
              //   setState(() {});
              // }
              onChanged: null,
            ),
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
            child: Column(
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
                                  horizontal: SizeConfig.horizontalPadding,
                                  vertical: SizeConfig.verticalPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(SizeConfig.largeRadius)),
                                border: Border.all(
                                    color: CommonColors.grey400!, width: 1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        size: SizeConfig.largeIconSize,
                                        color: CommonColors.appBarColor,
                                      ),
                                      SizedBox(
                                        width:
                                            SizeConfig.smallHorizontalSpacing,
                                      ),
                                      Text(
                                        "DISPATCH DATE",
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
                                        size: SizeConfig.largeIconSize,
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
                ),
                SizedBox(height: SizeConfig.mediumVerticalSpacing),
                Visibility(
                    visible: isOdometerUnAvailable!,
                    child: odoMeterUnAvailable()),
                SizedBox(height: SizeConfig.mediumVerticalSpacing),
                Opacity(
                  opacity: isOdometerUnAvailable == true ? 0.4 : 1.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    decoration: BoxDecoration(
                        border:
                            Border.all(color: CommonColors.grey400!, width: 1),
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
                                    horizontal: SizeConfig.horizontalPadding,
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
                                    errorStyle:
                                        const TextStyle(color: Colors.red),
                                    // helperText: isNullOrEmpty(lastTripInfo
                                    //         ?.lastendreadingkm
                                    //         .toString())
                                    //     ? "Enter start reading"
                                    //     : "Must be > last trip reading (${lastTripInfo!.lastendreadingkm})",
                                    helperStyle:
                                        const TextStyle(color: Colors.black),
                                    // color: isNullOrEmpty(lastTripInfo
                                    //           ?.lastendreadingkm
                                    //           .toString())
                                    //       ? Colors.black
                                    //       : Colors.red),
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
                                        Radius.circular(SizeConfig.largeRadius),
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
                              style: TextStyle(color: CommonColors.appBarColor),
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
                        border:
                            Border.all(color: CommonColors.grey400!, width: 1),
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
                                      Radius.circular(SizeConfig.largeRadius))),
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
                                            color: CommonColors.appBarColor,
                                            size: SizeConfig.extraLargeIconSize,
                                          ),
                                          Text(
                                            "Upload Image",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    SizeConfig.mediumTextSize),
                                          ),
                                          Text(
                                            "Click the upload button above",
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                    SizeConfig.smallTextSize),
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

Future<void> openUpdateMidMileTripInfo(BuildContext context,
    MidMileTripListModel model, Future<void> Function() onRefresh) {
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
                child: UpdateMidMileTripInfo(model: model, refresh: onRefresh),
              );
            },
          ),
        );
      });
}
