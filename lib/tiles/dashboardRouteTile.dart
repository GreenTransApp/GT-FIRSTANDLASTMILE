import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
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
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      // shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(12),
      //     side: const BorderSide(color: Colors.black
      //     )),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding,
            vertical: SizeConfig.verticalPadding),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.smallHorizontalPadding,
                            vertical: SizeConfig.smallVerticalPadding),
                        decoration: BoxDecoration(
                          color: CommonColors.colorPrimary!
                              .withAlpha((255 * 0.1).toInt()),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(Icons.location_on,
                            size: SizeConfig.mediumIconSize,
                            color: CommonColors.colorPrimary),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.model.routename.toString(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: SizeConfig.mediumTextSize,
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
                      fontSize: SizeConfig.extraSmallTextSize,
                      color: CommonColors.colorPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.smallVerticalSpacing),

            // Card Content
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.horizontalPadding,
                  vertical: SizeConfig.verticalPadding),
              decoration: BoxDecoration(
                color:
                    CommonColors.colorPrimary!.withAlpha((255 * 0.1).toInt()),
                border: Border.all(
                  color:
                      CommonColors.colorPrimary!.withAlpha((255 * 0.1).toInt()),
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
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
                            size: SizeConfig.largeIconSize,
                          ),
                          SizedBox(width: SizeConfig.horizontalPadding),
                          Text(
                            "View Details",
                            style:
                                TextStyle(fontSize: SizeConfig.smallTextSize),
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
                        size: SizeConfig.smallIconSize,
                        color: CommonColors.red600),
                    const SizedBox(width: 4),
                    Text(
                      'You must punch-in to access routes',
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
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
