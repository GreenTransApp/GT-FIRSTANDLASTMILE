import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/GrListModel.dart';

import 'package:gtlmd/optionMenu/stickerPrinting/model/StickerModel.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/stickerPrintingRepository.dart';


class StickerPrintingProvider extends ChangeNotifier {
  StickerPrintingRepository _repo = StickerPrintingRepository();
  ApiCallingStatus _status = ApiCallingStatus.initial;
  ApiCallingStatus get status => _status;
  String? _lastScannedSticker;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<GrListModel>? _grListResp;
  List<GrListModel>? get grListResp => _grListResp;

  List<StickerListModel>? _stickerListResp;
  List<StickerListModel>? get stickerListResp => _stickerListResp;
  bool _selectAllStickers = false;
  bool get selectAllStickers => _selectAllStickers;

  void _clearResults() {
    _grListResp = [];
    _stickerListResp = [];
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

  Future<void> getGrList(Map<String, String> params) async {
    _setStatus(ApiCallingStatus.loading);
    try {
      _grListResp = await _repo.GetGrList(params);
      _setStatus(ApiCallingStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> getStickerList(Map<String, String> params) async {
    _setStatus(ApiCallingStatus.loading);
    try {
      _stickerListResp = await _repo.GetStickerList(params);
      _setStatus(ApiCallingStatus.success);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  String _grSearch = '';
  String _stickerSearch = '';

  List<GrListModel> get grSearch {
    if (_grListResp == null) return [];
    if (_grSearch.isEmpty) return _grListResp!;
    return _grListResp!
        .where((b) =>
            b.grno!.toLowerCase().contains(_grSearch.toLowerCase()) ||
            b.destname!.toLowerCase().contains(_grSearch.toLowerCase()))
        .toList();
  }

  void updateGrSearch(String value) {
    _grSearch = value;
    notifyListeners();
  }

  List<StickerListModel> get stickerSearch {
    if (_stickerListResp == null) return [];
    if (_stickerSearch.isEmpty) return _stickerListResp!;
    return _stickerListResp!
        .where((b) =>
            b.stickerno!.toLowerCase().contains(_grSearch.toLowerCase()) ||
            b.destinationname!.toLowerCase().contains(_grSearch.toLowerCase()))
        .toList();
  }

  void updateStickerSearch(String value) {
    _stickerSearch = value;
    notifyListeners();
  }

  void onStickerCheckChange(bool value, int index) {
    if (_stickerListResp == null || _stickerListResp!.isEmpty) return;

    _stickerListResp![index].selectedsticker = value;

    _selectAllStickers =
        _stickerListResp!.every((item) => item.selectedsticker == true);

    notifyListeners();
  }

  List<StickerListModel> get selectedStickerList {
    if (_stickerListResp == null) return [];
    return _stickerListResp!
        .where((sticker) => sticker.selectedsticker == true)
        .toList();
  }
}
