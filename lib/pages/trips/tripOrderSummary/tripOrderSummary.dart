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
    // createDummyData();
  }

  // createDummyData() {
  //   ordersList = [
  //     TripOrderSummaryModel(
  //       grno: "GRN-001",
  //       ordertype: "Pickup",
  //       dispatchdt: "2023-01-01",
  //       dispatchtime: "10:00 AM",
  //       orderStatus: "Pending",
  //     ),
  //     TripOrderSummaryModel(
  //       grno: "GRN-002",
  //       ordertype: "Delivery",
  //       dispatchdt: "2023-01-01",
  //       dispatchtime: "10:00 AM",
  //       orderStatus: "Delivered",
  //     ),
  //     TripOrderSummaryModel(
  //       grno: "GRN-003",
  //       ordertype: "Reverse Pickup",
  //       dispatchdt: "2023-01-01",
  //       dispatchtime: "10:00 AM",
  //       orderStatus: "Picked",
  //     ),
  //     TripOrderSummaryModel(
  //       grno: "GRN-001",
  //       ordertype: "Pickup",
  //       dispatchdt: "2023-01-01",
  //       dispatchtime: "10:00 AM",
  //       orderStatus: "Un-Picked",
  //     ),
  //     TripOrderSummaryModel(
  //       grno: "GRN-002",
  //       ordertype: "Delivery",
  //       dispatchdt: "2023-01-01",
  //       dispatchtime: "10:00 AM",
  //       orderStatus: "Un-Delivered",
  //     ),
  //     TripOrderSummaryModel(
  //       grno: "GRN-003",
  //       ordertype: "Reverse Pickup",
  //       dispatchdt: "2023-01-01",
  //       dispatchtime: "10:00 AM",
  //       orderStatus: "Pending",
  //     ),
  //   ];
  //   setState(() {});
  // }

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
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmtripid": widget.tripModel.tripid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };
    viewModel.getOrdersList(params);
  }

  Widget infoItem(
      String heading,
      String value,
      //  String status,
      CrossAxisAlignment crossAxisAlignment) {
    Color textColor = CommonColors.colorPrimary!;
    // if (status == "Picked") {
    //   textColor = CommonColors.colorPrimary!;
    // } else if (status == "Un-Picked") {
    //   textColor = CommonColors.colorPrimary!;
    // } else if (status == "Delivered") {
    //   textColor = CommonColors.green600!;
    // } else if (status == "Un-Delivered") {
    //   textColor = CommonColors.red600!;
    // } else if (status == "Pending") {
    //   textColor = CommonColors.amber500!;
    // }
    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Text(
          heading,
          style: const TextStyle(
              color: CommonColors.appBarColor, fontWeight: FontWeight.normal),
        ),
        Text(
          value,
          style: const TextStyle(
              color: CommonColors.appBarColor, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget orderInfo(TripOrderSummaryModel model, int index) {
    Color backgroundColor =
        CommonColors.colorPrimary!.withAlpha((0.2 * 255).round());
    // if (model.orderStatus == "Picked") {
    //   backgroundColor =
    //       CommonColors.colorPrimary!.withAlpha((0.2 * 255).round());
    // } else if (model.orderStatus == "Un-Picked") {
    //   backgroundColor =
    //       CommonColors.colorPrimary!.withAlpha((0.2 * 255).round());
    // } else if (model.orderStatus == "Delivered") {
    //   backgroundColor = CommonColors.green200!.withAlpha((0.6 * 255).round());
    // } else if (model.orderStatus == "Un-Delivered") {
    //   backgroundColor = CommonColors.red200!.withAlpha((0.6 * 255).round());
    // } else if (model.orderStatus == "Pending") {
    //   backgroundColor = CommonColors.amber200!.withAlpha((0.6 * 255).round());
    // }
    Color dotColor = CommonColors.colorPrimary!.withAlpha((0.2 * 255).round());
    // if (model.orderStatus == "Picked") {
    //   dotColor = CommonColors.colorPrimary!;
    // } else if (model.orderStatus == "Un-Picked") {
    //   dotColor = CommonColors.colorPrimary!;
    // } else if (model.orderStatus == "Delivered") {
    //   dotColor = CommonColors.green600!;
    // } else if (model.orderStatus == "Un-Delivered") {
    //   dotColor = CommonColors.red600!;
    // } else if (model.orderStatus == "Pending") {
    //   dotColor = CommonColors.amber500!;
    // }

    if (model.consignmenttype == "R") {
      switch (model.reversepickupstatus) {
        case "U":
          // status = "Un-Picked";
          dotColor = CommonColors.colorPrimary!;
          // cardBorderColor = CommonColors.colorPrimary!;
          backgroundColor =
              CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          // statusIcon = Icons.cancel;
          // statusIconColor = CommonColors.colorPrimary!;
          break;
        case "D":
          // status = "Picked";
          dotColor = CommonColors.colorPrimary!;
          backgroundColor = CommonColors.colorPrimary!;
          // cardBgColor =
          //     CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          // statusIcon = Icons.check_circle;
          // statusIconColor = CommonColors.colorPrimary!;
          break;
        case "P":
          // status = "Pending";
          dotColor = CommonColors.colorPrimary!;
          backgroundColor = CommonColors.colorPrimary!;
          // cardBorderColor = CommonColors.colorPrimary!;
          // cardBgColor =
          //     CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          // statusIcon = Icons.access_time;
          // statusIconColor = CommonColors.colorPrimary!;
          break;
      }
    } else if (model.consignmenttype == 'D' || model.consignmenttype == 'U') {
      switch (model.deliverystatus) {
        case "U":
          // status = "Undelivered";
          dotColor = CommonColors.red500!;
          backgroundColor = CommonColors.red50!;
          // statusIcon = Icons.cancel;
          // statusIconColor = CommonColors.red500!;
          break;
        case "D":
          // status = "Delivered";
          dotColor = CommonColors.green500!;
          backgroundColor = CommonColors.green50!;
          // statusIcon = Icons.check_circle;
          // statusIconColor = CommonColors.green500!;
          break;
        case "P":
          // status = "Pending";
          dotColor = CommonColors.amber500!;
          backgroundColor = CommonColors.amber50!;
          // statusIcon = Icons.access_time;
          // statusIconColor = CommonColors.amber500!;
          break;
      }
    } else {
      switch (model.pickupstatus) {
        // case "U":
        //   status = "Undelivered";
        //   dotColor = CommonColors.red500!;
        //   cardBorderColor = CommonColors.red500!;
        //   cardBgColor = CommonColors.red50!;
        //   statusIcon = Icons.cancel;
        //   statusIconColor = CommonColors.red500!;
        //   break;
        case "D":
          // status = "Picked";
          dotColor = CommonColors.green500!;
          backgroundColor = CommonColors.green50!;
          // statusIcon = Icons.check_circle;
          // statusIconColor = CommonColors.green500!;
          break;
        case "P":
          // status = "Pending";
          dotColor = CommonColors.amber500!;
          backgroundColor = CommonColors.amber50!;
          // statusIcon = Icons.access_time;
          // statusIconColor = CommonColors.amber500!;
          break;
        default:
          // status = "Pending";
          dotColor = CommonColors.amber500!;
          backgroundColor = CommonColors.amber50!;
          break;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TimelineTile(
        isFirst: index == 0,
        isLast: index == ordersList.length - 1,
        beforeLineStyle: LineStyle(
          color: dotColor,
          thickness: 2,
        ),
        afterLineStyle: LineStyle(
          color: dotColor,
          thickness: 2,
        ),
        indicatorStyle: IndicatorStyle(
          height: 15,
          width: 15,
          indicator: Container(
            // margin: const EdgeInsets.only(top: 20),
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        endChild: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(width: 1, color: backgroundColor),
                borderRadius: BorderRadiusGeometry.circular(12)),
            child: Column(
              children: [
                Row(children: [
                  Text(
                    "${(index + 1).toString()}#",
                    style: const TextStyle(
                        color: CommonColors.appBarColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ]),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                        child: infoItem(
                      "GR-NO",
                      model.grno.toString(),
                      // model.orderStatus.toString(),
                      CrossAxisAlignment.start,
                    )),
                    Expanded(
                        child: infoItem(
                      "Date",
                      "Chale?",
                      // model.orderStatus.toString(),
                      CrossAxisAlignment.end,
                    )),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                        child: infoItem(
                      "Order Type",
                      model.consignmenttype == "R"
                          ? "Reverse"
                          : model.consignmenttype == "D"
                              ? "Delivery"
                              : "Pickup",
                      // model.ordertype.toString(),
                      // model.orderStatus.toString(),
                      CrossAxisAlignment.start,
                    )),
                    // Expanded(
                    //     child: infoItem(
                    //   "Status",
                    //   model.orderStatus.toString(),
                    //   model.orderStatus.toString(),
                    //   CrossAxisAlignment.end,
                    // )),
                  ],
                )
              ],
            ),
          ),
        ),
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
