import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gtlmd/bottomSheet/multiImageBottomSheet.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/pages/consignmentEnquiry/consignmentEnquiryViewModel.dart';

import 'package:gtlmd/pages/consignmentEnquiry/model/consignmentEnquiryModel.dart';
import 'package:gtlmd/pages/consignmentEnquiry/model/consignmentImageModel.dart';

class ConsignmentEnquiryPage extends StatefulWidget {
  final String consignmentNo;
  const ConsignmentEnquiryPage({super.key, required this.consignmentNo});

  @override
  State<ConsignmentEnquiryPage> createState() => _ConsignmentEnquiryPageState();
}

class _ConsignmentEnquiryPageState extends State<ConsignmentEnquiryPage> {
  ConsignmentEnquiryModel? consignData;
  List<ConsignmentImageModel> imageList = List.empty(growable: true);
  List<String> imageUrls = List.empty(growable: true);
  ConsignmentEnquiryViewModel viewModel = ConsignmentEnquiryViewModel();
  late LoadingAlertService loadingAlertService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    ConsignmentEnquiry();
  }

  setObservers() {
    viewModel.viewDialog.stream.listen((showLoading) async {
      if (showLoading) {
        setState(() {
          // isLoading = true;
          loadingAlertService.showLoading();
        });
      } else {
        setState(() {
          // isLoading = false;
          loadingAlertService.hideLoading();
        });
      }
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.consignLiveData.stream.listen((data) {
      setState(() {
        consignData = data;
      });
    });
    viewModel.consignImgLiveData.stream.listen((data) {
      setState(() {
        imageList = data;
      });
    });
  }

  ConsignmentEnquiry() {
    Map<String, dynamic> params = {
      "prmgrno": widget.consignmentNo,
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmlogindivisionid": savedUser.logindivisionid.toString(),
      "prmmenucode": menuCode,
      "prmusercode": savedUser.usercode.toString(),
      "prmsessionid": savedUser.sessionid.toString(),
    };

    viewModel.consignmentEnquiry(params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.grey,
      appBar: AppBar(

        backgroundColor: CommonColors.colorPrimary,
        title:  Text("Consignment Enquiry",style: TextStyle(color:CommonColors.White),),
          leading: Builder(builder: (context) {
            return IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: CommonColors.white,
                ));
          }),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 16),
            buildInfoCard(
              title: "Consignment Details",
              icon: Icons.inventory_2_outlined,
              children: [
                buildDetailTile(
                  "GR No",
                  consignData?.grNo ?? "",
                  Icons.confirmation_number,
                ),
                buildDetailTile(
                  "Reference",
                  consignData?.referenceNo ?? "",
                  Icons.tag,
                ),
                buildDetailTile(
                  "Invoice",
                  consignData?.invoiceCode ?? "",
                  Icons.receipt_long,
                ),
              ],
            ),
            buildInfoCard(
              title: "Route Information",
              icon: Icons.route,
              children: [
                buildDetailTile(
                  "Origin",
                  consignData?.orgName ?? "",
                  Icons.location_on,
                ),
                buildDetailTile(
                  "Destination",
                  consignData?.destName ?? "",
                  Icons.flag,
                ),
                buildDetailTile(
                  "Distance",
                  "${consignData?.distance ?? 0} KM",
                  Icons.straighten,
                ),
              ],
            ),
            buildInfoCard(
              title: "Consignor",
              icon: Icons.business,
              children: [
                buildDetailTile(
                  "Name",
                  consignData?.cngrName ?? "",
                  Icons.person,
                ),
                buildDetailTile(
                  "Mobile",
                  consignData?.cngrTelNo ?? "",
                  Icons.phone,
                ),
              ],
            ),
            buildInfoCard(
              title: "Consignee",
              icon: Icons.person_outline,
              children: [
                buildDetailTile(
                  "Name",
                  consignData?.cngeName ?? "",
                  Icons.person,
                ),
                buildDetailTile(
                  "Mobile",
                  consignData?.cngeTelNo ?? "",
                  Icons.phone,
                ),
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  for (var image in imageList) {
                    imageUrls.add(image.filePath ?? "");
                  }
                  showMultiImageBottomSheetDialog(context, imageUrls);
                },
                icon: const Icon(Icons.photo_library_outlined),
                label: Text(
                  "View Images (${imageList.length})",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.colorPrimary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            CommonColors.colorPrimary!,
            CommonColors.primaryColorShade!,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_shipping,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consignData?.grNo ?? "",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  consignData?.referenceNo ?? "",
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shadowColor: CommonColors.grey300,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      CommonColors.primaryColorShade!.withOpacity(.1),
                  child: Icon(
                    icon,
                    color: CommonColors.primaryColorShade,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: CommonColors.primaryColorShade,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget buildDetailTile(
    String label,
    String value,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: CommonColors.colorPrimary,
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                color: CommonColors.grey600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
