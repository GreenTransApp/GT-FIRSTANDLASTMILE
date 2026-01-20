import 'dart:convert';
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';
import 'package:gtlmd/pages/pickup/model/serviceTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/LoadTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';

List<dynamic> parseListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  return table.values.first as List<dynamic>;
}

Map<String, dynamic> parseMapIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  return table;
}

List<BranchModel> parseBranchListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(
      list.length, (index) => BranchModel.fromJson(list[index]));
}

List<CustomerModel> parseCustomerListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(
      list.length, (index) => CustomerModel.fromJson(list[index]));
}

List<CngrCngeModel> parseCngrCngeListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(
      list.length, (index) => CngrCngeModel.fromJson(list[index]));
}

Map<String, List<dynamic>> parseBookingLovsIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  Map<String, List<dynamic>> result = {};

  if (table.containsKey("Table")) {
    List<dynamic> list = table["Table"];
    result["service"] = List.generate(
        list.length, (index) => ServiceTypeModel.fromJson(list[index]));
  }
  if (table.containsKey("Table1")) {
    List<dynamic> list = table["Table1"];
    result["load"] = List.generate(
        list.length, (index) => LoadTypeModel.fromJson(list[index]));
  }
  if (table.containsKey("Table2")) {
    List<dynamic> list = table["Table2"];
    result["delivery"] = List.generate(
        list.length, (index) => DeliveryTypeModel.fromJson(list[index]));
  }
  if (table.containsKey("Table3")) {
    List<dynamic> list = table["Table3"];
    result["booking"] = List.generate(
        list.length, (index) => BookingTypeModel.fromJson(list[index]));
  }
  return result;
}
