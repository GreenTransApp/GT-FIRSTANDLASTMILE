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
import 'package:gtlmd/tiles/deliveryDetailTile.dart';
import 'package:lottie/lottie.dart';

class DeliveryDetail extends StatefulWidget {
  final CurrentDeliveryModel model;
  const DeliveryDetail({super.key, required this.model});

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
    deliveryModel = widget.model;

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
      "prmbranchcode": savedUser.password.toString(),
      "prmdrsno": deliveryModel.drsno.toString(),
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
          'Delivery Detail',
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
                model: deliveryModel,
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
      body: deliveryModel == null
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
                                      'DRS#',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      deliveryModel.drsno.toString(),
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
                                      deliveryModel.manifestdate.toString(),
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
                                      '${deliveryModel.noofconsign}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          // const Divider(height: 32),

                          // Stats
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         padding:
                          //             const EdgeInsets.symmetric(vertical: 12),
                          //         decoration: BoxDecoration(
                          //           color: Colors.green.shade50,
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             Text(
                          //               'Delivered',
                          //               style: TextStyle(
                          //                 fontSize: 12,
                          //                 color: Colors.green.shade700,
                          //               ),
                          //             ),
                          //             const SizedBox(height: 4),
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               children: [
                          //                 Icon(
                          //                   Icons.check_circle,
                          //                   size: 16,
                          //                   color: Colors.green.shade700,
                          //                 ),
                          //                 const SizedBox(width: 4),
                          //                 Text(
                          //                   '${deliveryModel.deliveredconsign}',
                          //                   style: TextStyle(
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: Colors.green.shade700,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: Container(
                          //         padding:
                          //             const EdgeInsets.symmetric(vertical: 12),
                          //         decoration: BoxDecoration(
                          //           color: Colors.red.shade50,
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             Text(
                          //               'Undelivered',
                          //               style: TextStyle(
                          //                 fontSize: 12,
                          //                 color: Colors.red.shade700,
                          //               ),
                          //             ),
                          //             const SizedBox(height: 4),
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               children: [
                          //                 Icon(
                          //                   Icons.cancel,
                          //                   size: 16,
                          //                   color: Colors.red.shade700,
                          //                 ),
                          //                 const SizedBox(width: 4),
                          //                 Text(
                          //                   '${deliveryModel.undeliveredconsign}',
                          //                   style: TextStyle(
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: Colors.red.shade700,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: Container(
                          //         padding:
                          //             const EdgeInsets.symmetric(vertical: 12),
                          //         decoration: BoxDecoration(
                          //           color: Colors.amber.shade50,
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             Text(
                          //               'Pending',
                          //               style: TextStyle(
                          //                 fontSize: 12,
                          //                 color: Colors.amber.shade700,
                          //               ),
                          //             ),
                          //             const SizedBox(height: 4),
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               children: [
                          //                 Icon(
                          //                   Icons.access_time,
                          //                   size: 16,
                          //                   color: Colors.amber.shade700,
                          //                 ),
                          //                 const SizedBox(width: 4),
                          //                 Text(
                          //                   '${deliveryModel.pendingconsign}',
                          //                   style: TextStyle(
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: Colors.amber.shade700,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // const SizedBox(height: 8),
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         padding:
                          //             const EdgeInsets.symmetric(vertical: 12),
                          //         decoration: BoxDecoration(
                          //           color: CommonColors.blue600!
                          //               .withAlpha((0.1 * 255).round()),
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             Text(
                          //               'Pending R-Pickups',
                          //               style: TextStyle(
                          //                 fontSize: 12,
                          //                 color: CommonColors.blue600,
                          //               ),
                          //             ),
                          //             const SizedBox(height: 4),
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               children: [
                          //                 Icon(
                          //                   Icons.local_shipping_outlined,
                          //                   size: 16,
                          //                   color: CommonColors.blue600,
                          //                 ),
                          //                 const SizedBox(width: 4),
                          //                 Text(
                          //                   '${deliveryModel.totpickup}',
                          //                   style: TextStyle(
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: CommonColors.blue600,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //     const SizedBox(width: 8),
                          //     Expanded(
                          //       child: Container(
                          //         padding:
                          //             const EdgeInsets.symmetric(vertical: 12),
                          //         decoration: BoxDecoration(
                          //           color: CommonColors.colorPrimary!
                          //               .withAlpha((0.1 * 255).round()),
                          //           borderRadius: BorderRadius.circular(8),
                          //         ),
                          //         child: Column(
                          //           children: [
                          //             Text(
                          //               'Pending Pickups',
                          //               style: TextStyle(
                          //                 fontSize: 12,
                          //                 color: CommonColors.colorPrimary,
                          //               ),
                          //             ),
                          //             const SizedBox(height: 4),
                          //             Row(
                          //               mainAxisAlignment:
                          //                   MainAxisAlignment.center,
                          //               children: [
                          //                 Icon(
                          //                   Icons.local_shipping_outlined,
                          //                   size: 16,
                          //                   color: CommonColors.colorPrimary,
                          //                 ),
                          //                 const SizedBox(width: 4),
                          //                 Text(
                          //                   '${deliveryModel.totpickup}',
                          //                   style: TextStyle(
                          //                     fontSize: 18,
                          //                     fontWeight: FontWeight.bold,
                          //                     color: CommonColors.colorPrimary,
                          //                   ),
                          //                 ),
                          //               ],
                          //             ),
                          //           ],
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // )
                       
                       
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
/*                        Expanded(
                          child: Container(
                            width: double.infinity,
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
                            child: RefreshIndicator(
                              onRefresh: refreshScreen,
                              backgroundColor: CommonColors.colorPrimary,
                              color: CommonColors.White,
                              child: ListView.builder(
                                itemCount: deliveryDetailList.length,
                                itemBuilder: (context, index) {
                                  var data = deliveryDetailList[index];
                                  return DeliveryDetailTile(
                                    model: data,
                                    currentDeliveryModel: deliveryModel,
                                    listLength: deliveryDetailList.length,
                                    index: index,
                                  );
                                },
                              ),
                            ),
                          ),
                        )
 */
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
      // persistentFooterButtons: [
      // Row(
      //   children: [
      //     Expanded(
      //       child: InkWell(
      //         onTap: () {},
      //         child: Container(
      //           alignment: Alignment.center,
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //           decoration: BoxDecoration(
      //               color: CommonColors.dangerColor,
      //               borderRadius:
      //                   const BorderRadius.all(Radius.circular(10))),
      //           child: Text("Un-Deliver".toUpperCase(),
      //               style: TextStyle(color: CommonColors.White)),
      //         ),
      //       ),
      //     ),
      //     const SizedBox(
      //       width: 10,
      //     ),
      //     Expanded(
      //       child: InkWell(
      //         onTap: () {},
      //         child: Container(
      //           alignment: Alignment.center,
      //           padding:
      //               const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      //           decoration: BoxDecoration(
      //               color: CommonColors.successColor,
      //               borderRadius:
      //                   const BorderRadius.all(Radius.circular(10))),
      //           child: Text("Deliver".toUpperCase(),
      //               style: TextStyle(color: CommonColors.White)),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      // ],
    );
  }
}
