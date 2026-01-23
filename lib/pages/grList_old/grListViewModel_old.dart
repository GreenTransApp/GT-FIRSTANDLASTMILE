import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/grList_old/grListRepository_old.dart';
import 'package:gtlmd/pages/grList_old/model/grListModel_old.dart';

class GrListViewModel_old extends BaseViewModel {
  final _repo = GrListRepository_old();
  StreamController<List<GrListModel_old>> grListLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  GrListViewModel_old() {
    grListLiveData = _repo.grListLiveData;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
  }

  getGrList(Map<String, String> params) {
    _repo.getGrList(params);
  }
}
