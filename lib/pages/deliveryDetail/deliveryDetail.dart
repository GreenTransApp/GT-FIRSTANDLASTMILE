import 'dart:async';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/lmdMenuModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryViewModel.dart';
import 'package:gtlmd/pages/directBooking/directBookingPage.dart';
import 'package:gtlmd/pages/mapView/mapViewPage.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/tiles/deliveryDetailTile.dart';
import 'package:lottie/lottie.dart';

class DeliveryDetail extends StatefulWidget {
  // final CurrentDeliveryModel model;
  final TripModel tripModel;
  const DeliveryDetail(
      {super.key,
      // required this.model,
      required this.tripModel});

  @override
  State<DeliveryDetail> createState() => _DeliveryDetailState();
}

class _DeliveryDetailState extends State<DeliveryDetail>
    with WidgetsBindingObserver {
  CurrentDeliveryModel deliveryModel = CurrentDeliveryModel();
  List<DeliveryDetailModel> deliveryDetailList = List.empty(growable: true);
  List<LmdMenuModel> menuList = [];
  late LoadingAlertService loadingAlertService;
  final DeliveryViewModel viewModel = DeliveryViewModel();
  final BaseRepository _baseRepo = BaseRepository();
  final List<StreamSubscription> _subscription = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // deliveryModel = widget.model;

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));

    getUserData().then((user) => {
          if (user.commandstatus == null || user.commandstatus == -1)
            throw Exception("")
          else
            {
              setObservers(),
              getDeliveryDetails(),
              getMenu(),
              getBookingMenuCodeFromCompAccPara(),
              // getBookingPdf()
            }
        });
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     refreshScreen();
  //   }
  // }

  void getBookingPdf() async {
    Map<String, String> params = {
      "prmconnstring": savedUser.companyid.toString(),
      "prmgrno": 'RUH10000288',
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": "GTAPP_BOOKING",
      "prmsessionid": savedUser.sessionid.toString(),
    };
    String url = await _baseRepo.getBookingPrint(params);
    print(url);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    for (var sub in _subscription) {
      sub.cancel();
    }

    super.dispose();
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   refreshScreen();
  // }

  setObservers() {
    viewModel.deliveryDetailLiveData.stream.listen((resp) {
      if (resp.isNotEmpty && resp.elementAt(0).commandstatus == 1) {
        setState(() {
          deliveryDetailList = resp;
        });
      } else {
        setState(() {
          deliveryDetailList = [];
        });
      }
    });
    viewModel.deliveryDataLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        setState(() {
          deliveryModel = resp;
        });
      }
    });

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

    _subscription.add(viewModel.getMenuLiveData.stream.listen((data) {
      setState(() {
        menuList = data;
      });
      print(data);
    }));

    _subscription.add(_baseRepo.compAccPara.stream.listen((resp) {
      debugPrint(resp);
      setState(() {
        if (resp.isNotEmpty && resp.contains('GTI')) {
          menuCode = resp;
          debugPrint('Booking Menucode ${resp}');
        } else {
          debugPrint('Booking Menucode Not Found');
        }
      });
    }));

    _subscription.add(viewModel.updateDriverReachedLD.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        successToast("Location Update successfull");
        refreshScreen();
      } else {
        failToast(resp.commandmessage ?? "Something went wrong");
      }
    }));

    _subscription.add(viewModel.driverReachedDlvPoint.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        successToast("Location Update successfull");
        refreshScreen();
      } else {
        failToast(resp.commandmessage ?? "Something went wrong");
      }
    }));
  }

  getDeliveryDetails() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmdrsno": "",
      "prmtripid": widget.tripModel.tripid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    viewModel.getDeliveryDetail(params);
  }

  getMenu() {
    Map<String, String> params = {
      "prmusercode": savedUser.usercode.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmdivisionid": savedUser.logindivisionid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    viewModel.getMenu(params);
  }

  Future<void> refreshScreen() async {
    getDeliveryDetails();
    getBookingMenuCodeFromCompAccPara();
  }

  Future<void> updateDriverReached(
      String grno, String indentId, String tripid) async {
    // Position position = await Geolocator.getCurrentPosition(
    //     // ignore: deprecated_member_use
    //     desiredAccuracy: LocationAccuracy.high);
    loadingAlertService.showLoading();

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

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
      viewModel.updateDriverReached(params);
    } finally {
      loadingAlertService.hideLoading();
    }
  }

  Future<void> updateDriverReachedDlvPoint(
      String grno, String indentId, String tripid) async {
    loadingAlertService.showLoading();

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 0,
        ),
      );

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
      viewModel.updateDriverReachedDlvPoint(params);
    } finally {
      loadingAlertService.hideLoading();
    }
  }

  getBookingMenuCodeFromCompAccPara() {
    Map<String, String> params = {
      "prmvarname": "GLMDBOOKINGMENUCODE",
      "prmcompanyid": savedLogin.companyid.toString(),
    };

    printParams(params);
    _baseRepo.getValueFromCompAccPara(params);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'Trip Detail',
          style: TextStyle(
              color: CommonColors.White, fontSize: isSmallDevice ? 18 : 20),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: CommonColors.White,
              size: isSmallDevice ? 25 : 30,
            )),
        actions: [
          InkWell(
            onTap: () {
              Get.to(MapViewPage(
                model: widget.tripModel,
                // routeDetailList: routeDetailList,
              ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                "assets/images/map.png",
                height: isSmallDevice ? 25 : 35,
              ),
            ),
          ),
        ],
      ),
      // floatingActionButton: AvatarGlow(
      //   glowColor: CommonColors.colorPrimary ?? Colors.blue,
      //   repeat: true,
      //   child: FloatingActionButton(
      //     onPressed: () async {
      //       Get.to(DirectBookingPage());
      //     },
      //     shape: const CircleBorder(),
      //     backgroundColor: CommonColors.indigoshade50,
      //     highlightElevation: 10.0,
      //     child: Container(
      //       decoration: BoxDecoration(
      //         shape: BoxShape.circle,
      //         border: Border.all(
      //           color: CommonColors.colorPrimary ?? Colors.blue, // Border color
      //           width: 1, // Border thickness
      //         ),
      //       ),
      //       child: ClipOval(
      //         child: Image.asset(
      //           'assets/images/directbooking.png',
      //           fit: BoxFit.cover,
      //           // width: 50,
      //           // height: 50,
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
      body: widget.tripModel == null
          ? Scaffold(
              body: Center(
              child: Text(
                "data not  found ".toUpperCase(),
                style:
                    TextStyle(color: CommonColors.successColor, fontSize: 20),
              ),
            ))
          : Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: isSmallDevice ? 8 : 10, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 1,
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(isSmallDevice ? 12.0 : 16.0),
                      child: Column(
                        children: [
                          // Basic Info
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Trip ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                        fontSize: isSmallDevice ? 13 : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.tripModel.tripid.toString(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallDevice ? 14 : 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Consignment',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                        fontSize: isSmallDevice ? 13 : 14,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${deliveryModel.noofconsign}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: isSmallDevice ? 14 : 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Consignments Title
                  Text(
                    'Consignments',
                    style: TextStyle(
                      fontSize: isSmallDevice ? 16 : 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  deliveryDetailList.isNotEmpty
                      ? Expanded(
                          child: RefreshIndicator(
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
                                itemCount: deliveryDetailList.length,
                                itemBuilder: (context, index) {
                                  var data = deliveryDetailList[index];

                                  return DeliveryDetailTile(
                                      model: data,
                                      currentDeliveryModel: deliveryModel,
                                      listLength: deliveryDetailList.length,
                                      index: index,
                                      onRefresh: refreshScreen,
                                      menuList: menuList,
                                      updateDriverPosition: updateDriverReached,
                                      updateDriverReachedDlvPoint:
                                          updateDriverReachedDlvPoint);
                                },
                              ),
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
                ],
              ),
            ),
    );
  }
}
