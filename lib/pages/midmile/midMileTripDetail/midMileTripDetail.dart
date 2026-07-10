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

  Future<Position> getCurrentLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  // void generateDummyData() {
  //   tripsList = [
  //     MidMileTripDetailModel(
  //       dataId: 1,
  //       tripId: 106003,
  //       tripDetailId: 106003,
  //       documentType: "Manifest",
  //       documentNo: "MF0001",
  //       lhcNo: "LH1001",
  //       grno: "DEL",
  //       totpckgs: 25,
  //       aWeight: 450.75,
  //       cWeight: 455.00,
  //       manifestNo: "MAN1001",
  //       billNo: "BIL1001",
  //       manifestType: "Regular",
  //       seqNo: 1,
  //       unloadingStnCode: "NDLS",
  //       arrivalDt: "",
  //       arrivalTime: "",
  //       unloadDt: "2026-07-08",
  //       unloadTime: "09:45",
  //       transshipmentStation: "Delhi Hub",
  //       arrivalLat: 28.6139,
  //       arrivalLong: 77.2090,
  //       arrivalKm: 182.5,
  //       arrivalReadingImageId: 101,
  //     ),
  //     MidMileTripDetailModel(
  //       dataId: 2,
  //       tripId: 106004,
  //       tripDetailId: 106004,
  //       documentType: "Bill",
  //       documentNo: "BL0002",
  //       lhcNo: "LH1001",
  //       grno: "JPR",
  //       totpckgs: 18,
  //       aWeight: 310.40,
  //       cWeight: 312.00,
  //       manifestNo: "MAN1002",
  //       billNo: "BIL1002",
  //       manifestType: "Express",
  //       seqNo: 2,
  //       unloadingStnCode: "JP",
  //       arrivalDt: "2026-07-08",
  //       arrivalTime: "11:30",
  //       unloadDt: "2026-07-08",
  //       unloadTime: "12:00",
  //       transshipmentStation: "Jaipur Hub",
  //       arrivalLat: 26.9124,
  //       arrivalLong: 75.7873,
  //       arrivalKm: 275.8,
  //       arrivalReadingImageId: 102,
  //     ),
  //     MidMileTripDetailModel(
  //       dataId: 3,
  //       tripId: 106000,
  //       tripDetailId: 106000,
  //       documentType: "Manifest",
  //       documentNo: "MF0003",
  //       lhcNo: "LH1002",
  //       grno: "LKO",
  //       totpckgs: 40,
  //       aWeight: 680.20,
  //       cWeight: 682.50,
  //       manifestNo: "MAN1003",
  //       billNo: "BIL1003",
  //       manifestType: "Regular",
  //       seqNo: 3,
  //       unloadingStnCode: "LKO",
  //       arrivalDt: "2026-07-09",
  //       arrivalTime: "08:10",
  //       unloadDt: "2026-07-09",
  //       unloadTime: "08:50",
  //       transshipmentStation: "Lucknow Hub",
  //       arrivalLat: 26.8467,
  //       arrivalLong: 80.9462,
  //       arrivalKm: 420.3,
  //       arrivalReadingImageId: 103,
  //     ),
  //     MidMileTripDetailModel(
  //       dataId: 4,
  //       tripId: 106001,
  //       tripDetailId: 106001,
  //       documentType: "Bill",
  //       documentNo: "BL0004",
  //       lhcNo: "LH1003",
  //       grno: "BPL",
  //       totpckgs: 12,
  //       aWeight: 195.80,
  //       cWeight: 198.00,
  //       manifestNo: "MAN1004",
  //       billNo: "BIL1004",
  //       manifestType: "Express",
  //       seqNo: 4,
  //       unloadingStnCode: "BPL",
  //       arrivalDt: "2026-07-09",
  //       arrivalTime: "14:20",
  //       unloadDt: "2026-07-09",
  //       unloadTime: "14:45",
  //       transshipmentStation: "Bhopal Hub",
  //       arrivalLat: 23.2599,
  //       arrivalLong: 77.4126,
  //       arrivalKm: 612.9,
  //       arrivalReadingImageId: 104,
  //     ),
  //     MidMileTripDetailModel(
  //       dataId: 5,
  //       tripId: 106002,
  //       tripDetailId: 106002,
  //       documentType: "Manifest",
  //       documentNo: "MF0005",
  //       lhcNo: "LH1004",
  //       grno: "MUM",
  //       totpckgs: 30,
  //       aWeight: 540.00,
  //       cWeight: 545.30,
  //       manifestNo: "MAN1005",
  //       billNo: "BIL1005",
  //       manifestType: "Regular",
  //       seqNo: 5,
  //       unloadingStnCode: "BCT",
  //       arrivalDt: "2026-07-10",
  //       arrivalTime: "17:40",
  //       unloadDt: "2026-07-10",
  //       unloadTime: "18:10",
  //       transshipmentStation: "Mumbai Hub",
  //       arrivalLat: 19.0760,
  //       arrivalLong: 72.8777,
  //       arrivalKm: 890.4,
  //       arrivalReadingImageId: 105,
  //     ),
  //   ];
  // }

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
      if (listData.isNotEmpty) {
        tripsList = listData;
        filterList = listData;
      } else {
        tripsList.clear();
        filterList.clear();
      }

      setState(() {});
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
                false) ||
            (trip.documentNo?.toLowerCase().contains(newQuery.toLowerCase()) ??
                false) ||
            (trip.lhcNo?.toLowerCase().contains(newQuery.toLowerCase()) ??
                false) ||
            (trip.grno?.toLowerCase().contains(newQuery.toLowerCase()) ??
                false) ||
            (trip.billNo?.toLowerCase().contains(newQuery.toLowerCase()) ??
                false) ||
            (trip.transshipmentStation
                    ?.toLowerCase()
                    .contains(newQuery.toLowerCase()) ??
                false)) {
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
      "prmcompanyid": savedUser.companyid.toString(),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmlogindivisionid": savedUser.logindivisionid.toString(),
      "prmtripid": widget.tripid.toString(),
      "prmtripdetailid": widget.tripdetailid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": "GTLMD",
      "prmsessionid": savedUser.sessionid.toString(),
    };
    await viewModel.getMidMileTripsDetail(params);
  }

  startTrip() {
    // openUpdateMidMileTripInfo(context, tripsList[0], onRefresh);
  }

  void refresh() {
    getMidMileTripsDetail();
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

  Widget tripsDetailCard(MidMileTripDetailModel item) {
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
                        "GR No : ${item.grno}",
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
                    Expanded(child: _infoTile("Origin", item.origin)),
                    Expanded(child: _infoTile("Destination", item.destination)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _infoTile("CNGE", item.cnge)),
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
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                        openUpdateMidMileDriverPosition(
                            context, item, onRefresh);
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
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (isNullOrEmpty(item.arrivalDt)) {
                        failToast("Please Reach At Before Delivering");
                        return;
                      }
                      Get.to(PodEntry(
                              deliveryDetailModel:
                                  DeliveryDetailModel(generatedGr: item.grno)))
                          ?.then((_) {
                        onRefresh;
                      });
                    },
                    // icon: Icon(Icons.close, size: SizeConfig.mediumIconSize),
                    label: Text('Deliver',
                        style: TextStyle(fontSize: SizeConfig.smallTextSize)),
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
                              deliveryDetailModel:
                                  DeliveryDetailModel(generatedGr: item.grno)))
                          ?.then((_) {
                        onRefresh;
                      });
                    },
                    // icon: Icon(Icons.close, size: SizeConfig.mediumIconSize),
                    label: Text('Undeliver',
                        style: TextStyle(fontSize: SizeConfig.smallTextSize)),
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
          ],
        ),
      ),
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
                          return tripsDetailCard(filterList[index]);
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
