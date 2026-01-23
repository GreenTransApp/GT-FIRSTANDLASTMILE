import 'dart:convert';

import 'package:gtlmd/optionMenu/stickerPrinting/model/GrListModel.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/StickerModel.dart';
import 'package:gtlmd/pages/bookingList/model/BookingListModel.dart';
import 'package:gtlmd/pages/grList_old/model/grListModel_old.dart';

List<GrListModel> parseGrListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(
      list.length, (index) => GrListModel.fromJson(list[index]));
}

List<StickerListModel> parseStickerListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(
      list.length, (index) => StickerListModel.fromJson(list[index]));
}
