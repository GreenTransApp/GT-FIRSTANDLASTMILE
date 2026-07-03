 import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/imagePicker/alertBoxImagePicker.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/directBooking/directBookingViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/lastActiveTripModel.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripViewModel.dart';
import 'package:gtlmd/service/fireBaseService/firebaseLocationUpload.dart';
import 'package:gtlmd/service/locationService/appLocationService.dart';
import 'package:intl/intl.dart';

class UpdatebookingDispatchInfo extends StatefulWidget {
    final DeliveryDetailModel model;
    Future<void> Function()? refresh;
   UpdatebookingDispatchInfo({super.key, required this.model, required this.refresh});

  @override
  State<UpdatebookingDispatchInfo> createState() => _UpdatebookingDispatchInfoState();
}

class _UpdatebookingDispatchInfoState extends State<UpdatebookingDispatchInfo> {
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
  DirectBookingViewModel directBookingViewModel = DirectBookingViewModel();
  late LoadingAlertService loadingAlertService;
  LastActiveTripModel? lastTripInfo;

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
    getLastTripInfo();
  }


 void setObservers() {
    viewModel.isErrorLiveData.stream.listen((error) {
      failToast(error);
    });
    directBookingViewModel.isErrorLiveData.stream.listen((error) {
      failToast(error);
    });

    viewModel.viewDialogLiveData.stream.listen((showDialog) {
      if (showDialog) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });
    directBookingViewModel.viewDialog.stream.listen((showDialog) {
      if (showDialog) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

  
    directBookingViewModel.updateDispatchLiveData.stream.listen((model) async {
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

  }
void getLastTripInfo() {
    Map<String, dynamic> params = {
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmtripid": widget.model.tripid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmvehiclecode":  widget.model.vehiclecode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };
    viewModel.getLastTripInfo(params);
  }

 void updateBookingDispatchdetail() {
    Map<String, String> params = {
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmgrno": widget.model.grno.toString(),
      "prmtransactionid": widget.model.transactionid.toString(),
      "prmdispatchdt":
          convert2SmallDateTime( _dispatchDateController.text.toString()),
      "prmdispatchtime":_dispatchTimeController.text.toString(),
      "prmstartreading": isNullOrEmpty(widget.model.startreadingkm.toString())
          ? ''
          : widget.model.startreadingkm.toString(),
      "prmstartreadimgpath":  isNullOrEmpty(widget.model.startreadingimg)
              ? ""
              : convertFilePathToBase64(widget.model.startreadingimg),
      'prmentrylocation': currentAddress,
      "prmsessionid": savedUser.sessionid.toString()
     
    };

    directBookingViewModel.UpdateDispatchDetail(params);
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
      int currentReading = int.tryParse(value.trim()) ?? 0;
      int lastReading = lastTripInfo?.lastendreadingkm ?? 0;
      if (value.isNotEmpty) {
        if (lastTripInfo != null && currentReading <= lastReading) {
          _startReadingError =
              "Start Reading Value Can't be less than Last Trip's End Reading ${lastTripInfo!.lastendreadingkm}";
          debugPrint(_startReadingError);
        } else if (currentReading - lastReading >
            int.parse(lastTripInfo!.readingdiff.toString())) {
          commonAlertDialog(
              context,
              "ALERT!",
              "Start and last close reading difference cannot exceed ${lastTripInfo!.readingdiff} KM.",
              "",
              const Icon(Icons.info),
              okayCallBackForAlert,
              cancelCallBack: () {});
        } else {
          _startReadingError = null;
        }
        _startReadingImagePath = null;
      } else {
        _startReadingError = null;
      }
    });
  }

  void okayCallBackForAlert() {
    _startReadingController.text = "";
  }

  validateBeforeUpdate() {
   
      int currentReading =
          int.tryParse(_startReadingController.text.trim()) ?? 0;
      int lastReading = lastTripInfo?.lastendreadingkm ?? 0;
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
        } else if (lastReading > 0 &&
            currentReading - lastReading >
                int.parse(lastTripInfo!.readingdiff.toString())) {
          failToast(
              "Reading difference exceeds ${lastTripInfo!.readingdiff} KM. Check entry.");
          return;
        }
        widget.model.startreadingkm =
            int.tryParse(_startReadingController.text);
        widget.model.startreadingimg = _startReadingImagePath;
      }
      // widget.model.dispatchdate = _dispatchDateController.text;
      // widget.model.dispatchdatetime = _dispatchTimeController.text;
    
    fetchLocationAndSubmit();
  }

  Future<void> fetchLocationAndSubmit() async {
    loadingAlertService.showLoading();
    String? address = await AppLocationService().getCurrentAddress();
    loadingAlertService.hideLoading();

    if (address != null) {
      currentAddress = address;
      debugPrint("Current Address: $currentAddress");
     
        updateBookingDispatchdetail();
      
    } else {
      failToast("Could not get your location.");
    }
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
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: CommonColors.colorPrimary,
        // title: Text("DRS NUMBER: ${widget.model.ma}",
        //     style: TextStyle(color: CommonColors.White)),
        title: Text("${widget.model.grno.toString()}",
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
            child:Column(
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
                                          errorStyle:
                                              TextStyle(color: Colors.red),
                                          helperText: isNullOrEmpty(lastTripInfo
                                                  ?.lastendreadingkm
                                                  .toString())
                                              ? "Enter start reading"
                                              : "Must be > last trip reading (${lastTripInfo!.lastendreadingkm})",
                                          helperStyle:
                                              TextStyle(color: Colors.black),
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

Future<void> openUpdateBookingDispatchInfo(BuildContext context, DeliveryDetailModel model,
   Future<void> Function()? onRefresh) {
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
                child: UpdatebookingDispatchInfo(
                    model: model, refresh: onRefresh),
              );
            },
          ),
        );
      });
}
