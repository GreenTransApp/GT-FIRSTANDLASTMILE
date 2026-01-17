import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get/get.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bluetooth/bluetooth.dart';
import 'package:gtlmd/common/bluetooth/bluetoothScreen.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/navDrawer/navDrawer.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/navigateRoutes/Routes.dart';
import 'package:gtlmd/navigateRoutes/RoutesName.dart';
import 'package:gtlmd/pages/attendance/attendanceScreen.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBill.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/home/Model/moduleModel.dart';
import 'package:gtlmd/pages/home/homeViewModel.dart';
import 'package:gtlmd/pages/offlineView/dbHelper.dart';
import 'package:gtlmd/pages/offlineView/offlineDrsBottomSheet.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionBottomSheet.dart';
import 'package:gtlmd/pages/profile/profilePage.dart';
import 'package:gtlmd/pages/routes/routesList/allotedRouteWidget.dart';
import 'package:gtlmd/pages/runningTrips/runningTrips.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/updateVersionScreen/updateVersionScreen.dart';
import 'package:gtlmd/service/locationService/locationService.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

enum DashboardTabs { ALLOTEDROUTES, CURRENTDELIVERY }

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  String fromDt = "";
  String toDt = "";
  String viewFromDt = "";
  String viewToDt = "";
  late DateTime todayDateTime;
  late String smallDateTime;
  late LoadingAlertService loadingAlertService;
  final HomeViewModel viewModel = HomeViewModel();
  List<AllotedRouteModel> routeList = List.empty(growable: true);
  List<CurrentDeliveryModel> deliveryList = List.empty(growable: true);
  List<CurrentDeliveryModel> activeDrsList = List.empty(growable: true);
  List<TripModel> tripsList = List.empty(growable: true);

  List<CurrentDeliveryModel> activeDrsLiveData = List.empty(growable: true);
  List<ModulesModel> modulesList = List.empty(growable: true);
  bool menuCardVisibility = true;
  String menuTitle = "";
  // DateTime? nowTime;
  String formattedDate = '';
  late AttendanceModel attendanceModel = AttendanceModel();
  Color? cardColor;
  DashboardTabs channel = DashboardTabs.ALLOTEDROUTES;
  late TabController _tabController;
  int offlinePodCount = 0;
  int offlineUndeliveryCount = 0;
  final locationService = LocationService();
  // final authService = AuthenticationService();
  bool showLocationWarning = false;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  GlobalKey<AllocatedRouteWidgetState> allotedRouteKey = GlobalKey();
  GlobalKey<DrsselectionBottomSheetState> drsSelectionKey = GlobalKey();
  GlobalKey<RunningTripsState> runningTripsKey = GlobalKey();
  final List<StreamSubscription> _subscriptions = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    getLoginPrefs();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timestamp) {
      ScreenDimension.width = MediaQuery.of(context).size.width;
      ScreenDimension.height = MediaQuery.of(context).size.height;
    });

    formattedDate = formatDate(DateTime.now().millisecondsSinceEpoch);
    debugPrint('Formatted date $formattedDate');
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    DateTime fromdt = DateTime.parse(fromDt);
    DateTime todt = DateTime.parse(toDt);
    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    fetchOfflineDrsCounts();
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        refreshScreen();
      }
    });
    // Bluetooth().scan();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  @override
  void didPopNext() {
    refreshScreen();
  }

  Future<void> refreshScreen() async {
    // Fluttertoast.showToast(msg: 'Refreshing');
    getDashboardDetails();
    fetchOfflineDrsCounts();
  }

  fetchOfflineDrsCounts() async {
    try {
      int pod = await DBHelper.getPodEntryCount();
      int undelivery = await DBHelper.getUndeliveryCount();

      setState(() {
        offlinePodCount = pod;
        offlineUndeliveryCount = undelivery;
      });
    } catch (err) {
      failToast(err.toString());
    }
  }

  setObservers() {
    _subscriptions
        .add(viewModel.routeDashboardLiveData.stream.listen((dashboard) {
      debugPrint('dashboard List Length: ${dashboard.length}');
      if (dashboard.isNotEmpty && dashboard.elementAt(0).commandstatus == 1) {
        setState(() {
          routeList = dashboard;
        });
      }
    }));
    _subscriptions
        .add(viewModel.deliveryDashboardLiveData.stream.listen((dashboard) {
      debugPrint('dashboard List Length: ${dashboard.length}');

      if (dashboard.isNotEmpty && dashboard.elementAt(0).commandstatus == 1) {
        setState(() {
          deliveryList = dashboard;
        });
      }
    }));
    _subscriptions.add(viewModel.attendanceLiveData.stream.listen((attendance) {
      debugPrint('dashboard List Length: ${attendance}');

      if (attendance.commandstatus == 1) {
        setState(() {
          attendanceModel = attendance;
          todayAttendance = attendance;
          cardColor = attendanceModel.attendancestatus == "Present"
              ? CommonColors.successColor!
              : CommonColors.dangerColor!;
        });
      }
    }));
    _subscriptions.add(viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    }));

    _subscriptions.add(viewModel.tripsListData.stream.listen((tripData) {
      if (tripData == null || tripData.isEmpty) {
        debugPrint('Trip data is empty, stopping location service...');
        locationService.stopService();
        tripsList.clear();
        return;
      } else {
        if (tripData.elementAt(0).commandstatus == 1) {
          setState(() {
            // tripsList = tripData;
            checkAuthenticatedUserForRunService(tripData);
          });
        }
      }
      // checkAuthenticatedUserForRunService(tripData);
    }));

    _subscriptions
        .add(viewModel.validateDeviceLiveData.stream.listen((validate) {
      setState(() {
        if (validate.validlogin == "N" || validate.singledevice == "N") {
          failToast(validate.commandmessage.toString());
          authService.logout(context);
        } else if (validate.requiredaupdate == "Y") {
          failToast(validate.commandmessage.toString());
          _updateScreen(context);
          // } else if (validate.executiveid == null ||
          //     validate.employeeid == null) {
        } else if (validate.executiveid == null) {
          failToast("Invalid User details");
          authService.logout(context);
        } else {
          getDashboardDetails();
        }
      });
    }));

    _subscriptions.add(viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    }));

    _subscriptions.add(
        viewModel.drsDateTimeUpdateLiveData.stream.listen((drsUpdate) async {
      if (drsUpdate.commandstatus == 1) {
        // if(drsUpdate.drsstatus == "O"){
        //     locationService.startService(activeDrsList,savedUser);
        // }else if(drsUpdate.drsstatus == "C"){
        //     locationService.stopService();
        // }
        //  else
        if (drsUpdate.commandmessage != null) {
          successToast(drsUpdate.commandmessage!);
        } else {
          successToast("Date time updated successfully");
        }
        getDashboardDetails();
      } else {
        if (drsUpdate.commandmessage != null) {
          failToast(drsUpdate.commandmessage!);
        } else {
          failToast("Something went wrong");
        }
      }
    }));
  }

  checkAuthenticatedUserForRunService(List<TripModel> tripData) {
    try {
      if (tripData == null || tripData.isEmpty) {
        debugPrint('Trip data is empty, stopping location service...');
        locationService.stopService();
        // return Future.value();
        return;
      }

      if (tripData.elementAt(0).commandstatus == 1) {
        setState(() {
          tripsList = tripData;
        });

        bool hasDispatchedTrip = tripsList.any(
          (trip) =>
              trip.tripdispatchdatetime != null &&
              trip.tripdispatchdatetime.toString().isNotEmpty,
        );

        if (hasDispatchedTrip) {
          debugPrint(authService.isAuthenticated.value.toString());

          authService.isAuthenticated
              .where((val) => val != null)
              .take(1)
              .listen((isAuthenticated) async {
            try {
              if (isAuthenticated == true) {
                if (tripsList.isNotEmpty) {
                  if (savedUser.employeeid != null &&
                      savedUser.employeeid! > 0) {
                    if (attendanceModel.intime != null &&
                        attendanceModel.intime!.isNotEmpty &&
                        (attendanceModel.outtime != null ||
                            attendanceModel.outtime!.isNotEmpty)) {
                      final tripList = tripsList
                          .map((trip) => trip.tripid.toString())
                          .toList();
                      final dataToPass = {
                        'tripList': tripList,
                        'userData': savedUser.toJson(),
                      };
                      bool isRunnig =
                          await FlutterForegroundTask.isRunningService;
                      if (!isRunnig) {
                        locationService.startService(tripData, savedUser);
                      } else {
                        FlutterForegroundTask.sendDataToTask(dataToPass);
                      }
                    }
                  } else {
                    final tripList = tripsList
                        .map((trip) => trip.tripid.toString())
                        .toList();
                    final dataToPass = {
                      'tripList': tripList,
                      'userData': savedUser.toJson(),
                    };
                    bool isRunnig =
                        await FlutterForegroundTask.isRunningService;
                    if (!isRunnig) {
                      locationService.startService(tripData, savedUser);
                    } else {
                      FlutterForegroundTask.sendDataToTask(dataToPass);
                    }
                  }
                } else {
                  debugPrint(' No trips found, service not started.');
                  locationService.stopService();
                }
              } else {
                debugPrint('User logged out, stopping location service...');
                locationService.stopService();
              }
            } catch (innerError, innerStack) {
              debugPrint('Error in authentication listener: $innerError');
              debugPrint(innerStack.toString());
              try {
                locationService.stopService();
              } catch (_) {}
            }
          });
        } else {
          debugPrint(
              ' No dispatched trips found, stopping location service...');
          locationService.stopService();
        }
      } else {
        debugPrint(' Command status not valid, stopping location service...');
        locationService.stopService();
      }
    } catch (error, stackTrace) {
      debugPrint(' Error in handleTripDataUpdate: $error');
      debugPrint(stackTrace.toString());
      try {
        locationService.stopService();
      } catch (_) {}
    }
  }

  getLoginPrefs() {
    try {
      getLoginData().then((login) => {
            if (login.commandstatus == null || login.commandstatus == -1)
              {_goToLogin()}
            else
              {
                companyId = login.companyid.toString(),
                getUserData().then((user) => {
                      if (user.commandstatus == null ||
                          user.commandstatus == -1)
                        throw Exception("")
                      else
                        {
                          setObservers(),
                          validateDevice(),
                          getDashboardDetails()
                        }
                    })
              }
          });
    } catch (err) {
      debugPrint(err.toString());
      _goToLogin();
    }
  }

  _goToLogin() {
    Routes.goToPage(RoutesName.login, "Login");
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     setState(() {
  //       // getLoginPref().then((value) => {refreshData()});
  //       getLoginData();
  //       getDashboardDetails();
  //     });
  //   }
  // }

  void _updateScreen(BuildContext context) {
    // storageClear();
    // Routes.goToPage(RoutesName.update, "Update");
    Get.offAll(const UpdateVersionScreen());
  }

  logout() {
    commonAlertDialog(context, "ALERT!", "Are you sure you want to logout?", "",
        const Icon(Icons.logout), okayCallBack,
        cancelCallBack: cancelPopup);
  }

  okayCallBack() {
    Future.delayed(Duration.zero, () {
      // Get.off(const LoginPage());
      // authService.storageRemove(ENV.userPrefTag);
      // authService.storageRemove(ENV.loginPrefTag);
      authService.logout(context);
    });
  }

  void cancelPopup() {
    // Navigator.pop(context);
    Get.back();
  }

  Future<void> validateDevice() async {
    // failToast('data not found');
    String deviceId = await getDeviceId();
    Map<String, String> params = {
      "prmconstring": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmpassword": savedUser.password.toString(),
      "prmappversion": ENV.appVersion,
      "prmapp": ENV.appName,
      // "prmdeviceid": getUuid(),
      "prmdeviceid": deviceId,
      "prmsessionid": savedUser.sessionid.toString(),
      "prmappplatform": Platform.isAndroid ? "ANDROID" : "IOS",
    };
    debugPrint("Validating Device: ");
    printParams(params);
    viewModel.callValidateDeviceData(params);
  }

  void getDashboardDetails() {
    // failToast('data not found');
    deliveryList.clear();
    routeList.clear();

    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      // "prmfromdt": ENV.isDebugging == true ? "2025-01-01" : fromDt,
      "prmfromdt": convert2SmallDateTime(dashboardFromDt.toString()),
      "prmtodt": convert2SmallDateTime(dashboardToDt.toString()),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    viewModel.callDashboardDetail(params);
  }

  void _dateChanged(String fromDt, String toDt) {
    // debugPrint("fromDt ${fromDt}");
    // debugPrint("toDt ${toDt}");

    this.fromDt = fromDt;
    this.toDt = toDt;

    DateTime fromdt = DateTime.parse(this.fromDt);
    DateTime todt = DateTime.parse(this.toDt);
    dashboardFromDt = fromdt;
    dashboardToDt = todt;
    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    getDashboardDetails();
    allotedRouteKey.currentState?.onRefresh();
    drsSelectionKey.currentState?.refreshScreen();
    runningTripsKey.currentState?.onRefresh();
  }

  // void _handleDrsUpdateRequest(dynamic model, DrsStatus status) {
  //   // debugPrint(
  //   //     'Update requested with Date: $selectedDate, Time: $selectedTime, DRS No: $drsNo');

  //   Map<String, String> params = {
  //     "prmcompanyid": savedUser.companyid.toString(),
  //     "prmemployeeid": savedUser.employeeid.toString(),
  //     "prmdrsno": model.drsno.toString(),
  //     "prmdispatchdt": convert2SmallDateTime(model.dispatchdt.toString()),
  //     "prmdispatchtime": model.dispatchtime.toString(),
  //     "prmmanifestdt": convert2SmallDateTime(model.manifestdate.toString()),
  //     "prmmanifesttime": model.manifesttime.toString(),
  //     "prmusercode": savedUser.usercode.toString(),
  //     "prmsessionid": savedUser.sessionid.toString(),
  //     "prmstartreading": model.startreadingkm.toString(),
  //     "prmstartreadimgpath": status == DrsStatus.CLOSE
  //         ? model.startreadingimgpath
  //         : convertFilePathToBase64(model.startreadingimgpath.toString()),
  //     "prmendreadimgpath":
  //         convertFilePathToBase64(model.closeReadingImagePath.toString()),
  //     "prmclosetripdt": model.closeTripDate == null
  //         ? ""
  //         : convert2SmallDateTime(model.closeTripDate),
  //     "prmclosetriptime": model.closeTripTime ?? "",
  //     "prmclosetripreading": model.closeReadingKm?.toString() ?? "",
  //     "prmdrsstatus": status == DrsStatus.OPEN ? 'O' : 'C'

  //     /// O for open and C for close
  //   };

  //   viewModel.callDrsDateTimeUpdate(params);
  //   // Perform your update logic here, e.g., call an API
  //   // You can also update the state of this screen if needed
  // }

  Widget attendanceInfo() {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.mediumHorizontalSpacing,
          vertical: SizeConfig.mediumVerticalSpacing),
      margin: EdgeInsets.only(
          top: SizeConfig.mediumVerticalSpacing,
          bottom: SizeConfig.smallVerticalSpacing,
          left: SizeConfig.mediumHorizontalSpacing,
          right: SizeConfig.mediumHorizontalSpacing),
      decoration: BoxDecoration(
        color: CommonColors.colorPrimary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Date',
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
                          color: CommonColors.White,
                        ),
                      ),
                      SizedBox(height: SizeConfig.smallVerticalSpacing),
                      Text(
                        formattedDate,
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
                          fontWeight: FontWeight.w500,
                          color: CommonColors.White,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                  Visibility(
                    visible: ENV.isDebugging,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(const BluetoothScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.smallHorizontalSpacing,
                            vertical: SizeConfig.smallVerticalSpacing),
                        decoration: BoxDecoration(
                          border: Border.all(color: CommonColors.white!),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.bluetooth,
                            size: SizeConfig.extraLargeIconSize,
                            color: CommonColors.White),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDatePickerBottomSheet(context, _dateChanged);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.mediumHorizontalSpacing,
                          vertical: SizeConfig.mediumVerticalSpacing),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: CommonColors.colorPrimary,
                          border: Border.all(color: CommonColors.White!)),
                      child: Icon(Icons.calendar_today,
                          size: SizeConfig.largeIconSize,
                          color: CommonColors.White),
                    ),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: SizeConfig.smallVerticalSpacing),
          Visibility(
            visible: employeeid != null,
            child: InkWell(
              onTap: () {
                Get.to(() => const AttendanceScreen())?.then((_) {
                  getDashboardDetails();
                });
              },
              child: Row(
                children: [
                  // Punch status indicator with color based on status
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    decoration: BoxDecoration(
                      color: CommonColors.colorPrimary,
                      borderRadius:
                          BorderRadius.circular(SizeConfig.largeRadius),
                      border: Border.all(color: Colors.white30),
                    ),
                    child: Row(
                      children: [
                        // Status indicator dot
                        Container(
                          width: isSmallDevice ? 6 : 8,
                          height: isSmallDevice ? 6 : 8,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: attendanceModel.attendancestatus == "Absent"
                                ? CommonColors.dangerColor
                                : CommonColors.successColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          attendanceModel.attendancestatus == 'Present'
                              ? "${attendanceModel.attendancedisplaytxt!.substring(0, 10)}${attendanceModel.attendancedisplaytxt!.substring(attendanceModel.attendancedisplaytxt!.length - 8)}"
                                  .toString()
                                  .toUpperCase()
                              : "Absent",
                          style: TextStyle(
                            fontSize: SizeConfig.smallTextSize,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // Icon(
                  //   Icons.chevron_right,
                  //   size: isSmallDevice ? 16 : 20,
                  //   color: Colors.white,
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    if (attendanceModel == null) {
      return Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.largeRadius),
                bottomRight: Radius.circular(SizeConfig.largeRadius),
              ),
            ),
            backgroundColor: CommonColors.colorPrimary,
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    size: SizeConfig.mediumIconSize,
                    color: CommonColors.white,
                  ));
            }),
            title: Text(
              'Dashboard',
              style: TextStyle(
                  color: CommonColors.white,
                  fontSize: SizeConfig.extraLargeIconSize),
            ),
          ),
          drawer: const SideMenu(),
          body: Center(
            child: Text(
              "data not  found ".toUpperCase(),
              style: TextStyle(
                  color: CommonColors.successColor,
                  fontSize: SizeConfig.mediumTextSize),
            ),
          ));
    } else {
      return Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.largeRadius),
                bottomRight: Radius.circular(SizeConfig.largeRadius),
              ),
            ),
            backgroundColor: CommonColors.colorPrimary,
            title: Text(
              'Dashboard',
              style: TextStyle(
                fontSize: SizeConfig.extraLargeIconSize,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            leading: Builder(builder: (context) {
              return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: Icon(
                    Icons.menu,
                    size: SizeConfig.largeIconSize,
                    color: CommonColors.white,
                  ));
            }),
            actions: [
              Badge(
                backgroundColor: CommonColors.orange,
                label: Text('${offlinePodCount + offlineUndeliveryCount}'),
                offset: const Offset(-3, 5),
                child: IconButton.outlined(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        CommonColors.White!.withAlpha((255 * 0.2).toInt())),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                          color: CommonColors.White!.withAlpha((255 * 0.2)
                              .toInt())), // <-- Outline color and width
                    ),
                  ),
                  color: CommonColors.white,
                  onPressed: () async {
                    // Get.to(() => const Offlinedrslist());
                    await showOfflineDrsBottomSheet(context);
                    refreshScreen();
                  },
                  icon: Icon(
                    Symbols.autorenew_rounded,
                    size: SizeConfig.largeIconSize,
                    color: CommonColors.white,
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.mediumHorizontalSpacing),
            ],
          ),
          extendBody: true,
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (value) {
              setState(() {
                _selectedIndex = value;
                // _pageController.jumpToPage(value);
                debugPrint("value $value");
                if (value == 0) {
                  allotedRouteKey.currentState?.onRefresh();
                } else if (value == 1) {
                  drsSelectionKey.currentState?.refreshScreen();
                } else if (value == 2) {
                  runningTripsKey.currentState?.onRefresh();
                }
              });
            },
            labelTextStyle: WidgetStatePropertyAll(
                TextStyle(fontSize: SizeConfig.smallTextSize)),
            indicatorColor: CommonColors.colorPrimary!
                .withAlpha((0.15 * 255).toInt()), // light background
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.route, size: SizeConfig.extraLargeIconSize),
                selectedIcon: Icon(
                  Icons.route,
                  size: SizeConfig.extraLargeIconSize,
                  color: CommonColors.colorPrimary,
                ),
                label: "ROUTES",
              ),
              NavigationDestination(
                icon: Icon(Symbols.package_2,
                    size: SizeConfig.extraLargeIconSize),
                selectedIcon: Icon(
                  Symbols.package_2,
                  size: SizeConfig.extraLargeIconSize,
                  color: CommonColors.colorPrimary,
                ),
                label: "CREATE TRIP",
              ),
              NavigationDestination(
                icon: Icon(Symbols.delivery_truck_bolt,
                    size: SizeConfig.extraLargeIconSize),
                selectedIcon: Icon(
                  Symbols.delivery_truck_bolt,
                  size: SizeConfig.extraLargeIconSize,
                  color: CommonColors.colorPrimary,
                ),
                label: "TRIPS",
              ),
              NavigationDestination(
                icon: Icon(Symbols.person_rounded,
                    size: SizeConfig.extraLargeIconSize),
                selectedIcon: Icon(
                  Symbols.person_rounded,
                  size: SizeConfig.extraLargeIconSize,
                  color: CommonColors.colorPrimary,
                ),
                label: "PROFILE",
              ),
            ],
          ),
          drawer: const SideMenu(),
          body: IndexedStack(
            index: _selectedIndex,
            children: [
              Column(
                children: [
                  attendanceInfo(),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: ENV.isDebugging,
                    child: GestureDetector(
                      onTap: () async {
                        // Bluetooth.printReceipt();
                        Get.to(() => const BluetoothScreen());
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: isSmallDevice ? 8 : 16,
                            vertical: isSmallDevice ? 8 : 12),
                        margin: EdgeInsets.only(
                            top: 16,
                            bottom: 4,
                            left: isSmallDevice ? 8 : 16,
                            right: isSmallDevice ? 8 : 16),
                        decoration: BoxDecoration(
                          color: CommonColors.colorPrimary,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Test',
                          style: TextStyle(
                            fontSize: isSmallDevice ? 12 : 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: AllocatedRouteWidget(
                      key: allotedRouteKey,
                      attendanceModel: attendanceModel,
                      // routeList: routeList,
                      // onRefresh: refreshScreen,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  attendanceInfo(),
                  Expanded(
                    child: DrsselectionBottomSheet(
                      key: drsSelectionKey,
                      tripId: 0,
                      showTripInfoUpdate: true,
                      onRefresh: refreshScreen,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  attendanceInfo(),
                  Expanded(
                    child: RunningTrips(
                      key: runningTripsKey,
                      // deliveryList: tripsList,
                      attendanceModel: attendanceModel,
                      // onRefresh: refreshScreen
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  // attendanceInfo(),
                  Expanded(child: const ProfileScreen()),
                ],
              )
            ],
          )
          // PageView(
          //   physics: const NeverScrollableScrollPhysics(),
          //   controller: _pageController,
          //   children: [
          // Column(
          //   children: [
          //     attendanceInfo(),
          //     Expanded(
          //       child: AllocatedRouteWidget(
          //         attendanceModel: attendanceModel,
          //         // routeList: routeList,
          //         // onRefresh: refreshScreen,
          //       ),
          //     ),
          //   ],
          // ),
          //     Column(
          //       children: [
          //         attendanceInfo(),
          //         Expanded(
          //           child: DrsselectionBottomSheet(
          //             tripId: 0,
          //             showTripInfoUpdate: false,
          //             onRefresh: refreshScreen,
          //           ),
          //         ),
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         attendanceInfo(),
          //         Expanded(
          //           child: AssignTripWidget(
          //               deliveryList: tripsList,
          //               attendanceModel: attendanceModel,
          //               onRefresh: refreshScreen),
          //         ),
          //       ],
          //     ),
          //     Column(
          //       children: [
          //         attendanceInfo(),
          //         const Expanded(child: ProfileScreen()),
          //       ],
          //     ),
          //   ],
          // )
          );
    }
  }
}
