import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/consignmentEnquiry/consignmentEnquiryRespository.dart';
import 'package:gtlmd/pages/consignmentEnquiry/model/consignmentEnquiryModel.dart';
import 'package:gtlmd/pages/consignmentEnquiry/model/consignmentImageModel.dart';

class ConsignmentEnquiryViewModel  extends BaseViewModel {
 ConsignmentEnquiryRepository _repo = ConsignmentEnquiryRepository();
  StreamController<ConsignmentEnquiryModel> consignLiveData =
      StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<ConsignmentImageModel>> consignImgLiveData =
      StreamController();

  ConsignmentEnquiryViewModel() {
    consignLiveData = _repo.consignData;
    consignImgLiveData = _repo.consignImgData;
     isErrorLiveData = _repo.isErrorLiveData;
       viewDialog = _repo.viewDialog;
  }

  

  void consignmentEnquiry(Map<String, dynamic> params) {
    _repo.consignmentEnquiry(params);
  }

  
}
 
