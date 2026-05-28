import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/documentApproval/documentApprovalRepository.dart';
import 'package:gtlmd/pages/documentApproval/model/documentApprovalModel.dart';

class DocumentApprovalViewModel extends BaseViewModel {
  final DocumentApprovalRepository _repo = DocumentApprovalRepository();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<List<DocumentApprovalModel>> docApprovalLiveData =
      StreamController();

  DocumentApprovalViewModel() {
    viewDialog = _repo.viewDialog;
    isErrorLiveData = _repo.isErrorLiveData;
    docApprovalLiveData = _repo.docApprovalLiveData;
  }

  getDocApprovalList(Map<String, String> params) {
    _repo.getDocApprovalList(params);
  }
}
