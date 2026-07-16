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
import 'package:gtlmd/pages/midmile/midMileTripDetail/midMileTripDetailModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/updateMidMileTripDetailInfo/updateMidMileDriverReachViewModel.dart';
import 'package:gtlmd/service/locationService/locationService.dart';
import 'package:intl/intl.dart';

enum MIDMILETRIPSTATUS { ARRIVAL, UNLOAD }

// ignore: must_be_immutable
class UpdateMidMileDriverPosition extends StatefulWidget {
  MidMileTripDetailModel model;
  final MIDMILETRIPSTATUS status;
  // final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  Future<void> Function()? refresh;
  UpdateMidMileDriverPosition({
    super.key,
    required this.model,
    // this.onUpdate,
    this.refresh,
    required this.status,
  });

  @override
  // ignore: library_private_types_in_public_api
  _UpdateMidMileDriverPositionState createState() =>
      _UpdateMidMileDriverPositionState();
}

class _UpdateMidMileDriverPositionState
    extends State<UpdateMidMileDriverPosition> {
  final TextEditingController _arrivalDateController = TextEditingController();
  final TextEditingController _arrivalTimeController = TextEditingController();
  final TextEditingController _arrivalReadingController =
      TextEditingController();

  final TextEditingController _unloadDateController = TextEditingController();
  final TextEditingController _unloadTimeController = TextEditingController();
  final TextEditingController _unloadReadingController =
      TextEditingController();
  bool showCamera = false;
  String? _arrivalReadingImagePath;
  String? _unloadReadingImagePath;
  String totalTime = "";
  String totaldistance = "";
  String currentAddress = '';
  String? _arrivalReadingError;
  String? _unloadReadingError;
  bool? isOdometerUnAvailable = false;

  UpdateMidMileDriverPositionViewModel viewModel =
      UpdateMidMileDriverPositionViewModel();
  late LoadingAlertService loadingAlertService;
  // LastActiveTripModel? lastTripInfo;
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();

    _arrivalDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    _arrivalTimeController.text = DateFormat('HH:mm').format(DateTime.now());
    _arrivalReadingController.text = "0";

    _unloadDateController.text =
        DateFormat('dd-MM-yyyy').format(DateTime.now()).toString();
    _unloadTimeController.text = DateFormat('HH:mm').format(DateTime.now());
    _unloadReadingController.text = "0";

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
        successToast(model.commandmessage!);
        if (widget.refresh != null) {
          widget.refresh!();
        }
        Get.back();
      } else {
        failToast(model.commandmessage!);
      }
    });

    viewModel.arrivalWithOutstandingLiveData.stream.listen((data) {
      if (data.commandstatus == 1) {
        successToast("Update successfull");
         if (widget.refresh != null) {
          widget.refresh!();
        }
        Get.back();
      } else {
        failToast(data.commandmessage ?? "Something went wrong");
      }
    });
  }

  void odoMeterChange(String value) {
    setState(() {
      if (value != "0" && value.isNotEmpty) {
        showCamera = true;
      } else {
        showCamera = false;
        _arrivalReadingImagePath = null;
      }
    });
  }

  void changeArrivalReading(String value) {
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
      _arrivalReadingImagePath = null;
      // } else {
      //   _startReadingError = null;
      // }
    });
  }

  changeUnloadReading(String value) {
    int currentReading = int.tryParse(value.trim()) ?? 0;
    int lastReading = widget.model.arrivalKm ?? 0;
    setState(() {
      if (lastReading > 0 && currentReading < lastReading) {
        _unloadReadingError =
            "Unload reading  can't be greater than arrival reading.";
      } else {
        _unloadReadingError = '';
      }
      _unloadReadingImagePath = null;
    });
  }

  void okayCallBackForAlert() {
    _arrivalReadingController.text = "";
  }

  validateBeforeUpdate() {
    // int currentReading = int.tryParse(_arrivalReadingController.text.trim()) ?? 0;
    // int lastReading = lastTripInfo?.lastendreadingkm ?? 0;

    if (widget.status == MIDMILETRIPSTATUS.ARRIVAL) {
      if (isOdometerUnAvailable == false) {
        // if (isNullOrEmpty(_arrivalDateController.text)) {
        //   failToast("Please Select Arrival Date.");
        //   return;
        // } else if (isNullOrEmpty(_arrivalTimeController.text)) {
        //   failToast("Please Select Arrival Time");
        //   return;
        // } else
         if (isNullOrEmpty(_arrivalReadingController.text)) {
          failToast("Please Enter Odometer Value");
          return;
        } else if (int.tryParse(_arrivalReadingController.text)! <= 0) {
          failToast("Odometer Value Can't be Zero");
          return;
        } else if (_arrivalReadingError != null) {
          failToast(_arrivalReadingError!);
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
      updateDriverReached();
    } else {
      int currentReading =
          int.tryParse(_unloadReadingController.text.trim()) ?? 0;
      int lastReading = widget.model.arrivalKm ?? 0;
     
        // if (isNullOrEmpty(_unloadDateController.text)) {
        //   failToast("Please Select Unload Date.");
        //   return;
        // } else if (isNullOrEmpty(_unloadTimeController.text)) {
        //   failToast("Please Select Unload Time");
        //   return;
        // } else
         if (isNullOrEmpty(_unloadReadingController.text)) {
          failToast("Please Enter Odometer Value");
          return;
        } else if (int.tryParse(_unloadReadingController.text)! <= 0) {
          failToast("Odometer Value Can't be Zero");
          return;
        } else if (!isNullOrEmpty(_unloadReadingError)) {
          failToast(_unloadReadingError!);
          return;
        }else if(isNullOrEmpty(_unloadReadingImagePath)) {
          failToast("Please Select Reading Image.");
          return;
        }else if (lastReading > 0 && lastReading > currentReading) {
          failToast("Unload reading  can't be greater than arrival reading.");
          return;
        
      }
      updateVehicleArrivalWithOutstanding();
    }
  }

  Future<void> updateDriverReached()  async {
    loadingAlertService.showLoading();
    // _currentPosition = await Geolocator.getCurrentPosition();
    // _currentPosition = _currentPosition =  LocationService().getCurrentLocation();
    LocationService().getCurrentLocation().then((position) {
  _currentPosition = position;
});
    loadingAlertService.hideLoading();
    Map<String, String> params = {
      // "prmcompanyid": savedUser.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmmenucode": '',
      "prmdivisionid": savedUser.logindivisionid.toString(),
      "prmtripid": widget.model.tripId.toString(),
      "prmtripdetailid": widget.model.tripDetailId.toString(),
      "prmgrno": widget.model.grno.toString(),
      "prmmanifestno": widget.model.manifestNo.toString(),
      "prmarrivaldt": convert2SmallDateTime(_arrivalDateController.text),
      "prmarrivaltime": _arrivalTimeController.text,
      "prmarrivalkm": isNullOrEmpty(_arrivalReadingController.text)
          ? ''
          : _arrivalReadingController.text,
      "prmstartreadingimage": isNullOrEmpty(_arrivalReadingImagePath)
          ? ""
          : convertFilePathToBase64(_arrivalReadingImagePath.toString()),
      // 'prmisodometerunavailable': isOdometerUnAvailable == true ? 'Y' : 'N',
      'prmarrivallat': _currentPosition?.latitude.toString() ?? '',
      'prmarrivallong': _currentPosition?.longitude.toString() ?? '',
    };
    viewModel.updateDriverReached(params);
  }

  Future<void> updateVehicleArrivalWithOutstanding() async {
    loadingAlertService.showLoading();
    // _currentPosition = await Geolocator.getCurrentPosition();
    // _currentPosition = _currentPosition = await LocationService().getCurrentLocation();
    LocationService().getCurrentLocation().then((position) {
  _currentPosition = position;
});
    loadingAlertService.hideLoading();
    Map<String, dynamic> params = {
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmtripid":int.parse( widget.model.tripId.toString()),
      "prmtripdetailid":int.parse( widget.model.tripDetailId.toString()),
      "prmgrno": widget.model.grno.toString(),
      "prmmanifestno": widget.model.manifestNo.toString(),
      "prmunloaddt":
          convert2SmallDateTime(_unloadDateController.text.toString()),
      "prmunloadtime": _unloadTimeController.text.toString(),
      "prmunloadkm":int.parse(_unloadReadingController.text.toString()),
      "prmimgpath": isNullOrEmpty(_unloadReadingImagePath)
          ? ""
          : convertFilePathToBase64(_unloadReadingImagePath),
      "prmunloadlat": _currentPosition?.latitude.toString() ?? '',
      "prmunloadlong": _currentPosition?.longitude.toString() ?? '',
      "prmfromstn": widget.model.orgcode.toString(),
      "prmtostn": widget.model.destcode.toString(),
      "prmdrivercode": savedUser.drivercode.toString(),
      "prmmodecode": widget.model.modecode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmmenucode": "GTAPP_MIDMILEUNLOAD",
      "prmpckgs":double.tryParse(widget.model.totpckgs.toString())?.toInt() ?? 0,
      "prmaweight": isNullOrEmpty(widget.model.aWeight.toString())
          ? 0.0
          : double.tryParse(widget.model.aWeight.toString()) ?? 0.0,
    };
    await viewModel.UpdateVehicleArrivalWithOutstanding(params);
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
        title: Text("Trip ID: ${widget.model.tripId.toString()}",
            style: TextStyle(color: CommonColors.White)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CommonColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: widget.status == MIDMILETRIPSTATUS.ARRIVAL
          ? arrivalWidget()
          : unloadWidget(),
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

  Widget arrivalWidget() {
    return LayoutBuilder(
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
                                      width: SizeConfig.smallHorizontalSpacing,
                                    ),
                                    Text(
                                      "ARRIVAL DATE",
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
                                      _arrivalDateController.text,
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
                                      width: SizeConfig.smallHorizontalSpacing,
                                    ),
                                    Text(
                                      "ARRIVAL TIME",
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
                                      width: SizeConfig.mediumHorizontalSpacing,
                                    ),
                                    Text(
                                      _arrivalTimeController.text,
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
                                controller: _arrivalReadingController,
                                onChanged: changeArrivalReading,
                                cursorColor: CommonColors.colorPrimary,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.smallTextSize),
                                decoration: InputDecoration(
                                  errorText: _arrivalReadingError,
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
                                        width: 1, color: CommonColors.grey400!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.largeRadius),
                                    ),
                                    borderSide: BorderSide(
                                        width: 1, color: CommonColors.grey400!),
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
                                              _arrivalReadingImagePath =
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
                            child: isNullOrEmpty(_arrivalReadingImagePath)
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
                                                    _arrivalReadingImagePath =
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
                                    File(_arrivalReadingImagePath!),
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
    );
  }

  Widget unloadWidget() {
    return LayoutBuilder(
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
                                      width: SizeConfig.smallHorizontalSpacing,
                                    ),
                                    Text(
                                      "UNLOAD DATE",
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
                                      _unloadDateController.text,
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
                                      width: SizeConfig.smallHorizontalSpacing,
                                    ),
                                    Text(
                                      "UNLOAD TIME",
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
                                      width: SizeConfig.mediumHorizontalSpacing,
                                    ),
                                    Text(
                                      _unloadTimeController.text,
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
                      Text(
                        "Arrival Reading : ${widget.model.arrivalKm} km",
                        style: TextStyle(
                            color: CommonColors.appBarColor,
                            fontSize: SizeConfig.smallTextSize),
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
                                controller: _unloadReadingController,
                                onChanged: changeUnloadReading,
                                cursorColor: CommonColors.colorPrimary,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: SizeConfig.smallTextSize),
                                decoration: InputDecoration(
                                  errorText: _unloadReadingError,
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
                                        width: 1, color: CommonColors.grey400!),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(SizeConfig.largeRadius),
                                    ),
                                    borderSide: BorderSide(
                                        width: 1, color: CommonColors.grey400!),
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
                            "READING IMAGE",
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
                                              _unloadReadingImagePath =
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
                            child: isNullOrEmpty(_unloadReadingImagePath)
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
                                                    _unloadReadingImagePath =
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
                                    File(_unloadReadingImagePath!),
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
    );
  }
}

Future<void> openUpdateMidMileDriverPosition(
    BuildContext context,
    MidMileTripDetailModel model,
    Future<void> Function()? onRefresh,
    MIDMILETRIPSTATUS status) {
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
                child: UpdateMidMileDriverPosition(
                  model: model,
                  status: status,
                  refresh: onRefresh,
                ),
              );
            },
          ),
        );
      });
}
