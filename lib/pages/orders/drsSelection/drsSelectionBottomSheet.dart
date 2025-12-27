import 'package:flutter/cupertino.dart';
import 'package:gtlmd/main.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/pages/orders/drsSelection/appToolTip.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionRepository.dart';
import 'package:gtlmd/pages/orders/drsSelection/drsSelectionViewModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/model/DrsListModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/upsertDrsResponseModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';
import 'package:gtlmd/pages/trips/updateTripInfo/updateTripInfo.dart';
import 'package:gtlmd/tiles/dashboardDeliveryTile.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:material_symbols_icons/symbols.dart';

// ignore: must_be_immutable
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
      DrsselectionBottomSheetState();
}

class DrsselectionBottomSheetState extends State<DrsselectionBottomSheet> {
  DrsSelectionViewModel viewModel = DrsSelectionViewModel();
  DrsSelectionRepository repository = DrsSelectionRepository();

  List<DrsListModel> _deliveryList = List.empty(growable: true);
  final List<DrsListModel> _selectedDrsList = List.empty(growable: true);
  late LoadingAlertService loadingAlertService;
  final BaseRepository _baseRepo = BaseRepository();
  String fromDt = "";
  String toDt = "";
  String formattedDate = '';
  late DateTime todayDateTime;
  late String smallDateTime;
  late String viewFromDt;
  late String viewToDt;
  bool? allSelected = false;
  bool isLoading = false;
  OverlayEntry? _overlayEntry;
  @override
  void initState() {
    super.initState();
    debugPrint('DRS Selection Init State');
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
    // DateTime fromdt = DateTime.parse(fromDt);
    // DateTime todt = DateTime.parse(toDt);
    getDeliveryList();
  }

  setObservers() {
    viewModel.drsListLiveData.stream.listen((list) {
      debugPrint('dashboard List Length: ${list.length}');
      // if (list.elementAt(0).commandstatus == 1) {
      setState(() {
        _deliveryList = list;
        _selectedDrsList.clear();
        allSelected = false;
      });
      // }
    });

    viewModel.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        // setState(() {
        //   isLoading = true;
        // });
        loadingAlertService.showLoading();
      } else {
        // setState(() {
        //   isLoading = false;
        // });

        loadingAlertService.hideLoading();
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
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

    Get.to(() => UpdateTripInfo(
          model: model,
          status: TripStatus.open,
        ))?.then((_) {
      Get.back();
      refreshScreen();
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
      "prmfromdt": convert2SmallDateTime(dashboardFromDt.toString()),
      "prmtodt": convert2SmallDateTime(dashboardToDt.toString()),
      // "prmfromdt": ENV.isDebugging == true ? "2025-01-01" : fromDt,
      // "prmtodt": toDt,2
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    // _baseRepo.getDrsList(params);
    viewModel.getDrsList(params);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

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
                                "No Assigned DRS/PRS",
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
                            padding: EdgeInsets.only(
                                left: isSmallDevice ? 8.0 : 16.0),
                            child: Text(
                              "Total: ${_deliveryList.length}",
                              style:
                                  TextStyle(fontSize: isSmallDevice ? 12 : 14),
                            ),
                          ),
                          SizedBox(
                            width: isSmallDevice ? 8 : 16,
                          ),
                          AppTooltip(
                            items: [
                              TooltipItem(CommonColors.green200!, "Delivery"),
                              TooltipItem(CommonColors.amber200!, "Pickup"),
                            ],
                            child: const Icon(Icons.info_outline),
                          )
                        ],
                      )),
                      Expanded(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Select All",
                              style:
                                  TextStyle(fontSize: isSmallDevice ? 12 : 14)),
                          SizedBox(
                            width: isSmallDevice ? 4 : 8,
                          ),
                          Checkbox(
                              activeColor: CommonColors.colorPrimary,
                              value: allSelected,
                              onChanged: (checked) {
                                allSelected = checked;
                                _selectedDrsList.clear();
                                if (checked == true) {
                                  for (DrsListModel model in _deliveryList) {
                                    // model.tripconfirm = true;
                                    _selectedDrsList.add(model);
                                  }
                                } else {
                                  for (DrsListModel model in _deliveryList) {
                                    // model.tripconfirm = false;
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

                        return manifestCard(_deliveryList[index]);
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

  void showTooltip() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy + size.height + 8,
          left: offset.dx,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue, // your dot color
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "This is info tooltip",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    overlay.insert(_overlayEntry!);

    // auto-dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), hideTooltip);
  }

  void hideTooltip() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Widget manifestCard(DrsListModel deliveryModel) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    Color backColor = CommonColors.White!;
    if (deliveryModel.manifesttype == 'D') {
      backColor = CommonColors.green200!;
      // .withAlpha((0.3 * 255).toInt());
    } else {
      backColor = CommonColors.amber200!;
      // .withAlpha((0.3 * 255).toInt());
    }
    String manifestType = "";
    if (deliveryModel.manifesttype == 'D') {
      manifestType = 'DRS';
    } else {
      manifestType = 'PRS';
    }
    return Padding(
      padding: EdgeInsets.all(isSmallDevice ? 8 : 16),
      child: GestureDetector(
        onTap: () {
          onCheckChange(
              deliveryModel, !_selectedDrsList.contains(deliveryModel));
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: backColor,
              width: 1,
            ),
            // color: backColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: backColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.only(
                    left: isSmallDevice ? 8 : 16, right: 0, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${deliveryModel.manifestno.toString()}/$manifestType",
                      style: TextStyle(
                        fontSize: isSmallDevice ? 11 : 13,
                        fontWeight: FontWeight.w600,
                        color: CommonColors.colorPrimary,
                      ),
                    ),
                    Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(right: isSmallDevice ? 8 : 16),
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
                              semanticLabel: "Select",
                            )
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallDevice ? 8 : 16),
              Padding(
                padding: EdgeInsets.all(isSmallDevice ? 8 : 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CommonColors.colorPrimary!
                                  .withAlpha((255 * 0.2).toInt()),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_today,
                              size: isSmallDevice ? 12 : 16,
                              color: CommonColors.colorPrimary!,
                            ),
                          ),
                          SizedBox(width: isSmallDevice ? 6 : 12),
                          Text(
                            deliveryModel.createddt.toString(),
                            style: TextStyle(
                                fontSize: isSmallDevice ? 12 : 14,
                                fontWeight: FontWeight.bold
                                // color: Color(0xFF475569),
                                ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: CommonColors.colorPrimary!
                                  .withAlpha((255 * 0.2).toInt()),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Symbols.package_2_rounded,
                              size: isSmallDevice ? 12 : 16,
                              color: CommonColors.colorPrimary!,
                            ),
                          ),
                          SizedBox(width: isSmallDevice ? 6 : 12),
                          Text(
                            '${deliveryModel.noofconsign} ${deliveryModel.noofconsign == 1 ? 'item' : 'items'}',
                            style: TextStyle(
                                fontSize: isSmallDevice ? 12 : 14,
                                fontWeight: FontWeight.bold
                                // color: Color(0xFF475569),
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
      "prmplanningid": _selectedDrsList[0].planningid.toString(),
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
