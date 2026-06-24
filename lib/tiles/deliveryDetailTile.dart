import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/commonModel/pageLinkJsonParams.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/lmdMenuModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/OtexPickupScreen.dart';
import 'package:gtlmd/pages/pickup/pickup.dart';
import 'package:gtlmd/pages/podEntry/podEntry.dart';
import 'package:gtlmd/pages/rejectPickup/rejectPickup.dart';
import 'package:gtlmd/pages/reversePickup/reversePickup.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/unDelivery/unDelivery.dart';
import 'package:gtlmd/tiles/addressCard.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

enum MenuTags { DELIVERY, UNDELIVERY, PICKUP, REVERSE_PICKUP }

class DeliveryDetailTile extends StatefulWidget {
  final DeliveryDetailModel model;
  final CurrentDeliveryModel currentDeliveryModel;
  final int index;
  final int listLength;
  final Function() onRefresh;
  final Future<void> Function(String grno) updateDriverPosition;
  final List<LmdMenuModel> menuList;

  const DeliveryDetailTile({
    super.key,
    required this.model,
    required this.currentDeliveryModel,
    required this.index,
    required this.listLength,
    required this.onRefresh,
    required this.updateDriverPosition,
    this.menuList = const [],
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
  BaseRepository _baseRepo = BaseRepository();
  List<StreamSubscription> _subscription = [];

  @override
  void initState() {
    super.initState();
    modelDetail = widget.model;
    currentDelivery = widget.currentDeliveryModel;
    // setObservers();

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
        case "U":
          status = "Rejected";
          dotColor = CommonColors.red500!;
          // cardBorderColor = CommonColors.red500!;
          cardBgColor = CommonColors.red50!;
          statusIcon = Icons.cancel;
          statusIconColor = CommonColors.red500!;
          break;
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

  getBookingPrintLink() async {
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmgrno": widget.model.generatedGr.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmmenucode": "GTAPP_BOOKING",
        "prmsessionid": savedUser.sessionid.toString(),
      };
      String url = await _baseRepo.getBookingPrint(params);
      if (!isNullOrEmpty(url)) {
        launchUrl(Uri.parse(url));
      }
    } catch (error) {
      failToast(error.toString());
    }
  }

  Future<void> navigateToLocation({
    required String latitude,
    required String longitude,
  }) async {
    final Uri googleMapsUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
      '&destination=$latitude,$longitude'
      '&travelmode=driving',
    );

    try {
      await launchUrl(googleMapsUri, mode: LaunchMode.externalApplication);
    } on Exception catch (e) {
      print('Error launching Google Maps: $e');
    }
  }

  updateDriverReached() async {
    await widget.updateDriverPosition(widget.model.grno.toString());
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
                                        horizontal:
                                            SizeConfig.smallHorizontalPadding,
                                        vertical:
                                            SizeConfig.smallVerticalPadding),
                                    decoration: BoxDecoration(
                                      color: CommonColors.colorPrimary!
                                          .withAlpha((0.1 * 255).round()),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Stop ${modelDetail.sequenceno} / ${modelDetail.consignmenttypeview}',
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
                                PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert),
                                  onSelected: (value) {
                                    switch (value) {
                                      case 'enquiry':
                                        // Get.to(OtexPickupScreen(
                                        //   transactionId: isNullOrEmpty(widget
                                        //           .model.transactionid
                                        //           .toString())
                                        //       ? '0'
                                        //       : widget.model.transactionid
                                        //           .toString(),
                                        //   grno: widget.model.grno.toString(),
                                        //   orderid: isNullOrEmpty(widget
                                        //           .model.orderid
                                        //           .toString())
                                        //       ? '0'
                                        //       : widget.model.orderid.toString(),
                                        //   isReadOnly: true,
                                        // ));
                                        Get.to(ConsignmentEnquiryPage(
                                          consignmentNo: widget
                                              .model.generatedGr
                                              .toString(),
                                        ));
                                        break;
                                      case 'share':
                                        getBookingPrintLink();
                                        break;
                                      case 'map':
                                        {
                                          // we have to pass lattitude and longitude of the consignment.
                                          // used static for testing.
                                          navigateToLocation(
                                              latitude: widget.model.deliverylat
                                                  .toString(),
                                              longitude: widget
                                                  .model.deliverylong
                                                  .toString());
                                        }
                                        break;
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    if (widget.model.consignmenttype == 'P' &&
                                        status == 'Picked')
                                      const PopupMenuItem(
                                        value: 'enquiry',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.contact_support_rounded,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text('Enquiry')
                                          ],
                                        ),
                                      ),
                                    if (widget.model.consignmenttype == 'P' &&
                                        status == 'Picked')
                                      const PopupMenuItem(
                                        value: 'share',
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.share_rounded,
                                              size: 20,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Text('Share')
                                          ],
                                        ),
                                      ),
                                    const PopupMenuItem(
                                      value: 'map',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.location_on_rounded,
                                            size: 20,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text('Map')
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                          horizontal: SizeConfig
                                              .extraSmallHorizontalPadding,
                                          vertical: SizeConfig
                                              .extraSmallVerticalPadding),
                                      child: Text(
                                        status.toString(),
                                        style: TextStyle(
                                          fontSize: SizeConfig.smallTextSize,
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
                                isNullOrEmpty(modelDetail.undeliverreason)
                                    ? const SizedBox.shrink()
                                    : Text(
                                        'Reason: ${modelDetail.undeliverreason}',
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
                                updateDriverReached();
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
                                  "Reached",
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
                      color: statusIconColor.withAlpha((0.1 * 255).toInt())),
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
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: status == "Pending" ||
                                              status == "Un-Picked"
                                          ? CommonColors.colorPrimary
                                          : CommonColors.grey400,
                                      borderRadius: BorderRadius.circular(
                                          SizeConfig.extraLargeRadius),
                                    ),
                                    width:
                                        SizeConfig.extraLargeHorizontalPadding,
                                    height:
                                        SizeConfig.extraLargeVerticalPadding,
                                    child: Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            if (status == 'Pending' ||
                                                status == 'Un-Picked') {
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
                                          },
                                          child: Icon(
                                            Icons.call_outlined,
                                            color: CommonColors.White,
                                            size: SizeConfig.smallIconSize,
                                          )),
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

                  // Action Buttons for Pending
                  if (modelDetail.consignmenttype == "D" &&
                      status == "Pending") ...[
                    SizedBox(height: SizeConfig.smallVerticalSpacing),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              LmdMenuModel? targetMenu;
                              try {
                                targetMenu = widget.menuList.firstWhere(
                                    (element) =>
                                        element.tag?.toString() ==
                                        MenuTags.UNDELIVERY.name.toString());
                                {
                                  menuCode = targetMenu.menuCode.toString();
                                }
                              } catch (e) {
                                targetMenu = null;
                              }

                              String fileName =
                                  targetMenu?.fileName?.toLowerCase() ??
                                      'UnDelivery';

                              if (fileName == 'UnDelivery' ||
                                  fileName == 'undelivery') {
                                if (widget.model.reached == 'N') {
                                  failToast("Not reached");
                                  return;
                                }
                                Get.to(UnDelivery(
                                  deliveryDetailModel: modelDetail,
                                  currentDeliveryModel: currentDelivery,
                                ))?.then((_) {
                                  widget.onRefresh();
                                });
                              } else {
                                failToast("Screen $fileName not mapped.");
                              }
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
                              LmdMenuModel? targetMenu;
                              try {
                                targetMenu = widget.menuList.firstWhere(
                                    (element) =>
                                        element.tag?.toString() ==
                                        MenuTags.DELIVERY.name.toString());
                                {
                                  {
                                    menuCode = targetMenu.menuCode.toString();
                                  }
                                }
                              } catch (e) {
                                targetMenu = null;
                              }

                              String fileName =
                                  targetMenu?.fileName?.toLowerCase() ??
                                      'PodEntry';

                              if (fileName == 'PodEntry' ||
                                  fileName == 'podentry') {
                                if (widget.model.reached == 'N') {
                                  failToast("Not reached");
                                  return;
                                }
                                Get.to(PodEntry(
                                        deliveryDetailModel: modelDetail))
                                    ?.then((_) {
                                  widget.onRefresh();
                                });
                              } else {
                                failToast("Screen $fileName not mapped.");
                              }
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
                              LmdMenuModel? targetMenu;
                              try {
                                targetMenu = widget.menuList.firstWhere(
                                    (element) =>
                                        element.tag?.toString() ==
                                        MenuTags.REVERSE_PICKUP.name
                                            .toString());
                                {
                                  {
                                    menuCode = targetMenu.menuCode.toString();
                                  }
                                }
                              } catch (e) {
                                targetMenu = null;
                              }

                              String fileName =
                                  targetMenu?.fileName?.toLowerCase() ??
                                      'ReversePickup';

                              if (fileName == 'ReversePickup' ||
                                  fileName == 'reversepickup') {
                                if (widget.model.reached == 'N') {
                                  failToast("Not reached");
                                  return;
                                }
                                Get.to(ReversePickup(
                                  deliveryDetailModel: modelDetail,
                                ))?.then((_) {
                                  widget.onRefresh();
                                });
                              } else {
                                failToast("Screen $fileName not mapped.");
                              }
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
                      (modelDetail.pickupstatus == "P")) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              LmdMenuModel? targetMenu;
                              print(MenuTags.PICKUP.name.toString());
                              try {
                                targetMenu = widget.menuList.firstWhere(
                                    (element) =>
                                        element.tag?.toString() ==
                                        MenuTags.PICKUP.name.toString());
                                {
                                  {
                                    menuCode = targetMenu.menuCode.toString();
                                  }
                                }
                                {}
                              } catch (e) {
                                targetMenu = null;
                              }

                              String fileName =
                                  targetMenu?.fileName?.toLowerCase() ??
                                      'pickup';

                              if (fileName == 'OtexPickupScreen' ||
                                  fileName == 'otexpickupscreen') {
                                if (widget.model.reached == 'N') {
                                  failToast("Not reached");
                                  return;
                                }
                                Get.to(
                                  OtexPickupScreen(
                                      transactionId: isNullOrEmpty(widget
                                              .model.transactionid
                                              .toString())
                                          ? '0'
                                          : widget.model.transactionid
                                              .toString(),
                                      grno: widget.model.grno.toString(),
                                      orderid: isNullOrEmpty(
                                              widget.model.orderid.toString())
                                          ? '0'
                                          : widget.model.orderid.toString()),
                                )?.then((_) {
                                  widget.onRefresh();
                                });
                              } else if (fileName == 'Pickup' ||
                                  fileName == 'pickup') {
                                if (widget.model.reached == 'N') {
                                  failToast("Not reached");
                                  return;
                                }
                                Get.to(Pickup(details: widget.model))
                                    ?.then((_) {
                                  widget.onRefresh();
                                });
                              } else {
                                failToast("Screen $fileName not mapped.");
                              }
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
                        SizedBox(
                          width: SizeConfig.smallHorizontalPadding,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              LmdMenuModel? targetMenu;
                              try {
                                targetMenu = widget.menuList.firstWhere(
                                    (element) =>
                                        element.tag?.toString() ==
                                        'rejectpickup');
                                {
                                  {
                                    menuCode = targetMenu.menuCode.toString();
                                  }
                                }
                              } catch (e) {
                                targetMenu = null;
                              }

                              String fileName =
                                  targetMenu?.fileName ?? 'RejectPickup';

                              if (fileName == 'RejectPickup') {
                                Get.to(RejectPickup(details: widget.model))
                                    ?.then((_) {
                                  widget.onRefresh();
                                });
                              } else {
                                failToast("Screen $fileName not mapped.");
                              }
                            },
                            icon: Icon(Icons.close,
                                size: SizeConfig.mediumIconSize),
                            label: Text('Reject',
                                style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize)),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  vertical:
                                      SizeConfig.extraSmallVerticalSpacing),
                              backgroundColor: CommonColors.dangerColor,
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
