import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/deliveryPerformanceViewModel.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/model/deliveryPerformanceSummaryModel.dart';
import 'package:gtlmd/optionMenu/tripMis/Model/tripMisJsonPramas.dart';
import 'package:gtlmd/tiles/deliveryPerformanceTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../common/Colors.dart';
import '../../design_system/size_config.dart';

class DeliveryPerformanceSummary extends StatefulWidget {
  final String title;
  final String fromDt;
  final String toDt;
  const DeliveryPerformanceSummary({super.key, required this.title, required this.fromDt, required this.toDt});

  @override
  State<DeliveryPerformanceSummary> createState() =>
      _DeliveryPerformanceSummaryState();
}

class _DeliveryPerformanceSummaryState
    extends State<DeliveryPerformanceSummary> {
  List<DeliveryPerformanceSummaryModel> performanceSummaryList =
      List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  DeliveryPerformanceViewModel viewModel = DeliveryPerformanceViewModel();
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
    getDeliveryPerformanceData();
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

    viewModel.performanceSummaryData.stream.listen((data) {
      setState(() {
        performanceSummaryList = data;
      });
    });
  }

  getDeliveryPerformanceData() {
    final LiveDataJsonParams parameters = LiveDataJsonParams(
        fromdt: convert2SmallDateTime(widget.fromDt.toString()),
        todt: convert2SmallDateTime(widget.toDt.toString()),
        branchname: 'ALL',
        branchcode: 'ALL',
        ridername: savedUser.username.toString(),
        ridercode: savedUser.drivercode.toString(),
        drsno: null,
        cnno: null,
        hourtype: widget.title);

    Map<String, dynamic> params = {
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmlogindivisionid": savedUser.logindivisionid.toString(),
      "prmjsondatastr": jsonEncode(parameters.toJson()),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": "GTI_LMDLIVEDASHBOARD",
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.getPerformanceData(params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: CommonColors.white,
            size: SizeConfig.largeIconSize,
          ),
        ),
        title: Text(
          '${widget.title}  Hour Summary',
          style: TextStyle(
              color: CommonColors.white,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.largeTextSize),
        ),
        actions: [
         ]
      ),
      body: Container(
        child: (performanceSummaryList.isEmpty) == true
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
                    "Data Not Found",
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
          itemCount: performanceSummaryList.length,
          itemBuilder: (context, index) {
            var data = performanceSummaryList[index];
            return DeliveryPerformanceSummaryTile(model: data);
          },
        ),

        ),
      );
  }
}
