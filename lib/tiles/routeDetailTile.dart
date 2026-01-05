import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';

import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailModel.dart';
import 'package:timeline_tile/timeline_tile.dart';

class RouteDetailTile extends StatefulWidget {
  final RouteDetailModel model;
  final int listLength;
  final int index;
  final bool showDragHandle;

  RouteDetailTile({
    super.key,
    required this.model,
    required this.listLength,
    required this.index,
    this.showDragHandle = true,
  });

  @override
  State<RouteDetailTile> createState() => _RouteDetailTileState();
}

class _RouteDetailTileState extends State<RouteDetailTile> {
  bool isFirst = false;
  bool isLast = false;
  RouteDetailModel modelDetail = RouteDetailModel();
  int listValue = 0;
  int listIndex = 0;
  late Color dotColor;
  late Color cardBorderColor;
  late Color cardBgColor;
  late IconData statusIcon;
  late Color statusIconColor;
  String? status;

  bool isConsignVisible = false;
  bool isPickUp = false;
  bool isDesitnation = false;
  bool isExpanded = false;
  @override
  void initState() {
    super.initState();
    modelDetail = widget.model;
    listValue = widget.listLength;
    listIndex = widget.index;
    isPickUp = modelDetail.grno.toString().contains("Pickup");
    isDesitnation = modelDetail.grno.toString().contains("Final");

    setState(() {
      if (modelDetail.grno!.contains("Pickup") ||
          modelDetail.grno!.contains("Final Point")) {
        isConsignVisible = true;
      } else {
        isConsignVisible = false;
      }
      checkConsignTypeAndStatus();
    });

    if (listIndex == 0 && listValue == 1) {
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

  checkConsignTypeAndStatus() {
    switch (modelDetail.consignmenttype) {
      case "R":
        status = "REVERSE PICKUP";
        dotColor = CommonColors.orangeColor!;
        cardBorderColor = CommonColors.orangeColor!;
        cardBgColor = CommonColors.orangeColor!.withAlpha((0.1 * 255).round());
        statusIcon = Icons.cancel;
        statusIconColor = CommonColors.orangeColor!;
        break;
      case "P":
        status = "PICKUP";
        dotColor = CommonColors.amber700!;
        cardBorderColor = CommonColors.amber700!;
        cardBgColor = CommonColors.amber700!.withAlpha((0.1 * 255).round());
        statusIcon = Icons.check_circle;
        statusIconColor = CommonColors.amber700!;
        break;
      case "D":
        status = "DELIVERY";
        dotColor = CommonColors.successColor!;
        cardBorderColor = CommonColors.successColor!;
        cardBgColor = CommonColors.successColor!.withAlpha((0.1 * 255).round());
        statusIcon = Icons.access_time;
        statusIconColor = CommonColors.successColor!;
        break;
      default:
        status = "DELIVERY";
        dotColor = CommonColors.colorPrimary!;
        cardBorderColor = CommonColors.colorPrimary!;
        cardBgColor = CommonColors.colorPrimary!.withAlpha((0.1 * 255).round());
        statusIcon = Icons.access_time;
        statusIconColor = CommonColors.colorPrimary!;
        break;
    }
  }

  @override
  void didUpdateWidget(covariant RouteDetailTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.model != widget.model) {
      setState(() {
        modelDetail = widget.model;
      });
    }
    setState(() {
      checkConsignTypeAndStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    Widget content = TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.1,
      isFirst: isFirst,
      isLast: isLast,
      indicatorStyle: _buildIndicatorStyle(),
      beforeLineStyle: LineStyle(
        // color: CommonColors.colorPrimary!,
        color: dotColor,
        thickness: 2,
      ),
      afterLineStyle: LineStyle(
        // color: CommonColors.colorPrimary!,
        color: dotColor,
        thickness: 2,
      ),
      endChild: Padding(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.verticalPadding,
            horizontal: SizeConfig.horizontalPadding),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(SizeConfig.smallIconSize),
                    decoration: BoxDecoration(
                      color: CommonColors.colorPrimary!
                          .withAlpha((0.1 * 255).round()),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.largeRadius),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Visibility(
                              visible: !isConsignVisible,
                              child: Flexible(
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal:
                                          SizeConfig.smallHorizontalPadding,
                                      vertical:
                                          SizeConfig.smallVerticalPadding),
                                  decoration: BoxDecoration(
                                    color: CommonColors.colorPrimary!
                                        .withAlpha((0.1 * 255).round()),
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.largeRadius),
                                  ),
                                  child: Text(
                                    // 'Stop ${modelDetail.sequenceid}',
                                    'Stop ${widget.index} / ${modelDetail.consignmenttypeview}',
                                    style: TextStyle(
                                      fontSize: SizeConfig.extraSmallTextSize,
                                      fontWeight: FontWeight.bold,
                                      color: CommonColors.colorPrimary,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (!isConsignVisible)
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isExpanded = !isExpanded;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: SizeConfig.smallHorizontalPadding),
                                  child: Icon(
                                    isExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_down,
                                    color: CommonColors.colorPrimary,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: SizeConfig.smallVerticalSpacing),
                        Row(
                          children: [
                            Text(
                              // modelDetail.grno.toString(),
                              modelDetail.grno.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.smallTextSize,
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: !isFirst && !isLast,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  modelDetail.address.toString(),
                                  style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isPickUp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Starting location',
                          style: TextStyle(
                            color: CommonColors.appBarColor,
                            fontSize: SizeConfig.smallTextSize,
                          ),
                        ),
                        Text(
                          '${modelDetail.address}',
                          style: TextStyle(
                            color: CommonColors.appBarColor,
                            fontSize: SizeConfig.smallTextSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isDesitnation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Destination',
                          style: TextStyle(
                            color: CommonColors.black54,
                            fontSize: SizeConfig.smallTextSize,
                          ),
                        ),
                        Text(
                          '${modelDetail.address}',
                          style: TextStyle(
                            color: CommonColors.black54,
                            fontSize: SizeConfig.smallTextSize,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                      visible: !isConsignVisible,
                      child: const SizedBox(height: 8)),
                  Visibility(
                    visible: !isConsignVisible && isExpanded,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.smallHorizontalPadding,
                                vertical: SizeConfig.smallVerticalPadding),
                            decoration: BoxDecoration(
                              // color: CommonColors.grey50,
                              color: cardBgColor,
                              borderRadius:
                                  BorderRadius.circular(SizeConfig.smallRadius),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: SizeConfig.extraSmallIconSize,
                                          color: CommonColors.colorPrimary,
                                        ),
                                        Text(
                                          'Name:',
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.extraSmallTextSize,
                                            color: CommonColors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Text(
                                        modelDetail.cnge.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              SizeConfig.extraSmallTextSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.phone_android_outlined,
                                          size: SizeConfig.smallIconSize,
                                          color: CommonColors.colorPrimary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Mobile No.:',
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.extraSmallTextSize,
                                            color: CommonColors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Text(
                                        modelDetail.cngemobile.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              SizeConfig.extraSmallTextSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: SizeConfig.smallIconSize,
                                          color: CommonColors.colorPrimary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Pcs:',
                                          style: TextStyle(
                                            fontSize: SizeConfig.smallTextSize,
                                            color: CommonColors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Text(
                                        modelDetail.pcs.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              SizeConfig.extraSmallTextSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.route_outlined,
                                          size: isSmallDevice ? 12 : 16,
                                          color: CommonColors.amber700,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Distance:',
                                          style: TextStyle(
                                            fontSize: isSmallDevice ? 10 : 12,
                                            color: CommonColors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${modelDetail.distance}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: SizeConfig.smallTextSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                                // const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: SizeConfig.smallIconSize,
                                          color: CommonColors.colorPrimary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Type:',
                                          style: TextStyle(
                                            fontSize: SizeConfig.smallTextSize,
                                            color: CommonColors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Flexible(
                                      child: Text(
                                        '${modelDetail.consignmenttypeview}',
                                        style: TextStyle(
                                          color: statusIconColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize: SizeConfig.smallTextSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (widget.showDragHandle &&
                widget.index != 0 &&
                widget.index != widget.listLength - 1)
              ReorderableDragStartListener(
                index: widget.index,
                child: Padding(
                  padding: EdgeInsets.only(left: SizeConfig.horizontalPadding),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    decoration: BoxDecoration(
                        color: CommonColors.colorPrimary,
                        borderRadius: BorderRadius.all(
                            Radius.circular(SizeConfig.mediumRadius)),
                        border: Border.all(
                            color: CommonColors.colorPrimary!, width: 1)),
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Text(
                        "Drag",
                        style: TextStyle(
                          color: CommonColors.White,
                          fontSize: SizeConfig.smallTextSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    SizedBox(
      child: TimelineTile(
        isFirst: isFirst,
        isLast: isLast,
        indicatorStyle:
            IndicatorStyle(width: 20, color: CommonColors.colorPrimary!),
        afterLineStyle: LineStyle(color: CommonColors.colorPrimary!),
        beforeLineStyle: LineStyle(color: CommonColors.colorPrimary!),
        endChild: Container(
            decoration: BoxDecoration(
              color: cardBgColor,
              border: Border.symmetric(
                  horizontal:
                      BorderSide(width: 0.5, color: CommonColors.disableColor)),
              // borderRadius: const BorderRadius.all(Radius.circular(10))
            ),
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding),
            child: Column(
              children: [
                Visibility(
                  visible: !isConsignVisible,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('${widget.model.grno}',
                                      style: TextStyle(
                                          fontSize: SizeConfig.smallTextSize,
                                          fontWeight: FontWeight.bold)),
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
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: CircleAvatar(
                                      radius: SizeConfig.smallRadius,
                                      backgroundColor:
                                          CommonColors.colorPrimary,
                                      child: CircleAvatar(
                                        radius: SizeConfig.mediumRadius,
                                        backgroundColor: CommonColors.White,
                                        child: Text(
                                          "${widget.model.sequenceid}",
                                          style: TextStyle(
                                              color: CommonColors.colorPrimary,
                                              fontSize:
                                                  SizeConfig.smallTextSize),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("${widget.model.address}",
                                      style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Pcs ',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: SizeConfig.smallTextSize)),
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
                                    style: TextStyle(
                                      fontSize: SizeConfig.smallTextSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Distance ',
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontSize: SizeConfig.smallTextSize)),
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
                                    " : ${widget.model.distance}",
                                    maxLines: 2,
                                    softWrap: false,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: SizeConfig.smallTextSize,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                    visible: isConsignVisible,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                fit: FlexFit.tight,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${widget.model.grno}".toUpperCase(),
                                      maxLines: 3,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: SizeConfig.smallTextSize,
                                          fontWeight: FontWeight.bold,
                                          // color: CommonColors.colorPrimary,
                                          // decoration: TextDecoration.underline,
                                          decorationColor:
                                              CommonColors.colorPrimary),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ))
              ],
            )),
      ),
    );

    // if (widget.showDragHandle) {
    //   content = ReorderableDragStartListener(
    //     index: widget.index,
    //     child: content,
    //   );
    // }

    return content;
  }

  _buildIndicatorStyle() {
    Color? indicatorBackgroundColor = CommonColors.White;
    if (isPickUp) {
      indicatorBackgroundColor = CommonColors.colorPrimary;
    } else if (isDesitnation) {
      indicatorBackgroundColor = CommonColors.green600;
    }

    // Color? borderColor = CommonColors.colorPrimary;
    Color? borderColor = dotColor;
    if (isPickUp) {
      borderColor = CommonColors.colorPrimary;
    }
    if (isDesitnation) {
      borderColor = CommonColors.green600;
    }
    return IndicatorStyle(
      width: SizeConfig.largeHorizontalSpacing,
      height: SizeConfig.largeVerticalSpacing,
      indicator: Container(
        decoration: BoxDecoration(
          color: indicatorBackgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor!,
            width: 2,
          ),
        ),
        child: isPickUp
            ? Icon(
                Icons.local_shipping_outlined,
                color: CommonColors.White,
                size: SizeConfig.smallIconSize,
              )
            : isDesitnation
                ? Icon(
                    Icons.flag_outlined,
                    color: CommonColors.White,
                    size: 16,
                  )
                : Center(
                    child: Text(
                      // '$listIndex',
                      '${widget.index}',
                      style: TextStyle(
                        // color: CommonColors.colorPrimary,
                        color: dotColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
      ),
    );
  }
}
