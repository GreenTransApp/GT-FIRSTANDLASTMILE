import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/SuccessAlert.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/home/Model/allotedRouteModel.dart';
import 'package:gtlmd/pages/receivedLoad/ReceivedLoadViewModel.dart';

import 'package:gtlmd/pages/routeDetail/Model/routeDetailModel.dart';
import 'package:gtlmd/pages/routeDetail/routeDetail.dart';
import 'package:gtlmd/tiles/receivedLoadTile.dart';
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
  @override
  void initState() {
    super.initState();
    modelDetail = widget.model;
    for (var i = 0; i < widget.receivedLoadList.length; i++) {
      if (widget.receivedLoadList[i].consignmenttype == 'D') {
        _receivedLoadList.add(widget.receivedLoadList[i]);
      }
    }

    baseRepo.scanBarcode();
    setObservers();
    // debugPrint(_receivedLoadList.toString());
    // _receivedLoadList = widget.receivedLoadList;
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
          var acceptRouteModel = resp;
          showSuccessAlert(context, "SUCCESSFULLY\n Routes Are Accepted", "",
              okayCallBackForAlert);
          // successToast("PLANNING ACCEPTED SUCCESSFULLY");
        });
      } else {
        failToast(resp.commandmessage.toString() ?? "Something went wrong");
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

    // if (selected == 0) {
    //   failToast("Select at least one delivery to accept");
    //   return;
    // }

    Map<String, String> params = {
      "prmcompanyid": savedLogin.companyid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmbranchcode": savedUser.password.toString(),
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
        Icon(Icons.dangerous),
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
          onPressed: () {
            // if (!showScan) {
            setState(() {
              showScan = !showScan;
            });
            // }
          },
          child: const Icon(Icons.camera_alt_rounded),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Container(
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
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        child: QRView(
                            key: qrKey, onQRViewCreated: _onQRViewCreated)),
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
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
        ),
        persistentFooterButtons: [
          Container(
            height: 60,
            child: CommonButton(
                title: "Submit".toUpperCase(),
                color: CommonColors.colorPrimary!,
                onTap: () {
                  alterForAccept();
                }),
          ),
        ],
      ),
    );
  }
}
