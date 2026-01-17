import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
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
            size: SizeConfig.largeIconSize,
          ),
        ),
        title: Text(
          'Delivery Performance',
          style: TextStyle(
              color: CommonColors.white,
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.largeTextSize),
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
            SizedBox(height: SizeConfig.smallVerticalSpacing),

            /// USER NAME
            Text(
              savedUser.displayusername.toString(),
              style: TextStyle(
                fontSize: SizeConfig.largeTextSize,
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
                borderRadius:
                    BorderRadius.circular(SizeConfig.extraLargeRadius),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.extraLargeRadius),
                  gradient: const LinearGradient(
                    colors: [
                      CommonColors.primaryLight,
                      CommonColors.primaryLight,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.largeHorizontalPadding,
                    vertical: SizeConfig.largeVerticalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// TITLE
                    Text(
                      'Consignment Summary',
                      style: TextStyle(
                        fontSize: SizeConfig.mediumTextSize,
                        color: CommonColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: SizeConfig.smallVerticalSpacing),

                    /// TOTAL CONSIGNMENT
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.horizontalPadding,
                              vertical: SizeConfig.verticalPadding),
                          decoration: BoxDecoration(
                            color: CommonColors.colorPrimary
                                ?.withAlpha((0.2 * 255).toInt()),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.extraLargeRadius),
                          ),
                          child: Icon(
                            Icons.local_shipping_outlined,
                            color: CommonColors.colorPrimary,
                            size: SizeConfig.extraLargeIconSize,
                          ),
                        ),
                        SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Consignment',
                              style: TextStyle(
                                fontSize: SizeConfig.mediumTextSize,
                                color: CommonColors.textSecondary,
                              ),
                            ),
                            SizedBox(height: SizeConfig.smallVerticalSpacing),
                            Text(
                              isNullOrEmpty(performanceData.noOfConsignments
                                      .toString())
                                  ? "0"
                                  : performanceData.noOfConsignments
                                      .toString(), // You can bind this dynamically
                              style: TextStyle(
                                fontSize: SizeConfig.largeTextSize,
                                fontWeight: FontWeight.bold,
                                color: CommonColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.mediumVerticalSpacing),

                    Divider(
                      thickness: 1,
                      color: CommonColors.testColor,
                    ),

                    SizedBox(height: SizeConfig.mediumVerticalSpacing),

                    /// PENDING CONSIGNMENT AS % WITH PROGRESS
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.horizontalPadding,
                              vertical: SizeConfig.verticalPadding),
                          decoration: BoxDecoration(
                            color: CommonColors.orange!
                                .withAlpha((255 * 0.2).toInt()),
                            borderRadius: BorderRadius.circular(
                                SizeConfig.extraLargeIconSize),
                          ),
                          child: Icon(
                            Icons.hourglass_bottom_rounded,
                            color: CommonColors.orange,
                            size: SizeConfig.extraLargeIconSize,
                          ),
                        ),
                        SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pending Consignment',
                                style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize,
                                  color: CommonColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: SizeConfig.smallVerticalSpacing),
                              Text(
                                isNullOrEmpty(performanceData.pendingPercent
                                        .toString())
                                    ? "0"
                                    : performanceData.pendingPercent
                                        .toString(), // dynamically bind pending %
                                style: TextStyle(
                                  fontSize: SizeConfig.largeTextSize,
                                  fontWeight: FontWeight.w600,
                                  color: CommonColors.orange,
                                ),
                              ),
                              const SizedBox(height: 6),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.smallRadius),
                                  child: LinearProgressIndicator(
                                    value: ((double.tryParse(performanceData
                                                        .pendingPercent ??
                                                    '0') ??
                                                0) /
                                            100)
                                        .clamp(0.0,
                                            1.0), // ensures the value is between 0 and 1
                                    backgroundColor: CommonColors.orange!
                                        .withAlpha((0.2 * 255).toInt()),
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

            SizedBox(height: SizeConfig.mediumVerticalSpacing),

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
      padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.largeHorizontalPadding,
          vertical: SizeConfig.verticalPadding),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(SizeConfig.extraLargeRadius),
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
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  decoration: BoxDecoration(
                    color: CommonColors.appBarColor!
                        .withAlpha((255 * 0.2).toInt()),
                    borderRadius:
                        BorderRadius.circular(SizeConfig.extraLargeRadius),
                  ),
                  child: Icon(
                    icon,
                    size: SizeConfig.largeIconSize,
                    color: CommonColors.white,
                  ),
                ),
              if (icon != null)
                SizedBox(width: SizeConfig.smallHorizontalSpacing),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: SizeConfig.mediumTextSize,
                    fontWeight: FontWeight.w600,
                    color: CommonColors.appBarColor,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // COUNT
          FittedBox(
            child: Text(
              count,
              style: TextStyle(
                fontSize: SizeConfig.largeTextSize,
                fontWeight: FontWeight.bold,
                color: CommonColors.white,
              ),
            ),
          ),

          SizedBox(height: SizeConfig.mediumVerticalSpacing),

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
                      fontSize: SizeConfig.largeTextSize,
                      fontWeight: FontWeight.w800,
                      color: CommonColors.white!.withAlpha((0.8 * 255).toInt()),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.smallVerticalSpacing),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: percentValue.clamp(0.0, 1.0),
                    backgroundColor:
                        CommonColors.white!.withAlpha((0.2 * 255).toInt()),
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
