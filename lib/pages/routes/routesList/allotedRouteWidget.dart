import 'dart:async';

import 'package:firebase_database/ui/utils/stream_subscriber_mixin.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/routes/routesList/routesListViewModel.dart';
import 'package:gtlmd/tiles/dashboardRouteTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class AllocatedRouteWidget extends StatefulWidget {
  final AttendanceModel attendanceModel;
  // final Future<void> Function() onRefresh;

  const AllocatedRouteWidget({
    super.key,
    required this.attendanceModel,
    //  required this.onRefresh
  });

  @override
  State<AllocatedRouteWidget> createState() => AllocatedRouteWidgetState();
}

class AllocatedRouteWidgetState extends State<AllocatedRouteWidget> {
  final RoutesListViewModel viewModel = RoutesListViewModel();
  List<AllotedRouteModel> _routeList = List.empty(growable: true);
  AttendanceModel _attendanceModel = AttendanceModel();
  late LoadingAlertService loadingAlertService;
  String fromDt = "";
  String toDt = "";
  late DateTime todayDateTime;
  late String smallDateTime;
  List<StreamSubscription> _subscriptions = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    _attendanceModel = widget.attendanceModel;
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    _getRoutesList();
  }

  setObservers() {
    _subscriptions.add(viewModel.viewDialog.stream.listen((show) {
      if (show) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    }));
    _subscriptions.add(viewModel.errorDialog.stream.listen((error) {
      failToast(error);
    }));

    _subscriptions.add(viewModel.routesList.stream.listen((list) {
      setState(() {
        _routeList = list;
      });
    }));
  }

  void _getRoutesList() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmfromdt": convert2SmallDateTime(dashboardFromDt.toString()),
      "prmtodt": convert2SmallDateTime(dashboardToDt.toString())
    };

    printParams(params);
    viewModel.getRoutesList(params);
  }

  Future<void> onRefresh() async {
    _getRoutesList();
  }

  @override
  void dispose() {
    for (var sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: CommonColors.colorPrimary,
      onRefresh: onRefresh,
      child: (_routeList.isEmpty) == true
          ? ListView(physics: const AlwaysScrollableScrollPhysics(), children: [
              Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset("assets/map_blue.json",
                      height: isSmallDevice ? 80 : 100),
                  Text(
                    "No Routes",
                    style: TextStyle(
                        fontSize: isSmallDevice ? 14 : 18,
                        color: CommonColors.appBarColor),
                  )
                ],
              )),
            ])
          : ListView.builder(
              // physics: const AlwaysScrollableScrollPhysics(),
              // shrinkWrap: true,
              itemCount: _routeList.length,
              clipBehavior: Clip.antiAlias,
              itemBuilder: (context, index) {
                var currentData = _routeList[index];
                return DashBoardRouteTile(
                  model: currentData,
                  attendanceModel: _attendanceModel,
                  onRefresh: onRefresh,
                );
              },
            ),
    );
  }
}
