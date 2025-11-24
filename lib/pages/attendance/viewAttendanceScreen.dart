import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/pages/attendance/attendanceViewModel.dart';
import 'package:gtlmd/tiles/viewAttendanceTile.dart';
import 'package:intl/intl.dart';
import 'package:gtlmd/pages/attendance/models/viewAttendanceModel.dart';

import '../../Common/TextFormatter/UpperCaseTextFormatter.dart';

class viewAttendanceScreen extends StatefulWidget {
  const viewAttendanceScreen({super.key});

  @override
  State<viewAttendanceScreen> createState() => _viewAttendanceScreenState();
}

class _viewAttendanceScreenState extends State<viewAttendanceScreen> {
  late LoadingAlertService loadingAlertService;

  TextEditingController searchController = TextEditingController();
  List<viewAttendanceModel> viewAttendanceList = List.empty(growable: true);
  late GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  AttendanceViewModel viewModel = AttendanceViewModel();
  late DateTime todayDateTime;
  late String smallDateTime;
  String fromDt = "";
  String toDt = "";
  bool showProgressBar = false;
  @override
  void initState() {
    super.initState();

    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      loadingAlertService = LoadingAlertService(context: context);
    });
    setobserve();
    _callViewAttendance();
  }

  void setobserve() {
    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });
    viewModel.viewAttendanceListLiveData.stream.listen((viewAttendance) {
      debugPrint(viewAttendance.elementAt(0).attendancestatus);
      if (viewAttendance.elementAt(0).commandstatus == 1) {
        setState(() {
          viewAttendanceList = viewAttendance;
        });
      }
    });
    viewModel.isErrorLiveData.stream.listen((error) {
      failToast(error);
    });
  }

  void _callViewAttendance() {
    setState(() {
      viewAttendanceList.clear();
    });
    Map<String, String> params = {
      "prmconnstring": savedLogin.companyid.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmfromdt": fromDt,
      "prmtodt": toDt,
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": 'GTAPP_ATTENDANCE',
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.callViewAttendanceDetails(params);
  }

  void _dateChanged(String fromDt, String toDt) {
    this.fromDt = fromDt;
    this.toDt = toDt;
    debugPrint("fromdate${{fromDt}}");
    _callViewAttendance();
  }

  Future<void> refreshIndicatorFunc() async {
    setState(() {
      _callViewAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          elevation: 0,
          title: Text(
            "View Attendance".toUpperCase(),
            style: TextStyle(color: CommonColors.white),
          ),
          systemOverlayStyle: CommonColors.systemUiOverlayStyle,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
                color: CommonColors.white,
              )),
          actions: [
            IconButton(
              onPressed: () {
                showDatePickerBottomSheet(context, _dateChanged);
              },
              icon: Icon(
                Icons.calendar_month_rounded,
                size: 30,
                color: CommonColors.white,
              ),
              tooltip: 'Period Selection',
            ),
          ],
        ),
        body: RefreshIndicator(
          color: CommonColors.white,
          backgroundColor: CommonColors.colorPrimary,
          onRefresh: refreshIndicatorFunc,
          child: Stack(children: [
            Container(
              child: Column(
                children: [
                  // Container(
                  //   color: CommonColors.colorPrimary,~
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(15),
                  //     child: TextField(
                  //       controller: searchController,
                  //       inputFormatters: [UpperCaseTextFormatter()],
                  //       keyboardType: TextInputType.multiline,
                  //       cursorColor: Colors.black,
                  //       obscureText: false,
                  //       decoration: InputDecoration(
                  //         prefixIcon: const Icon(
                  //           Icons.search,
                  //           color: Colors.grey,
                  //         ),
                  //         suffixIcon: IconButton(
                  //           onPressed: searchController.clear,
                  //           icon: const Icon(Icons.clear),
                  //         ),
                  //         filled: true,
                  //         fillColor: Colors.white,
                  //         // hintText:,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                      child: ListView.separated(
                    itemCount: viewAttendanceList.length,
                    itemBuilder: (context, index) {
                      var currentAttendance = viewAttendanceList[index];
                      debugPrint(currentAttendance.fulldt.toString());
                      return
                          // viewAttendanceTile(viewAttModel: currentAttendance);
                          showProgressBar
                              ? CircularProgressIndicator()
                              : viewAttendanceTile(
                                  viewAttModel: currentAttendance);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.white,
                        height: 1,
                      );
                    },
                  ))
                  // AttendanceTile()
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
