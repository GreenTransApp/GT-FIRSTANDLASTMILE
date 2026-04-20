import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/rejectPickup/rejectPickupViewModel.dart';
import 'package:gtlmd/service/locationService/appLocationService.dart';

// ignore: must_be_immutable
class RejectPickup extends StatefulWidget {
  DeliveryDetailModel details;
  RejectPickup({super.key, required this.details});

  @override
  State<RejectPickup> createState() => _RejectPickupState();
}

class _RejectPickupState extends State<RejectPickup> {
  RejectPickupViewModel viewModel = RejectPickupViewModel();
  late DeliveryDetailModel details;
  late LoadingAlertService loadingAlertService;

  TextEditingController _remarksController = TextEditingController();
  String currentAddress = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    details = widget.details;
  }

  void setObservers() {
    viewModel.isError.stream.listen((error) {
      failToast(error);
    });

    viewModel.isLoading.stream.listen((isLoading) {
      if (isLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.result.stream.listen((data) {
      if (data.commandstatus == 1) {
        successToast(data.commandmessage!);
        Get.back();
      } else {
        failToast(data.commandmessage!);
      }
    });
  }

  Future<void> fetchLocationAndSubmit() async {
    loadingAlertService.showLoading();
    String? address = await AppLocationService().getCurrentAddress();
    loadingAlertService.hideLoading();

    if (address != null) {
      currentAddress = address;
      debugPrint("Current Address: $currentAddress");
      submitRejectRequest();
    } else {
      failToast("Location is required. Could not get your location.");
    }
  }

  void submitRejectRequest() {
    var params = {
      "prmcompanyid": savedUser.companyid,
      "prmusercode": savedUser.usercode,
      "prmbranchcode": savedUser.loginbranchcode,
      "prmsessionid": savedUser.sessionid,
      "prmtransactionid": details.transactionid,
      "prmremarks": _remarksController.text,
      "prmlocation": currentAddress
    };

    viewModel.rejectPickup(params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        title: const Text("Reject Pickup"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.smallHorizontalSpacing,
            vertical: SizeConfig.smallVerticalSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Card(
                        elevation: 4,
                        shadowColor: CommonColors.appBarColor,
                        margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.horizontalPadding,
                          vertical: SizeConfig.verticalPadding,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.horizontalPadding,
                              vertical: SizeConfig.verticalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text.rich(
                                TextSpan(
                                  text: "Pickup : ",
                                  style: TextStyle(
                                      fontSize: SizeConfig.largeTextSize,
                                      fontWeight: FontWeight.w400),
                                  children: [
                                    TextSpan(
                                      text: details.grno.toString(),
                                      style: TextStyle(
                                          fontSize: SizeConfig.largeTextSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: SizeConfig.smallVerticalSpacing),
                              Row(
                                children: [
                                  SizedBox(
                                    width: SizeConfig.largeHorizontalPadding,
                                  ),
                                  Text(
                                    details.cngename.toString(),
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              SizedBox(
                                  height: SizeConfig.mediumVerticalSpacing),
                              Row(
                                children: [
                                  SizedBox(
                                    width: SizeConfig.largeHorizontalPadding,
                                  ),
                                  Text(
                                    "${details.pcs.toString()} PCS",
                                    style: TextStyle(
                                        fontSize: SizeConfig.mediumTextSize,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: SizeConfig.largeVerticalSpacing),
                    Text(
                      "Reject Reason",
                      style: TextStyle(
                          fontSize: SizeConfig.largeTextSize,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: SizeConfig.smallVerticalSpacing),
                    TextField(
                      controller: _remarksController,
                      maxLines: 8,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: "Reason",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              color: CommonColors.colorPrimary,
              width: MediaQuery.sizeOf(context).width,
              child: TextButton(
                  onPressed: () {
                    fetchLocationAndSubmit();
                  },
                  child: Text(
                    "Reject",
                    style: TextStyle(color: CommonColors.white),
                  )),
            )
          ],
        ),
      ),
    );
  }
}
