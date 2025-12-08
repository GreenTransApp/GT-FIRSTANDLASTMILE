import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/homeViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/tripDetail.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummary.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfo.dart';

import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:material_symbols_icons/symbols.dart';

class DashboardTripTile extends StatefulWidget {
  late TripModel model;
  late AttendanceModel attendanceModel;
  // final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  final Future<void> Function() onRefresh;
  DashboardTripTile(
      {super.key,
      required this.model,
      required this.attendanceModel,
      // this.onUpdate,
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

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TripDetail(model: widget.model));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Trip ID and Summary Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trip #${widget.model.tripid.toString()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isNullOrEmpty(widget.model.tripdispatchdatetime)
                            ? ""
                            : widget.model.tripdispatchdatetime.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.model.tripdispatchdatetime != null) {
                      Get.to(() => TripORdersSummary(tripModel: widget.model));
                    } else {
                      openUpdateTripInfo(context, widget.model, TripStatus.open,
                          widget.onRefresh);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe8f5f2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF4db8a8).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: widget.model.tripdispatchdatetime != null,
                          child: const Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: Color(0xFF4db8a8),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Visibility(
                          visible: widget.model.tripdispatchdatetime != null,
                          child: const Text(
                            'Summary',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4db8a8),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: widget.model.tripdispatchdatetime == null,
                          child: const Icon(
                            Icons.schedule_outlined,
                            size: 16,
                            color: Color(0xFF4db8a8),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Visibility(
                          visible: widget.model.tripdispatchdatetime == null,
                          child: const Text(
                            'Start Trip',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4db8a8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            // Trip Details Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.2,
              children: [
                _buildInfoItem(
                    'Date', widget.model.tripdispatchdate.toString()),
                _buildInfoItem(
                    'Starting KM',
                    isNullOrEmpty(widget.model.startreadingkm.toString())
                        ? ""
                        : "${widget.model.startreadingkm} km"),
                _buildInfoItem(
                  'Consignments',
                  widget.model.totalconsignment.toString(),
                ),
                // _buildInfoItem(
                //     'Pending', '${widget.model.pendingconsignment.toString()}'),
              ],
            ),
            const SizedBox(height: 16),
            // ORS Status Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF4db8a8).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total DRS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4db8a8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.model.totaldrs.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Visibility(
              visible: widget.model.pendingconsignment == 0 &&
                  widget.model.tripdispatchdatetime != null,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xFF4db8a8).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Close Trip',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        openUpdateTripInfo(context, widget.model,
                            TripStatus.close, widget.onRefresh);
                      },
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4db8a8),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Icon(Symbols.close,
                              color: CommonColors.appBarColor)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isNullOrEmpty(value) ? "" : value!,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
