import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummaryModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummaryViewModel.dart';

import 'package:timeline_tile/timeline_tile.dart';

// ignore: must_be_immutable
class TripORdersSummary extends StatefulWidget {
  TripModel tripModel;
  TripORdersSummary({required this.tripModel, super.key});

  @override
  State<TripORdersSummary> createState() => _TripORdersSummaryState();
}

class _TripORdersSummaryState extends State<TripORdersSummary> {
  TripOrderSummaryViewModel viewModel = TripOrderSummaryViewModel();
  late LoadingAlertService loadingAlertService;
  List<TripOrderSummaryModel> ordersList = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    getOrdersList();
  }

  setObservers() {
    // viewModel.viewDialog.stream.listen((showLoading) {
    //   if (showLoading) {
    //     loadingAlertService.showLoading();
    //   } else {
    //     loadingAlertService.hideLoading();
    //   }
    // });

    viewModel.errorDialog.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.ordersList.stream.listen((list) {
      ordersList = list;
      setState(() {});
    });
  }

  getOrdersList() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmtripid": widget.tripModel.tripid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };
    viewModel.getOrdersList(params);
  }

  Widget orderInfo(TripOrderSummaryModel model, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TimelineTile(
        isFirst: index == 0,
        isLast: index == ordersList.length - 1,
        endChild: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
                border: Border.all(width: 1),
                borderRadius: BorderRadiusGeometry.circular(12)),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      model.grno.toString(),
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      model.ordertype.toString(),
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        beforeLineStyle: const LineStyle(color: Colors.black, thickness: 4),
        afterLineStyle: const LineStyle(color: Colors.black, thickness: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        title: Text(
          "Trip Order Summary",
          style: TextStyle(color: CommonColors.White),
        ),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return orderInfo(ordersList[index], index);
        },
        itemCount: ordersList.length ?? 0,
      ),
    );
  }
}
