import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/routesList/routesListViewModel.dart';
import 'package:gtlmd/tiles/dashboardRouteTile.dart';
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
  State<AllocatedRouteWidget> createState() => _AllocatedRouteWidgetState();
}

class _AllocatedRouteWidgetState extends State<AllocatedRouteWidget> {
  final RoutesListViewModel viewModel = RoutesListViewModel();
  List<AllotedRouteModel> _routeList = List.empty(growable: true);
  AttendanceModel _attendanceModel = AttendanceModel();
  late LoadingAlertService loadingAlertService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    _attendanceModel = widget.attendanceModel;
    _getRoutesList();
  }

  setObservers() {
    // viewModel.viewDialog.stream.listen((show) {
    //   if (show) {
    //     loadingAlertService.showLoading();
    //   } else {
    //     loadingAlertService.hideLoading();
    //   }
    // });

    viewModel.errorDialog.stream.listen((error) {
      failToast(error);
    });

    viewModel.routesList.stream.listen((list) {
      _routeList = list;
      setState(() {});
    });
  }

  void _getRoutesList() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    viewModel.getRoutesList(params);
  }

  Future<void> onRefresh() async {
    _getRoutesList();
  }

  @override
  Widget build(BuildContext context) {
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
