import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/login/models/UpdatePasswordModel.dart';
import 'package:gtlmd/pages/reminderList/models/reminderLIstModel.dart';
import 'package:gtlmd/pages/reminderList/reminderListRepository.dart';

class ReminderListViewModel extends BaseViewModel {
  final ReminderListRepository _repo = ReminderListRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<List<ReminderListModel>> reminderListLiveData =
      StreamController();

  StreamController<CommonUpdateModel> archieveLiveData = StreamController();

  ReminderListViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    reminderListLiveData = _repo.reminderListLiveData;
    archieveLiveData = _repo.archieveLiveData;
  }

  getReminderList(Map<String, String> params) {
    _repo.getReminderList(params);
  }

  archieveReminder(Map<String, String> params) {
    _repo.archieveReminder(params);
  }
}
