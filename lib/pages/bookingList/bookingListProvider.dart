import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/bookingList/bookingListRepository.dart';
import 'package:gtlmd/pages/bookingList/model/bookingModel.dart';
import 'package:gtlmd/pages/bookingList/model/BookingListModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/bookingWithEwayBill.dart';
import 'package:intl/intl.dart';

class BookingListProvider extends ChangeNotifier {
  final BookingListRepository _repo = BookingListRepository();

  ApiCallingStatus _status = ApiCallingStatus.initial;
  ApiCallingStatus get status => _status;
  String fromDate = DateFormat('yyyy-MM-dd').format(DateTime.now()),
      toDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

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

  Future<void> refreshList() async {
    // _setStatus(ApiCallingStatus.loading);
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmbranchcode": savedUser.loginbranchcode.toString(),
        "prmfromdt": fromDate,
        "prmtodt": toDate,
        "prmsessionid": savedUser.sessionid.toString()
      };
      getBookingList(params);
    } catch (error) {
      _setError(error.toString());
    }
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

  Future<void> cancelBooking(String remarks, BookingListModel booking) async {
    _setStatus(ApiCallingStatus.loading);
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmbranchcode": savedUser.loginbranchcode.toString(),
        'prmgrdt': stringToDateTime(booking.grdt.toString(), 'dd/MM/yyyy'),
        'prmgrno': booking.grno.toString(),
        'prmremarks': remarks,
        "prmusercode": savedUser.usercode.toString(),
        "prmsessionid": savedUser.sessionid.toString()
      };
      await _repo.cancelBooking(params);
      refreshList();
      // _setStatus(ApiCallingStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void navigateToBookingWithEwayBill(String grno) {
    Get.off(() => BookingWithEwayBill(grno: grno));
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
