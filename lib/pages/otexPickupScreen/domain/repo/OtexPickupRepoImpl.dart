import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/otexPickupScreen/data/repository/OtexPickupRepo.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/pinCodeModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class OtexPickupRepoImpl implements OtexPickupRepo {
  @override
  Future<List<BranchModel>> getBranchList(Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp =
          await apiGet("${bookingUrl}GetBranchListWithSearchType", params);

      if (resp.commandStatus != 1) {
        throw Exception(resp.commandMessage ?? "Failed to fetch branch list");
      }

      Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<BranchModel> resultList = List.generate(
          list.length, (index) => BranchModel.fromJson(list[index]));
      return resultList;
    } on SocketException catch (_) {
      throw Exception("No Internet");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<CngrCngeModel>> getCngrCngeList(
      Map<String, String> params, String type) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp = await apiGet("${lmdUrl}showcngrcnge", params);

      if (resp.commandStatus != 1) {
        throw Exception(
            resp.commandMessage ?? "Failed to fetch consignor/consignee list");
      }

      Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<CngrCngeModel> resultList = List.generate(
          list.length, (index) => CngrCngeModel.fromJson(list[index]));
      return resultList;
    } on SocketException catch (_) {
      throw Exception("No Internet");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<CustomerModel>> getCustomerList(
      Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp =
          await apiGet("${lmdUrl}GetViewAllCustomerList", params);

      if (resp.commandStatus != 1) {
        throw Exception(
            resp.commandMessage ?? "Failed to fetch customer list");
      }

      Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<CustomerModel> resultList = List.generate(
          list.length, (index) => CustomerModel.fromJson(list[index]));
      return resultList;
    } on SocketException catch (_) {
      throw Exception("No Internet");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<DepartmentModel>> getDepartmentList(
      Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp =
          await apiGet("${bookingUrl}GetDepartment", params);

      if (resp.commandStatus != 1) {
        throw Exception(
            resp.commandMessage ?? "Failed to fetch department list");
      }

      Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<DepartmentModel> resultList = List.generate(
          list.length, (index) => DepartmentModel.fromJson(list[index]));
      return resultList;
    } on SocketException catch (_) {
      throw Exception("No Internet");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<PinCodeModel>> getPincodeList(
      Map<String, String> params) async {
    final hasInternet = await NetworkStatusService().hasConnection;
    if (!hasInternet) {
      throw Exception("No Internet available");
    }

    try {
      CommonResponse resp =
          await apiGet("${bookingUrl}getPinCodeList", params);

      if (resp.commandStatus != 1) {
        throw Exception(
            resp.commandMessage ?? "Failed to fetch pincode list");
      }

      Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
      List<dynamic> list = table.values.first;
      List<PinCodeModel> resultList = List.generate(
          list.length, (index) => PinCodeModel.fromJson(list[index]));
      return resultList;
    } on SocketException catch (_) {
      throw Exception("No Internet");
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }
}
