import 'dart:convert';

import 'package:gtlmd/pages/login/models/divisionModel.dart';

List<DivisionModel> parseDivisionListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(
      list.length, (index) => DivisionModel.fromJson(list[index]));
}
