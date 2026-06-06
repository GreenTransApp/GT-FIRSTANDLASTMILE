import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gtlmd/api/model/ApiCallParametersModel.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupInfoModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupSplitInfo.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/goodsTypeModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/packingTypeModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/productTypeModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/controller/state/OtexPickupState.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/repo/OtexPickupRepoImpl.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';

// Import necessary models for search APIs
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';

class OtexPickupProvider extends ChangeNotifier {
  OtexPickupState _state = OtexPickupState.initial();
  final OtexPickupRepoImpl _repo = OtexPickupRepoImpl();
  OtexPickupState get state => _state;

  // API Call: Fetch pre-fill booking details
  // Future<void> fetchBookingDetails(String transactionId) async {
  //   _state = _state.copyWith(status: OtexPickupStatus.loading);
  //   notifyListeners();

  //   try {
  //     // TODO: Implement API call via repository
  //     // final response = await repository.getPickupDetails(params);

  //     _state = _state.copyWith(
  //       status: OtexPickupStatus.success,
  //       // info: fetchedInfo,
  //       // splitInfo: fetchedSplitList,
  //     );
  //   } catch (e) {
  //     _state = _state.copyWith(
  //       status: OtexPickupStatus.failure,
  //       errorMessage: e.toString(),
  //     );
  //   }
  //   notifyListeners();
  // }

  void initializeForm({String? transactionId, String? grno}) {
    _state = OtexPickupState(
      headerStatus: SectionStatus.idle,
      cardListStatus: SectionStatus.idle,
      info: const OtexPickupInfoModel(),
      splitInfo: [OtexPickupSplitInfo()],
      permanentCardCount: 0,
      totalPalletQty: 0,
      hasTransactionId: transactionId != null && transactionId != "0",
      errorMessage: null,
    );
    notifyListeners();

    if (transactionId != null && transactionId != "0") {
      fetchBookingDetails(transactionId); // <-- already here
    }
  }

  Future<void> fetchBookingDetails(String transactionid) async {
    // Set both sections to loading independently
    _state = _state.copyWith(
      headerStatus: SectionStatus.loading,
      cardListStatus: SectionStatus.loading,
      hasTransactionId: true,
    );
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // simulate network

    try {
      // final stubInfo = OtexPickupInfoModel(
      //   bookingBranchName: "Mumbai Central",
      //   bookingBranchCode: "MBC",
      //   bookingDate: "01-06-2025",
      //   bookingTime: "10:30",
      //   bookingTypeName: "PP",
      //   bookingTypeCode: "PP",
      //   referenceNumber: "REF-2025-001",
      //   customerName: "Tata Logistics",
      //   customerCode: "TATA001",
      //   departmentName: "Warehousing",
      //   departmentCode: "WH01",
      //   shipperName: "Rajesh Transport",
      //   shipperCode: "RT001",
      //   shipperMobileNo: "9876543210",
      //   productTypeName: "OTEX",
      //   productTypeCode: "OTEX",
      //   loadTypeName: "Full Load",
      //   loadTypeCode: "FL",
      //   deliveryTypeName: "Door to Door",
      //   deliveryTypeCode: "DD",
      // );

      // final stubCards = [
      //   OtexPickupSplitInfo(
      //     wayBillNo: "WB-1001",
      //     destName: "Delhi Hub",
      //     destCode: "DLH",
      //     cngeName: "Amit Sharma",
      //     cngeCode: "AS001",
      //     packingMethodName: "Carton",
      //     packingMethodCode: "CTN",
      //     saidToContainName: "Electronics",
      //     saidToContainCode: "ELC",
      //     palletQty: 3,
      //     weight: 120.5,
      //     freightAmt: 4500.0,
      //     isSaved: true, // server-fetched cards are already saved
      //   ),
      //   OtexPickupSplitInfo(
      //     wayBillNo: "WB-1002",
      //     destName: "Pune Depot",
      //     destCode: "PND",
      //     cngeName: "Sunita Verma",
      //     cngeCode: "SV002",
      //     packingMethodName: "Pallet",
      //     packingMethodCode: "PLT",
      //     saidToContainName: "Spare Parts",
      //     saidToContainCode: "SP",
      //     palletQty: 5,
      //     weight: 340.0,
      //     freightAmt: 8200.0,
      //     isSaved: true,
      //   ),
      //   OtexPickupSplitInfo(
      //     wayBillNo: "WB-1002",
      //     destName: "Pune Depot",
      //     destCode: "PND",
      //     cngeName: "Sunita Verma",
      //     cngeCode: "SV002",
      //     packingMethodName: "Pallet",
      //     packingMethodCode: "PLT",
      //     saidToContainName: "Spare Parts",
      //     saidToContainCode: "SP",
      //     palletQty: 5,
      //     weight: 340.0,
      //     freightAmt: 8200.0,
      //     isSaved: false,
      //   ),
      //   OtexPickupSplitInfo(
      //     wayBillNo: "WB-1002",
      //     destName: "Pune Depot",
      //     destCode: "PND",
      //     cngeName: "Sunita Verma",
      //     cngeCode: "SV002",
      //     packingMethodName: "Pallet",
      //     packingMethodCode: "PLT",
      //     saidToContainName: "Spare Parts",
      //     saidToContainCode: "SP",
      //     palletQty: 5,
      //     weight: 340.0,
      //     freightAmt: 8200.0,
      //     isSaved: false,
      //   ),
      // ];

      Map<String, String> params = {
        "prmconnstring": savedLogin.companyid.toString(),
        "prmloginbranchcode": savedUser.loginbranchcode.toString(),
        "prmlogindivisionid": savedUser.logindivisionid.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmmenucode": 'GTLMD_OTEXPICKUP',
        "prmsessionid": savedUser.sessionid.toString(),
        "prmindentid": transactionid,
      };
      List<dynamic> result = await _repo.getPickupDetails(params);

      final OtexPickupInfoModel infoData = result[0] as OtexPickupInfoModel;
      List<OtexPickupSplitInfo> splitData =
          (result[1] as List).cast<OtexPickupSplitInfo>().toList();

      if (splitData.isEmpty) {
        splitData = [OtexPickupSplitInfo()];
      }

      int totalPallets = 0;
      for (var card in splitData) {
        totalPallets += card.palletQty ?? 0;
      }

      _state = _state.copyWith(
        headerStatus: SectionStatus.success,
        cardListStatus: SectionStatus.success,
        info: infoData,
        splitInfo: splitData,
        // Both cards came from server so permanent count = 2
        permanentCardCount: splitData.where((c) => c.isSaved).length,
        totalPalletQty: totalPallets,
      );
      notifyListeners();
    } catch (e) {
      _state = _state.copyWith(
        headerStatus: SectionStatus.failure,
        cardListStatus: SectionStatus.failure,
        errorMessage: _extractMessage(e),
      );
      notifyListeners();
    }
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
    final currentInfo = _state.info ?? const OtexPickupInfoModel();
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
      // Map<String, String> params = {
      //   "prmconnstring": savedUser.companyid.toString(),
      //   "prmbranchcode": savedUser.loginbranchcode.toString(),
      //   "prmgrtype": 'R',
      //   "prmcngrcnge": 'R',
      //   "prmcustcode": '',
      //   "prmcharstr": query,
      // };
      Map<String, String> p = {
        "BookingBranchCode": isNullOrEmpty(_state.info.bookingBranchCode)
            ? ''
            : _state.info.bookingBranchCode.toString(),
        'DestinationCode': '',
        'LOVType': 'R'
      };
      Map<String, String> params = {
        'prmconnstring': savedUser.companyid.toString(),
        'prmfilter': query,
        'prmeventname': 'ShortBookingCngr',
        'prmjsondatastr': jsonEncode(p),
        'prmloginbranchcode': savedUser.loginbranchcode.toString(),
        'prmlogindivisionid': savedUser.logindivisionid.toString(),
        'prmusercode': savedUser.usercode.toString(),
        'prmmenucode': 'GTI_WayBillTallySheetComp',
        'prmsessionid': savedUser.sessionid.toString()
      };
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
      Map<String, String> p = {
        "BookingBranchCode": isNullOrEmpty(_state.info.bookingBranchCode)
            ? ''
            : _state.info.bookingBranchCode.toString(),
        'DestinationCode': '',
        'LOVType': cngrcnge
      };
      Map<String, String> params = {
        'prmconnstring': savedUser.companyid.toString(),
        'prmfilter': query,
        'prmeventname': 'ShortBookingCngr',
        'prmjsondatastr': jsonEncode(p),
        'prmloginbranchcode': savedUser.loginbranchcode.toString(),
        'prmlogindivisionid': savedUser.logindivisionid.toString(),
        'prmusercode': savedUser.usercode.toString(),
        'prmmenucode': 'GTI_WayBillTallySheetComp',
        'prmsessionid': savedUser.sessionid.toString()
      };
      return await _repo.getCngrCngeList(params, cngrcnge);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Consignee (CngrCnge) for LOV Bottom Sheet
  Future<List<ProductTypeModel>> searchProductType(String query) async {
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmloginbranchcode": savedUser.loginbranchcode.toString(),
        "prmlogindivisionid": savedUser.logindivisionid.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmmenucode": '',
        "prmsessionid": savedUser.sessionid.toString(),
        "prmquery": query,
      };
      return await _repo.getProductTypeList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Consignee (CngrCnge) for LOV Bottom Sheet
  Future<List<GoodsTypeModel>> searchGoodsType(String query) async {
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmloginbranchcode": savedUser.loginbranchcode.toString(),
        "prmlogindivisionid": savedUser.logindivisionid.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmmenucode": '',
        "prmsessionid": savedUser.sessionid.toString(),
        "prmquery": query,
      };
      return await _repo.getGoodsList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Consignee (CngrCnge) for LOV Bottom Sheet
  Future<List<PackingTypeModel>> searchPackingType(String query) async {
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmloginbranchcode": savedUser.loginbranchcode.toString(),
        "prmlogindivisionid": savedUser.logindivisionid.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmmenucode": '',
        "prmsessionid": savedUser.sessionid.toString(),
        "prmquery": query,
      };
      return await _repo.getPackingTypeList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Consignee (CngrCnge) for LOV Bottom Sheet
  Future<List<BookingTypeModel>> searchBookingType(String query) async {
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmloginbranchcode": savedUser.loginbranchcode.toString(),
        "prmlogindivisionid": savedUser.logindivisionid.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmmenucode": '',
        "prmsessionid": savedUser.sessionid.toString(),
        "prmquery": query,
      };
      return await _repo.getBookingTypeList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // API Call: Search Consignee (CngrCnge) for LOV Bottom Sheet
  Future<List<DeliveryTypeModel>> searchDeliveryType(String query) async {
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmloginbranchcode": savedUser.loginbranchcode.toString(),
        "prmlogindivisionid": savedUser.logindivisionid.toString(),
        "prmusercode": savedUser.usercode.toString(),
        "prmmenucode": '',
        "prmsessionid": savedUser.sessionid.toString(),
        "prmquery": query,
      };
      return await _repo.getDeliveryTypeList(params);
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return [];
    }
  }

  // Clear the error message after it has been shown
  void clearError() {
    _state = _state.copyWith(clearError: true);
    notifyListeners();
  }

  void updateInfo(OtexPickupInfoModel info) {
    _state = _state.copyWith(info: info, clearError: true);
    notifyListeners();
  }

  void setCardCount(int count) {
    // Floor is max(1, permanentCardCount) — cannot go below saved bookings
    final floor = _state.permanentCardCount > 0 ? _state.permanentCardCount : 1;
    final clamped = count.clamp(floor, 100);
    final current = List<OtexPickupSplitInfo>.from(_state.splitInfo);

    if (clamped > current.length) {
      for (int i = current.length; i < clamped; i++) {
        current.add(OtexPickupSplitInfo());
      }
    } else if (clamped < current.length) {
      current.removeRange(clamped, current.length);
    }

    int totalPallets = 0;
    for (var card in current) {
      totalPallets += card.palletQty ?? 0;
    }

    _state = _state.copyWith(splitInfo: current, totalPalletQty: totalPallets);
    notifyListeners();
  }

  Future<bool> saveCardEntry(int index) async {
    if (index >= _state.splitInfo.length) return false;

    // Validate total pieces before saving
    final maxPcs = _state.info.pcs ?? 0;
    var totQty = 0;
    for (var item in _state.splitInfo) {
      totQty += item.palletQty ?? 0;
    }

    if (maxPcs > 0 && totQty > maxPcs) {
      _state = _state.copyWith(
          errorMessage:
              "Total pieces across cards (${_state.totalPalletQty}) exceed the limit ($maxPcs).");
      notifyListeners();
      clearError();
      return false;
    }

    // Update the state with the new info object
    String status =
        isNullOrEmpty(_state.splitInfo[index].wayBillNo) ? 'A' : 'U';

    _state = _state.copyWith(
        info: _state.info.copyWith(documentType: 'C', recstatus: status));

    Map<String, dynamic> buildSaveJson() {
      return {
        // ── Basic Info ────────────────────────────────────────────
        'indentid': _state.info.indentId ?? 0,
        'documenttype': _state.info.documentType ?? '',
        'orgcode': _state.info.bookingBranchCode ?? '',
        'orgname': _state.info.bookingBranchName ?? '',
        'grdt': _state.info.grdt ?? '',
        'picktime': _state.info.picktime ?? '',
        'cnmtno1': _state.info.cnmtNo1 ?? '',
        'cnmtno2': _state.info.cnmtNo2 ?? '',
        'grno': _state.info.grNo ?? '',
        'contracttype': '',
        'referenceno': _state.info.referenceNumber ?? '',

        // ── Pickup ────────────────────────────────────────────────
        'pickuppoint': _state.info.pickupPoint ?? '',
        'pickuppincode': _state.info.pickupPinCode ?? '',
        'pickupaddress': _state.info.pickupAddress ?? '',

        // ── Destination / Delivery ────────────────────────────────
        'destcode': '',
        'destname': '',
        'deliverypoint': _state.info.deliveryPoint ?? '',
        'deliverypincode': _state.info.deliveryPinCode ?? '',
        'dlvaddress': _state.info.deliveryAddress ?? '',

        // ── GR / Booking ──────────────────────────────────────────
        'grtype': _state.info.bookingTypeCode ?? '',
        'expecteddeliverydt': '',

        // ── Customer ──────────────────────────────────────────────
        'custcode': _state.info.customerCode ?? '',
        'custname': _state.info.customerName ?? '',
        'custgstno': _state.info.customerGstNo ?? '',
        'custdeptid': int.tryParse(_state.info.departmentCode ?? '0') ?? 0,
        'collectionstn': '',
        'billingbranchcode': '',

        // ── Consignor ─────────────────────────────────────────────
        'cngrdocumenttype': '',
        'cngrgstno': _state.info.shipperCode ?? '',
        'cngrdocnocode': _state.info.shipperCode ?? '',
        'cngrcode': _state.info.shipperCode ?? '',
        'cngr': _state.info.shipperName ?? '',
        'cngrname': _state.info.shipperName ?? '',
        'cngrdealercode': '',
        'cngrtelno': _state.info.shipperMobileNo ?? '',
        'cngremail': _state.info.shipperEmail ?? '',
        'cngraddress': _state.info.shipperAddress ?? '',
        'cngrcity': '',
        'cngrzipcode': _state.info.shipperZipCode ?? '',
        'cngrstate': '',
        'cngrcountry': '',

        // ── Consignee ─────────────────────────────────────────────
        'cngedocumenttype': '',
        'cngegstno': _state.info.cngeCode ?? '',
        'cngedocnocode': _state.info.cngeCode ?? '',
        'cngecode': _state.info.cngeCode ?? '',
        'cnge': _state.info.cngeName ?? '',
        'cngename': _state.info.cngeName ?? '',
        'cngedealercode': '',
        'cngetelno': _state.info.cngeMobileNo ?? '',
        'cngeemail': _state.info.cngeEmail ?? '',
        'cngeaddress': _state.info.cngeAddress ?? '',
        'cngecity': '',
        'cngezipcode': _state.info.cngeZipCode ?? '',
        'cngestate': '',
        'cngecountry': '',

        // ── Other Details ─────────────────────────────────────────
        'loadtype': _state.info.loadTypeCode ?? '',
        'productcode': _state.info.productTypeCode ?? '',
        'dlvtype': _state.info.deliveryTypeCode ?? '',
        'freighton': '',
        'valgoods': 0,
        'remarks': _state.info.remarks ?? '',
        'freight': 0.00,
        'orderid': 0,

        // ── Settings ──────────────────────────────────────────────
        'recstatus': _state.info.recstatus ?? 'N',
        'totalpckgs': _state.info.pcs.toString() ?? '0',
        'totalvweight': 0.00,
        'totalaweight': 0.00,
        'totalcweight': 0.00,
        'indentrefrenceno': _state.info.indentId ?? 0,
      };
    }

    Map<String, String> params = {
      // "companyId": savedUser.companyid.toString(),
      "prmjsondatastr": jsonEncode(buildSaveJson()),
      "prminvjsondatastr":
          jsonEncode(_state.splitInfo.map((e) => e.toJson()).toList()),
      "prmloginbranchcode": savedUser.loginbranchcode.toString(),
      "prmlogindivisionid": savedUser.logindivisionid.toString(),
      "prmusercode": savedUser.usercode.toString(),
      "prmmenucode": 'GTLMD_OTEXPICKUP',
      "prmsessionid": savedUser.sessionid.toString(),
    };

    try {
      final response = await _repo.savePickup(params);
      if (response.commandStatus == 1) {
        final updated = List<OtexPickupSplitInfo>.from(_state.splitInfo);

        String? newWayBillNo = response.grno;
        if (newWayBillNo == null || newWayBillNo.isEmpty) {
          newWayBillNo = updated[index].wayBillNo;
        }

        updated[index] = updated[index].copyWith(
          wayBillNo: newWayBillNo,
          isSaved: true,
        );
        final permanentCount = updated.where((c) => c.isSaved).length;
        final wasFirstSave = _state.permanentCardCount == 0;

        _state = _state.copyWith(
          splitInfo: updated,
          permanentCardCount: permanentCount,
          hasTransactionId: wasFirstSave ? true : _state.hasTransactionId,
        );
        notifyListeners();
        return true;
      } else {
        _state = _state.copyWith(errorMessage: response.commandMessage);
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = _state.copyWith(errorMessage: _extractMessage(e));
      notifyListeners();
      return false;
    }
  }

  // Add a dynamic card entry
  void addCardEntry() {
    final updatedList = List<OtexPickupSplitInfo>.from(_state.splitInfo)
      ..add(OtexPickupSplitInfo());
    _state = _state.copyWith(splitInfo: updatedList);
    notifyListeners();
  }

  void removeCardEntry(int index) {
    if (_state.splitInfo.length <= 1) return;

    final updatedList = List<OtexPickupSplitInfo>.from(_state.splitInfo)
      ..removeAt(index);

    int newTotal = 0;
    for (var card in updatedList) {
      newTotal += card.palletQty ?? 0;
    }

    _state = _state.copyWith(splitInfo: updatedList, totalPalletQty: newTotal);
    notifyListeners();
  }

  void updateCardData(int index, OtexPickupSplitInfo cardData) {
    if (index >= _state.splitInfo.length) return;
    final updatedList = List<OtexPickupSplitInfo>.from(_state.splitInfo);
    updatedList[index] = cardData;

    int newTotal = 0;
    for (var card in updatedList) {
      newTotal += card.palletQty ?? 0;
    }

    _state = _state.copyWith(splitInfo: updatedList, totalPalletQty: newTotal);
    notifyListeners();
  }

  // API Call: Save/Submit specific destination entry card
  // Future<bool> saveCardEntry(int index) async {
  //   if (index >= _state.splitInfo.length) return false;
  //   final card = _state.splitInfo[index];

  //   // TODO: Perform local API call for card level upsert (e.g. Card validation & post request)
  //   // final success = await repository.saveCard(card, _state.info);

  //   return true;
  // }

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
