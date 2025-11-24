import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/bottomSheet/UpdateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/common/bottomSheet/drsSelection/drsSelectionRepository.dart';
import 'package:gtlmd/common/bottomSheet/drsSelection/drsSelectionViewModel.dart';
import 'package:gtlmd/common/bottomSheet/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/pages/tripSummary/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/tripSummary/Model/tripModel.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class DrsselectionBottomSheet extends StatefulWidget {
  int tripId = 0;
  bool showTripInfoUpdate;
  Future<void> Function()? onRefresh;
  DrsselectionBottomSheet(
      {super.key,
      required this.tripId,
      required this.showTripInfoUpdate,
      this.onRefresh});

  @override
  State<DrsselectionBottomSheet> createState() =>
      _DrsselectionBottomSheetState();
}

class _DrsselectionBottomSheetState extends State<DrsselectionBottomSheet> {
  DrsSelectionViewModel viewModel = DrsSelectionViewModel();
  DrsSelectionRepository repository = DrsSelectionRepository();

  List<CurrentDeliveryModel> _deliveryList = List.empty(growable: true);
  List<CurrentDeliveryModel> _selectedDrsList = List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  BaseRepository _baseRepo = BaseRepository();
  String fromDt = "";
  String toDt = "";
  String formattedDate = '';
  late DateTime todayDateTime;
  late String smallDateTime;
  late String viewFromDt;
  late String viewToDt;
  bool? allSelected = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));

    WidgetsBinding.instance.addPostFrameCallback((timestamp) {});
    setObservers();
    formattedDate = formatDate(DateTime.now().millisecondsSinceEpoch);
    debugPrint('Formatted date $formattedDate');
    todayDateTime = DateTime.now();
    smallDateTime = DateFormat('yyyy-MM-dd').format(todayDateTime);
    fromDt = smallDateTime.toString();
    toDt = smallDateTime.toString();
    viewFromDt = DateFormat('dd-MM-yyyy').format(todayDateTime);
    viewToDt = DateFormat('dd-MM-yyyy').format(todayDateTime);
    DateTime fromdt = DateTime.parse(fromDt);
    DateTime todt = DateTime.parse(toDt);
    getDeliveryList();
  }

  setObservers() {
    _baseRepo.deliveryLiveData.stream.listen((dashboard) {
      debugPrint('dashboard List Length: ${dashboard.length}');
      if (dashboard.elementAt(0).commandstatus == 1) {
        setState(() {
          _deliveryList = dashboard;
        });
      }
    });

    _baseRepo.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    _baseRepo.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.upsertTripLiveData.stream.listen((data) {
      if (data.commandstatus == 1) {
        successToast(data.commandmessage!);
        if (widget.showTripInfoUpdate) {
          navigateToUpdateTripInfo(data);
        }
        // Get.back();
      } else {
        failToast(data.commandmessage!);
      }
    });
  }

  navigateToUpdateTripInfo(UpsertTripResponseModel data) async {
    // Get.back();
    TripModel model = TripModel();
    model.tripid = data.tripid;
    openUpdateTripInfo(Get.context!, model, TripStatus.open, widget.onRefresh)
        .then((value) {
      Get.back();
    });
  }

  Future<void> refreshScreen() async {
    getDeliveryList();
  }

  getDeliveryList() {
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmfromdt": ENV.isDebugging == true ? "2025-01-01" : fromDt,
      "prmtodt": toDt,
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    _baseRepo.getDrsList(params);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: CommonColors.colorPrimary,
      onRefresh: refreshScreen,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          title: const Text(
            'DRS Selection',
            style: TextStyle(color: CommonColors.appBarColor),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.close_rounded,
                  color: CommonColors.appBarColor,
                  size: 30,
                )),
          ],
        ),
        body: Container(
            child: (_deliveryList.isEmpty) == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          showDatePickerBottomSheet(context, _dateChanged);
                        },
                        icon: Icon(Icons.calendar_today,
                            size: 16, color: CommonColors.colorPrimary),
                        label: Text('$viewFromDt - $viewToDt',
                            style: TextStyle(color: CommonColors.colorPrimary)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          side: BorderSide(color: CommonColors.colorPrimary!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Lottie.asset("assets/emptyDelivery.json",
                                      height: 150),
                                  const Text(
                                    "No Assigned DRS",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: CommonColors.appBarColor),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              showDatePickerBottomSheet(context, _dateChanged);
                            },
                            icon: Icon(Icons.calendar_today,
                                size: 16, color: CommonColors.colorPrimary),
                            label: Text('$viewFromDt - $viewToDt',
                                style: TextStyle(
                                    color: CommonColors.colorPrimary)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              side:
                                  BorderSide(color: CommonColors.colorPrimary!),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Text("Select All"),
                                Checkbox(
                                    activeColor: CommonColors.colorPrimary,
                                    value: allSelected,
                                    onChanged: (checked) {
                                      allSelected = checked;
                                      if (checked == true) {
                                        for (CurrentDeliveryModel model
                                            in _deliveryList) {
                                          model.tripconfirm = true;
                                          _selectedDrsList.add(model);
                                        }
                                      } else {
                                        for (CurrentDeliveryModel model
                                            in _deliveryList) {
                                          model.tripconfirm = false;
                                          _selectedDrsList.clear();
                                        }
                                      }
                                      setState(() {});
                                    }),
                              ],
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          // physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: _deliveryList.length,
                          itemBuilder: (context, index) {
                            var currentData = _deliveryList[index];
                            return DashBoardDeliveryTile(
                              model: currentData,
                              // attendanceModel: _attendanceModel,
                              // onUpdate: widget.onUpdate ,
                              onRefresh: refreshScreen,
                              showHeader: true,
                              showInfo: true,
                              showCheckboxSelection: true,
                              showStatusIndicators: false,
                              onCheckChange: onCheckChange,
                              enableTap: false,
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const Divider(
                              color: Colors.grey, // Customize divider color
                              thickness: 1, // Customize divider thickness
                              height:
                                  20, // Customize the height of the divider (including spacing)
                              indent: 16, // Indent from the left
                              endIndent: 16, // Indent from the right
                            );
                          },
                        ),
                      ),
                    ],
                  )),
        persistentFooterButtons: [
          Container(
            height: 50,
            child: CommonButton(
                title: widget.tripId == 0 ? "Create Trip" : "Add DRS",
                color: CommonColors.colorPrimary!,
                onTap: () {
                  submit();
                }),
          ),
        ],
      ),
    );
  }

  void submit() {
    if (_selectedDrsList.isEmpty) {
      failToast("Selet at-least 1 DRS to create a trip.");
      return;
    }
    upsertTrip();
  }

  upsertTrip() {
    // String manifestStr = _selectedDrsList.join("~");
    String manifestStr = "";
    for (CurrentDeliveryModel data in _selectedDrsList) {
      manifestStr += data.drsno!;
      manifestStr += "~";
    }
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmmanifestnostr": manifestStr,
      "prmtripid": widget.tripId.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.upsertTrip(params);
  }

  Future<void> onCheckChange(CurrentDeliveryModel data, bool isSelected) async {
    if (isSelected) {
      _selectedDrsList.add(data);
    } else {
      _selectedDrsList.remove(data);
    }

    if (_selectedDrsList.length == _deliveryList.length) {
      allSelected = true;
    } else {
      allSelected = false;
    }

    if (_selectedDrsList.isEmpty) {
      allSelected = false;
    }
    setState(() {});
  }

  void _dateChanged(String fromDt, String toDt) {
    debugPrint("fromDt ${fromDt}");
    debugPrint("toDt ${toDt}");

    this.fromDt = fromDt;
    this.toDt = toDt;
    DateTime fromdt = DateTime.parse(this.fromDt);
    DateTime todt = DateTime.parse(this.toDt);
    viewFromDt = DateFormat('dd-MM-yyyy').format(fromdt);
    viewToDt = DateFormat('dd-MM-yyyy').format(todt);
    getDeliveryList();
  }
}

Future<void> showDrsSelectionBottomSheet(BuildContext context, int tripId,
    bool showTripInfoUpdate, Future<void> Function()? onRefresh) async {
  DraggableScrollableController controller = DraggableScrollableController();
  return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      showDragHandle: true,
      builder: (context) {
        return ClipRRect(
          child: DraggableScrollableSheet(
            initialChildSize: 0.85, // 85% of screen height
            maxChildSize: 0.9, // up to 90%
            minChildSize: 0.4, // optional
            expand: false, //
            builder: (context, scrollController) {
              return Container(
                color: Colors.white, // background for the sheet
                child: DrsselectionBottomSheet(
                    tripId: tripId, showTripInfoUpdate: showTripInfoUpdate),
              );
            },
            controller: controller,
          ),
        );
      });
}
