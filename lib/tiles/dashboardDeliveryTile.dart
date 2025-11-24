import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/bottomSheet/UpdateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryDetail.dart';

import 'package:gtlmd/pages/home/homeViewModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';

enum DrsStatus { OPEN, CLOSE }

enum TripStatus { open, close }

class DashBoardDeliveryTile extends StatefulWidget {
  late CurrentDeliveryModel model;
  // late AttendanceModel attendanceModel;
  // final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  final Future<void> Function() onRefresh;
  final bool showHeader;
  final bool showInfo;
  final bool showCheckboxSelection;
  final bool showStatusIndicators;
  final bool enableTap;
  final Future<void> Function(CurrentDeliveryModel data, bool isSelected)?
      onCheckChange;

  DashBoardDeliveryTile({
    super.key,
    required this.model,
    // required this.attendanceModel,
    // this.onUpdate,
    required this.onRefresh,
    required this.showHeader,
    required this.showInfo,
    required this.showCheckboxSelection,
    required this.showStatusIndicators,
    required this.enableTap,
    this.onCheckChange,
  });

  @override
  State<DashBoardDeliveryTile> createState() => DashBoardDeliveryTileState();
}

class DashBoardDeliveryTileState extends State<DashBoardDeliveryTile> {
  final HomeViewModel viewModel = HomeViewModel();
  late CurrentDeliveryModel currentDeliveryModel;
  // late AttendanceModel attendanceModel;

  @override
  void didUpdateWidget(covariant DashBoardDeliveryTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    // if (widget.model != oldWidget.model ||
    //     widget.attendanceModel != oldWidget.attendanceModel) {
    //   setState(() {
    //     currentDeliveryModel = widget.model;
    //     // attendanceModel = widget.attendanceModel;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
        onTap: () {
          // if (employeeid != null &&
          //     widget.attendanceModel.attendancestatus == "Absent") {
          //   failToast("Please Mark Your Attendance First");
          //   return;
          // } else if (isNullOrEmpty(widget.model.dispatchdatetime!)) {
          //   failToast("Please update dispatch time first");
          //   return;
          // } else {
          if (widget.enableTap) {
            Get.to(DeliveryDetail(
              model: widget.model,
            ))?.then((_) => {widget.onRefresh()});
          }
          // }
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
                if (widget.showHeader) _buildHeader(context, theme),

                // Card content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DRS Number row
                      _buildInfoRow(
                        label: 'DRS#',
                        value: widget.model.drsno.toString(),
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

                      // Total indicator
                      if (!widget.showStatusIndicators)
                        _buildInfoRow(
                            label: "Total",
                            value: widget.model.noofconsign.toString(),
                            theme: theme)
                    ],
                  ),
                ),
                // }

                Visibility(
                    visible: widget.showStatusIndicators,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildStatusIndicators(theme)
                      ],
                    ))
              ],
            ),
          ),
        ));
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      color: CommonColors.colorPrimary!.withOpacity(0.05),
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          widget.showCheckboxSelection == true
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Checkbox(
                          activeColor: CommonColors.colorPrimary,
                          value: widget.model.tripconfirm,
                          onChanged: (bool? value) {
                            setState(() {
                              widget.model.tripconfirm = value;
                            });
                            if (widget.onCheckChange != null && value != null) {
                              widget.onCheckChange!(widget.model, value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Dispatch Time',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // isNullOrEmpty(widget.model.dispatchdatetime) ?
                    // InkWell(
                    //   onTap: () => {
                    //     // showModalBottomSheet(
                    //     //     context: context,
                    //     //     // isScrollControlled: true,
                    //     //     elevation: 10,
                    //     //     // showDragHandle: true,
                    //     //     builder: (context) {
                    //     //       return DispatchTimeBottomSheet(
                    //     //         // drsNumber: widget.model.drsno.toString(),
                    //     //         // date: widget.model.dispatchdt!,
                    //     //         // time: widget.model.dispatchtime!,
                    //     //         model: widget.model,
                    //     //         // onUpdate: widget.onUpdate,
                    //     //         status: DrsStatus.OPEN,
                    //     //         // isClosing: false,
                    //     //       );
                    //     //     })
                    //   },
                    //   borderRadius: BorderRadius.circular(30),
                    //   child: Container(
                    //     padding: const EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //       color: CommonColors.colorPrimary!.withOpacity(0.1),
                    //       shape: BoxShape.circle,
                    //     ),
                    //     child: Icon(
                    //       Icons.schedule_rounded,
                    //       color: CommonColors.colorPrimary,
                    //       size: 22,
                    //     ),
                    //   ),
                    // ) :
                    Expanded(
                        child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                                "${widget.model.dispatchdatetime.toString()}")))
                  ],
                ),
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

  Widget _buildStatusIndicators(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for the status section
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Delivery Status',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Status grid
        Row(
          children: [
            _buildStatusItem(
              label: 'Total',
              value: widget.model.noofconsign.toString(),
              color: CommonColors.colorPrimary!,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Delivered',
              value: widget.model.deliveredconsign.toString(),
              color: Colors.green,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Undelivered',
              value: widget.model.undeliveredconsign.toString(),
              color: Colors.red,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Pending',
              value: widget.model.pendingconsign.toString(),
              color: Colors.orange,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Pickup',
              value: widget.model.totpickup.toString(),
              color: CommonColors.colorPrimary!,
              theme: theme,
            ),
          ],
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                  color: color.withOpacity(0.8),
                  overflow: TextOverflow.ellipsis),
              // style: theme.textTheme.bodySmall?.copyWith(
              //   color: color.withOpacity(0.8),

              // ),
            ),
          ],
        ),
      ),
    );
  }
}
