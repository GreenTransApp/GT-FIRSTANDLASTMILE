import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/optionMenu/tripMis/Model/tripMisModel.dart';
import 'package:gtlmd/pages/manifestEnquiry/manifestEnquiry.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummary.dart';

class TripMisTile extends StatelessWidget {
  final TripMisModel model;
  const TripMisTile({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;
    return Card(
      // Use Card or Material for better elevation/shadow handling
      margin: EdgeInsets.symmetric(
          horizontal: isSmallDevice ? 8 : 16, vertical: isSmallDevice ? 4 : 8),
      elevation: 4,
      shadowColor: Colors.grey.withOpacity(0.2), // Lighter shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      clipBehavior: Clip.antiAlias, // Ensures ripples don't overflow
      child: InkWell(
        onTap: () {
          // Get.to(() => ManifestEnquiry(tripModel: model));
          TripModel tripModel = TripModel(
            tripid: int.tryParse(model.tripId.toString()),
            planningid: int.tryParse(model.planningid.toString()),
            manifestno: model.manifestno.toString(),
          );
          Get.to(() => TripORdersSummary(tripModel: tripModel));
        },
        child: Padding(
          padding: EdgeInsets.all(isSmallDevice ? 12 : 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, isSmallDevice),
              SizedBox(height: isSmallDevice ? 10 : 16),
              Divider(height: 1, color: Colors.grey[200]),
              SizedBox(height: isSmallDevice ? 10 : 16),
              _buildDetailsRow(isSmallDevice), // Replaced GridView with Row
              SizedBox(height: isSmallDevice ? 10 : 16),
              // _buildFooter(onRefresh),
              _buildStatusIndicators(theme, model, isSmallDevice)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isSmallDevice) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trip #${model.tripId}',
                style: TextStyle(
                  fontSize: isSmallDevice ? 15 : 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1a1a1a),
                ),
              ),
            ],
          ),
        ),

        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildInfoItem(
                'Branch',
                isNullOrEmpty(model.branchName.toString())
                    ? "-"
                    : model.branchName.toString(),
                isSmallDevice),
          ],
        )),
        // _buildActionButton(context, isSmallDevice),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context, bool isSmallDevice) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: isSmallDevice ? 8 : 12, vertical: 8),
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
              Icons.schedule_outlined,
              size: isSmallDevice ? 14 : 16,
              color: CommonColors.White,
            ),
            SizedBox(width: isSmallDevice ? 4 : 6),
            Text(
              'Start Trip',
              style: TextStyle(
                fontSize: isSmallDevice ? 10 : 12,
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
  Widget _buildDetailsRow(bool isSmallDevice) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: _buildInfoItem(
                    'Map Distance',
                    isNullOrEmpty(model.mapDistance.toString())
                        ? "-"
                        : model.mapDistance.toString(),
                    isSmallDevice)),
            Expanded(
              child: _buildInfoItem(
                  'Run km',
                  isNullOrEmpty(model.kmRun.toString())
                      ? ""
                      : "${model.kmRun} ",
                  isSmallDevice),
            ),
            // Expanded(
            //     child: _buildInfoItem(
            //         'Consignments', model.totalconsignment.toString())),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: _buildInfoItem(
                    'Start Date',
                    isNullOrEmpty(model.startDate.toString())
                        ? "-"
                        : model.startDate.toString(),
                    isSmallDevice)),
            Expanded(
              child: _buildInfoItem(
                  'Start Reading',
                  isNullOrEmpty(model.startReading.toString())
                      ? "-"
                      : "${model.startReading}",
                  isSmallDevice),
            ),

            // Expanded(
            //     child: _buildInfoItem(
            //         'Consignments', model.totalconsignment.toString())),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: _buildInfoItem(
                    'Close Date',
                    isNullOrEmpty(model.closeDate.toString())
                        ? "-"
                        : model.startDate.toString(),
                    isSmallDevice)),
            Expanded(
              child: _buildInfoItem(
                  'Close Reading',
                  isNullOrEmpty(model.closeReading.toString())
                      ? "-"
                      : "${model.startReading}",
                  isSmallDevice),
            ),

            // Expanded(
            //     child: _buildInfoItem(
            //         'Consignments', model.totalconsignment.toString())),
          ],
        ),
      ],
    );
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
                _buildBadge('${model.noOfConsignments?.round() ?? 0}'),
              ],
            ),
          ),
        ),
        if (model.startDate != null && model.pending == 0) ...[
          const SizedBox(width: 12),
          InkWell(
            onTap: () {},
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

  Widget _buildInfoItem(String label, String value, bool isSmallDevice) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallDevice ? 10 : 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isSmallDevice ? 12 : 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1a1a1a),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildStatusIndicators(
      ThemeData theme, TripMisModel model, bool isSmallDevice) {
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
              fontSize: isSmallDevice ? 12 : 14,
            ),
          ),
        ),
        Row(
          children: [
            _buildStatusItem(
              label: 'Total',
              value: isNullOrEmpty(model.noOfConsignments.toString())
                  ? ""
                  : '${model.noOfConsignments?.round() ?? 0}',
              color: CommonColors.colorPrimary!,
              theme: theme,
              isSmallDevice: isSmallDevice,
            ),
            _buildStatusItem(
              label: 'Pending',
              value: isNullOrEmpty(model.pending.toString())
                  ? ""
                  : '${model.pending?.round() ?? 0}',
              color: Colors.orange,
              theme: theme,
              isSmallDevice: isSmallDevice,
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
              value: isNullOrEmpty(model.delivered.toString())
                  ? ""
                  : model.delivered.toString(),
              color: Colors.green,
              theme: theme,
              isSmallDevice: isSmallDevice,
            ),
            _buildStatusItem(
              label: 'Undelivered',
              value: isNullOrEmpty(model.undelivered.toString())
                  ? ""
                  : model.undelivered.toString(),
              color: Colors.red,
              theme: theme,
              isSmallDevice: isSmallDevice,
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
    required bool isSmallDevice,
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
                fontSize: isSmallDevice ? 12 : 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                  color: color.withOpacity(0.8),
                  overflow: TextOverflow.ellipsis,
                  fontSize: isSmallDevice ? 10 : 12),
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
