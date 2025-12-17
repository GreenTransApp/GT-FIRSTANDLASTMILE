 import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/pages/trips/closeTrip/closeTripViewModel.dart';
import 'package:gtlmd/pages/closedDrs/closedDrs.dart';
import 'package:gtlmd/pages/closedDrs/closedDrsViewModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';


import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class CloseTrip extends StatefulWidget {
  const CloseTrip({super.key});

  @override
  State<CloseTrip> createState() => _CloseTripState();
}

class _CloseTripState extends State<CloseTrip> {
  late String fromdt, todt;
  String viewFromDt = "";
  String viewToDt = "";
  CloseTripViewModel viewModel = CloseTripViewModel();
  List<TripModel> currentTripModel = [];
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
    getClosedTrips();
  }

  void setObservers() {
    viewModel.closedTripLiveData.stream.listen((data) {
      setState(() {
        currentTripModel = data;
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

  getClosedTrips() {
    Map<String, String> params = {
      'prmcompanyid': savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmfromdt": fromdt,
      "prmtodt": todt,
      "prmsessionid": savedUser.sessionid.toString(),
    };
    viewModel.getClosedTripList(params);
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
    getClosedTrips();
  }
  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: const Text('Closed Trips', style: TextStyle(color: Colors.white)),
        foregroundColor: CommonColors.White,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(0, 16, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {
                    showDatePickerBottomSheet(context, _dateChanged);
                  },
                  icon: Icon(Icons.calendar_today,
                      size: 16, color: CommonColors.colorPrimary),
                  label: Text('$viewFromDt - $viewToDt',
                      style: TextStyle(color: CommonColors.colorPrimary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    side: BorderSide(color: CommonColors.colorPrimary!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              color: CommonColors.colorPrimary,
              child: currentTripModel.isEmpty
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
                      itemCount: currentTripModel.length,
                      itemBuilder: (context, index) {
                        return _tile(currentTripModel[index], theme);
                      },
                    ),
              onRefresh: () async {
                getClosedTrips();
              },
            ),
          )
        ],
      ),
    );
  
  }

   Widget _tile(TripModel model, ThemeData theme) {
    final theme = Theme.of(context);
    return InkWell(
        onTap: () {
          
            Get.to(ClosedDrs(model: model))
                ?.then((_) => {});
          
        },
        child: Card(
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
                _buildHeader(context, theme,model),

                // Card content
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DRS Number row
                      _buildInfoRow(
                        label: 'Trip ID ',
                        value: model.tripid.toString(),
                        theme: theme,
                        isHighlighted: true,
                      ),

                      const SizedBox(height: 12),

                      // Date row
                      _buildInfoRow(
                        label: 'Date',
                        value: model.manifestdatetime.toString(),
                        theme: theme,
                      ),
                      const SizedBox(height: 12),

                      // KM row
                      _buildInfoRow(
                        label: 'Starting KM',
                        value: model.startreadingkm.toString(),
                        theme: theme,
                      ),

                      // const SizedBox(height: 12),

                      // // Date row
                      // _buildInfoRow(
                      //   label: 'Total Consignments',
                      //   value: model.noofconsign.toString(),
                      //   theme: theme,
                      // ),
                      const SizedBox(height: 12),

                      // Date row
                      _buildInfoRow(
                        label: 'Pending ',
                        value: model.pendingconsign.toString(),
                        theme: theme,
                      ),
                      const SizedBox(height: 16),
                      // Visibility(
                      //   visible: model.tripdispatchdatetime != null &&
                      //       model.pendingconsignment == 0,
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         "Close Trip",
                      //         style: theme.textTheme.bodyMedium?.copyWith(
                      //           color: Colors.grey.shade700,
                      //           fontWeight: FontWeight.w500,
                      //         ),
                      //       ),
                      //       IconButton(
                      //           onPressed: () {
                               
                      //           },
                      //           icon: Icon(
                      //             Icons.cancel_outlined,
                      //             color: CommonColors.dangerColor!,
                      //             size: 25,
                      //           ))
                      //     ],
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      Row(children: [
                        _buildStatusItem(
                          label: 'Total Consignment',
                          value: model.noofconsign.toString(),
                          color: CommonColors.colorPrimary!,
                          theme: theme,
                        ),
                      ])
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  
Widget _buildHeader(BuildContext context, ThemeData theme,TripModel model) {
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
          isNullOrEmpty(model.tripdispatchdatetime)
              ? InkWell(
                  onTap: () => {
                    // openUpdateTripInfo(context, widget.model, TripStatus.open,
                    //         widget.onRefresh)
                    //     .then((value) {
                    //   widget.onRefresh();
                    // })
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: CommonColors.colorPrimary!.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.schedule_rounded,
                      color: CommonColors.colorPrimary,
                      size: 22,
                    ),
                  ),
                )
              : Expanded(
                  child: Align(
                      alignment: Alignment.centerRight,
                      child:
                          Text(model.tripdispatchdatetime.toString())))
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

  Widget _buildStatusItem({
    required String label,
    required String value,
    required Color color,
    required ThemeData theme,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: color.withOpacity(0.8),
                  overflow: TextOverflow.ellipsis),
              // style: theme.textTheme.bodySmall?.copyWith(
              //   color: color.withOpacity(0.8),

              // ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
