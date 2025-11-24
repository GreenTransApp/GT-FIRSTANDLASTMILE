import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/pickup/pickup.dart';

import 'package:gtlmd/pages/podEntry/podEntry.dart';
import 'package:gtlmd/pages/reversePickup/reversePickup.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';
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
  late Color cardBorderColor;
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
          cardBorderColor = CommonColors.colorPrimary!;
          cardBgColor =
              CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          statusIcon = Icons.cancel;
          statusIconColor = CommonColors.colorPrimary!;
          break;
        case "D":
          status = "Picked";
          dotColor = CommonColors.colorPrimary!;
          cardBorderColor = CommonColors.colorPrimary!;
          cardBgColor =
              CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
          statusIcon = Icons.check_circle;
          statusIconColor = CommonColors.colorPrimary!;
          break;
        case "P":
          status = "Pending";
          dotColor = CommonColors.colorPrimary!;
          cardBorderColor = CommonColors.colorPrimary!;
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
          cardBorderColor = CommonColors.red500!;
          cardBgColor = CommonColors.red50!;
          statusIcon = Icons.cancel;
          statusIconColor = CommonColors.red500!;
          break;
        case "D":
          status = "Delivered";
          dotColor = CommonColors.green500!;
          cardBorderColor = CommonColors.green500!;
          cardBgColor = CommonColors.green50!;
          statusIcon = Icons.check_circle;
          statusIconColor = CommonColors.green500!;
          break;
        case "P":
          status = "Pending";
          dotColor = CommonColors.amber500!;
          cardBorderColor = CommonColors.amber500!;
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
          cardBorderColor = CommonColors.green500!;
          cardBgColor = CommonColors.green50!;
          statusIcon = Icons.check_circle;
          statusIconColor = CommonColors.green500!;
          break;
        case "P":
          status = "Pending";
          dotColor = CommonColors.amber500!;
          cardBorderColor = CommonColors.amber500!;
          cardBgColor = CommonColors.amber50!;
          statusIcon = Icons.access_time;
          statusIconColor = CommonColors.amber500!;
          break;
        default:
          status = "Pending";
          dotColor = CommonColors.amber500!;
          cardBorderColor = CommonColors.amber500!;
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
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
                          Text(
                            '${widget.model.grno}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Stop badge next to GR No
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: CommonColors.colorPrimary!
                                  .withAlpha((0.1 * 255).round()),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'Stop ${modelDetail.sequenceno}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: CommonColors.colorPrimary,
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                // decoration: BoxDecoration(
                                //   color: cardBgColor
                                //       .withAlpha((0.7 * 255).round()),
                                //   borderRadius: BorderRadius.circular(12),
                                // ),
                                child: Text(
                                  status.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: statusIconColor,
                                  ),
                                ),
                              ),
                              Icon(
                                statusIcon,
                                color: statusIconColor,
                                size: 24,
                              ),
                            ],
                          ),
                          Text('${modelDetail.consignmenttypeview}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: CommonColors.colorPrimary,
                              )),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Consignment Details
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Consignee Name',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              modelDetail.cngename.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Mobile No.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  modelDetail.cngemobile ?? '—',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Visibility(
                                  visible: status == "Pending",
                                  child: const SizedBox(
                                    width: 10,
                                  ),
                                ),
                                Visibility(
                                  visible: status == "Pending",
                                  child: SizedBox(
                                    width: 32,
                                    height: 32,
                                    child: IconButton(
                                      iconSize: 16,
                                      style: ButtonStyle(
                                        backgroundColor: status == "Pending"
                                            ? WidgetStatePropertyAll(
                                                CommonColors.colorPrimary)
                                            : WidgetStatePropertyAll(
                                                CommonColors.grey400),
                                      ),
                                      onPressed: status == "Pending"
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
                                                    const Icon(
                                                        Icons.phone_outlined),
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
                                                    const Icon(
                                                        Icons.phone_outlined),
                                                    () {});
                                              }
                                            }
                                          : null,
                                      icon: Icon(
                                        Icons.call_outlined,
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

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Pcs',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${modelDetail.pcs}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
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
                    const SizedBox(height: 16),
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
                            icon: const Icon(Icons.close),
                            label: const Text('Undeliver'),
                            style: ElevatedButton.styleFrom(
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
                            icon: const Icon(Icons.check),
                            label: const Text('Deliver'),
                            style: ElevatedButton.styleFrom(
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
                            icon: const Icon(Icons.check),
                            label: const Text('Reverse Pickup'),
                            style: ElevatedButton.styleFrom(
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
                              Get.to(Pickup(details: widget.model));
                            },
                            icon: const Icon(Icons.check),
                            label: const Text('Pickup'),
                            style: ElevatedButton.styleFrom(
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

/* 
        SizedBox(
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        indicatorStyle:
            IndicatorStyle(width: 20, color: CommonColors.colorPrimary!),
        afterLineStyle: LineStyle(color: CommonColors.colorPrimary!),
        beforeLineStyle: LineStyle(color: CommonColors.colorPrimary!),
        endChild: Card(
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: StringToHexaColor(
                          widget.model.statusColor.toString()),
                      width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(10))),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RichText(
                                text: TextSpan(
                                    text: widget.model.grno,
                                    // text: "",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: CommonColors.colorPrimary,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            CommonColors.colorPrimary))),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: /* Text(
                                    "Status: Undelivered",
                                    style: TextStyle(
                                        color: CommonColors.colorPrimary),
                                  ), */
                                      RichText(
                                    text: TextSpan(
                                      text: "Status: ",
                                      style: const TextStyle(
                                          color: CommonColors.appBarColor),
                                      children: <InlineSpan>[
                                        TextSpan(
                                          text: status,
                                          style: TextStyle(
                                            color: StringToHexaColor(
                                              widget.model.statusColor
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Consignee Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                " : ${widget.model.cngename}",
                                maxLines: 3,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Mobile No.',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                " : ${widget.model.cngemobile}",
                                maxLines: 3,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  Visibility(
                    visible: widget.model.deliverystatus == 'U',
                    child: Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Undelivery reason: ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          Flexible(
                            fit: FlexFit.tight,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  " : ${widget.model.undeliverreason}",
                                  maxLines: 3,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Divider(
                    thickness: 1,
                  ),
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Pcs ',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                " : ${widget.model.pcs}",
                                maxLines: 3,
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const Divider(
                  //   thickness: 1,
                  // ),

                  Visibility(
                    visible: showActionBtn,
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.to(UnDelivery(
                                  deliveryDetailModel: modelDetail,
                                  currentDeliveryModel: currentDelivery));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  color: CommonColors.dangerColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text("Un-Deliver".toUpperCase(),
                                  style: TextStyle(color: CommonColors.White)),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Get.to(
                                  PodEntry(deliveryDetailModel: modelDetail));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              decoration: BoxDecoration(
                                  color: CommonColors.successColor,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10))),
                              child: Text("Deliver".toUpperCase(),
                                  style: TextStyle(color: CommonColors.White)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );

 */
  }
}
