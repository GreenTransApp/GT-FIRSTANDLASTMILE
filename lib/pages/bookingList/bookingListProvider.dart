import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/bookingList/bookingListRepository.dart';
import 'package:gtlmd/pages/bookingList/model/bookingModel.dart';
import 'package:gtlmd/pages/bookingList/model/BookingListModel.dart';

class BookingListProvider extends ChangeNotifier {
  final BookingListRepository _repo = BookingListRepository();

  ApiCallingStatus _status = ApiCallingStatus.initial;
  ApiCallingStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<BookingListModel>? _bookingListResp;
  List<BookingListModel>? get bookingListResp => _bookingListResp;

  void _clearResults() {
    _bookingListResp = null;
  }

  void _setStatus(ApiCallingStatus status) {
    if (status == ApiCallingStatus.loading) {
      _clearResults();
      _errorMessage = null;
    }
    _status = status;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    if (message != null) {
      _status = ApiCallingStatus.error;
    }
    notifyListeners();
  }

  Future<void> getBookingList(Map<String, String> params) async {
    _setStatus(ApiCallingStatus.loading);
    try {
      _bookingListResp = await _repo.GetBookingList(params);
      _setStatus(ApiCallingStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // final List<BookingModel> _allBookings = [
  //   BookingModel(
  //     grNo: 'THN78587',
  //     grDate: DateTime(2026, 1, 19),
  //     destination: 'Ludhiana',
  //     amount: 0,
  //   ),
  //   BookingModel(
  //     grNo: 'THN78554',
  //     grDate: DateTime(2026, 1, 19),
  //     destination: 'Jammu',
  //     amount: 0,
  //   ),
  // ];

  String _search = '';

  List<BookingListModel> get bookings {
    if (_bookingListResp == null) return [];
    if (_search.isEmpty) return _bookingListResp!;
    return _bookingListResp!
        .where((b) =>
            b.grno!.toLowerCase().contains(_search.toLowerCase()) ||
            b.destname!.toLowerCase().contains(_search.toLowerCase()))
        .toList();
  }

  double get totalAmount =>
      bookings.isEmpty ? 0 : bookings.fold(0, (sum, b) => sum + b.tamount!);

  void updateSearch(String value) {
    _search = value;
    notifyListeners();
  }

  void sharePdf(BookingModel booking) {}
}
