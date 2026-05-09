import 'dart:async';

import 'package:gtlmd/pages/createAlert/createAlertRepository.dart';
import 'package:gtlmd/pages/login/models/UpdatePasswordModel.dart';

import '../../base/baseViewModel.dart';
import 'models/notificationDetailModel.dart';

class CreateAlertViewModel extends BaseViewModel {
  CreateAlertRepository _repo = CreateAlertRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<List<NotificationDetailModel>> notiDetailListLiveData =
      StreamController();
  StreamController<CommonUpdateModel> addCommentLiveData = StreamController();
  CreateAlertViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    notiDetailListLiveData = _repo.notiDetailListLiveData;
    addCommentLiveData = _repo.addCommentLiveData;
  }

  getNotificationDetail(Map<String, String> params) {
    _repo.getNotificationDetail(params);
  }

  addUserComment(Map<String, String> params) {
    _repo.addComment(params);
  }
}
