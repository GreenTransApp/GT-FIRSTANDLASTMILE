import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/attendance/attendanceViewModel.dart';
import 'package:gtlmd/pages/attendance/imageCapture.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/attendance/models/attendanceRadiusModel.dart';
import 'package:gtlmd/pages/attendance/viewAttendanceScreen.dart';
import 'package:gtlmd/service/connectionCheckService.dart';
import 'package:gtlmd/tiles/attendanceTile.dart';
import 'package:gtlmd/service/locationService/appLocationService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen>
    with WidgetsBindingObserver {
  bool servicestatus = false;
  bool hasPermission = false;
  String imagePath = '';
  late LocationPermission permission;
  late LoadingAlertService loadingAlertService;
  Position? _currentPosition;
  String? _currentAddress;
  String long = "", lat = "";
  late StreamSubscription<Position> positionStream;

  late DateTime todayDateTime;
  late String smallDateTime;
  double padValue = 0.0;
  String fromDt = "";
  String toDt = "";
  bool isProgressBarShowing = false;

  AttendanceViewModel viewModel = AttendanceViewModel();

  List<AttendanceModel> attendanceList = List.empty(growable: true);
  late AttendanceRadiusModel attendanceRadius;

  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));

    if (_refreshIndicatorKey.currentState == null) {
      _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
    }

    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();

    setObservers();
    _getCameraPermission();
    _getAttendance();
    _getAttendanceRadius();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      closeAlert(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> refreshScreen() async {
    setState(() {
      print('refreshing ...');
      _getAttendanceRadius();
      _getAttendance();
    });
  }

  Future<void> _getCameraPermission() async {
    final status = Permission.camera.request();
    debugPrint("Status: ${status.isGranted}");
  }

  // void convertUserImageToBase64(imgPath) {
  //   setState(() async {
  //     // // imagePath = imgPath!.path;
  //     // final bytes = File(imgPath).readAsBytesSync();
  //     // String base64Image = "data:image/png;base64," + base64Encode(bytes);
  //     // debugPrint("img_path : $base64Image");

  //     File imagefile = File(imgPath); //convert Path to File
  //     Uint8List imagebytes = await imagefile.readAsBytes(); //convert to bytes
  //     imagePath = base64.encode(imagebytes); //convert bytes to base64 string
  //     print(imagePath);
  //     _punchIn();
  //   });
  // }

  void convertUserImageToBase64(String imgPath) async {
    try {
      File imageFile = File(imgPath);

      if (!await imageFile.exists()) {
        print("Error: File does not exist at path $imgPath");
        return;
      }

      Uint8List imageBytes = await imageFile.readAsBytes();
      imagePath = base64.encode(imageBytes);

      print("Attendance Base64 Image: $imagePath");
      _punchIn();
    } catch (e) {
      print("Error converting image to Base64: $e");
      failToast("Error While Capture Image Please Try Again");
    }
  }

  void getUserImage() async {
    WidgetsFlutterBinding.ensureInitialized();

    var status = await Permission.camera.status;
    if (!status.isGranted) {
      status = await Permission.camera.request();
      if (!status.isGranted) {
        failToast('Camera permission denied');

        return;
      }
    }

    // final cameras = await availableCameras();
    // final firstCamera = cameras.last;

    // final path = await Get.to(Imagecapture(camera: firstCamera));
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        print('No camera found');
        return;
      }
      final firstCamera = cameras.last; // Use first available camera

      /// Navigate to image capture screen
      final path = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Imagecapture(camera: firstCamera),
        ),
      );

      debugPrint("Image Captured Screen 1: $path");
      if (path != null && path != '') {
        convertUserImageToBase64(path);
      }
    } catch (e) {
      debugPrint('Error accessing camera: $e');
    }
  }

  // void getUserImage() async {
  //   WidgetsFlutterBinding.ensureInitialized();
  //   final cameras = await availableCameras();
  //   final firstCamera = cameras.last;

  //   final path = /*await Navigator.push(
  //       context,
  //        MaterialPageRoute(
  //           builder: (BuildContext context) => Imagecapture(
  //                 camera: firstCamera,
  //               ))); */
  //       await Get.to(Imagecapture(camera: firstCamera));

  //   debugPrint("Image Captured Screen 1: ${path}");
  //   if (path != null && path != '') {
  //     convertUserImageToBase64(path);
  //   }
  // }

  void showNotification(String type) {
    var punchType = "";
    if (punchType == 'IN') {
      punchType = 'PUNCH-IN';
    } else if (type == 'OUT') {
      punchType = 'PUNCH-OUT';
    }
  }

  void checkGps(ALERT_TYPE alertType) async {
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      loadingAlertService.showLoading();
      String? address = await AppLocationService().getCurrentAddress();

      if (address != null) {
        _currentAddress = address;
        // We still need the position for radius check,
        // AppLocationService doesn't expose position directly yet,
        // but it does capture it. Let's get it.
        _currentPosition = await Geolocator.getCurrentPosition();
        lat = _currentPosition!.latitude.toString();
        long = _currentPosition!.longitude.toString();

        getLocation(alertType);
      } else {
        loadingAlertService.hideLoading();
        failToast("Could not get your location.");
      }
    } else {
      failToast("No Internet available");
    }
  }

  void getLocation(ALERT_TYPE alertType) async {
    debugPrint('getLocation');
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    lat = _currentPosition!.latitude.toString();
    debugPrint('getLocation');
    long = _currentPosition!.longitude.toString();
    debugPrint(
        'current Lat lng: ${_currentPosition!.latitude.toString()} ${_currentPosition!.longitude.toString()}');

    Location currentLocation = Location(
        latitude: _currentPosition!.latitude,
        longitude: _currentPosition!.longitude,
        timestamp: DateTime.now());

    if (attendanceRadius.attendanceradius != null) {
      debugPrint('Attendance Radius null or attendaradius null');
      debugPrint(
          "Radius to check is: ${attendanceRadius.attendanceradius.toString()}");
      late Location toCheckLocation;
      if (attendanceRadius.emplatposition != null &&
          attendanceRadius.emplongposition != null) {
        toCheckLocation = Location(
          latitude: double.parse(attendanceRadius.emplatposition!),
          longitude: double.parse(attendanceRadius.emplongposition!),
          timestamp: DateTime.now(),
        );
        debugPrint("emp long position ${attendanceRadius.emplongposition}");
        debugPrint("emp lat position ${attendanceRadius.emplongposition}");
      } else if (attendanceRadius.latposition != null &&
          attendanceRadius.longposition != null) {
        toCheckLocation = Location(
            latitude: double.parse(attendanceRadius.latposition!),
            longitude: double.parse(attendanceRadius.longposition!),
            timestamp: DateTime.now());
        debugPrint("branch long position ${attendanceRadius.emplongposition}");
        debugPrint("branch lat position ${attendanceRadius.emplongposition}");
      }
      if (isUserInRange(currentLocation, toCheckLocation,
          attendanceRadius.attendanceradius!.toDouble())) {
        debugPrint('user in range');
        loadingAlertService.hideLoading();
        showConfirmationAlert(alertType);
      } else {
        failToast(attendanceRadius.errmsg ?? "Out of office");
        loadingAlertService.hideLoading();
      }
    } else {
      debugPrint("Not Going to check Radius");
      loadingAlertService.hideLoading();
      showConfirmationAlert(alertType);
    }
  }

  showConfirmationAlert(ALERT_TYPE punchType) {
    if (punchType == ALERT_TYPE.IN) {
      // _savePunchIn();
      commonAlertDialog(
          context,
          "Confirm!",
          "Are you sure you want to 'PUNCH-IN' at : ",
          //  ' $_currentAddress ' ,
          "${_currentAddress ?? ""} ?",
          const Icon(Icons.alarm),
          getUserImage,
          cancelCallBack: cancelPopup,
          iconColor: CommonColors.successColor!,
          timer: 10);
    } else if (punchType == ALERT_TYPE.OUT) {
      commonAlertDialog(
          context,
          "Confirm!",
          "Are you sure you want to 'PUNCH-OUT' at ",
          " ${_currentAddress ?? ""} ?",
          const Icon(Icons.alarm),
          _punchOut,
          iconColor: CommonColors.dangerColor!,
          cancelCallBack: cancelPopup);
    }
  }

  void checkImagePath() {
    // We just need to store image path in local storage so we can check for image path and decide if user has already logged in or not
    if (!isNullOrEmpty(imagePath)) {
      _punchIn();
    } else {
      getUserImage();
    }
  }

  void _punchIn() async {
    // showProgressBar();
    debugPrint("Calling Save Punch In Api");
    var ipAddress = await getIpAddress();
    var deviceIpAddress = await getIp();
    debugPrint("deviceIp -> ${deviceIpAddress.toString()}");
    Map<String, dynamic> params = {
      "prmconnstring": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmmenucode": "GTAPP_ATTENDANCE",
      "prmsessionid": savedUser.sessionid.toString(),
      "prmdt": smallDateTime.toString(),
      "prmintime": todayDateTime.toString(),
      "prmingpslocation": _currentAddress.toString(),
      "prminipaddress":
          isNullOrEmpty(ipAddress) == true ? deviceIpAddress.toString() : "",
      "prminimeino": getUuid(),
      "prminlat": _currentPosition!.latitude.toString(),
      "prminlong": _currentPosition!.latitude.toString(),
      "prmindistance":
          isNullOrEmpty(attendanceRadius.attendanceradius.toString())
              ? 0
              : attendanceRadius.attendanceradius.toString(),
      "prmimagepath": imagePath,
    };
    viewModel.savePunchInData(params);
  }

  void _punchOut() async {
    // showProgressBar();
    var ipAddress = await getIpAddress();
    var deviceIp = await getDeviceIp();
    var deviceIpAddress = await getIp();
    debugPrint("IP -> ${ipAddress.toString()}");
    debugPrint("deviceIp -> ${deviceIp.toString()}");

    Map<String, dynamic> params = {
      "prmconnstring": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmmenucode": "GTAPP_ATTENDANCE",
      "prmsessionid": savedUser.sessionid.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmdt": smallDateTime.toString(),
      "prmouttime": todayDateTime.toString(),
      "prmoutgpslocation": _currentAddress.toString(),
      "prminipaddress":
          isNullOrEmpty(ipAddress) == true ? deviceIpAddress.toString() : "",
      "prmoutimeino": getUuid(),
      "prmoutlat": _currentPosition!.latitude.toString(),
      "prmoutlong": _currentPosition!.latitude.toString(),
      "prmoutdistance":
          isNullOrEmpty(attendanceRadius.attendanceradius.toString())
              ? 0
              : attendanceRadius.attendanceradius.toString(),
    };
    viewModel.savePunchOutData(params);
  }

  void cancelPopup() {}

  void _getAttendance() {
    debugPrint('Attendance list api ');
    setState(() {
      attendanceList.clear();
    });
    Map<String, String> params = {
      "prmconnstring": savedLogin.companyid.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmfromdt": fromDt,
      "prmtodt": toDt,
      // "prmtodt": this._date.transform(this.toDate, 'yyyy-MM-dd')
    };
    viewModel.callGetAttendanceDetails(params);
  }

  void _getAttendanceRadius() {
    Map<String, String> params = {
      "prmconnstring": savedLogin.companyid.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmusercode": savedUser.usercode.toString()
    };
    viewModel.callGetAttendanceRadiusData(params);
  }

  void setObservers() {
    viewModel.isErrorLiveData.stream.listen((errorMsg) {
      failToast(errorMsg);
    });
    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });
    viewModel.attendanceListLiveData.stream.listen((resp) {
      debugPrint(
          'Attendance list live data: ${resp.elementAt(0).attendancestatus}');
      if (resp.elementAt(0).commandstatus == 1) {
        setState(() {
          attendanceList = resp;
        });
      }
    });

    viewModel.attendanceRadiusLiveData.stream.listen((radiusData) {
      if (radiusData.commandstatus == 1) {
        attendanceRadius = radiusData;
      }
    });

    viewModel.punchInListLiveData.stream.listen((punchIn) {
      debugPrint(punchIn.commandmessage);
      // hideProgressBar();
      //  debugPrint("ip address print ${ipAddress.toString()}");
      if (punchIn.commandstatus == 1) {
        var type = "IN";
        successToast(punchIn.commandmessage.toString().toUpperCase());
        showNotification(type);
      } else if (punchIn.commandstatus == -1) {
        failToast(punchIn.commandmessage.toString().toUpperCase());
      }
      _getAttendance();
    });

    viewModel.punchoutListLiveData.stream.listen((punchOut) {
      debugPrint(punchOut.commandmessage);
      // hideProgressBar();
      if (punchOut.commandstatus == 1) {
        var type = "OUT";
        showNotification(type);
        successToast(punchOut.commandmessage.toString().toUpperCase());
      } else if (punchOut.commandstatus == -1) {
        failToast(punchOut.commandmessage.toString().toUpperCase());
      }
      _getAttendance();
    });
  }

  void _dateChanged(String fromDt, String toDt) {
    debugPrint("fromDt $fromDt");
    debugPrint("toDt $toDt");
    this.fromDt = fromDt;
    this.toDt = toDt;
    _getAttendance();
  }

  void _buttonPressed(BuildContext context, int index) {
    switch (index) {
      case 1:
        {
          checkGps(ALERT_TYPE.OUT);

          // loadingAlertService.showLoading();
          // getGpsLocation(ALERT_TYPE.OUT);
          // successToast('Punch-Out');
          break;
        }
      case 2:
        {
          checkGps(ALERT_TYPE.IN);
          // captureImage();

          // loadingAlertService.showLoading();
          // getGpsLocation(ALERT_TYPE.IN);
          // successToast("Punch-In");
          break;
        }
    }
  }

  bool isUserInRange(Location currentLatLong, Location toCheckLatLong,
      double allowedDistance) {
    debugPrint("Allowed Distance: ${allowedDistance.toString()}");
    double distanceBetweenUserAndAllocated = distance(
        currentLatLong.latitude,
        currentLatLong.longitude,
        toCheckLatLong.latitude,
        toCheckLatLong.longitude);
    debugPrint(
        "Calculated Distance: ${distanceBetweenUserAndAllocated.toString()}");
    if (distanceBetweenUserAndAllocated <= allowedDistance) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: CommonColors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Attendance',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: CommonColors.white,
          ),
        ),
        actions: [
          IconButton(
            icon:
                Icon(Icons.calendar_month_outlined, color: CommonColors.white),
            onPressed: () {
              showDatePickerBottomSheet(context, _dateChanged);
            },
          ),
          IconButton(
            icon: Icon(Icons.list_alt_outlined, color: CommonColors.white),
            onPressed: () {
              Get.to(() => const viewAttendanceScreen());
            },
          ),
        ],
      ),
/* 
       AppBar(
        foregroundColor: CommonColors.White,
        elevation: 0,
        systemOverlayStyle: CommonColors.systemUiOverlayStyle,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back)),
        // centerTitle:true,
        backgroundColor: CommonColors.colorPrimary,
        title: const Text(
          "ATTENDANCE",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          // Icon (Icons.calendar_month_rounded, size: 30,),
          // Icon (Icons.menu,size: 30,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {
                    showDatePickerBottomSheet(context, _dateChanged);
                    // showNotification();
                  },
                  icon: const Icon(
                    Icons.calendar_month_rounded,
                    size: 25,
                  ),
                  tooltip: 'Period Selection',
                ),
                // IconButton(
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => viewAttendanceScreen()));
                //   },
                // icon: const Icon(
                //   Icons.menu,
                //   size: 30,
                // ),
                InkWell(
                  onTap: () {
                    Get.to(viewAttendanceScreen());
                  },
                  child: Image.asset(
                    "assets/images/menu.png",
                    height: 25,
                    color: CommonColors.White,
                  ),
                ),
                // tooltip: 'View Attendance',
                // ),
              ],
            ),
          )
        ],
      ),

 */
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CommonColors.colorPrimary,
        onRefresh: refreshScreen,
        //      onRefresh: () async {

        //   await Future.delayed(Duration(seconds: 2));
        //   return ;
        // },
        //   notificationPredicate: (ScrollNotification notification) {

        //   return notification.depth == 1;
        // },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: attendanceList.length,
                    itemBuilder: (context, index) {
                      var currentAttendance = attendanceList[index];
                      debugPrint(currentAttendance.toString());
                      return AttendanceTile(
                        attendanceModel: currentAttendance,
                      );
                      //  showProgressBar?CircularProgressIndicator(): AttendanceTile(attendaceModel: currentAttendance);
                    },
                  ))
                  // AttendanceTile()
                ],
              ),
            ),
            Visibility(
                visible: isProgressBarShowing,
                child: Center(
                    child: CircularProgressIndicator(
                  color: CommonColors.colorPrimary,
                ))),
          ],
        ),
      ),
      // floatingActionButton: SpeedDial(
      //   buttonSize: const Size.square(40),
      //   // icon: Icons.expand_less_outlined,
      //   // childPadding: EdgeInsets.all(40),
      //   // childMargin: EdgeInsets.fromLTRB(0, 0, 0, 40),
      //   childrenButtonSize: const Size.square(70),
      //   spacing: 12,
      //   spaceBetweenChildren: 20,
      //   overlayColor: Colors.black,
      //   overlayOpacity: 0.8,
      //   animatedIcon: AnimatedIcons.menu_close,
      //   activeBackgroundColor: CommonColors.colorPrimary,
      //   backgroundColor: CommonColors.colorSecondary,
      //   children: [
      //     SpeedDialChild(
      //         labelBackgroundColor: Colors.grey,
      //         labelStyle: const TextStyle(color: Colors.black, fontSize: 20),
      //         backgroundColor: CommonColors.danger,
      //         child: const Icon(Icons.open_in_new_off),
      //         // onTap: () => _buttonPressed(context, 1),
      //         onTap: () {
      //           setState(() {
      //             _buttonPressed(context, 1);
      //             showProgressBar();
      //           });
      //         },
      //         label: 'Punch-Out'),
      //     SpeedDialChild(
      //         labelBackgroundColor: Colors.grey,
      //         labelStyle: const TextStyle(color: Colors.black, fontSize: 20),
      //         backgroundColor: CommonColors.success,
      //         child: const Icon(Icons.open_in_new),
      //         onTap: () => _buttonPressed(context, 2),
      //         label: 'Punch-In')
      //   ],
      // ),

      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _buttonPressed(context, 1);
                  // showProgressBar();
                  loadingAlertService.showLoading();
                },
                // icon: const Icon(Icons.close),
                label: const Text('Punch Out'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.red600,
                  foregroundColor: CommonColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  _buttonPressed(context, 2);
                  // showProgressBar();
                  // loadingAlertService.showLoading();
                },
                label: const Text('Punch In'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.green600,
                  foregroundColor: CommonColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

// ignore: camel_case_types, constant_identifier_names
enum ALERT_TYPE { OUT, IN }

// ignore: camel_case_types, constant_identifier_names
enum PUNCH_GEOFENCE_TYPE { ON, OFF }
