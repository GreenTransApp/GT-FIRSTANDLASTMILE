import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryDetail.dart';
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
    final theme = Theme.of(context);
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
            // Get.to(() => TripDetail(model: model))?.then((_) => {onRefresh()});
            Get.to(DeliveryDetail(
              // model: widget.model,
              tripModel: model,
            ))?.then((_) => {onRefresh()});
          } else {
            failToast("Start trip to continue");
            // successToast("Start trip to continue");
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
              // _buildFooter(onRefresh),
              _buildStatusIndicators(theme, model)
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
          color: CommonColors.colorPrimary!,
          // .withAlpha((255 * 0.5).toInt()),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: CommonColors.colorPrimary!,
            // .withAlpha((255 * 0.1).toInt()),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isTripStarted
                  ? Icons.description_outlined
                  : Icons.schedule_outlined,
              size: 16,
              color: CommonColors.White,
            ),
            const SizedBox(width: 6),
            Text(
              _isTripStarted ? 'Summary' : 'Start Trip',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: CommonColors.White,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Optimized: Removed heavy GridView
  Widget _buildDetailsRow() {
    if (model.tripdispatchdatetime == null) {
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Trip Not Started',
              style: TextStyle(
                  color: Colors.red,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w600)),
          Icon(Icons.warning_amber_rounded, color: Colors.red)
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: _buildInfoItem(
                  'Date',
                  isNullOrEmpty(model.tripdispatchdate.toString())
                      ? "Trip not started"
                      : model.tripdispatchdate.toString())),
          Expanded(
            child: _buildInfoItem(
                'Starting KM',
                isNullOrEmpty(model.startreadingkm.toString())
                    ? ""
                    : "${model.startreadingkm} km"),
          ),
          if (model.tripdispatchdatetime != null &&
              model.pendingconsign == 0) ...[
            const SizedBox(width: 12),
            InkWell(
              onTap: () {
                Get.to(() =>
                        UpdateTripInfo(model: model, status: TripStatus.close))!
                    .then((_) {
                  onRefresh();
                });
              },
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      CommonColors.dangerColor!.withAlpha((255 * 0.3).toInt()),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.cancel,
                    size: 16, color: CommonColors.dangerColor!),
              ),
            ),
          ]
          // Expanded(
          //     child: _buildInfoItem(
          //         'Consignments', model.totalconsignment.toString())),
        ],
      );
    }
  }

  Widget _buildFooter(Function onRefresh) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: CommonColors.colorPrimary!.withAlpha((255 * 0.1).toInt()),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color:
                    CommonColors.colorPrimary!.withAlpha((255 * 0.1).toInt()),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Consignment',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                _buildBadge(model.noofconsign.toString()),
              ],
            ),
          ),
        ),
        if (model.tripdispatchdatetime != null &&
            model.pendingconsign == 0) ...[
          const SizedBox(width: 12),
          InkWell(
            onTap: () {
              Get.to(() =>
                      UpdateTripInfo(model: model, status: TripStatus.close))!
                  .then((_) {
                onRefresh();
              });
            },
            borderRadius: BorderRadius.circular(6),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: CommonColors.dangerColor!.withAlpha((255 * 0.3).toInt()),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.cancel,
                  size: 16, color: CommonColors.dangerColor!),
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
        color: CommonColors.colorPrimary!,
        // .withAlpha((255 * 0.5).toInt()),
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

  Widget _buildStatusIndicators(ThemeData theme, TripModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for the status section
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Status',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Row(
          children: [
            _buildStatusItem(
              label: 'Total',
              value: isNullOrEmpty(model.noofconsign.toString())
                  ? ""
                  : model.noofconsign.toString(),
              color: CommonColors.colorPrimary!,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Pending',
              value: isNullOrEmpty(model.pendingconsign.toString())
                  ? ""
                  : model.pendingconsign.toString(),
              color: Colors.orange,
              theme: theme,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            _buildStatusItem(
              label: 'Delivered',
              value: isNullOrEmpty(model.deliveredconsign.toString())
                  ? ""
                  : model.deliveredconsign.toString(),
              color: Colors.green,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Undelivered',
              value: isNullOrEmpty(model.undeliveredconsign.toString())
                  ? ""
                  : model.undeliveredconsign.toString(),
              color: Colors.red,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Pickup',
              value: isNullOrEmpty(model.noofpickups.toString())
                  ? ""
                  : model.noofpickups.toString(),
              color: CommonColors.orangeColor!.withAlpha((0.5 * 255).toInt()),
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Reverse Pickup',
              value: isNullOrEmpty(model.noofrvpickups.toString())
                  ? ""
                  : model.noofrvpickups.toString(),
              color: CommonColors.colorPrimary!.withAlpha((0.5 * 255).toInt()),
              theme: theme,
            ),
          ],
        ),
        // Status grid
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
