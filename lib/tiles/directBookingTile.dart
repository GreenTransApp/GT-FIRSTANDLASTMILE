import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/directBooking/model/directBookingModel.dart';
import 'package:gtlmd/tiles/addressCard.dart';

class DirectBookingTile extends StatefulWidget {
  final DirectBookingModel model;
  const DirectBookingTile({super.key, required this.model});

  @override
  State<DirectBookingTile> createState() => _DirectBookingTileState();
}

class _DirectBookingTileState extends State<DirectBookingTile> {
  DirectBookingModel modelDetail = DirectBookingModel();
  @override
  void didUpdateWidget(covariant DirectBookingTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model) {
      setState(() {
        modelDetail = widget.model;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CommonColors.amber700,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding,
            vertical: SizeConfig.verticalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with ID and Status

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '${widget.model.grno}/${isNullOrEmpty(widget.model.orderid.toString()) ? "" : widget.model.orderid}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.mediumTextSize,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Stop badge next to GR No
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.smallHorizontalPadding,
                                  vertical: SizeConfig.smallVerticalPadding),
                              decoration: BoxDecoration(
                                color: CommonColors.colorPrimary!
                                    .withAlpha((0.1 * 255).round()),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                // 'Stop ${modelDetail.sequenceno} / ${modelDetail.consignmenttypeview}',
                                "",
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: CommonColors.colorPrimary,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.extraSmallHorizontalPadding,
                                    vertical:
                                        SizeConfig.extraSmallVerticalPadding),
                                child: Text(
                                  "",
                                  style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize,
                                    fontWeight: FontWeight.w500,
                                    color: CommonColors.blue50,
                                  ),
                                ),
                              ),
                              // Icon(
                              //   statusIcon,
                              //   color: statusIconColor,
                              //   size: SizeConfig.extraLargeIconSize,
                              // ),
                            ],
                          ),
                          isNullOrEmpty(modelDetail.undeliverreason)
                              ? const SizedBox.shrink()
                              : Text('Reason: ${modelDetail.undeliverreason}',
                                  style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize,
                                    fontWeight: FontWeight.w800,
                                    color: CommonColors.colorPrimary,
                                  )),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: widget.model.reached == 'N',
                      child: GestureDetector(
                        onTap: () {
                          // updateDriverReached();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.horizontalPadding,
                              vertical: SizeConfig.verticalPadding),
                          decoration: BoxDecoration(
                              color: CommonColors.colorPrimary!.withAlpha(
                                (0.1 * 255).toInt(),
                              ),
                              borderRadius: BorderRadius.circular(16)),
                          child: Text(
                            "Arrived At",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: CommonColors.colorPrimary),
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: widget.model.reached == 'Y',
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: CommonColors.green600,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text("Reached")
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),

            SizedBox(height: SizeConfig.smallVerticalSpacing),

            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: modelDetail.consignmenttype == 'P'
                        ? 'Consignor : '
                        : 'Consignee : ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextSpan(
                    text: modelDetail.cngename ?? '',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: SizeConfig.smallVerticalSpacing,
            ),

            // Address Card
            AddressCard(
                title: 'Address',
                address: modelDetail.cngeaddress ?? '',
                color: CommonColors.amber200!.withAlpha((0.1 * 255).toInt())),
            // Consignment Details
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pcs',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.smallTextSize,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${modelDetail.pcs}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: SizeConfig.smallTextSize,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mobile No.',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeConfig.smallTextSize,
                        ),
                      ),
                      SizedBox(height: SizeConfig.extraSmallVerticalSpacing),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: SizeConfig.smallVerticalSpacing),

            // Action Buttons for Pending
           
          ],
        ),
      ),
    );
  }
}
