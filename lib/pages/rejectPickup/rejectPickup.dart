import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/deliveryDetail/Model/deliveryDetailModel.dart';
import 'package:gtlmd/pages/rejectPickup/rejectPickupViewModel.dart';
import 'package:gtlmd/pages/unDelivery/reasonModel.dart';
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
    List<ReasonModel> _reasonList = List.empty(growable: true);
ReasonModel? _selectedReason;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    getReasons();
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

viewModel.reasonLiveData.stream.listen((list) {
      if (list != null) {
        setState(() {
          _reasonList = list;
        });
        // _showRelationDialog(context, _relations);
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
      "prmusercode": savedUser.usercode,
      "prmbranchcode": savedUser.loginbranchcode,
      "prmsessionid": savedUser.sessionid,
      "prmtransactionid": details.transactionid,
      "prmmanifestno": details.manifestno,
      "prmgrno": details.grno,
      "prmdacancelremarks":  _selectedReason!.reasonname.toString(),
      "prmlocation": currentAddress,
      "prmtripid": details.tripid,
    };

    viewModel.rejectPickup(params);
  }

  void getReasons() {
    var params = {
      "prmconnstring": savedUser.companyid.toString(),
    };

    viewModel.getReasons(params);
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: const Color(0xffF8FAFC),
  resizeToAvoidBottomInset: true,
  appBar: AppBar(
    elevation: 0,
    backgroundColor: CommonColors.colorPrimary,
    foregroundColor: CommonColors.white,
    centerTitle: true,
    title: const Text(
      "Reject Pickup",
      style: TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  body: Padding(
    padding: EdgeInsets.all(SizeConfig.horizontalPadding),
    child: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Pickup Details Card
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        CommonColors.colorPrimary!,
                        CommonColors.colorPrimary!.withOpacity(.85),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            CommonColors.colorPrimary!.withOpacity(.20),
                        blurRadius: 12,
                        offset: const Offset(0, 5),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Icon(
                              Icons.local_shipping_outlined,
                              color: Colors.white,
                              size: 28,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Pickup Details",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),

                        const SizedBox(height: 20),

                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                details.grno.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const Icon(
                              Icons.person_outline,
                              color: Colors.white70,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                details.cngename.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.inventory_2_outlined,
                                color:
                                    Colors.orange.shade700,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "${details.pcs} PCS",
                                style: TextStyle(
                                  color: Colors.orange
                                      .shade700,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height:
                      SizeConfig.largeVerticalSpacing * 1.5,
                ),

                /// Reject Reason Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: _buildFormField(
                    label: 'Reject Reason',
                    isRequired: true,
                    icon:
                        Icons.warning_amber_rounded,
                    child:
                        DropdownButtonFormField<
                            ReasonModel>(
                      value: _selectedReason,
                      style: TextStyle(
                        fontSize:
                            SizeConfig.mediumTextSize,
                        color: Colors.black,
                      ),
                      decoration:
                          _inputDecoration(
                              'Select reason'),
                      items: _reasonList
                          .map((ReasonModel reason) {
                        return DropdownMenuItem<
                            ReasonModel>(
                          value: reason,
                          child: Text(
                            reason.reasonname
                                .toString(),
                          ),
                        );
                      }).toList(),
                      onChanged:
                          (ReasonModel? newValue) {
                        setState(() {
                          _selectedReason =
                              newValue;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        /// Bottom Button
        SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(
                  Icons.cancel_outlined),
              label: const Text(
                "REJECT PICKUP",
                style: TextStyle(
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              onPressed:
                  fetchLocationAndSubmit,
              style: ElevatedButton
                  .styleFrom(
                backgroundColor:
                    Colors.red.shade600,
                foregroundColor:
                    Colors.white,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          16),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
  }
  Widget _buildFormField({
  required String label,
  required bool isRequired,
  required IconData icon,
  required Widget child,
}) {
  return Column(
    crossAxisAlignment:
        CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding:
                const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: CommonColors
                  .colorPrimary!
                  .withOpacity(.10),
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color:
                  CommonColors.colorPrimary,
            ),
          ),
          const SizedBox(width: 10),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize:
                        SizeConfig.mediumTextSize,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        const Color(0xff334155),
                  ),
                ),
                if (isRequired)
                  const TextSpan(
                    text: " *",
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      child,
    ],
  );
}
    
  }
  InputDecoration _inputDecoration(
  String hint,
) {
  return InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: const Color(0xffF8FAFC),

    hintStyle: TextStyle(
      color: Colors.grey.shade500,
      fontSize:
          SizeConfig.mediumTextSize,
    ),

    contentPadding:
        const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),

    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),

    enabledBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.grey.shade300,
      ),
    ),

    focusedBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide(
        color:
            CommonColors.colorPrimary!,
        width: 2,
      ),
    ),

    errorBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Colors.red,
      ),
    ),

    focusedErrorBorder:
        OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: Colors.red,
        width: 2,
      ),
    ),
  );
}

