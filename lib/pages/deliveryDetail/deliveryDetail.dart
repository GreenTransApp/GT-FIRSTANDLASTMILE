import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/deliveryDetail/deliveryViewModel.dart';

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
  late LoadingAlertService loadingAlertService;
  final DeliveryViewModel viewModel = DeliveryViewModel();
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
            {setObservers(), getDeliveryDetails()}
        });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getDeliveryDetails();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    refreshScreen();
  }

  setObservers() {
    viewModel.deliveryDetailLiveData.stream.listen((resp) {
      if (resp.isNotEmpty && resp.elementAt(0).commandstatus == 1) {
        setState(() {
          deliveryDetailList = resp;
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

  Future<void> refreshScreen() async {
    getDeliveryDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'Manifest Detail',
          style: TextStyle(color: CommonColors.White),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: CommonColors.White,
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
                height: 35,
              ),
            ),
          ),
        ],
      ),
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
              padding: const EdgeInsets.all(10),
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
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Basic Info
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Trip ID',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.tripModel.tripid.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      widget.tripModel.tripdispatchdate
                                          .toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Consignment',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${widget.tripModel.noofconsign}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
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
                  const Text(
                    'Consignments',
                    style: TextStyle(
                      fontSize: 18,
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
                                  );
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
