import 'dart:convert';
import 'package:gtlmd/common/operations/models/operationsModel.dart';

List<OperationsModel> parseOperationsListIsolate(dynamic dataSet) {
  if (dataSet == null) return [];
  final parsed = jsonDecode(dataSet.toString()).cast<Map<String, dynamic>>();
  return parsed
      .map<OperationsModel>((json) => OperationsModel.fromJson(json))
      .toList();
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
