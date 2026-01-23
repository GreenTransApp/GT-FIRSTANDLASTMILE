import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/operations/models/operationsModel.dart';
import 'package:gtlmd/common/operations/operationsRepo.dart';

class OperationsProvider extends ChangeNotifier {
  final OperationsRepository _repo = OperationsRepository();

  ApiCallingStatus _status = ApiCallingStatus.initial;
  ApiCallingStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<OperationsModel> _operationsList = [
    OperationsModel(
        menuname: 'Update Mid Mile Dispatch', menucode: 'GTI_MidMile'),
    OperationsModel(
        menuname: 'Update Mid Mile Arrival',
        menucode: 'GTI_UpdateMidMileArrival'),
  ];
  List<OperationsModel> get operationsList => _operationsList;

  OperationsModel? _singleOperation;
  OperationsModel? get singleOperation => _singleOperation;

  void _setStatus(ApiCallingStatus status) {
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

  Future<void> getOperationsList() async {
    _setStatus(ApiCallingStatus.success);
    // API call disabled as per request
  }

  Future<String?> getSingleOperationDetail(String menuCode) async {
    _setStatus(ApiCallingStatus.loading);
    try {
      Map<String, String> params = {
        "prmconnstring": savedUser.companyid.toString(),
        "prmlinkpagemenucode": menuCode,
        'prmdrivercode': savedUser.drivercode.toString(),
        "prmusercode": savedUser.usercode.toString(),
        'prmmenucode': 'GTAPP_PAGELINKS',
        "prmsessionid": savedUser.sessionid.toString(),
      };
      _singleOperation = await _repo.getSingleOperation(params);

      String? fetchedUrl;
      if (_singleOperation != null && _singleOperation!.pageLink != null) {
        fetchedUrl = _singleOperation!.pageLink;
        // Update the item in the list
        int index = _operationsList
            .indexWhere((element) => element.menucode == menuCode);
        if (index != -1) {
          _operationsList[index] =
              _operationsList[index].copyWith(pageLink: fetchedUrl);
        }
      }

      _setStatus(ApiCallingStatus.success);
      return fetchedUrl;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return null;
    }
  }
}
