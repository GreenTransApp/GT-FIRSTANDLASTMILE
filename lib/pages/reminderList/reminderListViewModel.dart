import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/reminderList/models/reminderLIstModel.dart';
import 'package:gtlmd/pages/reminderList/reminderListRepository.dart';

class ReminderListViewModel extends BaseViewModel {
  final ReminderListRepository _repo = ReminderListRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<List<ReminderListModel>> reminderListLiveData =
      StreamController();

  ReminderListViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    reminderListLiveData = _repo.reminderListLiveData;
  }

  getReminderList(Map<String, String> params) {
    _repo.getReminderList(params);
  }
}
