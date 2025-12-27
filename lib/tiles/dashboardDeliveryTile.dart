import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryDetail.dart';

import 'package:gtlmd/pages/home/homeViewModel.dart';

enum DrsStatus { OPEN, CLOSE }

enum TripStatus { open, close }

class DashBoardDeliveryTile extends StatefulWidget {
  late CurrentDeliveryModel model;
  late TripModel tripModel;
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
    required this.tripModel,
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
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

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
              // model: widget.model,
              tripModel: widget.tripModel,
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
                if (widget.showHeader)
                  _buildHeader(context, theme, isSmallDevice),

                // Card content
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      isSmallDevice ? 12 : 20, 12, isSmallDevice ? 12 : 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DRS Number row
                      _buildInfoRow(
                        label: 'DRS#',
                        value: isNullOrEmpty(widget.model.manifestno.toString())
                            ? ""
                            : widget.model.manifestno.toString(),
                        theme: theme,
                        isHighlighted: true,
                        isSmallDevice: isSmallDevice,
                      ),

                      const SizedBox(height: 12),

                      // Date row
                      _buildInfoRow(
                        label: 'Date',
                        value:
                            isNullOrEmpty(widget.model.manifestdate.toString())
                                ? ""
                                : widget.model.manifestdate.toString(),
                        theme: theme,
                        isSmallDevice: isSmallDevice,
                      ),
                      const SizedBox(height: 12),

                      // _buildInfoRow(
                      //   label: 'Type',
                      //   value: widget.model.ordertype == 'P'
                      //       ? 'Pickup'
                      //       : widget.model.ordertype == 'R'
                      //           ? 'Reverse Pickup'
                      //           : 'Delivery',
                      //   theme: theme,
                      // ),
                      // const SizedBox(height: 12),

                      // Total indicator
                      if (!widget.showStatusIndicators)
                        _buildInfoRow(
                            label: "Total",
                            value: isNullOrEmpty(
                                    widget.model.noofconsign.toString())
                                ? ""
                                : widget.model.noofconsign.toString(),
                            theme: theme,
                            isSmallDevice: isSmallDevice)
                    ],
                  ),
                ),
                // }

                Visibility(
                    visible: widget.showStatusIndicators,
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _buildStatusIndicators(theme, isSmallDevice)
                      ],
                    ))
              ],
            ),
          ),
        ));
  }

  Widget _buildHeader(
      BuildContext context, ThemeData theme, bool isSmallDevice) {
    return Container(
      color: CommonColors.colorPrimary!.withOpacity(0.05),
      padding: EdgeInsets.fromLTRB(
          isSmallDevice ? 12 : 20, 16, isSmallDevice ? 12 : 16, 4),
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
                          fontSize: isSmallDevice ? 14 : 16),
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
                              isNullOrEmpty(
                                      widget.model.dispatchtime.toString())
                                  ? ""
                                  : widget.model.dispatchtime.toString(),
                              style:
                                  TextStyle(fontSize: isSmallDevice ? 12 : 14),
                            )))
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
    required bool isSmallDevice,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: isSmallDevice ? 100 : 140,
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
              fontSize: isSmallDevice ? 12 : 14,
            ),
          ),
        ),
        Text(
          ': ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
            fontSize: isSmallDevice ? 12 : 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isHighlighted ? CommonColors.colorPrimary : Colors.black87,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
              fontSize: isSmallDevice ? 12 : 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicators(ThemeData theme, bool isSmallDevice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for the status section
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Status',
            style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600, fontSize: isSmallDevice ? 12 : 14),
          ),
        ),

        // Status grid
        Visibility(
          visible: widget.model.manifesttype == 'D',
          child: Row(
            children: [
              _buildStatusItem(
                label: 'Total',
                value: isNullOrEmpty(widget.model.noofconsign.toString())
                    ? ""
                    : widget.model.noofconsign.toString(),
                color: CommonColors.colorPrimary!,
                theme: theme,
                isSmallDevice: isSmallDevice,
              ),
              _buildStatusItem(
                label: 'Delivered',
                value: isNullOrEmpty(widget.model.deliveredconsign.toString())
                    ? ""
                    : widget.model.deliveredconsign.toString(),
                color: Colors.green,
                theme: theme,
                isSmallDevice: isSmallDevice,
              ),
              _buildStatusItem(
                label: 'Undelivered',
                value: isNullOrEmpty(widget.model.undeliveredconsign.toString())
                    ? ""
                    : widget.model.undeliveredconsign.toString(),
                color: Colors.red,
                theme: theme,
                isSmallDevice: isSmallDevice,
              ),
              _buildStatusItem(
                label: 'Pending',
                value: isNullOrEmpty(widget.model.pendingDeliveries.toString())
                    ? ""
                    : widget.model.pendingDeliveries.toString(),
                color: Colors.orange,
                theme: theme,
                isSmallDevice: isSmallDevice,
              ),
            ],
          ),
        ),
        Visibility(
          visible: widget.model.manifesttype == 'I',
          child: Row(
            children: [
              _buildStatusItem(
                label: 'Total',
                value: isNullOrEmpty(widget.model.noofconsign.toString())
                    ? ""
                    : widget.model.noofconsign.toString(),
                color: CommonColors.colorPrimary!,
                theme: theme,
                isSmallDevice: isSmallDevice,
              ),
              _buildStatusItem(
                label: 'Pickup',
                value: isNullOrEmpty(widget.model.noofpickups.toString())
                    ? ""
                    : widget.model.noofpickups.toString(),
                color: Colors.green,
                theme: theme,
                isSmallDevice: isSmallDevice,
              ),
              _buildStatusItem(
                label: 'Reverse Pickup',
                value: isNullOrEmpty(widget.model.noofrvpickups.toString())
                    ? ""
                    : widget.model.noofrvpickups.toString(),
                color: Colors.red,
                theme: theme,
                isSmallDevice: isSmallDevice,
              ),
            ],
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
    required bool isSmallDevice,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: isSmallDevice ? 6 : 8),
        margin: EdgeInsets.only(right: isSmallDevice ? 4 : 8),
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
                fontSize: isSmallDevice ? 14 : 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: color.withOpacity(0.8),
                overflow: TextOverflow.ellipsis,
                fontSize: isSmallDevice ? 10 : 12,
              ),
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
