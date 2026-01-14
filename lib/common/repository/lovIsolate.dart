import 'dart:convert';

List<dynamic> parseListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  return table.values.first as List<dynamic>;
}

Map<String, dynamic> parseDashboardDetailIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  return table;
}
