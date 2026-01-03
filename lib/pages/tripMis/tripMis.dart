import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/pages/tripMis/Model/tripMisJsonPramas.dart';
import 'package:gtlmd/pages/tripMis/Model/tripMisModel.dart';
import 'package:gtlmd/pages/tripMis/tripMisViewModel.dart';
import 'package:gtlmd/tiles/tripMisTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class TripMis extends StatefulWidget {
  const TripMis({super.key});

  @override
  State<TripMis> createState() => _TripMisState();
}

class _TripMisState extends State<TripMis> {
  List<TripMisModel> _tripList = List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  TripMisViewModel viewModel = TripMisViewModel();
  String fromDt = "";
  String toDt = "";
  String viewFromDt = "";
  String viewToDt = "";
  String formattedDate = '';
  late DateTime todayDateTime;
  late String smallDateTime;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
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
    setObservers();
    onRefresh();
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

  Future<void> onRefresh() async {
    getTripMISList();
  }

  getTripMISList() {
    final TripMisJsonParams parameters = TripMisJsonParams(
        fromdt: convert2SmallDateTime(fromDt.toString()),
        todt: convert2SmallDateTime(toDt.toString()),
        branchname: 'ALL',
        branchcode: 'ALL',
        ridername: savedUser.username.toString(),
        ridercode: savedUser.drivercode.toString(),
        drsno: null,
        cnno: null);

    Map<String, dynamic> params = {
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmlogindivisionid": "0",
      "prmjsondatastr": jsonEncode(parameters.toJson()),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": "GTI_LMDLIVEDASHBOARD",
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.getTripMIS(params);
  }

  void _dateChanged(String fromDt, String toDt) {
    // debugPrint("fromDt ${fromDt}");
    // debugPrint("toDt ${toDt}");

    this.fromDt = fromDt;
    this.toDt = toDt;

    DateTime fromdt = DateTime.parse(this.fromDt);
    DateTime todt = DateTime.parse(this.toDt);

    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: CommonColors.colorPrimary,
      onRefresh: onRefresh,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: CommonColors.white,
                ));
          }),
          title: Text(
            'Trip MIS',
            style: TextStyle(
              color: CommonColors.white,
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                showDatePickerBottomSheet(context, _dateChanged);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.calendar_today_rounded,
                  color: CommonColors.white,
                ),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {
                      showDatePickerBottomSheet(context, _dateChanged);
                    },
                    icon: Icon(Icons.calendar_today,
                        size: 16, color: CommonColors.colorPrimary),
                    label: Text('$viewFromDt - $viewToDt',
                        style: TextStyle(color: CommonColors.colorPrimary)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      side: BorderSide(color: CommonColors.colorPrimary!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
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
                                const Text(
                                  "No Trips",
                                  style: TextStyle(
                                      fontSize: 18,
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
                          return TripMisTile(
                            model: currentData,
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
