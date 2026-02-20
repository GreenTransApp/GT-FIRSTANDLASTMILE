import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/model/deliveryPerformanceSummaryModel.dart';

class DeliveryPerformanceSummaryTile extends StatelessWidget {
  final DeliveryPerformanceSummaryModel model;

  const DeliveryPerformanceSummaryTile({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    String status = (model.status ?? "").trim().toUpperCase();
    bool isUndelivered = status == "UNDELIVERED";

    return Card(
      elevation: 3,
      margin: EdgeInsets.only(
        bottom: SizeConfig.smallVerticalSpacing,
      ),
      shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(SizeConfig.mediumRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.smallHorizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// DATE + STATUS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        size: SizeConfig.smallIconSize,
                        color: CommonColors.textSecondary),
                    SizedBox(width: SizeConfig.extraSmallHorizontalSpacing),
                    Text(
                      model.bookingDate ?? "-",
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
                        color: CommonColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                _statusBadge(status),
              ],
            ),

            SizedBox(height: SizeConfig.smallVerticalSpacing),

            /// CONSIGNMENT
            _compactRow(
              icon: Icons.confirmation_number_outlined,
              label: "Consignment:",
              value: model.consignmentNo,
              isPrimary: true,
            ),

            SizedBox(height: SizeConfig.extraSmallVerticalSpacing),

            /// CONSIGNEE
            _compactRow(
              icon: Icons.person_outline,
              label: "Consignee:",
              value: model.cneeName,
            ),

            SizedBox(height: SizeConfig.extraSmallVerticalSpacing),

            /// MANIFEST
            _compactRow(
              icon: Icons.local_shipping_outlined,
              label: "Manifest:",
              value: model.manifestNo,
            ),

            /// UNDELIVERY REASON
            if (isUndelivered) ...[
              SizedBox(height: SizeConfig.extraSmallVerticalSpacing),
              _compactRow(
                icon: Icons.info_outline,
                label: "Reason:",
                value: model.undelReason,
              ),
            ],

            SizedBox(height: SizeConfig.smallVerticalSpacing),

            /// IMAGE SECTION
            isUndelivered
                ? _smallImage(model.undelImg,"UnDelivered Image")
                : Row(
              children: [
                Expanded(child: _smallImage(model.imagePath,"POD Image")),
                SizedBox(width: SizeConfig.smallHorizontalSpacing),
                Expanded(child: _smallImage(model.signImagePath,"Signature Image")),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 Compact Label + Value Row
  Widget _compactRow({
    required IconData icon,
    required String label,
    String? value,
    bool isPrimary = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: SizeConfig.smallIconSize,
          color: isPrimary
              ? CommonColors.colorPrimary
              : CommonColors.textSecondary,
        ),
        SizedBox(width: SizeConfig.extraSmallHorizontalSpacing),

        /// LABEL
        Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.smallTextSize,
            fontWeight: FontWeight.w600,
            color: CommonColors.textSecondary,
          ),
        ),

        SizedBox(width: SizeConfig.extraSmallHorizontalSpacing),

        /// VALUE
        Expanded(
          child: Text(
            value?.isNotEmpty == true ? value! : "-",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: SizeConfig.smallTextSize,
              fontWeight:
              isPrimary ? FontWeight.bold : FontWeight.normal,
              color: isPrimary
                  ? CommonColors.colorPrimary
                  : CommonColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    bool isDelivered = status == "DELIVERED";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.smallHorizontalPadding,
        vertical: SizeConfig.extraSmallVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: isDelivered
            ? CommonColors.successColor?.withOpacity(0.15)
            : CommonColors.dangerColor?.withOpacity(0.15),
        borderRadius:
        BorderRadius.circular(SizeConfig.largeRadius),
      ),
      child: Text(
        status.isEmpty ? "-" : status,
        style: TextStyle(
          fontSize: SizeConfig.smallTextSize,
          fontWeight: FontWeight.bold,
          color: isDelivered
              ? CommonColors.successColor
              : CommonColors.dangerColor,
        ),
      ),
    );
  }

  Widget _smallImage(String? url, String? title) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            Text(
              title ?? "-",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: CommonColors.grey,
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.smallTextSize,
              ),
            ),
            SizedBox(height: SizeConfig.extraSmallVerticalSpacing),

            // IMAGE
            Container(
              width: double.infinity, // take max width
              height: SizeConfig.scale(50),
              decoration: BoxDecoration(
                borderRadius:
                BorderRadius.circular(SizeConfig.mediumRadius),
                color: CommonColors.grey?.withOpacity(0.08),
                border: Border.all(
                  color: CommonColors.grey ?? const Color(0xFFE0E0E0),
                ),
              ),
              child: ClipRRect(
                borderRadius:
                BorderRadius.circular(SizeConfig.mediumRadius),
                child: url == null || url.isEmpty
                    ? _imagePlaceholder()
                    : Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder:
                      (context, child, progress) {
                    if (progress == null) return child;
                    return _imagePlaceholder();
                  },
                  errorBuilder:
                      (context, error, stackTrace) {
                    return _imagePlaceholder();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _imagePlaceholder() {
    return Center(
      child: Icon(
        Icons.image,
        size: SizeConfig.smallIconSize,
        color: CommonColors.textSecondary,
      ),
    );
  }
}
