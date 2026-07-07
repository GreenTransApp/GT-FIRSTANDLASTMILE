import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/directBooking/updateBookingDispatchInfo.dart';
import 'package:gtlmd/pages/podEntry/podEntry.dart';
import 'package:gtlmd/pages/unDelivery/unDelivery.dart';
import 'package:gtlmd/tiles/addressCard.dart';

class DirectBookingTile extends StatefulWidget {
  final DeliveryDetailModel model;
  final Future<void> Function() onRefresh;
  final Future<void> Function(String grno, String indentId, String tripid)
      updateDriverPosition;
  const DirectBookingTile(
      {super.key,
      required this.model,
      required this.onRefresh,
      required this.updateDriverPosition});

  @override
  State<DirectBookingTile> createState() => _DirectBookingTileState();
}

class _DirectBookingTileState extends State<DirectBookingTile> {
  DeliveryDetailModel modelDetail = DeliveryDetailModel();
  Color? dotColor;
  Color? cardBgColor = Colors.orange.shade50;

  String? status;
  bool showActionBtn = true;
  @override
  void initState() {
    super.initState();
    modelDetail = widget.model;

    if (widget.model.deliverystatus == 'P') {
      showActionBtn = true;
    } else {
      showActionBtn = false;
    }

    checkConsignTypeAndStatus();
  }

  @override
  void didUpdateWidget(covariant DirectBookingTile oldWidget) {
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
    if (modelDetail.consignmenttype == 'D' ||
        modelDetail.consignmenttype == 'U') {
      switch (modelDetail.deliverystatus) {
        case "U":
          status = "Undelivered";
          dotColor = CommonColors.red500!;
          cardBgColor = CommonColors.red50!;

          break;
        case "D":
          status = "Delivered";
          dotColor = CommonColors.green500!;
          cardBgColor = CommonColors.green50!;

          break;
        case "P":
          status = "Pending";
          dotColor = CommonColors.amber500!;
          cardBgColor = CommonColors.amber50!;

          break;
      }
    }
  }

  // ---------------- ACTION HANDLERS ----------------

  void _onUndeliver() {
    if (modelDetail.candeliver == "Y") {
      Get.to(UnDelivery(deliveryDetailModel: modelDetail))?.then((_) {
        widget.onRefresh();
      });
    } else {
      failToast(modelDetail.validationerrmsg ??
          "You cannot undeliver this consignment.Before fill other information");
    }
  }

  void _onDeliver() {
    if (modelDetail.candeliver == "Y") {
      Get.to(PodEntry(deliveryDetailModel: modelDetail))?.then((_) {
        widget.onRefresh();
      });
    } else {
      failToast(modelDetail.validationerrmsg ??
          "You cannot deliver this consignment.Before fill other information");
    }
  }

  void _onReached() async {
    if (isNullOrEmpty(modelDetail.dispatchdatetime)) {
      failToast(modelDetail.validationerrmsg ??
          "You cannot mark this consignment as reached.Before Date time is updated");
      return;
    } else {
      await widget.updateDriverPosition(
          widget.model.grno.toString(),
          widget.model.transactionid.toString(),
          widget.model.tripid.toString());
    }
  }

  Future<void> _onUpdateDateTime() async {
    openUpdateBookingDispatchInfo(context, modelDetail, widget.onRefresh);
    // setState(() {

    // });
  }

  // ---------------- REUSABLE ACTION BUTTON ----------------

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: SizeConfig.mediumIconSize),
      label: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          label,
          style: TextStyle(
            fontSize: SizeConfig.smallTextSize,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(
          vertical: SizeConfig.extraSmallVerticalSpacing + 4,
        ),
        elevation: 1.5,
        backgroundColor: color,
        foregroundColor: CommonColors.White,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final String? reachedTime = modelDetail. != null
    //     ? DateFormat('dd MMM, hh:mm a').format(modelDetail.reachedDateTime!)
    //     : null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          // color: cardBgColor,
          color: cardBgColor,
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     CommonColors.colorPrimary!.withAlpha((0.08 * 255).round()),
          //     CommonColors.colorPrimary!.withAlpha((0.02 * 255).round()),
          //   ],
          // ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: CommonColors.colorPrimary!.withAlpha((0.25 * 255).round()),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding,
            vertical: SizeConfig.verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("test")
              // ---------------- Header: GR No / Order ID + Status chip ----------------
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${widget.model.grno}/${isNullOrEmpty(widget.model.orderid.toString()) ? "" : widget.model.orderid}',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: SizeConfig.mediumTextSize,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.smallHorizontalPadding,
                      vertical: SizeConfig.smallVerticalPadding,
                    ),
                    decoration: BoxDecoration(
                      color: CommonColors.colorPrimary!
                          .withAlpha((0.12 * 255).round()),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.local_shipping_outlined,
                            size: SizeConfig.smallTextSize + 2,
                            color: CommonColors.colorPrimary),
                        const SizedBox(width: 4),
                        Text(
                          'Direct',
                          style: TextStyle(
                            fontSize: SizeConfig.smallTextSize,
                            fontWeight: FontWeight.bold,
                            color: CommonColors.colorPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // ---------------- Reached / Updated timestamp row ----------------
              // if (reachedTime != null) ...[
              SizedBox(height: SizeConfig.extraSmallVerticalSpacing),
              Row(
                children: [
                  // Icon(Icons.access_time_filled_rounded,
                  //     size: SizeConfig.smallTextSize + 2,
                  //     color: CommonColors.green600),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      'Status: ${status.toString()}',
                      // 'Reached: ',
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
                        fontWeight: FontWeight.w600,
                        color: status == "Delivered"
                            ? CommonColors.green600
                            : status == "Undelivered"
                                ? CommonColors.red600
                                : CommonColors.amber500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              // ],

              // ---------------- Undelivered reason ----------------
              if (!isNullOrEmpty(modelDetail.undeliverreason)) ...[
                SizedBox(height: SizeConfig.extraSmallVerticalSpacing),
                Text(
                  'Reason: ${modelDetail.undeliverreason}',
                  style: TextStyle(
                    fontSize: SizeConfig.smallTextSize,
                    fontWeight: FontWeight.w700,
                    color: CommonColors.red600,
                  ),
                ),
              ],

              SizedBox(height: SizeConfig.smallVerticalSpacing),
              Divider(
                height: 1,
                color:
                    CommonColors.colorPrimary!.withAlpha((0.15 * 255).round()),
              ),
              SizedBox(height: SizeConfig.smallVerticalSpacing),

              // ---------------- Consignee ----------------
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Dispatch DateTime : ',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: SizeConfig.smallTextSize,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    TextSpan(
                      text: modelDetail.dispatchdatetime ?? '',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: SizeConfig.smallTextSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: SizeConfig.smallVerticalSpacing),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Consignee : ',
                      style: TextStyle(
                        color: Colors.black54,
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

              SizedBox(height: SizeConfig.smallVerticalSpacing),

              // ---------------- Address Card ----------------
              AddressCard(
                title: 'Address',
                address: modelDetail.cngeaddress ?? '',
                color: CommonColors.amber200!.withAlpha((0.1 * 255).toInt()),
              ),

              SizedBox(height: SizeConfig.smallVerticalSpacing),

              // ---------------- Pcs / Mobile ----------------
              Row(
                children: [
                  Expanded(
                    child: _infoBlock('Pcs', '${modelDetail.pcs}'),
                  ),
                  Expanded(
                    child:
                        _infoBlock('Mobile No.', modelDetail.cngemobile ?? '—'),
                  ),
                  Expanded(
                    child: Visibility(
                        visible: modelDetail.reached == 'Y',
                        child: Row(children: [
                          Icon(
                            Icons.check_circle,
                            color: CommonColors.green600,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text("Reached")
                        ])),
                  ),
                ],
              ),

              SizedBox(height: SizeConfig.smallVerticalSpacing + 2),

              // ---------------- Action Buttons (responsive 2x2 grid) ----------------
              if (modelDetail.consignmenttype == "D" &&
                  status == "Pending") ...[
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Stack to 2 columns always; wraps to new row automatically
                    return Column(
                      children: [
                        Row(
                          children: [
                            Visibility(
                              visible: modelDetail.dispatchdatetime == null ||
                                  modelDetail.dispatchdatetime!.isEmpty,
                              child: Expanded(
                                child: _actionButton(
                                  label: 'Update DateTime',
                                  icon: Icons.edit_calendar_outlined,
                                  color: Colors.deepPurple,
                                  onPressed: _onUpdateDateTime,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Visibility(
                              visible: modelDetail.reached == 'N',
                              child: Expanded(
                                child: _actionButton(
                                  label: 'Arrival At',
                                  icon: Icons.location_on_outlined,
                                  color: CommonColors.colorPrimary!,
                                  onPressed: _onReached,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: _actionButton(
                                label: 'Undeliver',
                                icon: Icons.close_rounded,
                                color: CommonColors.dangerColor ??
                                    CommonColors.red600!,
                                onPressed: _onUndeliver,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _actionButton(
                                label: 'Deliver',
                                icon: Icons.check_rounded,
                                color: CommonColors.successColor ??
                                    CommonColors.green600!,
                                onPressed: _onDeliver,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBlock(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.black54,
            fontSize: SizeConfig.smallTextSize,
          ),
        ),
        SizedBox(height: SizeConfig.extraSmallVerticalSpacing),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: SizeConfig.smallTextSize,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
