// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/repository/lovIsolate.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';

class CngrCngeSelectionBottomSheet extends StatefulWidget {
  void Function(dynamic) callback;
  String custcode;
  String type;
  CngrCngeSelectionBottomSheet({
    super.key,
    required this.callback,
    required this.custcode,
    required this.type,
  });

  @override
  State<CngrCngeSelectionBottomSheet> createState() =>
      _CommonBottomSheetWithApiState();
}

class _CommonBottomSheetWithApiState
    extends State<CngrCngeSelectionBottomSheet> {
  late LoadingAlertService loadingAlertService;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<CngrCngeModel> filteredList = [];
  String query = '';
  bool isLoading = false;
  Map<String, String> params = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
    });
  }

  void callApi() async {
    // loadingAlertService.showLoading();
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmbranchcode": savedUser.loginbranchcode.toString(),
        "prmgrtype": 'R',
        "prmcngrcnge": widget.type,
        "prmcustcode": widget.custcode,
        'prmcharstr': query
      };
      CommonResponse resp =
          await apiGet('${bookingUrl}GetCngrCngeListV2', params);

      if (resp.commandStatus == 1) {
        List<CngrCngeModel> resultList =
            await compute(parseCngrCngeListIsolate, resp.dataSet!);
        filteredList = resultList;
      } else {}
      // loadingAlertService.hideLoading();
      isLoading = false;
    } on SocketException catch (_) {
      failToast('No Internet');
      // loadingAlertService.hideLoading();
      isLoading = false;
    } catch (err) {
      failToast(err.toString());
      // loadingAlertService.hideLoading();
      isLoading = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocus.dispose();
    super.dispose();
  }

  Widget searchWidget() {
    return SearchBar(
      controller: searchController,
      leading: const Icon(Icons.search),
      hintText: 'Search',
      elevation: WidgetStateProperty.all(4.0),
      focusNode: searchFocus,
      shadowColor: WidgetStateProperty.all(CommonColors.appBarColor),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SizeConfig.largeRadius)),
      ),
      padding: WidgetStateProperty.all(EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding)),
      onSubmitted: (value) {
        query = value;
        if (!isNullOrEmpty(value)) {
          callApi();
        } else {
          filteredList = [];
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: const Text(''),
        title: Text(
          'Select Customer',
          style: TextStyle(
              fontSize: SizeConfig.largeTextSize,
              fontWeight: FontWeight.w500,
              color: CommonColors.White),
        ),
        backgroundColor: CommonColors.colorPrimary,
        centerTitle: true,
      ),
      body: isLoading
          ? Column(
              children: [
                searchWidget(),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: CommonColors.colorPrimary,
                    ),
                  ),
                ),
              ],
            )
          : GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Column(
                children: [
                  searchWidget(),
                  filteredList.isEmpty
                      ? const Expanded(
                          child: Center(
                            child: Text('No Data Found'),
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            itemCount: filteredList.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  widget.callback(filteredList[index]);
                                  Navigator.pop(context);
                                },
                                title: Text(
                                  filteredList[index].name.toString(),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
    );
  }
}

Future<void> showCngeCngeSelectionBottomSheet<T>(
  BuildContext context,
  void Function(dynamic) callback,
  String custcode,
  String type,
) async {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: CngrCngeSelectionBottomSheet(
                callback: callback,
                custcode: custcode,
                type: type,
              )),
        );
      });
}
