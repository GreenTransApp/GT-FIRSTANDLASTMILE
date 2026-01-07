import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';

import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:lottie/lottie.dart';

class CurrentDeliveryWidget extends StatefulWidget {
  final List<CurrentDeliveryModel> deliveryList;
  final AttendanceModel attendanceModel;
  final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  final Future<void> Function() onRefresh;

  const CurrentDeliveryWidget(
      {super.key,
      required this.deliveryList,
      required this.attendanceModel,
      this.onUpdate,
      required this.onRefresh});

  @override
  State<CurrentDeliveryWidget> createState() => _CurrentDeliveryWidgetState();
}

class _CurrentDeliveryWidgetState extends State<CurrentDeliveryWidget> {
  List<CurrentDeliveryModel> _deliveryList = List.empty(growable: true);
  late AttendanceModel _attendanceModel = AttendanceModel();

  @override
  void initState() {
    super.initState();
    _deliveryList = widget.deliveryList;
    _attendanceModel = widget.attendanceModel;
  }

  @override
  void didUpdateWidget(covariant CurrentDeliveryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.deliveryList != oldWidget.deliveryList ||
        widget.attendanceModel != oldWidget.attendanceModel) {
      setState(() {
        _deliveryList = widget.deliveryList;
        _attendanceModel = widget.attendanceModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: CommonColors.colorPrimary,
      onRefresh: widget.onRefresh,
      child: Container(
          child: (_deliveryList.isEmpty) == true
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
                            "No Deliveries",
                            style: TextStyle(
                                fontSize: 18, color: CommonColors.appBarColor),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text("Test"),
                )
          // ListView.builder(
          //     shrinkWrap: true,
          //     // physics: const AlwaysScrollableScrollPhysics(),
          //     itemCount: _deliveryList.length,
          //     itemBuilder: (context, index) {
          //       var currentData = _deliveryList[index];
          //       return DashBoardDeliveryTile(
          //         model: currentData,
          //         // attendanceModel: _attendanceModel,
          //         // onUpdate: widget.onUpdate,
          //         onRefresh: widget.onRefresh,
          //         showHeader: true,
          //         showInfo: true,
          //         showCheckboxSelection: false,
          //         showStatusIndicators: true,
          //         enableTap: true,
          //       );
          //     },
          //   ),
          ),
    );
  }
}
