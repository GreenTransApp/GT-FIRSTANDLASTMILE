import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gtlmd/bottomSheet/datePicker.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryViewModel.dart';
import 'package:gtlmd/pages/directBooking/directBookingViewModel.dart';
import 'package:gtlmd/pages/directBooking/model/directBookingModel.dart';
import 'package:gtlmd/tiles/directBookingTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DirectBookingPage extends StatefulWidget {
  const DirectBookingPage({super.key});

  @override
  State<DirectBookingPage> createState() => _DirectBookingPageState();
}

class _DirectBookingPageState extends State<DirectBookingPage> {
  List<DeliveryDetailModel> directBookingList = List.empty(growable: true);

  DirectBookingViewModel viewModel = DirectBookingViewModel();
  DeliveryViewModel deliveryViewModel = DeliveryViewModel();
  late LoadingAlertService loadingAlertService;
  String fromDt = "";
  String toDt = "";
  String viewFromDt = "";
  String viewToDt = "";
  late String smallDateTime;
  late DateTime todayDateTime;
 final List<StreamSubscription> _subscription = [];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    setObservers();
    getDirectBookingSearchList();
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
    deliveryViewModel.viewDialog.stream.listen((showLoading) async {
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
    deliveryViewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.directBookingLiveData.stream.listen((data) {
      setState(() {
        directBookingList = data;
      });
    });

    _subscription.add(deliveryViewModel.updateDriverReachedLD.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        successToast("Location Update successfull");
        refreshScreen();
      }else{
        failToast(resp.commandmessage ?? "Something went wrong");
      }
    }));
  }

  getDirectBookingSearchList() {
    Map<String, dynamic> params = {
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      // "prmfromdate": convert2SmallDateTime("2026-06-01"),
      // "prmtodate": convert2SmallDateTime("2026-07-01"),
      "prmfromdate": convert2SmallDateTime(fromDt.toString()),
      "prmtodate": convert2SmallDateTime(toDt.toString()),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.getDirectBookingSearchList(params);
  }


   Future<void> updateDriverReached(String grno, String indentId,String tripid) async {
    Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high);

    Map<String, String> params = {
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmtripid": tripid,
      "prmgrno": grno,
      "prmindentid": indentId,
      "prmreachedlat": position.latitude.toString(),
      "prmreachedlong": position.longitude.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    deliveryViewModel.updateDriverReached(params);
  }
  void _dateChanged(String fromDt, String toDt) {
    // debugPrint("fromDt ${fromDt}");
    // debugPrint("toDt ${toDt}");

    this.fromDt = fromDt;
    this.toDt = toDt;

    DateTime fromdt = DateTime.parse(this.fromDt);
    DateTime todt = DateTime.parse(this.toDt);

    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    refreshScreen();
  }

  Future<void> refreshScreen() async {
    getDirectBookingSearchList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          "Direct Booking",
          style: TextStyle(color: CommonColors.White),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: CommonColors.white,
              ));
        }),
        actions: [
          InkWell(
            onTap: () {
              showDatePickerBottomSheet(context, _dateChanged);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.horizontalPadding,
                  vertical: SizeConfig.verticalPadding),
              child: Icon(
                Icons.calendar_today_rounded,
                color: CommonColors.white,
              ),
            ),
          )
        ],
      ),
      body: directBookingList.isEmpty
          ? Scaffold(
              body: Center(
              child: Text(
                "data not  found ".toUpperCase(),
                style:
                    TextStyle(color: CommonColors.successColor, fontSize: 20),
              ),
            ))
          :


              directBookingList.isNotEmpty
                  ? RefreshIndicator(
                    onRefresh: refreshScreen,
                    backgroundColor: CommonColors.colorPrimary,
                    color: CommonColors.White,
                    child: Container(
                      decoration: BoxDecoration(
                        color: CommonColors.White,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: CommonColors.appBarColor
                                .withAlpha((0.05 * 255).round()),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        itemCount: directBookingList.length,
                        itemBuilder: (context, index) {
                          var data = directBookingList[index];
                  
                          return DirectBookingTile(
                            model: data,
                            onRefresh: refreshScreen,
                            updateDriverPosition: updateDriverReached,
                          );
                        },
                      ),
                    ),
                  )
                  : Center(
                      child: Column(
                        children: [
                          Lottie.asset(
                            'assets/map_blue.json',
                            height: 100,
                          ),
                          const Text(
                            "No Data Found",
                            style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 18),
                          )
                        ],
                      ),
                    )

    );
  }
}
