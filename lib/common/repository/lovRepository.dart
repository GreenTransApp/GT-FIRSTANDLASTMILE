import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/repository/lovIsolate.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/validateEwayBillModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/pinCodeModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class LovRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  StreamController<List<ServiceTypeModel>> serviceTypeList = StreamController();
  StreamController<List<LoadTypeModel>> loadTypeList = StreamController();
  StreamController<List<DeliveryTypeModel>> deliveryTypeList =
      StreamController();
  StreamController<List<PinCodeModel>> pinCodeList = StreamController();
  StreamController<List<BranchModel>> branchList = StreamController();
  StreamController<List<CustomerModel>> customerList = StreamController();
  StreamController<List<BookingTypeModel>> bookingTypeList = StreamController();
  StreamController<List<CngrCngeModel>> cngrList = StreamController();
  StreamController<List<CngrCngeModel>> cngeList = StreamController();
  StreamController<List<DepartmentModel>> departmentList = StreamController();

  Future<void> getPincodeList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiGet("${bookingUrl}getPinCodeList", params);

        if (resp.commandStatus == 1) {
          List<dynamic> list =
              await compute(parseListIsolate, resp.dataSet.toString());
          List<PinCodeModel> resultList = List.generate(
              list.length, (index) => PinCodeModel.fromJson(list[index]));
          pinCodeList.add(resultList);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<List<BranchModel>> getBranchList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiGet("${bookingUrl}GetBranchListWithSearchType", params);

        if (resp.commandStatus == 1 && resp.dataSet != null) {
          List<BranchModel> resultList =
              await compute(parseBranchListIsolate, resp.dataSet!);
          branchList.add(resultList);
          return resultList;
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
        return [];
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
        return [];
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
        return [];
      }
      // viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
      return [];
    }
  }

  Future<List<CustomerModel>> getCustomerList(
      Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiGet("${lmdUrl}GetViewAllCustomerList", params);

        if (resp.commandStatus == 1 && resp.dataSet != null) {
          List<CustomerModel> resultList =
              await compute(parseCustomerListIsolate, resp.dataSet!);
          customerList.add(resultList);
          return resultList;
        } else {
          viewDialog.add(false);
          isErrorLiveData.add(resp.commandMessage!);
          return [];
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
        return [];
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
        return [];
      }
      // viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
      return [];
    }
  }

  Future<List<CngrCngeModel>> getCngrCngeList(
      Map<String, String> params, String type) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp = await apiGet("${lmdUrl}showcngrcnge", params);

        if (resp.commandStatus == 1 && resp.dataSet != null) {
          viewDialog.add(false);
          List<CngrCngeModel> resultList =
              await compute(parseCngrCngeListIsolate, resp.dataSet!);
          if (type == 'R') {
            cngrList.add(resultList);
          } else {
            cngeList.add(resultList);
          }
          return resultList;
        } else {
          isErrorLiveData.add(resp.commandMessage!);
          viewDialog.add(false);
        }
        return [];
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
        return [];
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
        return [];
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
      return [];
    }
  }

  Future<List<DepartmentModel>> getDepartmentList(
      Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${bookingUrl}GetDepartment", params);

        if (resp.commandStatus == 1) {
          List<dynamic> list =
              await compute(parseListIsolate, resp.dataSet.toString());
          List<DepartmentModel> resultList = List.generate(
              list.length, (index) => DepartmentModel.fromJson(list[index]));
          departmentList.add(resultList);
          return resultList;
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
        return [];
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
        return [];
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
        return [];
      }
      // viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
      return [];
    }
  }

  Future<void> getBookingLovs(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // CommonResponse resp = await apiGet("${lmdUrl}getBookingLovs", params);
        CommonResponse resp =
            await apiGet("${bookingUrl}GetPickupDataForBooking", params);

        if (resp.commandStatus == 1 && resp.dataSet != null) {
          Map<String, List<dynamic>> results =
              await compute(parseBookingLovsIsolate, resp.dataSet!);

          serviceTypeList
              .add(results["service"]?.cast<ServiceTypeModel>() ?? []);
          loadTypeList.add(results["load"]?.cast<LoadTypeModel>() ?? []);
          deliveryTypeList
              .add(results["delivery"]?.cast<DeliveryTypeModel>() ?? []);
          // bookingTypeList
          //     .add(results["booking"]?.cast<BookingTypeModel>() ?? []);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
          viewDialog.add(false);
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      // viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
}
