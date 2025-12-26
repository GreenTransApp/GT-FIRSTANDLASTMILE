import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/routes/routeDetail/routeDetail.dart';

import 'package:gtlmd/tiles/infoItem.dart';

class DashBoardRouteTile extends StatefulWidget {
  late AllotedRouteModel model;
  late AttendanceModel attendanceModel;
  final Future<void> Function() onRefresh;

  DashBoardRouteTile({
    super.key,
    required this.model,
    required this.attendanceModel,
    required this.onRefresh,
  });

  @override
  State<DashBoardRouteTile> createState() => _DashBoardRouteTileState();
}

class _DashBoardRouteTileState extends State<DashBoardRouteTile> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(
          horizontal: isSmallDevice ? 12 : 24,
          vertical: isSmallDevice ? 8 : 16),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     side: const BorderSide(color: Colors.black
      //     )),
      child: Padding(
        padding: EdgeInsets.all(isSmallDevice ? 10.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmallDevice ? 4 : 8),
                        decoration: BoxDecoration(
                          color: CommonColors.colorPrimary!
                              .withAlpha((255 * 0.1).toInt()),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(Icons.location_on,
                            size: isSmallDevice ? 12 : 16,
                            color: CommonColors.colorPrimary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.model.routename.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isSmallDevice ? 14 : 16,
                            fontWeight: FontWeight.w500,
                            color: CommonColors.colorPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Date chip
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: CommonColors.colorPrimary!
                        .withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.model.planningdt.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: isSmallDevice ? 10 : 12,
                      color: CommonColors.colorPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Card Content
            Container(
              padding: EdgeInsets.all(isSmallDevice ? 10 : 16),
              decoration: BoxDecoration(
                color:
                    CommonColors.colorPrimary!.withAlpha((255 * 0.1).toInt()),
                border: Border.all(
                  color:
                      CommonColors.colorPrimary!.withAlpha((255 * 0.1).toInt()),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    children: [
                      InfoItem(
                        label: 'Route ID',
                        value: widget.model.planningid.toString(),
                      ),
                      InfoItem(
                        label: 'No. of Consignment',
                        value: widget.model.noofconsign.toString(),
                      ),
                    ],
                  ),
                  TableRow(
                    children: [
                      InfoItem(
                        label: 'Total Weight',
                        value: widget.model.totweight.toString(),
                      ),
                      InfoItem(
                        label: 'Total Distance',
                        value: widget.model.totdistance.toString(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // View Details Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (employeeid != null &&
                      widget.attendanceModel.attendancestatus == "Absent") {
                    failToast("Please Mark Your Attendance First");
                    return;
                  } else {
                    Get.to(() => Routedetail(model: widget.model))?.then((_) {
                      widget.onRefresh();
                    });
                  }
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
                child: employeeid != null &&
                        widget.attendanceModel.attendancestatus == "Absent"
                    ? const Text("Punch-in Required")
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_red_eye,
                            size: isSmallDevice ? 18 : 24,
                          ),
                          SizedBox(width: isSmallDevice ? 8 : 12),
                          Text(
                            "View Details",
                            style: TextStyle(fontSize: isSmallDevice ? 12 : 14),
                          ),
                        ],
                      ),
              ),
            ),

            // Show warning if user is an employee and is not punched in
            if (employeeid != null &&
                widget.attendanceModel.attendancestatus == "Absent")
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        size: 14, color: CommonColors.red600),
                    const SizedBox(width: 4),
                    Text(
                      'You must punch-in to access routes',
                      style: TextStyle(
                        fontSize: 12,
                        color: CommonColors.red600,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      // ),
    );
  }
}
