import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/runningTrips/runningTripsViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';

import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:gtlmd/tiles/runningTripTile.dart';
import 'package:lottie/lottie.dart';

class RunningTrips extends StatefulWidget {
  // final List<TripModel> deliveryList;
  final AttendanceModel attendanceModel;
  // final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  // final Future<void> Function() onRefresh;
  RunningTrips({
    super.key,
    // required this.deliveryList,
    required this.attendanceModel,
    // this.onUpdate,
    // required this.onRefresh
  });

  @override
  State<RunningTrips> createState() => RunningTripsState();
}

class RunningTripsState extends State<RunningTrips> {
  List<TripModel> _tripList = List.empty(growable: true);
  late AttendanceModel _attendanceModel = AttendanceModel();
  late LoadingAlertService loadingAlertService;
  RunningTripsViewModel viewModel = RunningTripsViewModel();
  @override
  void initState() {
    super.initState();
    // _deliveryList = widget.deliveryList;
    _attendanceModel = widget.attendanceModel;
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    // getTripList();
  }

  setObservers() {
    viewModel.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        setState(() {
          // isLoading = true;
          loadingAlertService.showLoading();
        });
      } else {
        setState(() {
          // isLoading = false;
          loadingAlertService.hideLoading();
        });
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.tripsListData.stream.listen((data) {
      setState(() {
        _tripList = data;
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: CommonColors.colorPrimary,
      onRefresh: onRefresh,
      child: Scaffold(
        body: Container(
          child: (_tripList.isEmpty) == true
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
                  // physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _tripList.length,
                  itemBuilder: (context, index) {
                    var currentData = _tripList[index];
                    return RunningTripTile(
                      model: currentData,
                      attendanceModel: _attendanceModel,
                      // onUpdate: onUpdate,
                      onRefresh: onRefresh,
                    );
                  },
                ),
        ),
      ),
    );
  }
}
