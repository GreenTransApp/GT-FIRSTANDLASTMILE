import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupInfoModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupSplitInfo.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/controller/state/OtexPickupState.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/repo/OtexPickupRepoImpl.dart';

// Import necessary models for search APIs
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';

class OtexPickupProvider extends ChangeNotifier {
  OtexPickupState _state = OtexPickupState.initial();
  final OtexPickupRepoImpl _repo = OtexPickupRepoImpl();
  OtexPickupState get state => _state;

  // Initialize/reset form state
  void initializeForm({String? transactionId}) {
    _state = OtexPickupState(
      status: OtexPickupStatus.idle,
      info: OtexPickupInfoModel.empty(),
      splitInfo: [OtexPickupSplitInfo()], // Start with 1 default entry card
      errorMessage: null,
    );
    notifyListeners();

    if (transactionId != null && transactionId != "0") {
      fetchBookingDetails(transactionId);
    }
  }

  // API Call: Fetch pre-fill booking details
  Future<void> fetchBookingDetails(String transactionId) async {
    _state = _state.copyWith(status: OtexPickupStatus.loading);
    notifyListeners();

    try {
      // TODO: Implement API call via repository
      // final response = await repository.getPickupDetails(params);

      _state = _state.copyWith(
        status: OtexPickupStatus.success,
        // info: fetchedInfo,
        // splitInfo: fetchedSplitList,
      );
    } catch (e) {
      _state = _state.copyWith(
        status: OtexPickupStatus.failure,
        errorMessage: e.toString(),
      );
    }
    notifyListeners();
  }

  // API Call: Search Booking Branches for LOV Bottom Sheet
  Future<List<BranchModel>> searchBranches(String query) async {
    try {
      // final params = <String, String>{"SearchText": query, "SearchType": "B"};
      Map<String, String> params = {
        "prmcompanyid": savedLogin.companyid.toString(),
        "prmbranchcode": savedUser.loginbranchcode.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmsessionid": savedUser.sessionid.toString(),
        "prmcharstr": query,
      };
      return await _repo.getBranchList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Customers for LOV Bottom Sheet
  Future<List<CustomerModel>> searchCustomers(String query) async {
    try {
      // final params = <String, String>{"SearchText": query};
      Map<String, String> params = {
        "prmcompanyid": savedUser.companyid.toString(),
        "prmbranchcode": savedUser.loginbranchcode.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmsessionid": savedUser.sessionid.toString(),
        "prmcharstr": query,
      };
      return await _repo.getCustomerList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Departments for LOV Bottom Sheet
  Future<List<DepartmentModel>> searchDepartments(String query) async {
    final currentInfo = _state.info ?? OtexPickupInfoModel.empty();
    if (isNullOrEmpty(currentInfo.customerCode) ||
        isNullOrEmpty(currentInfo.bookingBranchCode)) {
      _state = _state.copyWith(
          errorMessage: "Booking Branch and customer mandatory");
      notifyListeners();
      return [];
    }
    try {
      // final params = <String, String>{"SearchText": query};
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmcustcode": _state.info!.customerCode.toString(),
        "prmorgcode": _state.info!.bookingBranchCode.toString(),
      };

      return await _repo.getDepartmentList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Shippers for LOV Bottom Sheet
  Future<List<CngrCngeModel>> searchShippers(String query) async {
    try {
      final params = <String, String>{"SearchText": query, "Type": "R"};
      return await _repo.getCngrCngeList(params, "R");
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Consignee (CngrCnge) for LOV Bottom Sheet
  Future<List<CngrCngeModel>> searchCngrCnge(
      String query, String cngrcnge) async {
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmbranchcode": savedUser.loginbranchcode.toString(),
        "prmgrtype": 'R',
        "prmcngrcnge": cngrcnge,
        "prmcustcode": '',
        "prmcharstr": query,
      };
      return await _repo.getCngrCngeList(params, cngrcnge);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // Clear the error message after it has been shown
  void clearError() {
    _state = _state.copyWith(errorMessage: null);
    notifyListeners();
  }

  // Updates global booking fields in state
  void updateGlobalInfo(OtexPickupInfoModel info) {
    _state = _state.copyWith(info: info);
    clearError();
    notifyListeners();
  }

  // Add a dynamic card entry
  void addCardEntry() {
    final updatedList = List<OtexPickupSplitInfo>.from(_state.splitInfo)
      ..add(OtexPickupSplitInfo());
    _state = _state.copyWith(splitInfo: updatedList);
    notifyListeners();
  }

  // Remove a dynamic card entry
  void removeCardEntry(int index) {
    if (_state.splitInfo.length <= 1) return;
    final updatedList = List<OtexPickupSplitInfo>.from(_state.splitInfo)
      ..removeAt(index);
    _state = _state.copyWith(splitInfo: updatedList);
    notifyListeners();
  }

  // Set card count explicitly
  void setCardCount(int count) {
    final currentList = List<OtexPickupSplitInfo>.from(_state.splitInfo);
    if (count > currentList.length) {
      // Add missing cards
      int diff = count - currentList.length;
      for (int i = 0; i < diff; i++) {
        currentList.add(OtexPickupSplitInfo());
      }
    } else if (count < currentList.length) {
      // Remove excess cards
      currentList.removeRange(count, currentList.length);
    }
    _state = _state.copyWith(splitInfo: currentList);
    notifyListeners();
  }

  // Updates card data locally inside dynamic cards list
  void updateCardData(int index, OtexPickupSplitInfo cardData) {
    if (index >= _state.splitInfo.length) return;
    final updatedList = List<OtexPickupSplitInfo>.from(_state.splitInfo);
    updatedList[index] = cardData;
    _state = _state.copyWith(splitInfo: updatedList);
    notifyListeners();
  }

  // API Call: Save/Submit specific destination entry card
  Future<bool> saveCardEntry(int index) async {
    if (index >= _state.splitInfo.length) return false;
    final card = _state.splitInfo[index];

    // TODO: Perform local API call for card level upsert (e.g. Card validation & post request)
    // final success = await repository.saveCard(card, _state.info);

    return true;
  }

  // Helper to extract clean message from Exception
  String _extractMessage(dynamic e) {
    if (e is Exception) {
      return e.toString().replaceFirst('Exception: ', '');
    }
    return e.toString();
  }

  // Bluetooth/Local Printer Call: Print Local labels
  Future<void> printLabel(int index) async {
    // TODO: Implement Bluetooth/USB printer labels spooled call
  }

  // Bluetooth/Local Printer Call: Print Local Waybill
  Future<void> printWaybill(int index) async {
    // TODO: Implement Bluetooth/USB printer waybill PDF print call
  }
}
