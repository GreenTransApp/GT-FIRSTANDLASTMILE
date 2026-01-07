import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/pages/offlineView/dbHelper.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/model/podEntry_offlineModel.dart';
import 'package:gtlmd/pages/offlineView/offlineUndelivery/model/undelivery_offlineModel.dart';
import 'package:gtlmd/widget/offlinePodWidget.dart';
import 'package:gtlmd/widget/offlineUndeliveryWidget.dart';

class OfflinedrsBottomSheet extends StatefulWidget {
  const OfflinedrsBottomSheet({super.key});

  @override
  State<OfflinedrsBottomSheet> createState() => _OfflinedrsBottomSheetState();
}

class _OfflinedrsBottomSheetState extends State<OfflinedrsBottomSheet> {
  List<PodEntryOfflineModel> offlinePods = List.empty(growable: true);
  List<UnDeliveryOfflineModel> offlineUndelivery = List.empty(growable: true);
  List<String> podDamageImagesList = List.empty(growable: true);
  @override
  void initState() {
    super.initState();
    fetchOfflinePodList();
    fetchOfflineUnDeliveryList();
  }

  fetchOfflinePodList() async {
    List<Map<String, dynamic>> podList = await DBHelper.getPodEntryDetail();
    List<PodEntryOfflineModel> tempList = List.empty(growable: true);
    for (var item in podList) {
      tempList.add(PodEntryOfflineModel.fromJson(item));
    }
    // for (int i = 0; i < 10; i++) {
    //   offlinePods.add(tempList[0]);
    // }
    setState(() {
      offlinePods.addAll(tempList);
    });
  }

  fetchOfflineUnDeliveryList() async {
    List<Map<String, dynamic>> undeliveryList =
        await DBHelper.getUndeliveryDetail();
    List<UnDeliveryOfflineModel> tempList = [];
    for (var item in undeliveryList) {
      tempList.add(UnDeliveryOfflineModel.fromJson(item));
    }

    setState(() {
      offlineUndelivery.addAll(tempList);
    });
  }

  fetchPodDamageImagesList() async {
    List<String> podDamageImagesList =
        await DBHelper.getAllPodDamageImagesList();
    setState(() {
      this.podDamageImagesList.addAll(podDamageImagesList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: const Color(0xFF2934AB), // Set AppBar color
        //   bottom: const TabBar(
        //     indicatorColor: Colors.white, // Underline color
        //     labelColor: Colors.white, // Selected tab text color
        //     unselectedLabelColor: Colors.white70, // Unselected tab text color
        //     tabs: [
        //       Tab(text: 'POD'),
        //       Tab(text: 'Undelivery'),
        //     ],
        //   ),
        // ),
        body: Column(
          children: [
            TabBar(
              indicatorColor: CommonColors.primaryColorShade, // Underline color
              labelColor:
                  CommonColors.primaryColorShade, // Selected tab text color
              unselectedLabelColor:
                  CommonColors.appBarColor, // Unselected tab text color
              tabs: [
                const Tab(text: 'POD'),
                const Tab(text: 'Undelivery'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  /// 👉 POD List Screen
                  OfflinePodWidget(
                    offlinePodList: offlinePods,
                    // podDamageImagesList: podDamageImagesList,
                  ),

                  /// 👉 Undelivery List Screen
                  OfflineUndeliveryWidget(
                    offlineUndeliveryList: offlineUndelivery,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showOfflineDrsBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    // backgroundColor: Colors.transparent,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20), // You can adjust the radius
      ),
    ),
    builder: (context) {
      final height = MediaQuery.of(context).size.height * 0.8;

      return SizedBox(
        height: height,
        child: const OfflinedrsBottomSheet(
            // callBack: callbackFun,
            ),
      );
    },
  );
}
