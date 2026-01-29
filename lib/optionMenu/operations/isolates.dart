import 'dart:convert';
import 'package:gtlmd/optionMenu/operations/models/operationsModel.dart';
import 'package:gtlmd/pages/home/Model/menuModel.dart';

List<MenuModel> parseMenuListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(list.length, (index) => MenuModel.fromJson(list[index]));
}

OperationsModel? parseSingleOperationIsolate(dynamic dataSet) {
  if (dataSet == null) return null;
  final parsed = jsonDecode(dataSet.toString());
  if (parsed != null &&
      parsed['Table'] != null &&
      (parsed['Table'] as List).isNotEmpty) {
    return OperationsModel.fromJson(parsed['Table'][0]);
  }
  return null;
}
