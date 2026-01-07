import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/pages/attendance/models/viewAttendanceModel.dart';
import 'package:gtlmd/optionMenu/closedDrs/closedDrsViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';

import 'package:gtlmd/service/connectionCheckService.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ClosedDrs extends StatefulWidget {
  TripModel model;
  ClosedDrs({
    super.key,
    required this.model,
  });

  @override
  State<ClosedDrs> createState() => _ClosedDrsState();
}

class _ClosedDrsState extends State<ClosedDrs> {
  late String fromdt, todt;
  String viewFromDt = "";
  String viewToDt = "";
  ClosedDrsViewModel viewModel = ClosedDrsViewModel();
  List<CurrentDeliveryModel> currentDeliveryModel = [];
  late LoadingAlertService loadingAlertService;

  @override
  void initState() {
    super.initState();
    // fromdt = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    fromdt = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    todt = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
    viewFromDt = DateFormat('dd-MM-yyyy').format(DateTime.parse(fromdt));
    viewToDt = DateFormat('dd-MM-yyyy').format(DateTime.parse(todt));
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    getClosedDrsList();
  }

  void setObservers() {
    viewModel.closedDrsLiveData.stream.listen((data) {
      setState(() {
        currentDeliveryModel = data;
      });
    });

    viewModel.viewDialogLiveData.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });
  }

  getClosedDrsList() {
    Map<String, String> params = {
      'prmcompanyid': savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmfromdt": fromdt,
      "prmtodt": todt,
      "prmtripid": widget.model.tripid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };
    viewModel.getClosedDrsList(params);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: const Text('Closed DRS', style: TextStyle(color: Colors.white)),
        foregroundColor: CommonColors.White,
      ),
      body: Column(
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       OutlinedButton.icon(
          //         onPressed: () {
          //           showDatePickerBottomSheet(context, _dateChanged);
          //         },
          //         icon: Icon(Icons.calendar_today,
          //             size: 16, color: CommonColors.colorPrimary),
          //         label: Text('$viewFromDt - $viewToDt',
          //             style: TextStyle(color: CommonColors.colorPrimary)),
          //         style: OutlinedButton.styleFrom(
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: 16, vertical: 12),
          //           side: BorderSide(color: CommonColors.colorPrimary!),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(8),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: RefreshIndicator(
              color: CommonColors.colorPrimary,
              child: currentDeliveryModel.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "No Closed DRS Found ",
                            style: TextStyle(
                              color: CommonColors.appBarColor,
                              fontSize: 24,
                            ),
                          ),
                          Lottie.asset("assets/emptyDelivery.json",
                              height: 150),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: currentDeliveryModel.length,
                      itemBuilder: (context, index) {
                        return tile(currentDeliveryModel[index], theme);
                      },
                    ),
              onRefresh: () async {
                getClosedDrsList();
              },
            ),
          )
        ],
      ),
    );
  }

  void _dateChanged(String fromDt, String toDt) {
    debugPrint("fromDt ${fromDt}");
    debugPrint("toDt ${toDt}");

    this.fromdt = fromDt;
    this.todt = toDt;
    DateTime fromdt = DateTime.parse(this.fromdt);
    DateTime todt = DateTime.parse(this.todt);
    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    getClosedDrsList();
  }

  Widget tile(CurrentDeliveryModel model, ThemeData theme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: CommonColors.grey200!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Header with dispatch time and edit button
            _buildHeader(model, context, theme),

            // Card content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // DRS Number row
                  _buildInfoRow(
                    label: 'DRS#',
                    value: model.drsno.toString(),
                    theme: theme,
                    isHighlighted: true,
                  ),

                  const SizedBox(height: 12),

                  // Date row
                  _buildInfoRow(
                    label: 'Manifest Date',
                    value: model.manifestdatetime.toString(),
                    theme: theme,
                  ),

                  const SizedBox(height: 16),

                  // _buildInfoRow(
                  //   label: 'Start Reading KM',
                  //   value: model.startreadingkm.toString(),
                  //   theme: theme,
                  // ),

                  // const SizedBox(height: 16),

                  // _buildInfoRow(
                  //   label: 'Close Reading KM',
                  //   value: model.closeReadingKm.toString(),
                  //   theme: theme,
                  // ),

                  // const SizedBox(height: 16),

                  // Status indicators

                  _buildStatusIndicators(model, theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
      CurrentDeliveryModel model, BuildContext context, ThemeData theme) {
    return Container(
      color: CommonColors.colorPrimary!.withOpacity(0.05),
      padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Dispatch Time',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          isNullOrEmpty(model.dispatchdatetime)
              ?
              //  InkWell(
              //     onTap: () => {},
              //     borderRadius: BorderRadius.circular(30),
              //     child: Container(
              //       padding: const EdgeInsets.all(8),
              //       decoration: BoxDecoration(
              //         color: CommonColors.colorPrimary!.withOpacity(0.1),
              //         shape: BoxShape.circle,
              //       ),
              //       child: Icon(
              //         Icons.schedule_rounded,
              //         color: CommonColors.colorPrimary,
              //         size: 22,
              //       ),
              //     ),
              //   )
              Text("Data Not found".toUpperCase(),
                  style: TextStyle(color: CommonColors.colorPrimary))
              : Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Text("${model.dispatchdatetime.toString()}")))
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    required ThemeData theme,
    bool isHighlighted = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            "${label}",
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          ': ',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: isHighlighted ? CommonColors.colorPrimary : Colors.black87,
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIndicators(CurrentDeliveryModel model, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for the status section
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            'Delivery Status',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        // Status grid
        Row(
          children: [
            _buildStatusItem(
              label: 'Total',
              value: model.noofconsign.toString(),
              color: CommonColors.colorPrimary!,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Delivered',
              value: model.deliveredconsign.toString(),
              color: Colors.green,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Undelivered',
              value: model.undeliveredconsign.toString(),
              color: Colors.red,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Pending',
              value: model.pendingconsign.toString(),
              color: Colors.orange,
              theme: theme,
            ),
            _buildStatusItem(
              label: 'Pickup',
              value: model.totpickup.toString(),
              color: CommonColors.colorPrimary!,
              theme: theme,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusItem({
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                  color: color.withOpacity(0.8),
                  overflow: TextOverflow.ellipsis),
              // style: theme.textTheme.bodySmall?.copyWith(
              //   color: color.withOpacity(0.8),

              // ),
            ),
          ],
        ),
      ),
    );
  }
}
