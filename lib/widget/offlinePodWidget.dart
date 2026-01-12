import 'package:flutter/material.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/offlineView/dbHelper.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/model/podEntryOfflineRespModel.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/model/podEntry_offlineModel.dart';
import 'package:gtlmd/pages/offlineView/offlinePod/offlinePodViewModel.dart';

class OfflinePodWidget extends StatefulWidget {
  List<PodEntryOfflineModel> offlinePodList;
  // List<String> podDamageImagesList = List.empty(growable: true);
  OfflinePodWidget({
    super.key,
    required this.offlinePodList,
    // required this.podDamageImagesList
  });

  @override
  State<OfflinePodWidget> createState() => _OfflinePodWidgetState();
}

class _OfflinePodWidgetState extends State<OfflinePodWidget> {
  OfflinePodViewModel viewModel = OfflinePodViewModel();
  List<PodEntryOfflineModel> offlinePods = List.empty(growable: true);
  List<PodEntryOfflineModel> podsToSync = List.empty(growable: true);
  bool _selectAll = false;
  BaseRepository baseRepo = BaseRepository();
  late LoadingAlertService loadingAlertService;
  List<String> sortedPodDamageImagesList = List.empty(growable: true);
  String existingGrErrorText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    offlinePods = widget.offlinePodList;
    // deleteAllPod();
    setObservers();
  }

  deleteAllPod() async {
    DBHelper.deleteAllPods();
  }

  fetchOfflinePodList() async {
    List<Map<String, dynamic>> podList = await DBHelper.getPodEntryDetail();
    List<PodEntryOfflineModel> tempList = [];
    for (var item in podList) {
      tempList.add(PodEntryOfflineModel.fromJson(item));
    }

    setState(() {
      // offlinePods.addAll(tempList);
      offlinePods = tempList;
    });
  }

  void _toggleSelectAllPods() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in offlinePods) {
        item.isSelected = _selectAll;
      }
    });
  }

  void _deletePod(int index) async {
    // setState(() {
    //   offlinePods.removeWhere((item) => item.isSelected == true);
    //   _selectAll = false;
    // });
    int count = await DBHelper.deletePodEntry(offlinePods[index]);
    debugPrint("POD Items left: $count");

    // offlinePods.removeAt(index);
    fetchOfflinePodList();
  }

  void setObservers() {
    viewModel.savePodOfflineLiveData.stream.listen((pod) {
      if (pod.commandstatus == 1) {
        successToast(pod.commandmessage.toString());
        // debugPrint(jsonDecode(pod.toString()));
        // deleteSelectedPods();
      } else {
        failToast(pod.commandmessage.toString());
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
      if (errMsg != null) {
        failToast(errMsg.toString());
      } else {
        failToast("Something went wrong");
      }
    });

    viewModel.existingGrList.stream.listen((list) {
      if (list.isEmpty) {
        // successToast("PODs saved successfully");
        // debugPrint(jsonDecode(pod.toString()));
        deleteSelectedPods();
      } else if (list[0].commandstatus == -1) {
        List<String> grNumbers = List.empty(growable: true);
        for (PodEntryOFflineRespModel entry in list) {
          grNumbers.add(entry.grno.toString());
        }
        deleteSelectedPods(grNumbers);
        setState(() {
          existingGrErrorText =
              "POD for GR Number: ${grNumbers.join(',')} has already been uploaded";
        });
      }
    });

    // baseRepo.isErrorLiveData.stream.listen((errMsg) {
    //   if (errMsg != null) {
    //     failToast(errMsg.toString());
    //   } else {
    //     failToast("Something went wrong");
    //   }
    // });
  }

  // deleteSelectedPods() async {
  //   try {
  //     int count = await DBHelper.deleteMultiplePodEntry(podsToSync);
  //     debugPrint("$count");
  //     podsToSync.clear();
  //     fetchOfflinePodList();
  //   } catch (err) {
  //     failToast(err.toString());
  //   }
  // }

  void deleteSelectedPods([List<String>? grNumbers]) async {
    setState(() async {
      if (grNumbers != null && grNumbers.isNotEmpty) {
        // Remove only pods whose grno is in the provided list
        podsToSync.removeWhere((pod) => grNumbers.contains(pod.prmgrno));
      }
      // Remove all pods
      int count = await DBHelper.deleteMultiplePodEntry(podsToSync);
      debugPrint("$count");
      podsToSync.clear();
      fetchOfflinePodList();
    });
  }

/* 
  Future<void> createDamageImageList() async {
    // widget.podDamageImagesList.clear();
    for (var item in offlinePods) {
      List<Map<String, dynamic>> result =
          await DBHelper.getPodDamageImages(item.prmgrno.toString());
      List<String> imagePaths = result.map((e) => e['path'] as String).toList();
      String image = '';
      if (imagePaths.isNotEmpty) {
        image = imagePaths.map((e) => convertFilePathToBase64(e)).join("~");
      }
      sortedPodDamageImagesList.add(image);
    }
  }

 */
  void startSync() {
    int selectedCount = 0;
    // List<PodEntryOfflineModel> podsToSync = [];
    List<String> grnoList = List.empty(growable: true);
    List<String> dlvdtList = List.empty(growable: true);
    List<String> dlvtimeList = List.empty(growable: true);
    List<String> nameList = List.empty(growable: true);
    List<String> relationList = List.empty(growable: true);
    List<String> phnoList = List.empty(growable: true);
    List<String> signList = List.empty(growable: true);
    List<String> stampList = List.empty(growable: true);
    List<String> remarksList = List.empty(growable: true);
    List<String> podimgList = List.empty(growable: true);
    List<String> signimgList = List.empty(growable: true);
    List<String> deliveryboyList = List.empty(growable: true);
    List<String> boyidList = List.empty(growable: true);
    List<String> deliverpckgsList = List.empty(growable: true);
    List<String> damagepckgsList = List.empty(growable: true);
    List<String> drsList = List.empty(growable: true);
    List<String> damageReasonList = List.empty(growable: true);
    // List<String> damageImagesList = List.empty(growable: true);
    List<String> damageImage1List = List.empty(growable: true);
    // List<String> damageImage2List = List.empty(growable: true);
    // List<String> damageImagesList = List.empty(growable: true);
    // damageImagesList.addAll(sortedPodDamageImagesList);
    podsToSync.clear();
    for (int i = 0; i < offlinePods.length; i++) {
      if (offlinePods[i].isSelected!) {
        selectedCount++;
        podsToSync.add(offlinePods[i]);
        grnoList.add(offlinePods[i].prmgrno.toString());
        dlvdtList.add(offlinePods[i].prmdlvdt.toString());
        dlvtimeList.add(offlinePods[i].prmdlvtime.toString());
        nameList.add(offlinePods[i].prmname.toString());
        relationList.add(offlinePods[i].prmrelation.toString());
        phnoList.add(offlinePods[i].prmphno.toString());
        signList.add("Y");
        stampList.add("Y");
        remarksList.add(offlinePods[i].prmremarks.toString());
        podimgList.add(
            convertFilePathToBase64(offlinePods[i].prmpodimageurl.toString()));
        signimgList.add(convertFilePathToBase64(
            offlinePods[i].prmsighnimageurl.toString()));
        deliveryboyList.add(offlinePods[i].prmdeliveryboy.toString());
        boyidList.add(offlinePods[i].prmboyid.toString() ?? '0');
        deliverpckgsList.add(offlinePods[i].prmdeliverpckgs.toString() ?? '0');
        damagepckgsList.add(offlinePods[i].prmdamagepckgs.toString() ?? '0');
        drsList.add(offlinePods[i].prmdrsno.toString());
        damageReasonList.add(offlinePods[i].prmdamagereasonid.toString());
        // List<String> dmmageImgSTr = List<String>.from(
        //     jsonDecode(offlinePods[i].prmdamageimgstr.toString()));
        // for (String imgStr in dmmageImgSTr) {
        //   damageImagesList.add(convertFilePathToBase64(imgStr));
        // }
        damageImage1List.add(
            convertFilePathToBase64(offlinePods[i].prmdamageimg1.toString()));
        // damageImage2List.add(
        //     convertFilePathToBase64(offlinePods[i].prmdamageimg2.toString()));
      }
    }

    if (selectedCount == 0) {
      failToast("Please select at-least 1 entry to sync");
      return;
    } else {
      Map<String, dynamic> params = {
        "prmconnstring": savedLogin.companyid.toString(),
        "prmloginbranchcode": savedUser.loginbranchcode.toString(),
        "prmgrno": grnoList.join(",") + ",",
        "prmdlvdt": dlvdtList.join(",") + ",",
        "prmdlvtime": dlvtimeList.join(",") + ",",
        "prmname": nameList.join(",") + ",",
        "prmrelation": relationList.join(",") + ",",
        "prmphno": phnoList.join(",") + ",",
        "prmsign": signList.join(",") + ",",
        "prmstamp": stampList.join(",") + ",",
        "prmremarks": remarksList.join(",") + ",",
        "prmusercode": savedUser.usercode.toString() + ",",
        "prmpodimagesstr": podimgList,
        "prmsignimagesstr": signimgList,
        "prmsessionid": savedUser.sessionid.toString(),
        "prmdeliveryboy": savedUser.username.toString(),
        "prmmenucode": "GTAPP_PODENTRY",
        "prmdrsno": drsList.join(",") + ",",
        "prmboyid": isNullOrEmpty(savedUser.executiveid.toString()) ? "0" : '',
        "prmdeliverpckgs": deliverpckgsList.join(",") + ",",
        "prmdamagepckgs": damagepckgsList.join(",") + ",",
        "prmdamagereasonid": damageReasonList.join(",") + ",",
        // "prmdamageimgstr": sortedPodDamageImagesList,
        "prmdamageimg1str": damageImage1List,
        // "prmdamageimg2str": damageImage2List,
      };

      viewModel.savePodEntryOffline(params);
      // debugPrint("Params: $params");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Total PODs: ${offlinePods.length}",
          style: TextStyle(fontSize: SizeConfig.mediumTextSize),
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
        onPressed: () async {
          // await createDamageImageList();
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
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.horizontalPadding,
              vertical: SizeConfig.verticalPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: existingGrErrorText.isNotEmpty,
                child: Text(
                  existingGrErrorText,
                  style: TextStyle(
                      color: CommonColors.red500, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: SizeConfig.mediumVerticalSpacing),
              ListView.builder(
                itemCount: offlinePods.length,
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(), // So it scrolls with outer scroll
                itemBuilder: (context, index) {
                  var item = offlinePods[index];
                  return Card(
                    margin: EdgeInsets.symmetric(
                        vertical: SizeConfig.verticalPadding),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.horizontalPadding,
                          vertical: SizeConfig.verticalPadding),
                      child: Row(
                        children: [
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
                                _selectAll = offlinePods
                                    .every((item) => item.isSelected!);
                              });
                            },
                          ),
                          SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '#${index + 1}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    SizedBox(
                                        width:
                                            SizeConfig.mediumHorizontalSpacing),
                                    Text(
                                      'GR: ${item.prmgrno}',
                                      style: TextStyle(
                                        // color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.mediumTextSize,
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              commonAlertDialog(
                                                  context,
                                                  "Delete ${item.prmgrno}",
                                                  "Are you sure you want to delete pod?",
                                                  "",
                                                  const Icon(
                                                      Icons.delete_outline),
                                                  () {
                                                _deletePod(index);
                                              });
                                            },
                                            child: const Icon(
                                                Icons.delete_outline),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                    height: SizeConfig.smallVerticalSpacing),
                                Text(
                                  item.prmname!,
                                  style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize,
                                  ),
                                ),
                                SizedBox(
                                    height: SizeConfig.smallVerticalSpacing),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${item.prmphno}',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      '📦 ${item.prmdeliverpckgs} pieces',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
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
