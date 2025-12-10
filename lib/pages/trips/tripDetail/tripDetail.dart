import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripDetailModel.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionBottomSheet.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/tripDetailViewModel.dart';
import 'package:gtlmd/service/fireBaseService/firebaseLocationUpload.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class TripDetail extends StatefulWidget {
  TripModel model;
  TripDetail({super.key, required this.model});

  @override
  State<TripDetail> createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
// final TripSummaryViewModel viewModel = TripSummaryViewModel();
  BaseRepository _baseRepo = BaseRepository();
  List<CurrentDeliveryModel> tripSummaryList = List.empty(growable: true);
  List<TripDetailModel> manifestList = List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  String fromDt = "";
  String toDt = "";
  String formattedDate = '';
  late DateTime todayDateTime;
  late String smallDateTime;

  TripDetailViewModel viewModel = TripDetailViewModel();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {});
    setObservers();
    formattedDate = formatDate(DateTime.now().millisecondsSinceEpoch);
    debugPrint('Formatted date $formattedDate');
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    DateTime fromdt = DateTime.parse(fromDt);
    DateTime todt = DateTime.parse(toDt);

    // getDrsList();
    getTripDetail();
  }

  void getTripDetail() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
      "prmtripid": widget.model.tripid.toString(),
    };

    // printParams(params);
    // _baseRepo.getDrsList(params);
    viewModel.getTripDetail(params);
  }

  setObservers() {
    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.tripSummaryList.stream.listen((tripSummaryList) {
      // debugPrint('Trip Summary List Length: ${tripSummaryList.length}');
      // if (tripSummaryList.elementAt(0).commandstatus == 1) {
      setState(() {
        this.tripSummaryList = tripSummaryList;
      });
      // }
    });

    viewModel.manifestListLiveData.stream.listen((list) {
      setState(() {
        manifestList = list;
      });
    });
  }

  Future<void> refreshScreen() async {
    getTripDetail();
  }

  Future<void> closeTripOnClick() async {
    FirebaseLocationUpload().deleteLocation(executiveid!.toString(),
        savedLogin.companyid.toString(), widget.model.tripid.toString());
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: CommonColors.grey600,
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'Trip Detail',
          style: TextStyle(color: CommonColors.White),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: CommonColors.White,
            )),
        actions: [
          IconButton(
              onPressed: () {
                showDrsSelectionBottomSheet(
                        context, widget.model.tripid!, false, null)
                    .then((value) {
                  refreshScreen();
                });
              },
              icon: Icon(
                Icons.add,
                color: CommonColors.White,
              ))
        ],
      ),
      body: RefreshIndicator(
        color: Colors.white,
        backgroundColor: CommonColors.colorPrimary,
        onRefresh: refreshScreen,
        child: Container(
          child: (tripSummaryList.isEmpty) == true
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset("assets/emptyDelivery.json",
                              height: 150),
                          const Text(
                            "No orders",
                            style: TextStyle(
                                fontSize: 18, color: CommonColors.appBarColor),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              : ListView.separated(
                  shrinkWrap: true,
                  // physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: tripSummaryList.length,

                  itemBuilder: (context, index) {
                    var currentData = tripSummaryList[index];
                    return Padding(
                        padding:
                            const EdgeInsetsGeometry.symmetric(horizontal: 16),
                        child: DashBoardDeliveryTile(
                          model: currentData,
                          tripModel: widget.model,
                          // attendanceModel: _attendanceModel,
                          // onUpdate: widget.onUpdate,
                          onRefresh: refreshScreen,
                          showHeader: true,
                          showInfo: true,
                          showCheckboxSelection: false,
                          showStatusIndicators: true,
                          enableTap: true,
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(
                      color: Colors.grey, // Customize divider color
                      thickness: 1, // Customize divider thickness
                      height:
                          20, // Customize the height of the divider (including spacing)
                      indent: 16, // Indent from the left
                      endIndent: 16, // Indent from the right
                    );
                  },
                ),
        ),
      ),
      // persistentFooterButtons: [
      // Container(
      //   height: 60,
      //   child: CommonButton(
      //       title: "Close Trip",
      //       color: CommonColors.colorPrimary!,
      //       onTap: () {
      //         // Get.back();
      //         for (var element in tripSummaryList) {
      //           if (element.pendingconsign! > 0) {
      //             failToast(
      //                 "All deliveries must be completed before closing the trip.");
      //             return;
      //           }
      //         }
      //         openUpdateTripInfo(
      //             context, widget.model, TripStatus.close, closeTripOnClick);
      //       }),
      // ),
      // ],
    );
  }
}
