import 'dart:convert';

Map<String, dynamic> parseValidateDeviceIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first;
  return Map<String, dynamic>.from(list.first);
}

Map<String, dynamic> parseDashboardDetailIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  return table;
}
