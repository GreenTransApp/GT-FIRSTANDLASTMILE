import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/app_sizes.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/pickup/pickup.dart';

import 'package:gtlmd/pages/podEntry/podEntry.dart';
import 'package:gtlmd/pages/reversePickup/reversePickup.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';

import 'package:gtlmd/pages/unDelivery/unDelivery.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryDetailTile extends StatefulWidget {
  final DeliveryDetailModel model;
  final CurrentDeliveryModel currentDeliveryModel;
  final Future<void> Function() onRefresh;

  final int listLength;
  final int index;
  DeliveryDetailTile({
    super.key,
    required this.model,
    required this.currentDeliveryModel,
    required this.listLength,
    required this.index,
    required this.onRefresh,
  });

  @override
  State<DeliveryDetailTile> createState() => _RouteDetailTileState();
}

class _RouteDetailTileState extends State<DeliveryDetailTile> {
  bool isFirst = false;
  bool isLast = false;
  bool showActionBtn = true;
  DeliveryDetailModel modelDetail = DeliveryDetailModel();
  CurrentDeliveryModel currentDelivery = CurrentDeliveryModel();
  int listValue = 0;
  int listIndex = 0;
  late Color dotColor;
  late Color cardBgColor;
  late IconData statusIcon;
  late Color statusIconColor;
  String? status;
  @override
  void initState() {
    super.initState();
    modelDetail = widget.model;
    currentDelivery = widget.currentDeliveryModel;
    setState(() {
      // if (widget.model.deliverystatus == 'Y') {
      if (widget.model.deliverystatus == 'P') {
        showActionBtn = true;
      } else {
        showActionBtn = false;
      }

      checkConsignTypeAndStatus();
    });
    listValue = widget.listLength;
    listIndex = widget.index;

    if (listValue == 1 && listIndex == 0) {
      isFirst = true;
      isLast = true;
    } else if (listIndex == 0) {
      isFirst = true;
      isLast = false;
    } else if (listIndex == listValue - 1) {
      isFirst = false;
      isLast = true;
    } else {
      isFirst = false;
      isLast = false;
    }
  }

  @override
  void didUpdateWidget(covariant DeliveryDetailTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model) {
      setState(() {
        modelDetail = widget.model;
        if (widget.model.deliverystatus == 'P') {
          showActionBtn = true;
        } else {
          showActionBtn = false;
        }
        checkConsignTypeAndStatus();
      });
    }
  }

  checkConsignTypeAndStatus() {
    if (modelDetail.consignmenttype == "R") {
      switch (modelDetail.reversepickupstatus) {
        case "U":
          status = "Un-Picked";
          dotColor = CommonColors.colorPrimary!;
          cardBgColor =
              CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          statusIcon = Icons.cancel;
          statusIconColor = CommonColors.colorPrimary!;
          break;
        case "D":
          status = "Picked";
          dotColor = CommonColors.colorPrimary!;
          cardBgColor =
              CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          statusIcon = Icons.check_circle;
          statusIconColor = CommonColors.colorPrimary!;
          break;
        case "P":
          status = "Pending";
          dotColor = CommonColors.colorPrimary!;
          cardBgColor =
              CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          statusIcon = Icons.access_time;
          statusIconColor = CommonColors.colorPrimary!;
          break;
      }
    } else if (modelDetail.consignmenttype == 'D' ||
        modelDetail.consignmenttype == 'U') {
      switch (modelDetail.deliverystatus) {
        case "U":
          status = "Undelivered";
          dotColor = CommonColors.red500!;
          cardBgColor = CommonColors.red50!;
          statusIcon = Icons.cancel;
          statusIconColor = CommonColors.red500!;
          break;
        case "D":
          status = "Delivered";
          dotColor = CommonColors.green500!;
          cardBgColor = CommonColors.green50!;
          statusIcon = Icons.check_circle;
          statusIconColor = CommonColors.green500!;
          break;
        case "P":
          status = "Pending";
          dotColor = CommonColors.amber500!;
          cardBgColor = CommonColors.amber50!;
          statusIcon = Icons.access_time;
          statusIconColor = CommonColors.amber500!;
          break;
      }
    } else {
      switch (modelDetail.pickupstatus) {
        // case "U":
        //   status = "Undelivered";
        //   dotColor = CommonColors.red500!;
        //   cardBorderColor = CommonColors.red500!;
        //   cardBgColor = CommonColors.red50!;
        //   statusIcon = Icons.cancel;
        //   statusIconColor = CommonColors.red500!;
        //   break;
        case "D":
          status = "Picked";
          dotColor = CommonColors.green500!;
          cardBgColor = CommonColors.green50!;
          statusIcon = Icons.check_circle;
          statusIconColor = CommonColors.green500!;
          break;
        case "P":
          status = "Pending";
          dotColor = CommonColors.amber500!;
          cardBgColor = CommonColors.amber50!;
          statusIcon = Icons.access_time;
          statusIconColor = CommonColors.amber500!;
          break;
        default:
          status = "Pending";
          dotColor = CommonColors.amber500!;
          cardBgColor = CommonColors.amber50!;
          statusIcon = Icons.access_time;
          statusIconColor = CommonColors.amber500!;
          break;
      }
    }
  }

  _makePhoneCall(String? mobileNum) async {
    try {
      var url = Uri.parse("tel:$mobileNum");
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        failToast("Somethinig went wrong, please try again later");
      }
    } catch (err) {
      failToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        alignment: TimelineAlign.manual,
        lineXY: 0.05,
        beforeLineStyle: LineStyle(
          color: dotColor,
          thickness: 2,
        ),
        afterLineStyle: LineStyle(
          color: dotColor,
          thickness: 2,
        ),
        indicatorStyle: IndicatorStyle(
          height: 15,
          width: 15,
          indicator: Container(
            // margin: const EdgeInsets.only(top: 20),
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ),
        endChild: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.verticalPadding,
              horizontal: SizeConfig.horizontalPadding),
          child: Container(
            decoration: BoxDecoration(
              color: cardBgColor,
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
                              '${widget.model.grno}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.smallTextSize,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Stop badge next to GR No
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
                                'Stop ${modelDetail.sequenceno} / ${modelDetail.consignmenttypeview}',
                                style: TextStyle(
                                  fontSize: SizeConfig.extraSmallTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: CommonColors.colorPrimary,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        SizeConfig.extraSmallHorizontalPadding,
                                    vertical:
                                        SizeConfig.extraSmallVerticalPadding),
                                // decoration: BoxDecoration(
                                //   color: cardBgColor
                                //       .withAlpha((0.7 * 255).round()),
                                //   borderRadius: BorderRadius.circular(12),
                                // ),
                                child: Text(
                                  status.toString(),
                                  style: TextStyle(
                                    fontSize: SizeConfig.extraSmallTextSize,
                                    fontWeight: FontWeight.w500,
                                    color: statusIconColor,
                                  ),
                                ),
                              ),
                              Icon(
                                statusIcon,
                                color: statusIconColor,
                                size: SizeConfig.extraLargeIconSize,
                              ),
                            ],
                          ),
                          // Text('${modelDetail.consignmenttypeview}',
                          //     style: TextStyle(
                          //       fontSize: 12,
                          //       fontWeight: FontWeight.w800,
                          //       color: CommonColors.colorPrimary,
                          //     )),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.smallVerticalSpacing),

                  // Consignment Details
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Consignee Name',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig.extraSmallTextSize,
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.extraSmallVerticalSpacing),
                            Text(
                              modelDetail.cngename.toString(),
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
                                fontSize: SizeConfig.extraSmallTextSize,
                              ),
                            ),
                            SizedBox(
                                height: SizeConfig.extraSmallVerticalSpacing),
                            Row(
                              children: [
                                Text(
                                  modelDetail.cngemobile ?? '—',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                                Visibility(
                                  visible: status == "Pending" ||
                                      status == "Un-Picked",
                                  child: const SizedBox(
                                    width: 10,
                                  ),
                                ),
                                Visibility(
                                  visible: status == "Pending" ||
                                      status == "Un-Picked",
                                  child: SizedBox(
                                    width:
                                        SizeConfig.extraLargeHorizontalPadding,
                                    height:
                                        SizeConfig.extraLargeVerticalPadding,
                                    child: IconButton(
                                      iconSize: SizeConfig.extraSmallIconSize,
                                      style: ButtonStyle(
                                        backgroundColor: status == "Pending" ||
                                                status == "Un-Picked"
                                            ? WidgetStatePropertyAll(
                                                CommonColors.colorPrimary)
                                            : WidgetStatePropertyAll(
                                                CommonColors.grey400),
                                      ),
                                      onPressed: status == "Pending" ||
                                              status == "Un-Picked"
                                          ? () {
                                              if (modelDetail.cngemobile
                                                      .toString()
                                                      .length ==
                                                  10) {
                                                commonAlertDialog(
                                                    context,
                                                    "Make a phone call?",
                                                    "Are you sure you want to call ${modelDetail.cngemobile}?",
                                                    "",
                                                    Icon(Icons.phone_outlined,
                                                        size: SizeConfig
                                                            .extraSmallIconSize),
                                                    () {
                                                  _makePhoneCall(
                                                      modelDetail.cngemobile);
                                                });
                                              } else {
                                                commonAlertDialog(
                                                    context,
                                                    "Invalid Phone Number",
                                                    "The phone number is not valid",
                                                    'address',
                                                    Icon(
                                                      Icons.phone_outlined,
                                                      size: SizeConfig
                                                          .smallIconSize,
                                                    ),
                                                    () {});
                                              }
                                            }
                                          : null,
                                      icon: Icon(
                                        Icons.call_outlined,
                                        size: SizeConfig.smallIconSize,
                                        color: status == "Pending"
                                            ? CommonColors.White
                                            : CommonColors.grey300,
                                      ),
                                      disabledColor: CommonColors.grey200,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.smallVerticalSpacing),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pcs',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig.extraSmallTextSize,
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
                      Expanded(child: Container()),
                    ],
                  ),

                  // Action Buttons for Pending
                  if (modelDetail.consignmenttype == "D" &&
                      status == "Pending") ...[
                    SizedBox(height: SizeConfig.smallVerticalSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(UnDelivery(
                                deliveryDetailModel: modelDetail,
                                currentDeliveryModel: currentDelivery,
                              ))?.then((_) {
                                widget.onRefresh();
                              });
                            },
                            icon: Icon(Icons.close,
                                size: SizeConfig.mediumIconSize),
                            label: Text('Undeliver',
                                style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      SizeConfig.extraSmallVerticalSpacing),
                              backgroundColor: CommonColors.red600,
                              foregroundColor: CommonColors.White,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(PodEntry(deliveryDetailModel: modelDetail))
                                  ?.then((_) {
                                widget.onRefresh();
                              });
                            },
                            icon: Icon(Icons.check,
                                size: SizeConfig.mediumIconSize),
                            label: Text('Deliver',
                                style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      SizeConfig.extraSmallVerticalSpacing),
                              backgroundColor: CommonColors.green600,
                              foregroundColor: CommonColors.White,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (modelDetail.consignmenttype == "R" &&
                      modelDetail.pickupstatus == "U") ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(ReversePickup(
                                deliveryDetailModel: modelDetail,
                              ))?.then((_) {
                                widget.onRefresh();
                              });
                            },
                            icon: Icon(Icons.check,
                                size: SizeConfig.mediumIconSize),
                            label: Text('Reverse Pickup',
                                style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      SizeConfig.extraSmallVerticalSpacing),
                              backgroundColor: CommonColors.colorPrimary,
                              foregroundColor: CommonColors.White,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (modelDetail.consignmenttype == "P" &&
                      modelDetail.pickupstatus == "U") ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.to(Pickup(details: widget.model))?.then((_) {
                                widget.onRefresh();
                              });
                            },
                            icon: Icon(Icons.check,
                                size: SizeConfig.mediumIconSize),
                            label: Text('Pickup',
                                style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      SizeConfig.extraSmallVerticalSpacing),
                              backgroundColor: CommonColors.colorPrimary,
                              foregroundColor: CommonColors.White,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ));
  }
}
