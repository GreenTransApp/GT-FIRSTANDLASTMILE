import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailModel.dart';

class ReceivedLoadTile extends StatefulWidget {
  final RouteDetailModel model;
  final Future<void> Function(bool value, int index) onCheckChange;
  int index;

  ReceivedLoadTile(
      {super.key,
      required this.model,
      required this.index,
      required this.onCheckChange});

  @override
  State<ReceivedLoadTile> createState() => _ReceivedLoadTileState();
}

class _ReceivedLoadTileState extends State<ReceivedLoadTile> {
  bool allChecked = false;
  RouteDetailModel modelDetail = RouteDetailModel();

  @override
  void initState() {
    super.initState();
    modelDetail = widget.model;
  }

  @override
  void didUpdateWidget(covariant ReceivedLoadTile oldWidget) {
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
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      decoration: BoxDecoration(
          border: Border.all(color: CommonColors.colorPrimary!, width: 1),
          borderRadius: BorderRadius.circular(SizeConfig.largeRadius)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                modelDetail.grno.toString(),
                // "GR#",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.mediumTextSize,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Receive ${modelDetail.pcs.toString()} Pieces: ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: SizeConfig.mediumTextSize),
                  ),
                  Checkbox(
                    value: modelDetail.checked,
                    activeColor: CommonColors.colorPrimary,
                    onChanged: (bool? value) {
                      setState(() {
                        // modelDetail.checked = value!;
                        widget.onCheckChange(value!, widget.index);
                      });
                    },
                  )
                ],
              )
            ],
          ),
          const Divider(),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding),
            decoration: BoxDecoration(
              color: CommonColors.grey200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    modelDetail.address.toString(),
                    style: const TextStyle(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  decoration: BoxDecoration(
                    color: CommonColors.grey200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: SizeConfig.largeIconSize,
                                color: CommonColors.colorPrimary,
                              ),
                              SizedBox(
                                  width: SizeConfig.smallHorizontalSpacing),
                              Text(
                                'Name:',
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
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
                                fontSize: SizeConfig.mediumTextSize,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone_android_outlined,
                                size: SizeConfig.largeIconSize,
                                color: CommonColors.colorPrimary,
                              ),
                              SizedBox(
                                  width: SizeConfig.smallHorizontalSpacing),
                              Text(
                                'Mobile No.:',
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
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
                                fontSize: SizeConfig.mediumTextSize,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: SizeConfig.largeIconSize,
                                color: CommonColors.colorPrimary,
                              ),
                              SizedBox(
                                  width: SizeConfig.smallHorizontalSpacing),
                              Text(
                                'pcs:',
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
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
                                fontSize: SizeConfig.mediumTextSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.route_outlined,
                                size: SizeConfig.largeIconSize,
                                color: CommonColors.amber700,
                              ),
                              SizedBox(
                                  width: SizeConfig.smallHorizontalSpacing),
                              Text(
                                'Distance:',
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
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
                                fontSize: SizeConfig.mediumTextSize,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: SizeConfig.largeIconSize,
                                color: CommonColors.colorPrimary,
                              ),
                              SizedBox(
                                  width: SizeConfig.smallHorizontalSpacing),
                              Text(
                                'Type:',
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
                                  color: CommonColors.black54,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              '${modelDetail.consignmenttypeview}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.mediumTextSize,
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
        ],
      ),
    );
  }
}
