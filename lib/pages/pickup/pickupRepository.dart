import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/pickup/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/branchModel.dart';
import 'package:gtlmd/pages/pickup/customerModel.dart';
import 'package:gtlmd/pages/pickup/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/departmentModel.dart';
import 'package:gtlmd/pages/pickup/pickResp.dart';
import 'package:gtlmd/pages/pickup/pickupDetailModel.dart';
import 'package:gtlmd/pages/pickup/pinCodeModel.dart';
import 'package:gtlmd/pages/pickup/savePickupRespModel.dart';
import 'package:gtlmd/pages/pickup/serviceTypeModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';
import 'package:http/retry.dart';

class PickupRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  StreamController<List<PickupDetailModel>> pickupDetailsList =
      StreamController();
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
  StreamController<SavePickupRespModel> savePickupResp = StreamController();

  Future<PickResp> getPickupDetails(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp =
            await apiGet("${lmdUrl}/GetPickupDetails", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          List<PickupDetailModel> pickupList = [];
          List<ServiceTypeModel> serviceList = [];
          List<LoadTypeModel> loadList = [];
          List<DeliveryTypeModel> deliveryList = [];
          List<BookingTypeModel> bookingList = [];
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list1 = entry.value;
              List<PickupDetailModel> resultList = List.generate(list1.length,
                  (index) => PickupDetailModel.fromJson(list1[index]));
              // pickupDetailsList.add(resultList);
              pickupList = resultList;
            } else if (entry.key == "Table1") {
              List<dynamic> list2 = entry.value;
              List<ServiceTypeModel> resultList = List.generate(list2.length,
                  (index) => ServiceTypeModel.fromJson(list2[index]));
              // serviceTypeList.add(resultList);
              serviceList = resultList;
            } else if (entry.key == "Table2") {
              List<dynamic> list2 = entry.value;
              List<LoadTypeModel> resultList = List.generate(list2.length,
                  (index) => LoadTypeModel.fromJson(list2[index]));
              // loadTypeList.add(resultList);
              loadList = resultList;
            } else if (entry.key == "Table3") {
              List<dynamic> list2 = entry.value;
              List<DeliveryTypeModel> resultList = List.generate(list2.length,
                  (index) => DeliveryTypeModel.fromJson(list2[index]));
              // deliveryTypeList.add(resultList);
              deliveryList = resultList;
            } else if (entry.key == "Table4") {
              List<dynamic> list2 = entry.value;
              List<BookingTypeModel> resultList = List.generate(list2.length,
                  (index) => BookingTypeModel.fromJson(list2[index]));
              // bookingTypeList.add(resultList);
              bookingList = resultList;
            }
          }
          // pickupDetailsList.add(pickupList);
          // serviceTypeList.add(serviceList);
          // loadTypeList.add(loadList);
          // deliveryTypeList.add(deliveryList);
          // bookingTypeList.add(bookingList);

          return PickResp(
            pickupList: pickupList,
            serviceList: serviceList,
            loadList: loadList,
            deliveryList: deliveryList,
            bookingList: bookingList,
          );
        } else {
          isErrorLiveData.add(resp.commandMessage!);
          viewDialog.add(false);
          return PickResp(
            pickupList: [],
            serviceList: [],
            loadList: [],
            deliveryList: [],
            bookingList: [],
          );
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
        return PickResp(
            pickupList: [],
            serviceList: [],
            loadList: [],
            deliveryList: [],
            bookingList: []);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
        return PickResp(
            pickupList: [],
            serviceList: [],
            loadList: [],
            deliveryList: [],
            bookingList: []);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
      return PickResp(
          pickupList: [],
          serviceList: [],
          loadList: [],
          deliveryList: [],
          bookingList: []);
    }
  }

  Future<void> getPincodeList(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiGet("${bookingUrl}getPinCodeList", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
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

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<BranchModel> resultList = List.generate(
              list.length, (index) => BranchModel.fromJson(list[index]));
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

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<CustomerModel> resultList = List.generate(
              list.length, (index) => CustomerModel.fromJson(list[index]));
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

        if (resp.commandStatus == 1) {
          viewDialog.add(false);
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<CngrCngeModel> resultList = List.generate(
              list.length, (index) => CngrCngeModel.fromJson(list[index]));
          if (type == 'R') {
            cngrList.add(resultList);
          } else {
            cngeList.add(resultList);
          }
          return [];
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
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
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

  Future<void> savePickup(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        // CommonResponse resp = await apiGet("${bookingUrl}GetCngrCngeListV2", params);
        CommonResponse resp = await apiPost("${lmdUrl}Pickup_Upsert", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          // SavePickupRespModel savePickupResponse =
          //     SavePickupRespModel.fromJson(list[0]);

          List<SavePickupRespModel> resultList = List.generate(list.length,
              (index) => SavePickupRespModel.fromJson(list[index]));
          savePickupResp.add(resultList[0]);
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
}
