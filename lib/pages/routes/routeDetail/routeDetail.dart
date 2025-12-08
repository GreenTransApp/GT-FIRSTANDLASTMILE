import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/grList/grList.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/mapView/mapViewPage.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigJsonModel.dart';
import 'package:gtlmd/pages/receivedLoad/ReceivedLoadPage.dart';

import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailModel.dart';
import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailUpdateModel.dart';
import 'package:gtlmd/pages/routes/routeDetail/routeDetailViewModel.dart';
import 'package:gtlmd/tiles/routeDetailTile.dart';
import 'package:lottie/lottie.dart';

class Routedetail extends StatefulWidget {
  final AllotedRouteModel model;
  const Routedetail({super.key, required this.model});

  @override
  State<Routedetail> createState() => _RoutedetailState();
}

class _RoutedetailState extends State<Routedetail> {
  late LoadingAlertService loadingAlertService;
  final RouteDetailviewModel viewModel = RouteDetailviewModel();
  List<RouteDetailModel> routeDetailList = List.empty(growable: true);
  List<RouteDetailModel> originalRouteDetailList = List.empty(growable: true);
  bool showActionBtn = true;
  bool showUpdateBtn = false;
  AllotedRouteModel modelDetail = AllotedRouteModel();
  MapConfigJsonModel mapConfig = MapConfigJsonModel();

  RouteUpdateModel acceptRouteModel = RouteUpdateModel();
  RouteUpdateModel rejectRouteModel = RouteUpdateModel();
  BaseRepository _baseRepo = BaseRepository();
  double totalDistance = 0;

  bool routeModifyAllowed = false;
  bool hasDeliveries = false;

  @override
  void initState() {
    super.initState();
    modelDetail = widget.model;

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));

    getUserData().then((user) => {
          if (user.commandstatus == null || user.commandstatus == -1)
            throw Exception("")
          else
            {
              setObservers(),
              _getGoogleMapApiKey(),
              _getRouteChangeAllowedPara(),
              getRouteDetails(),
              getMapConfig()
            }
        });

    setState(() {
      if (isNullOrEmpty(todayAttendance.outtime)) {
        showActionBtn = true;
      } else {
        showActionBtn = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  getMapConfig() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.password.toString(),
      "prmplanningid": modelDetail.planningid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    // viewModel.getMapConfig(params);
    _baseRepo.getMapConfig(params);
  }

  _getRouteChangeAllowedPara() {
    Map<String, String> params = {
      "prmvarname": "GALLOWLMDROUTEINMOBILEAPP",
      "prmcompanyid": savedLogin.companyid.toString(),
    };

    printParams(params);
    _baseRepo.getValueFromCompAccPara(params);
  }

  setObservers() {
    viewModel.routeDetailLiveData.stream.listen((resp) {
      if (resp.elementAt(0).commandstatus == 1) {
        setState(() {
          routeDetailList = resp;

          if (originalRouteDetailList.isEmpty) {
            originalRouteDetailList = resp;
          }

          // debugPrint(
          //     "===========================BEFORE===========================");
          for (int i = 0; i < routeDetailList.length; i++) {
            RouteDetailModel route = routeDetailList[i];
            // debugPrint(
            //     "${route.grno} ${route.address} ${route.deliverylat} ${route.deliverylong} ${route.distance} ${route.sequenceid} ${route.planningdraftcode}");

            if (route.consignmenttype == 'D' &&
                route.grno != 'Pickup' &&
                route.grno != 'Final Point') {
              hasDeliveries = true;
              return;
            }
          }
          // debugPrint(
          //     "===========================AFTER===========================");
        });
      }
    });
    viewModel.routeDataLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        setState(() async {
          modelDetail = resp;
          // if (totalDistance > 0) {
          //   modelDetail.totdistance = totalDistance.toString();
          // }

          if (modelDetail.acceptedStatus! == "Y") {
            showUpdateBtn = true;
          } else {
            showUpdateBtn = false;
          }
        });
      }
    });
    viewModel.routeAcceptLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        setState(() {
          acceptRouteModel = resp;
          successToast("PLANNING ACCEPTED SUCCESSFULLY");

          getRouteDetails();
        });
      } else {
        failToast(resp.commandmessage.toString() ?? "Something went wrong");
      }
    });
    viewModel.routeRejectLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        setState(() {
          rejectRouteModel = resp;
          successToast("PLANNING REJECTED SUCCESSFULLY");
          okayCallBackForAlert();
        });
      } else {
        failToast(resp.commandmessage.toString() ?? "Something went wrong");
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

    viewModel.updateRoutePlanning.stream.listen((updateRoute) {
      if (updateRoute.commandstatus == 1) {
        routeDetailList = [];
        successToast("Route updated successfully");
        getRouteDetails();
      }
    });

    _baseRepo.mapConfigDetail.stream.listen((resp) {
      if (resp.commandStatus == 1) {
        // Handle map config detail response
        debugPrint("Map Config Detail: ${resp.mapConfigData}");
        mapConfig = resp.mapConfigData ?? MapConfigJsonModel();
      } else {
        failToast(resp.commandMessage ?? "Failed to fetch map config details");
      }
    });

    _baseRepo.accResp.stream.listen((resp) async {
      if (isNullOrEmpty(resp)) {
        failToast("Unable To Fetch Google Map Api key, plese Try Again.");
      } else {
        GOOGLE_MAPS_API_KEY = resp;
      }
    });

    _baseRepo.compAccPara.stream.listen((resp) {
      routeModifyAllowed = resp == 'Y';
      setState(() {});
    });
  }

  void okayCallBackForAlert() {
    Navigator.pop(context);
  }

  void getRouteDetails() {
    // failToast('data not found');
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.password.toString(),
      "prmplanningid": modelDetail.planningid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };
    printParams(params);
    viewModel.getRouteDetailData(params);
  }

  void updateRoute() {
    List<String> grnoList = List.empty(growable: true);
    List<String> addressList = List.empty(growable: true);
    List<String> deliverylatList = List.empty(growable: true);
    List<String> deliverylongList = List.empty(growable: true);
    List<String> pickuplatList = List.empty(growable: true);
    List<String> pickuplongList = List.empty(growable: true);
    List<String> distanceList = List.empty(growable: true);
    List<String> sequenceidList = List.empty(growable: true);
    List<String> planningdraftcodeList = List.empty(growable: true);
    List<String> orderTypeList = List.empty(growable: true);
    List<String> indentIdList = List.empty(growable: true);

    for (int i = 0; i < routeDetailList.length; i++) {
      RouteDetailModel route = routeDetailList[i];
      debugPrint(
          "${route.grno} ${route.address} ${route.deliverylat} ${route.deliverylong} ${route.distance} ${route.sequenceid} ${route.planningdraftcode}");
      grnoList.add(route.grno.toString());
      addressList.add(route.address.toString());
      deliverylatList.add(route.deliverylat.toString());
      deliverylongList.add(route.deliverylong.toString());
      pickuplatList.add(route.pickuplat.toString());
      pickuplongList.add(route.pickuplong.toString());
      distanceList.add(route.distance.toString() ?? '0');
      sequenceidList.add(route.sequenceid.toString() ?? '0');
      indentIdList.add(route.indentid.toString() ?? '0');
      orderTypeList.add(route.consignmenttype.toString() ?? 'D');
      planningdraftcodeList.add(route.planningdraftcode.toString());
    }

    Map<String, dynamic> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmplanningid": modelDetail.planningid.toString(),
      "prmdraftcodestr": planningdraftcodeList.join(",") + ",",
      "prmsequenceidstr": sequenceidList.join(",") + ",",
      "prmgrnostr": grnoList.join(",") + ",",
      "prmaddressstr": addressList.join(",") + ",",
      "prmdeliverylatstr": deliverylatList.join(",") + ",",
      "prmdeliverylongstr": deliverylongList.join(",") + ",",
      "prmpickuplatstr": pickuplatList.join(",") + ",",
      "prmpickuplongstr": pickuplongList.join(",") + ",",
      "prmdistancestr": distanceList.join(",") + ",",
      "prmordertypestr": orderTypeList.join(",") + ",",
      "prmordertypestr": orderTypeList.join(",") + ",",
      "prmindentidstr": indentIdList.join(",") + ",",
      "prmsessionid": savedUser.sessionid.toString(),
    };

    debugPrint(savedLogin.companyid.toString());
    viewModel.updateRoute(params);
  }

  void alterForAccept() {
    commonAlertDialog(
        context,
        "Confirm!",
        "Are you sure you want to 'ACCEPT' route  ",
        //  ' $_currentAddress ' ,
        "",
        Icon(Icons.dangerous),
        _acceptRoute,
        cancelCallBack: okayCallBackForAlert,
        iconColor: CommonColors.successColor!,
        timer: 10);
  }

  void alterForReject() {
    commonAlertDialog(
        context,
        "Confirm!",
        "Are you sure you want to 'REJECT' route  ",
        //  ' $_currentAddress ' ,
        "",
        Icon(Icons.dangerous),
        _rejectRoute,
        cancelCallBack: okayCallBackForAlert,
        iconColor: CommonColors.dangerColor!,
        timer: 10);
  }

  void _acceptRoute() {
    // failToast('data not found');
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.password.toString(),
      "prmplanningid": modelDetail.planningid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    viewModel.acceptRouteUpdate(params);
  }

  _getGoogleMapApiKey() {
    Map<String, String> params = {
      "keyNo": "73",
      "prmcompanyid": savedLogin.companyid.toString(),
    };

    printParams(params);
    _baseRepo.getValueFromAccPara(params);
  }

  void _rejectRoute() {
    // failToast('data not found');
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.password.toString(),
      "prmplanningid": modelDetail.planningid.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    viewModel.rejectRouteUpdate(params);
  }

  void updateSequenceBeforeSubmit(List<int> totalDistanceList) {
    for (int i = 1; i < routeDetailList.length; i++) {
      routeDetailList[i].sequenceid = i;
      if (i < totalDistanceList.length) {
        routeDetailList[i].distance =
            (totalDistanceList[i].toDouble() / 1000).toString();
      } else {
        routeDetailList[i].distance = "0.00";
      }
    }

    getLoginData().then((login) => {updateRoute()});
  }

  Future<void> refreshScreen() async {
    getRouteDetails();
  }

  fetchDistanceFromGoogleApi(List<RouteDetailModel> routeDetail) async {
    try {
      // totalDistance = await fetchTotalRouteDistance(routeDetail);
      // loadingAlertService.showLoading();
      List<int> totalDistanceList =
          await fetchTotalRouteDistance(routeDetail, mapConfig);
      // loadingAlertService.hideLoading();
      totalDistance = (totalDistanceList[0].toDouble()) / 1000;
      // debugPrint("New Distance: $distance");
      if (totalDistance >
          double.parse(modelDetail.totdistance!
              .substring(0, modelDetail.totdistance!.length - 4))) {
        double diff = totalDistance -
            double.parse(modelDetail.totdistance!
                .substring(0, modelDetail.totdistance!.length - 4));
        double diff2 = double.parse(diff.toStringAsFixed(6));

        showAlert("Distance Increased", const Icon(Icons.update_outlined), "",
            "Your distance has increased by $diff2 km. Do you still want to update?",
            () {
          setState(() {
            updateSequenceBeforeSubmit(totalDistanceList);
          });
        }, () {
          refreshScreen();
        });
      } else if (totalDistance <=
          double.parse(modelDetail.totdistance!
              .substring(0, modelDetail.totdistance!.length - 4))) {
        updateSequenceBeforeSubmit(totalDistanceList);
      }
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  showAlert(String title, Icon icon, String address, String msg,
      void Function() okayCallBack, void Function() cancelCallBack) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            icon: icon,
            iconColor: CommonColors.appBarColor,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [Text(msg), Text(address)],
            ),
            actions: [
              Column(
                children: [
                  const Divider(
                    color: CommonColors.disableColor,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          cancelCallBack.call();
                          // Navigator.pop(context);
                          Get.back();
                        },
                        child: const Text(
                          'cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      Container(
                        height: 30.0,
                        width: 1.0,
                        color: CommonColors.disableColor,
                        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      ),
                      TextButton(
                          onPressed: () {
                            okayCallBack.call();
                            // Navigator.pop(context);
                            Get.back();
                          },
                          child: const Text(
                            'okay',
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ),
                ],
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'Route Detail',
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
          InkWell(
            onTap: () {
              Get.to(MapViewPage(
                model: modelDetail,
                // routeDetailList: routeDetailList,
              ));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset(
                "assets/images/map.png",
                height: 35,
              ),
            ),
          ),
        ],
      ),
      body: modelDetail == null
          ? Scaffold(
              body: Center(
              child: Text(
                "data not  found ".toUpperCase(),
                style:
                    TextStyle(color: CommonColors.successColor, fontSize: 20),
              ),
            ))
          : Container(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.all(16),
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
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: CommonColors.White!
                                          .withAlpha((0.3 * 255).round()),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.route,
                                      color: CommonColors.colorPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Route ID : ${modelDetail.planningid}',
                                          style: theme.textTheme.titleLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${modelDetail.routename}',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: CommonColors.grey600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: CommonColors.amber100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.inventory_2_outlined,
                                          size: 16,
                                          color: CommonColors.amber800,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${routeDetailList.length - 2} Stops',
                                          style: TextStyle(
                                            color: CommonColors.amber800,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: CommonColors.grey50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _buildInfoItem(
                                        context,
                                        Icons.calendar_today_outlined,
                                        'Date & Time',
                                        '${modelDetail.planningdt}',
                                        CommonColors.colorPrimary!,
                                      ),
                                    ),
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: CommonColors.grey300,
                                    ),
                                    Expanded(
                                      child: _buildInfoItem(
                                        context,
                                        Icons.straighten,
                                        'Total Distance',
                                        '${modelDetail.totdistance}',
                                        Colors.amber.shade700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Route Timeline
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timeline,
                          size: 20,
                          color: CommonColors.colorPrimary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Delivery Route',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  routeDetailList.isEmpty
                      ? Center(
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
                      : Expanded(
                          child: RefreshIndicator(
                            onRefresh: refreshScreen,
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                              child:
                                  //  showUpdateBtn?
                                  routeModifyAllowed
                                      ? ReorderableListView.builder(
                                          buildDefaultDragHandles: false,
                                          itemBuilder: (context, index) {
                                            var data = routeDetailList[index];
                                            return RouteDetailTile(
                                              key: ValueKey(data.sequenceid),
                                              model: data,
                                              listLength:
                                                  routeDetailList.length,
                                              index: index,
                                              showDragHandle: index != 0 &&
                                                  index !=
                                                      routeDetailList.length -
                                                          1,
                                            );
                                          },
                                          itemCount: routeDetailList.length,
                                          onReorder: (oldIndex, newIndex) {
                                            if (oldIndex == 0 ||
                                                oldIndex ==
                                                    routeDetailList.length - 1)
                                              return;
                                            if (newIndex == 0 ||
                                                newIndex ==
                                                    routeDetailList.length)
                                              return;

                                            if (oldIndex < newIndex) {
                                              newIndex--;
                                            }
                                            var item = routeDetailList
                                                .removeAt(oldIndex);
                                            routeDetailList.insert(
                                                newIndex, item);

                                            fetchDistanceFromGoogleApi(
                                                routeDetailList);
                                            // updateSequenceBeforeSubmit();
                                          },
                                        )
                                      :

                                      // // Normal List
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: routeDetailList.length,
                                          itemBuilder: (context, index) {
                                            var data = routeDetailList[index];
                                            return RouteDetailTile(
                                              model: data,
                                              listLength:
                                                  routeDetailList.length,
                                              index: index,
                                              showDragHandle: false,
                                            );
                                          },
                                        ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
      persistentFooterButtons: [
        Visibility(
          visible: showActionBtn && !showUpdateBtn,
          child: Row(
            children: [
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: () {
                  alterForReject();
                },
                icon: const Icon(Icons.close),
                label: const Text("Reject"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.red600,
                  foregroundColor: CommonColors.White,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
                  //  InkWell(
                  //   onTap: () {
                  //     alterForReject();
                  //   },
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 10, vertical: 15),
                  //     decoration: BoxDecoration(
                  //         color: CommonColors.dangerColor,
                  //         borderRadius:
                  //             const BorderRadius.all(Radius.circular(10))),
                  //     child: Text("Reject".toUpperCase(),
                  //         style: TextStyle(color: CommonColors.White)),
                  //   ),
                  // ),
                  ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: ElevatedButton.icon(
                onPressed: () {
                  // alterForAccept();
                  List<RouteDetailModel> _routeList =
                      List.empty(growable: true);

                  _routeList.addAll(routeDetailList.where((routeDetailList) =>
                      !routeDetailList.grno!.contains("Pickup") &&
                      !routeDetailList.grno!.contains("Final Point")));
                  if (_routeList.isNotEmpty && hasDeliveries) {
                    Get.to(() => ReceivedLoadPage(
                            receivedLoadList: _routeList, model: modelDetail))!
                        .then(
                      (value) => {refreshScreen()},
                    );
                  } else {
                    // _acceptRoute();
                    alterForAccept();
                  }
                },
                icon: const Icon(Icons.list),
                // label: const Text("Accept"),
                // label: const Text("Receive Load"),
                label: hasDeliveries
                    ? const Text("Receive Load")
                    : const Text("Accept"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.green600,
                  foregroundColor: CommonColors.White,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
                  //  InkWell(
                  //   onTap: () {
                  //     alterForAccept();
                  //   },
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     padding: const EdgeInsets.symmetric(
                  //         horizontal: 10, vertical: 15),
                  //     decoration: BoxDecoration(
                  //         color: CommonColors.successColor,
                  //         borderRadius:
                  //             const BorderRadius.all(Radius.circular(10))),
                  //     child: Text("Accept".toUpperCase(),
                  //         style: TextStyle(color: CommonColors.White)),
                  //   ),
                  // ),
                  ),
            ],
          ),
        ),
      ],
    );
  }

// This widget is used to create Date & time and Total distance containters
  Widget _buildInfoItem(BuildContext context, IconData icon, String label,
      String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
