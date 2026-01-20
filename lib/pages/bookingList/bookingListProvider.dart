import 'package:flutter/material.dart';
import 'package:gtlmd/pages/bookingList/bookingModel.dart';

class BookingListProvider extends ChangeNotifier {
  final List<BookingModel> _allBookings = [
    BookingModel(
      grNo: 'THN78587',
      grDate: DateTime(2026, 1, 19),
      destination: 'Ludhiana',
      amount: 0,
    ),
    BookingModel(
      grNo: 'THN78554',
      grDate: DateTime(2026, 1, 19),
      destination: 'Jammu',
      amount: 0,
    ),
  ];

  String _search = '';

  List<BookingModel> get bookings {
    if (_search.isEmpty) return _allBookings;
    return _allBookings
        .where((b) =>
            b.grNo.toLowerCase().contains(_search.toLowerCase()) ||
            b.destination.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  double get totalAmount => bookings.fold(0, (sum, b) => sum + b.amount);

  void updateSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void sharePdf(BookingModel booking) {}
}
