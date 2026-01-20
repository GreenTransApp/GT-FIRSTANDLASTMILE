// ignore_for_file: must_be_immutable

import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/repository/lovIsolate.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/pinCodeModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';

enum ListModel {
  department,
  serviceType,
  loadType,
  deliveryType,
  pinCode,
  branch,
  customer,
  bookingType,
  cngr,
  cnge,
}

class CommonBottomSheetWithApi<T> extends StatefulWidget {
  Map<String, String> params;
  String title;
  String sp;
  ListModel listModel;
  CommonBottomSheetWithApi({
    super.key,
    required this.params,
    required this.title,
    required this.sp,
    required this.listModel,
  });

  @override
  State<CommonBottomSheetWithApi> createState() =>
      _CommonBottomSheetWithApiState();
}

class _CommonBottomSheetWithApiState<T>
    extends State<CommonBottomSheetWithApi<T>> {
  late LoadingAlertService loadingAlertService;
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocus = FocusNode();
  List<T> filteredList = [];
  String query = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
    });
  }

  void callApi() async {
    // loadingAlertService.showLoading();
    isLoading = true;
    widget.params['prmcharstr'] = query;
    try {
      CommonResponse resp =
          await apiGet("${bookingUrl}GetDepartment", widget.params);

      if (resp.commandStatus == 1) {
        List<dynamic> list =
            await compute(parseListIsolate, resp.dataSet.toString());
        List<T> resultList;
        switch (widget.listModel) {
          case ListModel.department:
            resultList = List.generate(list.length,
                (index) => DepartmentModel.fromJson(list[index]) as T);
            break;
          case ListModel.serviceType:
            resultList = List.generate(list.length,
                (index) => ServiceTypeModel.fromJson(list[index]) as T);
            break;
          case ListModel.loadType:
            resultList = List.generate(list.length,
                (index) => LoadTypeModel.fromJson(list[index]) as T);
            break;
          case ListModel.deliveryType:
            resultList = List.generate(list.length,
                (index) => DeliveryTypeModel.fromJson(list[index]) as T);
            break;
          case ListModel.pinCode:
            resultList = List.generate(list.length,
                (index) => PinCodeModel.fromJson(list[index]) as T);
            break;
          case ListModel.branch:
            resultList = List.generate(
                list.length, (index) => BranchModel.fromJson(list[index]) as T);
            break;
          case ListModel.customer:
            resultList = List.generate(list.length,
                (index) => CustomerModel.fromJson(list[index]) as T);
            break;
          case ListModel.bookingType:
            resultList = List.generate(list.length,
                (index) => BookingTypeModel.fromJson(list[index]) as T);
            break;
          case ListModel.cngr:
            resultList = List.generate(list.length,
                (index) => CngrCngeModel.fromJson(list[index]) as T);
            break;
          case ListModel.cnge:
            resultList = List.generate(list.length,
                (index) => CngrCngeModel.fromJson(list[index]) as T);
            break;
        }
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(fontSize: SizeConfig.largeTextSize),
          ),
          backgroundColor: CommonColors.colorPrimary,
          centerTitle: true,
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  SearchBar(
                    controller: searchController,
                    leading: const Icon(Icons.search),
                    hintText: 'Search',
                    elevation: WidgetStateProperty.all(4.0),
                    focusNode: searchFocus,
                    shadowColor:
                        WidgetStateProperty.all(CommonColors.appBarColor),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(SizeConfig.largeRadius)),
                    ),
                    padding: WidgetStateProperty.all(EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding)),
                    onSubmitted: (value) {
                      query = value;
                      callApi();
                    },
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          titleAlignment: ListTileTitleAlignment.center,
                          title: Text(filteredList[index].toString()),
                        );
                      },
                    ),
                  ),
                ],
              ));
  }
}
