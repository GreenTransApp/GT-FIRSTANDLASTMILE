import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/bottomSheet/drsSelection/drsSelectionBottomSheet.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/tripModel.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:gtlmd/tiles/dashboardTripTile.dart';
import 'package:lottie/lottie.dart';

class AssignTripWidget extends StatefulWidget {
  final List<TripModel> deliveryList;
  final AttendanceModel attendanceModel;
  final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  final Future<void> Function() onRefresh;
  AssignTripWidget(
      {super.key,
      required this.deliveryList,
      required this.attendanceModel,
      this.onUpdate,
      required this.onRefresh});

  @override
  State<AssignTripWidget> createState() => _AssignTripWidgetState();
}

class _AssignTripWidgetState extends State<AssignTripWidget> {
  List<TripModel> _deliveryList = List.empty(growable: true);
  late AttendanceModel _attendanceModel = AttendanceModel();

  @override
  void initState() {
    super.initState();
    _deliveryList = widget.deliveryList;
    _attendanceModel = widget.attendanceModel;
  }

  @override
  void didUpdateWidget(covariant AssignTripWidget oldWidget) {
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
      child: Scaffold(
        body: Container(
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
                            "No Trips",
                            style: TextStyle(
                                fontSize: 18, color: CommonColors.appBarColor),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  // physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: _deliveryList.length,
                  itemBuilder: (context, index) {
                    var currentData = _deliveryList[index];
                    return DashboardTripTile(
                      model: currentData,
                      attendanceModel: _attendanceModel,
                      onUpdate: widget.onUpdate,
                      onRefresh: widget.onRefresh,
                    );
                  },
                ),
        ),
        persistentFooterButtons: [
          //   Container(
          //   height: 60,
          //   child: CommonButton(
          //       title: "Create New Trip".toUpperCase(),
          //       color: CommonColors.colorPrimary!,
          //       onTap: () {
          //         showDrsSelectionBottomSheet(context);
          //       }),
          // ),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDrsSelectionBottomSheet(
                  context,
                  0,
                  true,
                  widget.onRefresh,
                ).then((value) {
                  widget.onRefresh();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CommonColors.colorPrimary,
                foregroundColor: CommonColors.White,
                disabledBackgroundColor: CommonColors.grey300,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ), // Disable if not punched in
              child: const Text('Create New Trip'),
            ),
          ),
        ],
      ),
    );
  }
}
