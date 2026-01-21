import 'dart:convert';

import 'package:gtlmd/pages/bookingList/model/BookingListModel.dart';

List<BookingListModel> parseBookingListIsolate(String rawDataSet) {
  final Map<String, dynamic> table = jsonDecode(rawDataSet);
  final List<dynamic> list = table.values.first as List<dynamic>;
  return List.generate(
      list.length, (index) => BookingListModel.fromJson(list[index]));
}
