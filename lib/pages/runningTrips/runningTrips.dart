import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/runningTrips/runningTripsViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/service/locationService/locationService.dart';
import 'package:gtlmd/tiles/runningTripTile.dart';
import 'package:lottie/lottie.dart';

class RunningTrips extends StatefulWidget {
  final AttendanceModel attendanceModel;
  const RunningTrips({
    super.key,
    required this.attendanceModel,
  });

  @override
  State<RunningTrips> createState() => RunningTripsState();
}

class RunningTripsState extends State<RunningTrips> {
  List<TripModel> _tripList = List.empty(growable: true);
  List<TripModel> filterList = List.empty(growable: true);
  late AttendanceModel _attendanceModel = AttendanceModel();
  late LoadingAlertService loadingAlertService;
  RunningTripsViewModel viewModel = RunningTripsViewModel();
  final List<StreamSubscription> _subscription = [];
  final locationService = LocationService();
  final TextEditingController _searchController = TextEditingController();
  late String query = "";
  @override
  void initState() {
    super.initState();
    // _deliveryList = widget.deliveryList;
    _attendanceModel = widget.attendanceModel;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
  }

  setObservers() {
    _subscription.add(viewModel.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        setState(() {
          loadingAlertService.showLoading();
        });
      } else {
        setState(() {
          loadingAlertService.hideLoading();
        });
      }
    }));

    _subscription.add(viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    }));

    _subscription.add(viewModel.tripsListData.stream.listen((data) {
      setState(() {
        _tripList = data;
        filterList = _tripList;
        checkAuthenticatedUserForRunService(_tripList);
      });
    }));
  }

  Future<void> checkAuthenticatedUserForRunService(
      List<TripModel> tripData) async {
    try {
      final bool isRunning = await FlutterForegroundTask.isRunningService;

      // Stop if not authenticated
      if (authService.isAuthenticated.value != true) {
        debugPrint('[Service] User not authenticated → stop');
        if (isRunning) await locationService.stopService();
        return;
      }

      // Stop if no trips
      if (tripData.isEmpty) {
        debugPrint('[Service] Trip list empty → stop');
        if (isRunning) await locationService.stopService();
        return;
      }

      // Stop if command status invalid
      if (tripData.first.commandstatus != 1) {
        debugPrint('[Service] Invalid command status → stop');
        if (isRunning) await locationService.stopService();
        return;
      }

      // Stop if no dispatched trips
      final hasDispatchedTrip = tripData.any(
        (trip) =>
            trip.tripdispatchdatetime != null &&
            trip.tripdispatchdatetime.toString().isNotEmpty,
      );
      if (!hasDispatchedTrip) {
        debugPrint('[Service] No dispatched trips → stop');
        if (isRunning) await locationService.stopService();
        return;
      }

      // Prepare data to send
      final tripList = tripData.map((trip) => trip.tripid.toString()).toList();
      final dataToPass = {
        'tripList': tripList,
        'userData': savedUser.toJson(),
      };
      if (!isRunning) {
        debugPrint('[Service] Starting foreground service');
        locationService.requestPermissions();
        await FlutterForegroundTask.startService(
          notificationTitle: 'Location Tracking Active',
          notificationText: 'Your location is being tracked.',
          callback: startCallback,
        );

        // Send data after service starts
        Future.delayed(const Duration(milliseconds: 300), () {
          FlutterForegroundTask.sendDataToTask(dataToPass);
        });
      } else {
        debugPrint('[Service] Updating foreground service data');
        FlutterForegroundTask.sendDataToTask(dataToPass);
      }
    } catch (e, stack) {
      debugPrint('[Service] Error: $e');
      debugPrint(stack.toString());
    }
  }

  @override
  void dispose() {
    for (var sub in _subscription) {
      sub.cancel();
    }
    super.dispose();
  }

  void getTripList() {
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmfromdt": convert2SmallDateTime(dashboardFromDt.toString()),
      "prmtodt": convert2SmallDateTime(dashboardToDt.toString()),
      "prmsessionid": savedUser.sessionid.toString(),

      /// O for open and C for close
    };

    viewModel.getTripsList(params);
  }

  Future<void> onRefresh() async {
    getTripList();
  }

  void updateSearch(String newQuery) {
    List<TripModel> newMatchQuery = [];

    if (newQuery.isEmpty) {
      setState(() {
        query = '';
        filterList = _tripList;
      });
    } else {
      for (var trip in _tripList) {
        if (trip.tripid
            .toString()
            .toLowerCase()
            .contains(newQuery.toLowerCase())) {
          newMatchQuery.add(trip);
        }
      }
      setState(() {
        query = newQuery;
        filterList = newMatchQuery;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: CommonColors.colorPrimary,
      onRefresh: onRefresh,
      child: Scaffold(
        body: Container(
          color: CommonColors.blueGrey?.withAlpha((0.1 * 255).toInt()),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalPadding,
                    vertical: SizeConfig.verticalPadding),
                child: TextField(
                  controller: _searchController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  cursorColor: CommonColors.appBarColor,
                  obscureText: false,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: CommonColors.appBarColor,
                      size: SizeConfig.largeIconSize,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchController.clear();
                          updateSearch('');
                        });
                      },
                      icon: _searchController.text.isNotEmpty
                          ? const Icon(Icons.clear)
                          : const Icon(
                              Icons.clear,
                              color: Colors.transparent,
                            ),
                    ),
                    hintText: 'Search',
                    filled: true,
                    fillColor: CommonColors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Set the desired radius
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: updateSearch,
                ),
              ),
              Expanded(
                child: Container(
                  child: (filterList.isEmpty) == true
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.asset("assets/emptyDelivery.json",
                                      height: 150),
                                  Text(
                                    "No Trips",
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                        color: CommonColors.appBarColor),
                                  )
                                ],
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemCount: filterList.length,
                          itemBuilder: (context, index) {
                            var currentData = filterList[index];
                            return RunningTripTile(
                              model: currentData,
                              attendanceModel: _attendanceModel,
                              onRefresh: onRefresh,
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
