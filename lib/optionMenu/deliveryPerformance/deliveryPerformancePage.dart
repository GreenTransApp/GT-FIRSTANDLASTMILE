import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/deliveryPerformanceViewModel.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/model/deliveryPerformanceModel.dart';
import 'package:gtlmd/optionMenu/tripMis/Model/tripMisJsonPramas.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:intl/intl.dart';

class DeliveryPerformancePage extends StatefulWidget {
  const DeliveryPerformancePage({super.key});

  @override
  State<DeliveryPerformancePage> createState() =>
      _DeliveryPerformancePageState();
}

class _DeliveryPerformancePageState extends State<DeliveryPerformancePage> {
  DeliveryPerformanceModel performanceData = DeliveryPerformanceModel();
  late LoadingAlertService loadingAlertService;
  DeliveryPerformanceViewModel viewModel = DeliveryPerformanceViewModel();
  String fromDt = "";
  String toDt = "";
  String viewFromDt = "";
  String viewToDt = "";
  String formattedDate = '';
  late DateTime todayDateTime;
  late String smallDateTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    formattedDate = formatDate(DateTime.now().millisecondsSinceEpoch);
    debugPrint('Formatted date $formattedDate');
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    DateTime fromdt = DateTime.parse(fromDt);
    DateTime todt = DateTime.parse(toDt);
    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    setObservers();
    getDeliveryPerformanceData();
  }

  setObservers() {
    viewModel.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        setState(() {
          // isLoading = true;
          loadingAlertService.showLoading();
        });
      } else {
        setState(() {
          // isLoading = false;
          loadingAlertService.hideLoading();
        });
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.performanceData.stream.listen((data) {
      setState(() {
        performanceData = data;
      });
    });
  }

  getDeliveryPerformanceData() {
    final LiveDataJsonParams parameters = LiveDataJsonParams(
        fromdt: convert2SmallDateTime(fromDt.toString()),
        todt: convert2SmallDateTime(toDt.toString()),
        branchname: 'ALL',
        branchcode: 'ALL',
        ridername: savedUser.username.toString(),
        ridercode: savedUser.drivercode.toString(),
        drsno: null,
        cnno: null);

    Map<String, dynamic> params = {
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmlogindivisionid": "0",
      "prmjsondatastr": jsonEncode(parameters.toJson()),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": "GTI_LMDLIVEDASHBOARD",
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.getPerformanceData(params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.pageBackground,
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: CommonColors.white,
          ),
        ),
        title: Text(
          'Delivery Performance',
          style: TextStyle(
            color: CommonColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// USER IMAGE
            /// USER IMAGE
            CircleAvatar(
              radius: 42,
              backgroundColor: CommonColors.White,
              child: Image.network(
                savedLogin.logoimage.toString(),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset("assets/images/defaultimage.png",
                      fit: BoxFit.cover);
                },
              ),
            ),
            const SizedBox(height: 10),

            /// USER NAME
            Text(
              savedUser.displayusername.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: CommonColors.textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            /// CONSIGNMENT SUMMARY CARD
            Card(
              elevation: 4,
              shadowColor: CommonColors.shadow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      CommonColors.primaryLight,
                      CommonColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      'Consignment Summary',
                      style: TextStyle(
                        fontSize: 14,
                        color: CommonColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 15),

                    /// TOTAL CONSIGNMENT
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CommonColors.colorPrimary?.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.local_shipping_outlined,
                            color: CommonColors.colorPrimary,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Consignment',
                              style: TextStyle(
                                fontSize: 12,
                                color: CommonColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isNullOrEmpty(performanceData.noOfConsignments
                                      .toString())
                                  ? "0"
                                  : performanceData.noOfConsignments
                                      .toString(), // You can bind this dynamically
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: CommonColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Divider(
                      thickness: 1,
                      color: CommonColors.testColor,
                    ),

                    const SizedBox(height: 10),

                    /// PENDING CONSIGNMENT AS % WITH PROGRESS
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: CommonColors.orange!.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.hourglass_bottom_rounded,
                            color: CommonColors.orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending Consignment',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: CommonColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                isNullOrEmpty(performanceData.pendingPercent
                                        .toString())
                                    ? "0"
                                    : performanceData.pendingPercent
                                        .toString(), // dynamically bind pending %
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: CommonColors.orange,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: LinearProgressIndicator(
                                    value: ((double.tryParse(performanceData
                                                        .pendingPercent ??
                                                    '0') ??
                                                0) /
                                            100)
                                        .clamp(0.0,
                                            1.0), // ensures the value is between 0 and 1
                                    backgroundColor:
                                        CommonColors.orange!.withOpacity(0.2),
                                    valueColor: AlwaysStoppedAnimation(
                                        CommonColors.orange),
                                    minHeight: 6,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// ANALYTICS TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Analytics',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: CommonColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),

            const SizedBox(height: 12),

            /// ANALYTICS GRID
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                AnalyticsBox(
                  title: 'Within 4Hours',
                  count: isNullOrEmpty(performanceData.within4Hours.toString())
                      ? ''
                      : performanceData.within4Hours.toString(),
                  percentage: isNullOrEmpty(
                          performanceData.within24HoursPercent.toString())
                      ? ''
                      : performanceData.within4HoursPercent.toString(),
                  color: CommonColors.analytics4H,
                  icon: Icons.access_time, // clock icon
                ),
                AnalyticsBox(
                  title: 'Within 6Hours',
                  count: isNullOrEmpty(performanceData.within6Hours.toString())
                      ? ''
                      : performanceData.within6Hours.toString(),
                  percentage: isNullOrEmpty(
                          performanceData.within6HoursPercent.toString())
                      ? ''
                      : performanceData.within4HoursPercent.toString(),
                  color: CommonColors.analytics6H,
                  icon: Icons.timelapse, // alternative clock icon
                ),
                AnalyticsBox(
                  title: 'Within 24Hours',
                  count: isNullOrEmpty(performanceData.within24Hours.toString())
                      ? ''
                      : performanceData.within24Hours.toString(),
                  percentage: isNullOrEmpty(
                          performanceData.within24HoursPercent.toString())
                      ? ''
                      : performanceData.within24HoursPercent.toString(),
                  color: CommonColors.analytics24H,
                  icon: Icons.schedule, // schedule icon
                ),
                AnalyticsBox(
                  title: 'Post 24Hours',
                  count: isNullOrEmpty(performanceData.post24Hours.toString())
                      ? ''
                      : performanceData.post24Hours.toString(),
                  percentage: isNullOrEmpty(
                          performanceData.post24HoursPercent.toString())
                      ? ''
                      : performanceData.post24HoursPercent.toString(),
                  color: CommonColors.analyticsPost,
                  icon: Icons.history, // history icon
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

/// ANALYTICS BOX
class AnalyticsBox extends StatelessWidget {
  final String title;
  final String count;
  final String percentage;
  final Color color;
  final IconData? icon;

  const AnalyticsBox({
    super.key,
    required this.title,
    required this.count,
    required this.percentage,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    double percentValue = (double.tryParse(percentage) ?? 0) / 100;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ICON + TITLE
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null)
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: CommonColors.appBarColor!.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: CommonColors.white,
                  ),
                ),
              if (icon != null) const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: CommonColors.appBarColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // COUNT
          FittedBox(
            child: Text(
              count,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: CommonColors.white,
              ),
            ),
          ),

          const SizedBox(height: 4),

          // PERCENTAGE + PROGRESS
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Text(
                    '$percentage%',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                      color: CommonColors.white!.withOpacity(0.8),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: percentValue.clamp(0.0, 1.0),
                    backgroundColor: CommonColors.white!.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation(CommonColors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
