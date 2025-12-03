import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/homeViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/tripDetail.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/tripOrderSummary.dart';

import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';

class DashboardTripTile extends StatefulWidget {
  late TripModel model;
  late AttendanceModel attendanceModel;
  final Function(dynamic, DrsStatus)? onUpdate; // Callback function
  final Future<void> Function() onRefresh;
  DashboardTripTile(
      {super.key,
      required this.model,
      required this.attendanceModel,
      this.onUpdate,
      required this.onRefresh});

  @override
  State<DashboardTripTile> createState() => _DashboardTripTileState();
}

class _DashboardTripTileState extends State<DashboardTripTile> {
  final HomeViewModel viewModel = HomeViewModel();
  late TripModel tripModel;
  late AttendanceModel attendanceModel;

  @override
  void didUpdateWidget(covariant DashboardTripTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model ||
        widget.attendanceModel != oldWidget.attendanceModel) {
      setState(() {
        tripModel = widget.model;
        attendanceModel = widget.attendanceModel;
      });
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   final theme = Theme.of(context);
  //   return InkWell(
  //       onTap: () {
  //         if (employeeid != null &&
  //             widget.attendanceModel.attendancestatus == "Absent") {
  //           failToast("Please Mark Your Attendance First");
  //           return;
  //         } else if (isNullOrEmpty(widget.model.tripdispatchdatetime)) {
  //           failToast("Please update dispatch time first");
  //           return;
  //         } else {
  //           Get.to(TripSummary(model: widget.model))
  //               ?.then((_) => {widget.onRefresh()});
  //         }
  //       },
  //       child: Card(
  //         elevation: 4,
  //         margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16),
  //           side: BorderSide(color: CommonColors.appBarColor!),
  //         ),
  //         child: ClipRRect(
  //           borderRadius: BorderRadius.circular(16),
  //           child: Column(
  //             children: [
  //               // Header with dispatch time and edit button
  //               _buildHeader(context, theme),

  //               // Card content
  //               Padding(
  //                 padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // DRS Number row
  //                     _buildInfoRow(
  //                       label: 'Trip ID ',
  //                       value: widget.model.tripid.toString(),
  //                       theme: theme,
  //                       isHighlighted: true,
  //                     ),

  //                     const SizedBox(height: 12),

  //                     // Date row
  //                     _buildInfoRow(
  //                       label: 'Date',
  //                       value: widget.model.manifestdatetime.toString(),
  //                       theme: theme,
  //                     ),
  //                     const SizedBox(height: 12),

  //                     // KM row
  //                     _buildInfoRow(
  //                       label: 'Starting KM',
  //                       value: widget.model.startreadingkm.toString(),
  //                       theme: theme,
  //                     ),

  //                     const SizedBox(height: 12),

  //                     // Date row
  //                     _buildInfoRow(
  //                       label: 'Total Consignments',
  //                       value: widget.model.totalconsignment.toString(),
  //                       theme: theme,
  //                     ),
  //                     const SizedBox(height: 12),

  //                     // Date row
  //                     _buildInfoRow(
  //                       label: 'Pending ',
  //                       value: widget.model.pendingconsignment.toString(),
  //                       theme: theme,
  //                     ),
  //                     const SizedBox(height: 16),
  //                     Visibility(
  //                       visible: widget.model.tripdispatchdatetime != null &&
  //                           widget.model.pendingconsignment == 0,
  //                       child: Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             "Close Trip",
  //                             style: theme.textTheme.bodyMedium?.copyWith(
  //                               color: Colors.grey.shade700,
  //                               fontWeight: FontWeight.w500,
  //                             ),
  //                           ),
  //                           IconButton(
  //                               onPressed: () {
  //                                 openUpdateTripInfo(context, widget.model,
  //                                         TripStatus.close, widget.onRefresh)
  //                                     .then((value) {
  //                                   widget.onRefresh();
  //                                 });
  //                               },
  //                               icon: Icon(
  //                                 Icons.cancel_outlined,
  //                                 color: CommonColors.dangerColor!,
  //                                 size: 25,
  //                               ))
  //                         ],
  //                       ),
  //                     ),
  //                     const SizedBox(height: 16),
  //                     Row(children: [
  //                       _buildStatusItem(
  //                         label: 'Total DRS',
  //                         value: widget.model.totaldrs.toString(),
  //                         color: CommonColors.colorPrimary!,
  //                         theme: theme,
  //                       ),
  //                     ])
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ));
  // }

  // Widget _buildHeader(BuildContext context, ThemeData theme) {
  //   return Container(
  //     color: CommonColors.colorPrimary!.withOpacity(0.05),
  //     padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           'Dispatch Time',
  //           style: theme.textTheme.titleMedium?.copyWith(
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         isNullOrEmpty(widget.model.tripdispatchdatetime)
  //             ? InkWell(
  //                 onTap: () => {
  //                   openUpdateTripInfo(context, widget.model, TripStatus.open,
  //                           widget.onRefresh)
  //                       .then((value) {
  //                     widget.onRefresh();
  //                   })
  //                 },
  //                 borderRadius: BorderRadius.circular(30),
  //                 child: Container(
  //                   padding: const EdgeInsets.all(8),
  //                   decoration: BoxDecoration(
  //                     color: CommonColors.colorPrimary!.withOpacity(0.1),
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: Icon(
  //                     Icons.schedule_rounded,
  //                     color: CommonColors.colorPrimary,
  //                     size: 22,
  //                   ),
  //                 ),
  //               )
  //             : Expanded(
  //                 child: Align(
  //                     alignment: Alignment.centerRight,
  //                     child:
  //                         Text(widget.model.tripdispatchdatetime.toString())))
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildInfoRow({
  //   required String label,
  //   required String value,
  //   required ThemeData theme,
  //   bool isHighlighted = false,
  // }) {
  //   return Row(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       SizedBox(
  //         width: 140,
  //         child: Text(
  //           "${label}",
  //           style: theme.textTheme.bodyMedium?.copyWith(
  //             color: Colors.grey.shade700,
  //             fontWeight: FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //       Text(
  //         ': ',
  //         style: theme.textTheme.bodyMedium?.copyWith(
  //           color: Colors.grey.shade700,
  //         ),
  //       ),
  //       Expanded(
  //         child: Text(
  //           value,
  //           style: theme.textTheme.bodyMedium?.copyWith(
  //             color: isHighlighted ? CommonColors.colorPrimary : Colors.black87,
  //             fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildStatusItem({
  //   required String label,
  //   required String value,
  //   required Color color,
  //   required ThemeData theme,
  // }) {
  //   return Expanded(
  //     child: Container(
  //       padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
  //       margin: const EdgeInsets.only(right: 8),
  //       decoration: BoxDecoration(
  //         color: color.withOpacity(0.1),
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Text(
  //             label,
  //             style: TextStyle(
  //                 color: color.withOpacity(0.8),
  //                 overflow: TextOverflow.ellipsis),
  //             // style: theme.textTheme.bodySmall?.copyWith(
  //             //   color: color.withOpacity(0.8),

  //             // ),
  //           ),
  //           const SizedBox(height: 2),
  //           Text(
  //             value,
  //             style: theme.textTheme.titleMedium?.copyWith(
  //               fontWeight: FontWeight.bold,
  //               color: color,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => TripDetail(model: widget.model));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Trip ID and Summary Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trip #${widget.model.tripid.toString()}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a1a1a),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.model.manifestdatetime.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(() => TripORdersSummary(tripModel: widget.model));
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFe8f5f2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFF4db8a8).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Color(0xFF4db8a8),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Summary',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4db8a8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Divider
            Container(
              height: 1,
              color: Colors.grey[200],
            ),
            const SizedBox(height: 16),
            // Trip Details Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.2,
              children: [
                _buildInfoItem(
                    'Date', widget.model.manifestdatetime.toString()),
                _buildInfoItem(
                    'Starting KM', widget.model.startreadingkm.toString()),
                _buildInfoItem(
                  'Consignments',
                  widget.model.totalconsignment.toString(),
                ),
                _buildInfoItem(
                    'Pending', '${widget.model.pendingconsignment.toString()}'),
              ],
            ),
            const SizedBox(height: 16),
            // ORS Status Badge
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F9FF),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF4db8a8).withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total ORS',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4db8a8),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      widget.model.totaldrs.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1a1a1a),
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
