import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/pages/orders/drsSelection/model/DrsListModel.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/common/bottomSheet/datePicker.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionViewModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';

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

  List<DrsListModel> _deliveryList = List.empty(growable: true);
  List<DrsListModel> _selectedDrsList = List.empty(growable: true);
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
  bool isLoading = false;

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
           _selectedDrsList.clear();
        });
      }
    });

    _baseRepo.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        setState(() {
          isLoading = true;
        });
        // loadingAlertService.showLoading();
      } else {
        setState(() {
          isLoading = false;
        });

        // loadingAlertService.hideLoading();
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
    // openUpdateTripInfo(Get.context!, model, TripStatus.open, widget.onRefresh)
    //     .then((value) {
    //   Get.back();
    // });

     Get.to(() => UpdateTripInfo(model: model,status:TripStatus.open ,))?.then((_) { Get.back();});
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
        body: (_deliveryList.isEmpty) == true
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  Visibility(
                      visible: isLoading,
                      child: const CupertinoActivityIndicator(
                        radius: 12,
                      )),
                  Row(
                    children: [
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Text("Total: ${_deliveryList.length}"),
                          )
                        ],
                      )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Select All"),
                          const SizedBox(
                            width: 8,
                          ),
                          Checkbox(
                              activeColor: CommonColors.colorPrimary,
                              value: allSelected,
                              onChanged: (checked) {
                                allSelected = checked;
                                _selectedDrsList.clear();
                                if (checked == true) {
                                  for (DrsListModel model
                                      in _deliveryList) {
                                    model.tripconfirm = true;
                                    _selectedDrsList.add(model);
                                  }
                                } else {
                                  for (DrsListModel model
                                      in _deliveryList) {
                                    model.tripconfirm = false;
                                    _selectedDrsList.clear();
                                  }
                                }
                                setState(() {});
                              }),
                        ],
                      ))
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: _deliveryList.length,
                      itemBuilder: (context, index) {
                        var currentData = _deliveryList[index];

                        return drsCard(_deliveryList[index]);
                      },
                    ),
                  ),
                ],
              ),
        persistentFooterButtons: [
          Visibility(
            visible: _selectedDrsList.isNotEmpty,
            child: SizedBox(
              height: 50,
              child: CommonButton(
                  title: widget.tripId == 0
                      ? "Create Trip (${_selectedDrsList.length})"
                      : "Add DRS (${_selectedDrsList.length})",
                  color: CommonColors.colorPrimary!,
                  onTap: () {
                    submit();
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Widget drsCard(DrsListModel deliveryModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GestureDetector(
        onTap: () {
          onCheckChange(
              deliveryModel, !_selectedDrsList.contains(deliveryModel));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: const Color(0xFFE2E8F0),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: CommonColors.colorPrimary!
                          .withAlpha(((0.1) * 255).toInt()),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      deliveryModel.manifestno.toString(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: CommonColors.colorPrimary,
                      ),
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedDrsList.contains(deliveryModel)
                            ? CommonColors.colorPrimary!
                            : const Color(0xFFCBD5E1),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(4),
                      color: _selectedDrsList.contains(deliveryModel)
                          ? CommonColors.colorPrimary!
                          : Colors.white,
                    ),
                    child: _selectedDrsList.contains(deliveryModel)
                        ? Icon(
                            Icons.check,
                            size: 14,
                            color: CommonColors.white,
                          )
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    deliveryModel.createddt.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${deliveryModel.noofconsign} ${deliveryModel.noofconsign == 1 ? 'item' : 'items'}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (_selectedDrsList.isEmpty) {
      failToast("Select at-least 1 DRS to create a trip.");
      return;
    }
    upsertTrip();
  }

  upsertTrip() {
    // String manifestStr = _selectedDrsList.join("~");
    String manifestStr = "";
    String manifestTypeStr = "";
    for (DrsListModel data in _selectedDrsList) {
      manifestStr += data.manifestno!;
      manifestTypeStr += data.manifesttype!;
      manifestStr += "~";
      manifestTypeStr += "~";
    }
    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmemployeeid": savedUser.employeeid.toString(),
      "prmmanifestnostr": manifestStr,
      "prmmanifesttypestr": manifestTypeStr,
      "prmtripid": widget.tripId.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.upsertTrip(params);
  }

  Future<void> onCheckChange(DrsListModel data, bool isSelected) async {
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
