import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/grList/grListRepository.dart';
import 'package:gtlmd/pages/grList/model/grListModel.dart';

class GrListViewModel extends BaseViewModel {
  final _repo = GrListRepository();
  StreamController<List<GrListModel>> grListLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();

  GrListViewModel() {
    grListLiveData = _repo.grListLiveData;
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
  }

  getGrList(Map<String, String> params) {
    _repo.getGrList(params);
  }
}
