import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/bottomSheet/UpdateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/homeViewModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/tripModel.dart';
import 'package:gtlmd/pages/tripSummary/tripSummary.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';

class DashboardTripTile extends StatefulWidget {
  late TripModel model;
  late AttendanceModel attendanceModel;
  final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  final Future<void> Function() onRefresh;
  DashboardTripTile(
      {super.key,
      required this.model,
      required this.attendanceModel,
      this.onUpdate,
      required this.onRefresh});

  @override
  State<DashboardTripTile> createState() => _DashboardTripTileState();
}

class _DashboardTripTileState extends State<DashboardTripTile> {
  final HomeViewModel viewModel = HomeViewModel();
  late TripModel tripModel;
  late AttendanceModel attendanceModel;

  @override
  void didUpdateWidget(covariant DashboardTripTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model ||
        widget.attendanceModel != oldWidget.attendanceModel) {
      setState(() {
        tripModel = widget.model;
        attendanceModel = widget.attendanceModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
        onTap: () {
          if (employeeid != null &&
              widget.attendanceModel.attendancestatus == "Absent") {
            failToast("Please Mark Your Attendance First");
            return;
          } else if (isNullOrEmpty(widget.model.tripdispatchdatetime)) {
            failToast("Please update dispatch time first");
            return;
          } else {
            Get.to(TripSummary(model: widget.model))
                ?.then((_) => {widget.onRefresh()});
          }
        },
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: CommonColors.grey200!),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                // Header with dispatch time and edit button
                _buildHeader(context, theme),

                // Card content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DRS Number row
                      _buildInfoRow(
                        label: 'Trip ID ',
                        value: widget.model.tripid.toString(),
                        theme: theme,
                        isHighlighted: true,
                      ),

                      const SizedBox(height: 12),

                      // Date row
                      _buildInfoRow(
                        label: 'Date',
                        value: widget.model.manifestdatetime.toString(),
                        theme: theme,
                      ),
                      const SizedBox(height: 12),

                      // KM row
                      _buildInfoRow(
                        label: 'Starting KM',
                        value: widget.model.startreadingkm.toString(),
                        theme: theme,
                      ),

                      const SizedBox(height: 12),

                      // Date row
                      _buildInfoRow(
                        label: 'Total Consignments',
                        value: widget.model.totalconsignment.toString(),
                        theme: theme,
                      ),
                      const SizedBox(height: 12),

                      // Date row
                      _buildInfoRow(
                        label: 'Pending ',
                        value: widget.model.pendingconsignment.toString(),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),
                      Visibility(
                        visible: widget.model.tripdispatchdatetime != null &&
                            widget.model.pendingconsignment == 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Close Trip",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  openUpdateTripInfo(context, widget.model,
                                          TripStatus.close, widget.onRefresh)
                                      .then((value) {
                                    widget.onRefresh();
                                  });
                                },
                                icon: Icon(
                                  Icons.cancel_outlined,
                                  color: CommonColors.dangerColor!,
                                  size: 25,
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(children: [
                        _buildStatusItem(
                          label: 'Total DRS',
                          value: widget.model.totaldrs.toString(),
                          color: CommonColors.colorPrimary!,
                          theme: theme,
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      color: CommonColors.colorPrimary!.withOpacity(0.05),
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dispatch Time',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          isNullOrEmpty(widget.model.tripdispatchdatetime)
              ? InkWell(
                  onTap: () => {
                    openUpdateTripInfo(context, widget.model, TripStatus.open,
                            widget.onRefresh)
                        .then((value) {
                      widget.onRefresh();
                    })
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CommonColors.colorPrimary!.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.schedule_rounded,
                      color: CommonColors.colorPrimary,
                      size: 22,
                    ),
                  ),
                )
              : Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child:
                          Text(widget.model.tripdispatchdatetime.toString())))
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required ThemeData theme,
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            "${label}",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ': ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isHighlighted ? CommonColors.colorPrimary : Colors.black87,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem({
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: color.withOpacity(0.8),
                  overflow: TextOverflow.ellipsis),
              // style: theme.textTheme.bodySmall?.copyWith(
              //   color: color.withOpacity(0.8),

              // ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
