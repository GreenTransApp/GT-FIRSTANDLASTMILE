import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/tripDetail.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummary.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';

class RunningTripTile extends StatelessWidget {
  final TripModel model;
  final AttendanceModel attendanceModel;
  final Future<void> Function() onRefresh;

  const RunningTripTile({
    super.key,
    required this.model,
    required this.attendanceModel,
    required this.onRefresh,
  });

  // Helper getter to clean up the UI logic
  bool get _isTripStarted => model.tripdispatchdatetime != null;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Use Card or Material for better elevation/shadow handling
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2), // Lighter shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      clipBehavior: Clip.antiAlias, // Ensures ripples don't overflow
      child: InkWell(
        onTap: () {
          if (model.tripdispatchdatetime != null) {
            Get.to(() => TripDetail(model: model))?.then((_) => {onRefresh()});
          } else {
            failToast("Start trip to continue");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 16),
              Divider(height: 1, color: Colors.grey[200]),
              const SizedBox(height: 16),
              _buildDetailsRow(), // Replaced GridView with Row
              const SizedBox(height: 16),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trip #${model.tripid}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1a1a1a),
                ),
              ),
              const SizedBox(height: 4),
              if (!isNullOrEmpty(model.tripdispatchdatetime))
                Text(
                  model.tripdispatchdatetime.toString(),
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        _buildActionButton(context),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return InkWell(
      onTap: () {
        if (_isTripStarted) {
          Get.to(() => TripORdersSummary(tripModel: model));
        } else {
          openUpdateTripInfo(context, model, TripStatus.open, onRefresh);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFe8f5f2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF4db8a8).withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isTripStarted
                  ? Icons.description_outlined
                  : Icons.schedule_outlined,
              size: 16,
              color: const Color(0xFF4db8a8),
            ),
            const SizedBox(width: 6),
            Text(
              _isTripStarted ? 'Summary' : 'Start Trip',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4db8a8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Optimized: Removed heavy GridView
  Widget _buildDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: _buildInfoItem('Date', model.tripdispatchdate.toString())),
        Expanded(
          child: _buildInfoItem(
              'Starting KM',
              isNullOrEmpty(model.startreadingkm.toString())
                  ? ""
                  : "${model.startreadingkm} km"),
        ),
        Expanded(
            child: _buildInfoItem(
                'Consignments', model.totalconsignment.toString())),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color(0xFF4db8a8).withOpacity(0.2)),
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
                _buildBadge(model.totaldrs.toString()),
              ],
            ),
          ),
        ),
        if (model.pendingconsignment == 0 && _isTripStarted) ...[
          const SizedBox(width: 12),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4db8a8),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.close, size: 16, color: Colors.white),
            ),
          ),
        ]
      ],
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF4db8a8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
          value,
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
