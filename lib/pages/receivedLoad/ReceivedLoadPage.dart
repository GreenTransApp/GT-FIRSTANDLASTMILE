import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/SuccessAlert.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/receivedLoad/ReceivedLoadViewModel.dart';
import 'package:gtlmd/pages/routes/routeDetail/Model/routeDetailModel.dart';
import 'package:gtlmd/tiles/receivedLoadTile.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ReceivedLoadPage extends StatefulWidget {
  final AllotedRouteModel model;
  final List<RouteDetailModel> receivedLoadList;

  ReceivedLoadPage(
      {super.key, required this.receivedLoadList, required this.model});

  @override
  State<ReceivedLoadPage> createState() => _ReceivedLoadPageState();
}

class _ReceivedLoadPageState extends State<ReceivedLoadPage> {
  bool _selectAll = false;
  late LoadingAlertService loadingAlertService;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool showScan = false;
  List<RouteDetailModel> _receivedLoadList = List.empty(growable: true);
  final ReceivedLoadViewModel viewModel = ReceivedLoadViewModel();
  AllotedRouteModel modelDetail = AllotedRouteModel();
  BaseRepository baseRepo = BaseRepository();
  bool showLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    modelDetail = widget.model;
    for (var i = 0; i < widget.receivedLoadList.length; i++) {
      if (widget.receivedLoadList[i].consignmenttype == 'D') {
        _receivedLoadList.add(widget.receivedLoadList[i]);
      }
    }

    setObservers();
    baseRepo.scanBarcode();
  }

  @override
  void didUpdateWidget(covariant ReceivedLoadPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.receivedLoadList != oldWidget.receivedLoadList) {
      setState(() {
        _receivedLoadList = widget.receivedLoadList;
        modelDetail = widget.model;
      });
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (var item in _receivedLoadList) {
        item.checked = _selectAll;
      }
    });
  }

  setObservers() {
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

    baseRepo.scannedCode.stream.listen((scannedCode) {
      setState(() {
        for (var i = 0; i < _receivedLoadList.length; i++) {
          if (_receivedLoadList[i].grno == scannedCode) {
            _receivedLoadList[i].checked = true;
          } else {
            _receivedLoadList[i].checked = false;
          }
        }
      });
      debugPrint("Scanned Code: $scannedCode");
    });

    viewModel.routeAcceptLiveData.stream.listen((resp) {
      if (resp.commandstatus == 1) {
        setState(() {
          showSuccessAlert(context, "SUCCESSFULLY\n Route Accepted", "",
              okayCallBackForAlert);
        });
      } else {
        failToast(resp.commandmessage.toString());
      }
    });
  }

  void _acceptRoute() {
    List<String> grnoList = List.empty(growable: true);
    List<RouteDetailModel> actualRouteList = List.empty(growable: true);
    actualRouteList = widget.receivedLoadList;
    int selected = 0;
    for (int i = 0; i < actualRouteList.length; i++) {
      if (actualRouteList[i].consignmenttype != 'D') {
        grnoList.add(actualRouteList[i].grno.toString());
      } else if (actualRouteList[i].consignmenttype == 'D' &&
          actualRouteList[i].checked == true) {
        selected = selected + 1;
        grnoList.add(actualRouteList[i].grno.toString());
      }
    }

    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.loginbranchcode.toString(),
      "prmplanningid": modelDetail.planningid.toString(),
      "prmgrnostr": grnoList.join(",") + ",",
      "prmsessionid": savedUser.sessionid.toString(),
    };

    printParams(params);
    viewModel.acceptRouteUpdate(params);
  }

  void alterForAccept() {
    commonAlertDialog(
        context,
        "Confirm!",
        "Are you sure you want to 'ACCEPT' route  ",
        //  ' $_currentAddress ' ,
        "",
        const Icon(Symbols.check_circle),
        _acceptRoute,
        cancelCallBack: okayCallBackForAlert,
        iconColor: CommonColors.successColor!,
        timer: 10);
  }

  void okayCallBackForAlert() {
    Navigator.pop(context);
    // Get.offAll(Routedetail());
  }

  Future<void> onCheckChange(value, index) async {
    _receivedLoadList[index].checked = value;
    int selectedCount = 0;
    for (var item in _receivedLoadList) {
      if (!item.checked!) {
        _selectAll = false;
        break;
      } else {
        selectedCount++;
      }
    }
    if (selectedCount == _receivedLoadList.length) {
      _selectAll = true;
    }
    setState(() {});
  }

  selectGr(Barcode gr) {
    for (RouteDetailModel delivery in _receivedLoadList) {
      if (delivery.grno == gr.code) {
        delivery.checked = !delivery.checked!;
      }
    }
    setState(() {});
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        selectGr(scanData);
        showScan = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CommonColors.colorPrimary,
          title: Text(
            'Received Load',
            style: TextStyle(color: CommonColors.White),
          ),
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(
                Icons.arrow_back,
                color: CommonColors.White,
              )),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: CommonColors.colorPrimary,
          foregroundColor: CommonColors.White,
          onPressed: () {
            setState(() {
              showScan = !showScan;
            });
          },
          child: const Icon(Icons.camera_alt_rounded),
        ),
        body: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Select All"),
                  IconButton(
                    icon: _selectAll
                        ? Icon(Icons.check_box,
                            color: CommonColors.colorPrimary)
                        : const Icon(Icons.check_box_outline_blank),
                    onPressed: _toggleSelectAll,
                  ),
                ],
              ),
              Visibility(
                visible: showScan,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      child: QRView(
                          key: qrKey, onQRViewCreated: _onQRViewCreated)),
                ),
              ),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _receivedLoadList.length,
                  itemBuilder: (context, index) {
                    var data = _receivedLoadList[index];
                    return ReceivedLoadTile(
                      model: data,
                      index: index,
                      onCheckChange: onCheckChange,
                    );
                  })
            ],
          ),
        ),
        persistentFooterButtons: [
          // SizedBox(
          //   height: 60,
          //   child: CommonButton(
          //       title: "Submit".toUpperCase(),
          //       color: CommonColors.colorPrimary!,
          //       onTap: () {
          //         alterForAccept();
          //       }),
          // )

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                vertical: SizeConfig.verticalPadding,
                horizontal: SizeConfig.horizontalPadding),
            decoration: BoxDecoration(
              color: CommonColors.whiteShade,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.largeRadius),
                bottomRight: Radius.circular(SizeConfig.largeRadius),
              ),
            ),
            child: ElevatedButton(
              onPressed: () {
                alterForAccept();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CommonColors.colorPrimary,
                foregroundColor: CommonColors.White,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalPadding,
                    vertical: SizeConfig.verticalPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
                ),
                elevation: 0,
              ),
              child: Text(
                'Submit',
                style: TextStyle(
                  fontSize: SizeConfig.smallTextSize,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
