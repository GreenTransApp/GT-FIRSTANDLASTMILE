import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/offlineView/dbHelper.dart';
import 'package:gtlmd/pages/offlineView/offlineUndelivery/model/undelivery_offlineModel.dart';
import 'package:gtlmd/pages/offlineView/offlineUndelivery/offlineUndeliveryViewModel.dart';
import 'package:gtlmd/pages/unDelivery/unDeliveryRepository.dart';

class OfflineUndeliveryWidget extends StatefulWidget {
  List<UnDeliveryOfflineModel> offlineUndeliveryList;
  OfflineUndeliveryWidget({super.key, required this.offlineUndeliveryList});

  @override
  State<OfflineUndeliveryWidget> createState() =>
      _OfflineUndeliveryWidgetState();
}

class _OfflineUndeliveryWidgetState extends State<OfflineUndeliveryWidget> {
  List<UnDeliveryOfflineModel> offlineUndelivery = [];
  OfflineUndeliveryViewModel viewModel = OfflineUndeliveryViewModel();
  final UnDeliveryRepository repository = UnDeliveryRepository();
  bool _selectAll = false;
  bool _isLoading = true;
  List<UnDeliveryOfflineModel> itemsToSync = [];

  late LoadingAlertService loadingAlertService;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    offlineUndelivery = widget.offlineUndeliveryList;
    // deleteAllEntries();
    setObservers();
  }

  deleteAllEntries() async {
    DBHelper.deleteAllUndelivery();
  }

  void setObservers() {
    viewModel.saveUnDeliveryOfflineList.stream.listen((undelivery) {
      if (undelivery.commandstatus == 1) {
        successToast("Undelivery saved successfully");
        // debugPrint(jsonDecode(pod.toString()));
        deleteSelectedUndeliveries();
      }
    });

    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    repository.isErrorLiveData.stream.listen((errMsg) {
      if (errMsg != null) {
        failToast(errMsg.toString());
      } else {
        failToast("Something went wrong");
      }
    });

    viewModel.drsWithExistingPods.stream.listen((list) {
      if (list != null && list.length > 0) {
        String msg = list.join(',');
        commonAlertDialog(
            context,
            'DRS with existing POD',
            "$msg drs have already been delivered.",
            '',
            const Icon(Icons.cancel_outlined),
            () {});
      }
    });
  }

  deleteSelectedUndeliveries() async {
    try {
      int count = await DBHelper.deleteMultipleUndeliveryEntry(itemsToSync);
      debugPrint("$count");
      itemsToSync.clear();
      fetchOfflineUnDeliveryList();
    } catch (err) {
      failToast(err.toString());
    }
  }

  fetchOfflineUnDeliveryList() async {
    List<Map<String, dynamic>> undeliveryList =
        await DBHelper.getUndeliveryDetail();
    List<UnDeliveryOfflineModel> tempList = [];
    for (var item in undeliveryList) {
      tempList.add(UnDeliveryOfflineModel.fromJson(item));
    }

    setState(() {
      offlineUndelivery = tempList;
    });
  }

  void _toggleSelectAllPods() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in offlineUndelivery) {
        item.isSelected = _selectAll;
      }
    });
  }

  void _deleteUndleivery(int index) async {
    int count = await DBHelper.deleteUndeliveryEntry(offlineUndelivery[index]);
    debugPrint("Undelivery items left: $count");
    fetchOfflineUnDeliveryList();
  }

  void saveUndelivery() {
    // Map<String, String> params = {
    //   "prmconnstring": savedLogin.companyid.toString(),
    //   "prmbranchcode": savedUser.loginbranchcode.toString(),
    //   "prmundeldt": unDeliverDt,
    //   "prmtime": formatTimeString(_unDeliveryTimeController.text),
    //   "prmdlvtripsheetno": currentDeliveryModel.drsno.toString(),
    //   "prmgrno": deliveryDetailModel.grno.toString(),
    //   "prmreasoncode": _selectedReason!.reasoncode.toString(),
    //   "prmactioncode": _selectedAction!.reasoncode.toString(),
    //   "prmusercode": savedUser.usercode.toString(),
    //   "prmsessionid": savedUser.sessionid.toString(),
    //   "prmmenucode": 'GTAPP_DRS',
    //   "prmremarks": _remarksController.text.toUpperCase(),
    //   "prmdrno": "",
    //   "prmimagepath": _imageFilePathBase64.toString()
    // };

    debugPrint("Test");
    // viewModel.saveUnDelivery(params);
  }

  void startSync() {
    try {
      int selectedCount = 0;
      List<String> grnoList = List.empty(growable: true);
      List<String> undeldtList = List.empty(growable: true);
      List<String> timeList = List.empty(growable: true);
      List<String> reasonList = List.empty(growable: true);
      List<String> actionList = List.empty(growable: true);
      List<String> remarksList = List.empty(growable: true);
      List<String> imageList = List.empty(growable: true);
      List<String> tripsheetnoList = List.empty(growable: true);
      List<String> drnoList = List.empty(growable: true);
      itemsToSync.clear();
      for (int i = 0; i < offlineUndelivery.length; i++) {
        if (offlineUndelivery[i].isSelected!) {
          selectedCount++;
          itemsToSync.add(offlineUndelivery[i]);
          grnoList.add(offlineUndelivery[i].prmgrno.toString());
          undeldtList.add(offlineUndelivery[i].prmundeldt.toString());
          timeList.add(offlineUndelivery[i].prmtime.toString());
          reasonList.add(offlineUndelivery[i].prmreasoncode.toString());
          actionList.add(offlineUndelivery[i].prmactioncode.toString());
          remarksList.add(offlineUndelivery[i].prmremarks.toString());
          drnoList.add(offlineUndelivery[i].prmdrno.toString());
          tripsheetnoList
              .add(offlineUndelivery[i].prmdlvtripsheetno.toString());
          imageList.add(convertFilePathToBase64(
              offlineUndelivery[i].prmimagepath.toString()));
        }
      }

      if (selectedCount == 0) {
        failToast("Please select at-least 1 entry to sync");
        return;
      } else {
        // call repo and start sync

        // String undeldt = itemsToSync.map((r) => r.prmundeldt ?? '').join(',');
        // String time = itemsToSync.map((r) => r.prmtime ?? '').join(',');
        // String grno = itemsToSync.map((r) => r.prmgrno ?? '').join(',');
        // String reason = itemsToSync.map((r) => r.prmreasoncode ?? '').join(',');
        // String action = itemsToSync.map((r) => r.prmactioncode ?? '').join(',');
        // // String drno = itemsToSync.map((r) => r.prmdrno ?? '').join(',');
        // String remarks = itemsToSync.map((r) => r.prmremarks ?? '').join(',');
        // String imgpath = itemsToSync
        //     .map((r) => convertFilePathToBase64(r.prmimagepath))
        //     .join(',');
        // String tripsheetno = '';
        // String drno = '';
        // for (int i = 0; i < itemsToSync.length; i++) {
        //   if (i != itemsToSync.length - 1) {
        //     tripsheetno += ',';
        //     drno += ',';
        //   } else {
        //     tripsheetno += '';
        //     drno += '';
        //   }
        // }

        Map<String, dynamic> params = {
          "prmconnstring": savedLogin.companyid.toString(),
          "prmbranchcode": savedUser.loginbranchcode.toString(),
          "prmundeldt": undeldtList.join(",") + ",",
          "prmtime": timeList.join(",") + "",
          "prmdlvtripsheetno": tripsheetnoList.join(",") + ",",
          "prmgrno": grnoList.join(",") + ",",
          "prmreasoncode": reasonList.join(",") + ",",
          "prmactioncode": actionList.join(",") + ",",
          "prmusercode": savedUser.usercode.toString(),
          "prmsessionid": savedUser.sessionid.toString(),
          "prmmenucode": 'GTAPP_DRS',
          "prmremarks": remarksList.join(",") + ",",
          "prmdrno": drnoList.join(",") + ",",
          "prmimagesstr": imageList
        };

        viewModel.saveUndeliveryOffline(params);
      }
    } catch (err) {
      failToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Total Undeliveries: ${offlineUndelivery.length}",
          style: const TextStyle(fontSize: 18),
        ),
        actions: [
          Row(
            children: [
              const Text("Select All"),
              IconButton(
                icon: _selectAll
                    ? Icon(Icons.check_box, color: CommonColors.colorPrimary)
                    : const Icon(Icons.check_box_outline_blank),
                onPressed: _toggleSelectAllPods,
                tooltip: 'Select All',
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          startSync();
        },
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        child: const Icon(
          Icons.sync,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListView.builder(
                itemCount: offlineUndelivery.length,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // So it scrolls with outer scroll
                itemBuilder: (context, index) {
                  var item = offlineUndelivery[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Text(
                            '#${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Checkbox(
                            fillColor: item.isSelected!
                                ? WidgetStateProperty.all(
                                    CommonColors.colorPrimary)
                                : WidgetStatePropertyAll(CommonColors.White),
                            checkColor: CommonColors.White,
                            value: item.isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                item.isSelected = value;
                                _selectAll = offlineUndelivery
                                    .every((item) => item.isSelected!);
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'GR: ${item.prmgrno}',
                                    style: const TextStyle(
                                        // color: Colors.grey,
                                        ),
                                  ),
                                  Expanded(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          commonAlertDialog(
                                              context,
                                              'Delete ${item.prmgrno}',
                                              'Are you sure you want to delete undleivery?',
                                              "",
                                              const Icon(Icons.delete_outline),
                                              () {
                                            _deleteUndleivery(index);
                                          });
                                        },
                                        child: const Icon(Icons.delete_outline),
                                      ),
                                    ],
                                  ))
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Reason: ${item.prmreason ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Action: ${item.prmaction ?? 'N/A'}",
                                style: const TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
