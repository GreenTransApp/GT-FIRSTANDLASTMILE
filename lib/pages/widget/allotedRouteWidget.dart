import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/home/homeViewModel.dart';
import 'package:gtlmd/tiles/dashboardRouteTile.dart';
import 'package:lottie/lottie.dart';

class AllocatedRouteWidget extends StatefulWidget {
  final List<AllotedRouteModel> routeList;
  final AttendanceModel attendanceModel;
  final Future<void> Function() onRefresh;

  const AllocatedRouteWidget(
      {super.key,
      required this.attendanceModel,
      required this.routeList,
      required this.onRefresh});

  @override
  State<AllocatedRouteWidget> createState() => _AllocatedRouteWidgetState();
}

class _AllocatedRouteWidgetState extends State<AllocatedRouteWidget> {
  List<AllotedRouteModel> _routeList = List.empty(growable: true);
  AttendanceModel _attendanceModel = AttendanceModel();
  final HomeViewModel viewModel = HomeViewModel();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _routeList = widget.routeList;
    _attendanceModel = widget.attendanceModel;
    // setObservers();
    // _getDashboardDetails();
  }

  @override
  void didUpdateWidget(covariant AllocatedRouteWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.routeList != oldWidget.routeList ||
        widget.attendanceModel != oldWidget.attendanceModel) {
      setState(() {
        _routeList = widget.routeList;
        _attendanceModel = widget.attendanceModel;
      });
    }
  }

  // void _getDashboardDetails() {
  //   // failToast('data not found');
  //   Map<String, String> params = {
  //     "prmcompanyid": savedLogin.companyid.toString(),
  //     "prmusercode": savedUser.usercode.toString(),
  //     "prmbranchcode": savedUser.loginbranchcode.toString(),
  //     "prmemployeeid": savedUser.employeeid.toString(),
  //     "prmsessionid": savedUser.sessionid.toString(),
  //   };

  //   printParams(params);
  //   viewModel.callDashboardDetail(params);
  // }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: CommonColors.colorPrimary,
      onRefresh: widget.onRefresh,
      child: Container(
        child: (_routeList.isEmpty) == true
            ? ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                    Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/map_blue.json", height: 100),
                        const Text(
                          "No Routes",
                          style: TextStyle(
                              fontSize: 18, color: CommonColors.appBarColor),
                        )
                      ],
                    )),
                  ])
            : ListView.builder(
                // physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _routeList.length,
                itemBuilder: (context, index) {
                  var currentData = _routeList[index];
                  return DashBoardRouteTile(
                    model: currentData,
                    attendanceModel: _attendanceModel,
                    onRefresh: widget.onRefresh,
                  );
                },
              ),
      ),
    );
    ;
  }
}
