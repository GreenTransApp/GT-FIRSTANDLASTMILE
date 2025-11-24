import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/pages/routeDetail/Model/routeDetailModel.dart';

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
    // TODO: implement initState
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
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          border: Border.all(color: CommonColors.colorPrimary!, width: 1),
          borderRadius: BorderRadius.circular(10)),
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  Text(
                    "Receive ${modelDetail.pcs.toString()} Pieces: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  modelDetail.address.toString(),
                  // "address",
                  style: const TextStyle(),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: CommonColors.grey50,
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
                                size: 16,
                                color: CommonColors.colorPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Name:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CommonColors.black54,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              modelDetail.cnge.toString(),
                              // "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
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
                                size: 16,
                                color: CommonColors.colorPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Mobile No.:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CommonColors.black54,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              modelDetail.cngemobile.toString(),
                              // "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
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
                                size: 16,
                                color: CommonColors.colorPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'pcs:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CommonColors.black54,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              modelDetail.pcs.toString(),
                              // "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.route_outlined,
                                size: 16,
                                color: CommonColors.amber700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Distance:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CommonColors.black54,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              '${modelDetail.distance}',
                              // "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              softWrap: true,
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                size: 16,
                                color: CommonColors.colorPrimary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Type:',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: CommonColors.black54,
                                ),
                              ),
                            ],
                          ),
                          Flexible(
                            child: Text(
                              '${modelDetail.consignmenttypeview}',
                              // "",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
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
