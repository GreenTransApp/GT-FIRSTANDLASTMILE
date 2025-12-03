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
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                      Icon(Icons.location_on,
                          size: 16, color: CommonColors.colorPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.model.routename.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
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
                      fontSize: 12,
                      color: CommonColors.colorPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Card Content
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.5,
              crossAxisSpacing: 16,
              mainAxisSpacing: 8,
              children: [
                InfoItem(
                    label: 'Route ID',
                    value: isNullOrEmpty(widget.model.planningid.toString())
                        ? "Data not found"
                        : widget.model.planningid.toString()),
                InfoItem(
                    label: 'No. of Consignment',
                    value: isNullOrEmpty(widget.model.noofconsign.toString())
                        ? "Data not found"
                        : widget.model.noofconsign.toString()),
                InfoItem(
                    label: 'Total Weight',
                    value: isNullOrEmpty(widget.model.totweight)
                        ? "Data not found"
                        : widget.model.totweight.toString()),
                InfoItem(
                    label: 'Total Distance',
                    value: isNullOrEmpty(widget.model.totdistance.toString())
                        ? "Data not found"
                        : widget.model.totdistance.toString()),
              ],
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
                child: Text(employeeid != null &&
                        widget.attendanceModel.attendancestatus == "Absent"
                    ? 'Punch-in Required'
                    : 'View Details'),
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
