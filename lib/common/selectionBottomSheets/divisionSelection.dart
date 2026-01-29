// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/login/isolates/loginIsolates.dart';
import 'package:gtlmd/pages/login/models/divisionModel.dart';

class DivisionSelectionBottomSheet extends StatefulWidget {
  void Function(dynamic) callback;
  String title;
  Map<String, String> params;
  DivisionSelectionBottomSheet({
    super.key,
    required this.callback,
    required this.title,
    required this.params,
  });

  @override
  State<DivisionSelectionBottomSheet> createState() =>
      _DivisionSelectionBottomSheet();
}

class _DivisionSelectionBottomSheet
    extends State<DivisionSelectionBottomSheet> {
  late LoadingAlertService loadingAlertService;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<DivisionModel> filteredList = [];
  String query = '';
  bool isLoading = false;
  Map<String, String> params = {};
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
    });
    callApi();
  }

  void callApi() async {
    // loadingAlertService.showLoading();
    setState(() {
      isLoading = true;
    });
    try {
      // Map<String, String> params = {
      //   "prmcompanyid": savedUser.companyid.toString(),
      //   "prmbranchcode": savedUser.loginbranchcode.toString(),
      //   "prmusercode": savedUser.usercode.toString(),

      // };
      CommonResponse resp =
          await apiGet("${loginBaseUrl}GetDivisionList", widget.params);

      if (resp.commandStatus == 1) {
        List<DivisionModel> resultList =
            await compute(parseDivisionListIsolate, resp.dataSet!);
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
          // callApi();
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
          widget.title,
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
                                  filteredList[index]
                                      .accdivisionname
                                      .toString(),
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

Future<void> showDivisionSelectionBottomSheet<T>(
  BuildContext context,
  String title,
  void Function(dynamic) callback,
  Map<String, String> params,
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
              child: DivisionSelectionBottomSheet(
                title: title,
                callback: callback,
                params: params,
              )),
        );
      });
}
