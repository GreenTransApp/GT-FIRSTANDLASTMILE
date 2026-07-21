import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/lmdMenuModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/midMileTripDetailModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/midMileTripDetailViewModel.dart';
import 'package:gtlmd/pages/midmile/midMileTripDetail/updateMidMileTripDetailInfo/updateMidMileDriverReach.dart';
import 'package:gtlmd/pages/podEntry/podEntry.dart';
import 'package:gtlmd/pages/unDelivery/unDelivery.dart';
import 'package:gtlmd/service/locationService/appLocationService.dart';
import 'package:gtlmd/service/locationService/locationService.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class MidMileTripDetail extends StatefulWidget {
  final int tripid;
  final int tripdetailid;
  const MidMileTripDetail(
      {super.key, required this.tripid, required this.tripdetailid});

  @override
  State<MidMileTripDetail> createState() => _MidMileTripDetailState();
}

class _MidMileTripDetailState extends State<MidMileTripDetail> {
  List<MidMileTripDetailModel> tripsList = List.empty(growable: true);
  List<MidMileTripDetailModel> filterList = List.empty(growable: true);
  final TextEditingController _searchController = TextEditingController();
  String query = '';
  final MidMileTripDetailViewModel viewModel = MidMileTripDetailViewModel();
  late LoadingAlertService loadingAlertService;

  // Future<Position> getCurrentLocation() async {
  //   return await Geolocator.getCurrentPosition();
  // }

  late DateTime todayDateTime;
  late String currentdate;
  late String currentTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
    });
    setObserver();
    // generateDummyData();
    getMidMileTripsDetail();
    filterList = tripsList;
     todayDateTime = DateTime.now();
     currentdate = DateFormat('yyyy-MM-dd').format(todayDateTime);
     currentTime = DateFormat('hh:mm a').format(todayDateTime);
  }

  setObserver() {
    viewModel.loadingDialog.stream.listen((show) {
      show
          ? loadingAlertService.showLoading()
          : loadingAlertService.hideLoading();
    });

    viewModel.errorDialog.stream.listen((error) {
      failToast(error);
    });

    viewModel.tripDetailList.stream.listen((listData) {
      setState(() {
        if (listData.isNotEmpty) {
          tripsList = listData;
          filterList = listData;
        } else {
          tripsList.clear();
          filterList.clear();
        }

      });


    });

    viewModel.departedPositionLiveData.stream.listen((data) {
      if (data.commandstatus == 1) {
        successToast("Location Update successfull");
        onRefresh();
      } else {
        failToast(data.commandmessage ?? "Something went wrong");
      }
    });
    viewModel.arrivalLiveData.stream.listen((data) {
      if (data.commandstatus == 1) {
        successToast("Location Update successfull");
        onRefresh();
      } else {
        failToast(data.commandmessage ?? "Something went wrong");
      }
    });
  }

 
  void updateSearch(String newQuery) {
    List<MidMileTripDetailModel> newMatchQuery = [];

    if (newQuery.isEmpty) {
      setState(() {
        query = '';
        filterList = tripsList;
      });
    } else {
      for (var trip in tripsList) {
        if ((trip.tripId
                    ?.toString()
                    .toLowerCase()
                    .contains(newQuery.toLowerCase()) ??
                false) ||
            (trip.manifestNo?.toLowerCase().contains(newQuery.toLowerCase()) ??
                false) 
           ) {
          newMatchQuery.add(trip);
        }
      }
      setState(() {
        query = newQuery;
        filterList = newMatchQuery;
      });
    }
  }

  Future<void> onRefresh() async {
    await getMidMileTripsDetail();
  }

  Future<void> getMidMileTripsDetail() async {
    Map<String, String> params = {
      // "prmcompanyid": savedUser.companyid.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmlogindivisionid": savedUser.logindivisionid.toString(),
      "prmtripid": widget.tripid.toString(),
      "prmtripdetailid": widget.tripdetailid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": "GTAPP_MIDMILETRIPDETAIL",
      "prmsessionid": savedUser.sessionid.toString(),
    };
    await viewModel.getMidMileTripsDetail(params);
  }

  startTrip() {
    // openUpdateMidMileTripInfo(context, tripsList[0], onRefresh);
  }

  Future<void> updatePickupDepartedPosition(
      String grno, String manifestno) async {
   

    try {
       loadingAlertService.showLoading();
      // Position position = await Geolocator.getCurrentPosition(
      //   locationSettings: const LocationSettings(
      //     accuracy: LocationAccuracy.high,
      //     distanceFilter: 0,
      //   ),
      // );
      // Position? currentPosition;
      await WidgetsBinding.instance.endOfFrame;
      LocationService().getCurrentLocation().then((position) {
        // currentPosition = position;

        Map<String, String> params = {
          "prmusercode": savedUser.usercode.toString(),
          "prmbranchcode": savedUser.loginbranchcode.toString(),
          "prmdivisionid": savedUser.logindivisionid.toString(),
          "prmgrno": grno,
          "prmmanifestno": manifestno,
          "prmpickuplat": position.latitude.toString(),
          "prmpickuplong": position.longitude.toString(),
          "prmmenucode": "GTAPP_MIDMILEDEPARTPICKUP",
          "prmsessionid": savedUser.sessionid.toString(),
        };

        printParams(params);
        viewModel.updateDepartLocation(params);
      });
    } finally {
      loadingAlertService.hideLoading();
    }
  }

  void refresh() {
    getMidMileTripsDetail();
  }

  Future<void> updateVehicleArrival(MidMileTripDetailModel model) async {
  try {
    loadingAlertService.showLoading();

    final positionFuture = LocationService().getCurrentLocation();
    final position = await positionFuture;
    // final addressFuture = AppLocationService().getCurrentAddress();
    final  addressFuture = await AppLocationService().getAddressFromLatLng(
  position.latitude,
  position.longitude,
);
    final currentAddress =  addressFuture;

        Map<String, dynamic> params = {
          "prmusercode": savedUser.companyid.toString(),
          "prmbranchcode": savedUser.loginbranchcode.toString(),
          "prmtripid": int.parse( model.tripId.toString()) ?? 0,
          "prmtripiddetailid":int.parse( model.tripDetailId.toString() )?? 0,
          "prmgrno": model.grno.toString(),
          "prmmanifestno": model.manifestNo.toString(),
          "prmunloaddt": convert2SmallDateTime(currentdate),
          "prmunloadtime":convertTo24Hour(currentTime),
          "prmentrylocation": currentAddress?? '',
          "prmunloadlat": position.latitude.toString(),
          "prmunloadlong": position.longitude.toString(),
          "prmfromstn": model.orgcode.toString(),
          "prmtostn": model.destcode.toString(),
          "prmdrivercode": savedUser.drivercode.toString(),
          "prmmodecode": model.modecode.toString(),
          "prmsessionid": savedUser.sessionid.toString(),
          "prmmenucode": "GTAPP_MIDMILEVEHICLEARRIVAL",
     };

    await viewModel.updateArrival(params);
  } finally {
    loadingAlertService.hideLoading();
  }
}
  Widget _infoTile(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? "-",
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'Mid Mile Trip Detail',
          style:
              TextStyle(fontWeight: FontWeight.w600, color: CommonColors.White),
        ),
        leading: BackButton(
          color: CommonColors.White,
        ),
      ),
      body: Container(
        color: CommonColors.blueGrey?.withAlpha((0.1 * 255).toInt()),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.horizontalPadding,
                  vertical: SizeConfig.verticalPadding),
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                cursorColor: CommonColors.appBarColor,
                obscureText: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: CommonColors.appBarColor,
                    size: SizeConfig.largeIconSize,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchController.clear();
                        updateSearch('');
                      });
                    },
                    icon: _searchController.text.isNotEmpty
                        ? const Icon(Icons.clear)
                        : const Icon(
                            Icons.clear,
                            color: Colors.transparent,
                          ),
                  ),
                  hintText: 'Search',
                  filled: true,
                  fillColor: CommonColors.white,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Set the desired radius
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: updateSearch,
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: filterList.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.15),
                                Lottie.asset("assets/emptyDelivery.json",
                                    height: 150),
                                Text(
                                  "No Trips Found",
                                  style: TextStyle(
                                      fontSize: SizeConfig.mediumTextSize,
                                      color: CommonColors.appBarColor),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filterList.length,
                        itemBuilder: (context, index) {
                          var currentData = filterList[index];

                          return currentData.despatchtype == "D"
                              ? DirectDetailCard(currentData)
                              : HubDetailCard(currentData);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget HubDetailCard(MidMileTripDetailModel item) {
    String arrivaltime = convertTo12Hour(item.arrivalTime ?? '');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
               Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.smallHorizontalPadding,
                    vertical: SizeConfig.smallVerticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: CommonColors.colorPrimary!
                        .withAlpha((0.12 * 255).round()),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_shipping_outlined,
                          size: SizeConfig.smallTextSize + 2,
                          color: CommonColors.colorPrimary),
                      const SizedBox(width: 4),
                      Text(
                        'HUB',
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
                          fontWeight: FontWeight.bold,
                          color: CommonColors.colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  child: Icon(Icons.local_shipping),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       "Manifest: ${item.manifestNo ?? "-"}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //    "GR No : ${item.grno}",
                        
                      //   style: TextStyle(
                      //     color: Colors.grey.shade700,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _infoTile("Origin", item.orgname)),
                    Expanded(child: _infoTile("Destination", item.destname)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _infoTile("Total Consignment", item.totgr.toString())),
                    Expanded(
                        child: _infoTile("Total Pkgs", "${item.totpckgs}")),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: (!isNullOrEmpty(item.arrivalDt) &&
                      !isNullOrEmpty(item.arrivalTime))
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text("${item.arrivalDt} $arrivaltime",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Arrived AT",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: () {
                        openUpdateMidMileDriverPosition(context, item,
                           MIDMILETRIPSTATUS.ARRIVAL,  onRefresh);
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text("Arrive AT"),
                      style: FilledButton.styleFrom(
                        backgroundColor: CommonColors.colorPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
            ),
            SizedBox(
              height: SizeConfig.mediumVerticalSpacing,
            ),
            // if (item.deliverystatus == "P") ...[
            //   Row(
            //     children: [
            //       Expanded(
            //         child: ElevatedButton.icon(
            //           onPressed: () {
            //             if (isNullOrEmpty(item.arrivalDt)) {
            //               failToast("Please Reach At Before Delivering");
            //               return;
            //             }
            //             Get.to(
            //                 () => PodEntry(
            //                   deliveryDetailModel: DeliveryDetailModel(
            //                     generatedGr: item.grno,
            //                   ),
            //                 ),
            //               )?.then((_) {
            //                 onRefresh(); 
            //               });
            //                                     },
            //           // icon: Icon(Icons.close, size: SizeConfig.mediumIconSize),
            //           label: Text('Deliver',
            //               style: TextStyle(fontSize: SizeConfig.smallTextSize)),
            //           style: ElevatedButton.styleFrom(
            //             padding: EdgeInsets.symmetric(
            //                 horizontal: SizeConfig.horizontalPadding,
            //                 vertical: SizeConfig.verticalPadding),
            //             backgroundColor: CommonColors.successColor,
            //             foregroundColor: CommonColors.White,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(14),
            //             ),
            //           ),
            //         ),
            //       ),
            //       SizedBox(
            //         width: SizeConfig.horizontalPadding,
            //       ),
            //       Expanded(
            //         child: ElevatedButton.icon(
            //           onPressed: () {
            //             if (isNullOrEmpty(item.arrivalDt)) {
            //               failToast("Please Reach At Before Delivering");
            //               return;
            //             }
            //             Get.to(UnDelivery(
            //                     deliveryDetailModel: DeliveryDetailModel(
            //                         manifestno: item.manifestNo,
            //                         generatedGr: item.grno)))
            //                 ?.then((_) {
            //               onRefresh();
            //             });
            //           },
            //           // icon: Icon(Icons.close, size: SizeConfig.mediumIconSize),
            //           label: Text('Undeliver',
            //               style: TextStyle(fontSize: SizeConfig.smallTextSize)),
            //           style: ElevatedButton.styleFrom(
            //             padding: EdgeInsets.symmetric(
            //                 horizontal: SizeConfig.horizontalPadding,
            //                 vertical: SizeConfig.verticalPadding),
            //             backgroundColor: CommonColors.red600,
            //             foregroundColor: CommonColors.White,
            //             shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(14),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ] else ...[
            //   Container(
            //     padding:
            //         const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            //     decoration: BoxDecoration(
            //       color: Colors.green.shade50,
            //       borderRadius: BorderRadius.circular(10),
            //       border: Border.all(
            //         color: Colors.green.shade300,
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Expanded(
            //           child: Text(item.deliverystatusupdateon ?? '',
            //               style: TextStyle(
            //                 color: item.deliverystatus == "D"
            //                     ? Colors.green.shade700
            //                     : Colors.red.shade700,
            //                 fontWeight: FontWeight.bold,
            //                 fontSize: 16,
            //               )),
            //         ),
            //         Icon(
            //           Icons.check_circle,
            //           color: item.deliverystatus == "D"
            //               ? Colors.green.shade700
            //               : Colors.red.shade700,
            //         ),
            //         const SizedBox(width: 8),
            //         Text(
            //           item.deliverystatus == "D" ? "Delivered" : "Unde",
            //           style: TextStyle(
            //             color: item.deliverystatus == "D"
            //                 ? Colors.green.shade700
            //                 : Colors.red.shade700,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 16,
            //           ),
            //         ),
            //       ],
            //     ),
            //   )
            // ],
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: (!isNullOrEmpty(item.vehiclearrivalstatus) &&
                      item.vehiclearrivalstatus == "D")
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.green.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text("${item.vehiclearrivalupdateon}",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                )),
                          ),
                          Icon(
                            Icons.check_circle,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Vehicle Arrived",
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : FilledButton.icon(
                      onPressed: () {
                        if (isNullOrEmpty(item.deliverystatusupdateon)) {
                          failToast(
                              "Please Update Delivery Status Before Vehicle Arrival.");
                          return;
                        }
                        openUpdateMidMileDriverPosition(
                            context, item, MIDMILETRIPSTATUS.UNLOAD, onRefresh);
                      },
                      icon: const Icon(Icons.location_on),
                      label: const Text("Vehicle Arrival "),
                      style: FilledButton.styleFrom(
                        backgroundColor: CommonColors.colorPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget DirectDetailCard(MidMileTripDetailModel item) {
    String arrivaltime = convertTo12Hour(item.arrivalTime ?? '');
    String pickupdepartedtime = convertTo12Hour(item.pickupdepartedtime ?? '');
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: CommonColors.amber500!.withAlpha((0.1 * 255).round()),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.smallHorizontalPadding,
                    vertical: SizeConfig.smallVerticalPadding,
                  ),
                  decoration: BoxDecoration(
                    color: CommonColors.colorPrimary!
                        .withAlpha((0.12 * 255).round()),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_shipping_outlined,
                          size: SizeConfig.smallTextSize + 2,
                          color: CommonColors.colorPrimary),
                      const SizedBox(width: 4),
                      Text(
                        'DIRECT',
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
                          fontWeight: FontWeight.bold,
                          color: CommonColors.colorPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    child: Icon(Icons.local_shipping),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Consignment No : ${item.grno}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Manifest: ${item.manifestNo ?? "-"}",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: _infoTile("Origin", item.orgname)),
                      Expanded(
                          child: _infoTile("Destination", item.destname)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _infoTile("Total Consignment", item.totgr.toString())),
                      Expanded(
                          child: _infoTile("Total Pkgs", "${item.totpckgs}")),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: (!isNullOrEmpty(item.arrivalDt) &&
                        !isNullOrEmpty(item.arrivalTime))
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "${item.arrivalDt}  ${arrivaltime}",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Reached",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FilledButton.icon(
                        onPressed: () {
                          openUpdateMidMileDriverPosition(context, item,
                              MIDMILETRIPSTATUS.ARRIVAL, onRefresh);
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text("Reach At"),
                        style: FilledButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
              ),
              SizedBox(
                height: SizeConfig.mediumVerticalSpacing,
              ),
              if (item.deliverystatus == "P") ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isNullOrEmpty(item.arrivalDt)) {
                            failToast("Please Reach At Before Delivering");
                            return;
                          }
                          Get.to(
                                () => PodEntry(
                              deliveryDetailModel: DeliveryDetailModel(
                                generatedGr: item.grno,
                              ),
                            ),
                          )?.then((_) {
                            onRefresh();
                          });
                        },
                        // icon: Icon(Icons.close, size: SizeConfig.mediumIconSize),
                        label: Text('Deliver',
                            style:
                                TextStyle(fontSize: SizeConfig.smallTextSize)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.horizontalPadding,
                              vertical: SizeConfig.verticalPadding),
                          backgroundColor: CommonColors.successColor,
                          foregroundColor: CommonColors.White,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: SizeConfig.horizontalPadding,
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          if (isNullOrEmpty(item.arrivalDt)) {
                            failToast("Please Reach At Before Delivering");
                            return;
                          }
                          Get.to(UnDelivery(
                                  deliveryDetailModel: DeliveryDetailModel(
                                      manifestno: item.manifestNo,
                                      generatedGr: item.grno,
                                      orgcode: item.orgcode,
                                      orgname: item.orgname,
                                      destcode: item.destcode,
                                      destname: item.destname,
                                      )))
                              ?.then((_) {
                            onRefresh();
                          });
                        },
                        // icon: Icon(Icons.close, size: SizeConfig.mediumIconSize),
                        label: Text('Undeliver',
                            style:
                                TextStyle(fontSize: SizeConfig.smallTextSize)),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.horizontalPadding,
                              vertical: SizeConfig.verticalPadding),
                          backgroundColor: CommonColors.red600,
                          foregroundColor: CommonColors.White,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.green.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(item.deliverystatusupdateon ?? '',
                            style: TextStyle(
                              color: item.deliverystatus == "D"
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                      Icon(
                        Icons.check_circle,
                        color: item.deliverystatus == "D"
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.deliverystatus == "D" ? "Delivered" : "Unde",
                        style: TextStyle(
                          color: item.deliverystatus == "D"
                              ? Colors.green.shade700
                              : Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ],
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: (!isNullOrEmpty(item.pickupdeparteddate) &&
                        !isNullOrEmpty(item.pickupdepartedtime))
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "${item.pickupdeparteddate} ${pickupdepartedtime}",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Delivery Departed",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : FilledButton.icon(
                        onPressed: () {
                          if (isNullOrEmpty(item.deliverystatusupdateon)) {
                            failToast(
                                "Please Update Delivery Status Before Departing");
                            return;
                          }
                          updatePickupDepartedPosition(
                              item.grno ?? '', item.manifestNo ?? '');
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text("Departed From Location"),
                        style: FilledButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                child: (item.vehiclearrivalstatus == 'D')
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.green.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "${item.vehiclearrivalupdateon}",
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.green.shade700,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Vehicle Arrived",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      )
                    : (item.vehiclearrivalstatus == "P")
                        ? FilledButton.icon(
                            onPressed: () {
                              if (isNullOrEmpty(item.pickupdeparteddate) &&
                                  isNullOrEmpty(item.pickupdepartedtime)) {
                                failToast(
                                    "Please depart location update before vehicle Arrival.");
                                return;
                              }
                              updateVehicleArrival(item);
                            },
                            icon: const Icon(Icons.location_on),
                            label: const Text("Vehicle Arrival "),
                            style: FilledButton.styleFrom(
                              backgroundColor: CommonColors.colorPrimary,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          )
                        : Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
