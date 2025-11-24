import 'dart:async';

import 'package:gtlmd/base/baseViewModel.dart';
import 'package:gtlmd/pages/attendance/attendanceRepository.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/attendance/models/attendanceRadiusModel.dart';
import 'package:gtlmd/pages/attendance/models/punchInModel.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/attendance/models/viewAttendanceModel.dart';

class AttendanceViewModel extends BaseViewModel {
  final AttendanceRepository _repo = AttendanceRepository();

  StreamController<List<AttendanceModel>> attendanceListLiveData =
      StreamController<List<AttendanceModel>>();

  StreamController<AttendanceRadiusModel> attendanceRadiusLiveData =
      StreamController<AttendanceRadiusModel>();

  StreamController<PunchInModel> punchInListLiveData =
      StreamController<PunchInModel>();

  StreamController<PunchoutModel> punchoutListLiveData =
      StreamController<PunchoutModel>();
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<List<viewAttendanceModel>> viewAttendanceListLiveData =
      StreamController<List<viewAttendanceModel>>();

  AttendanceViewModel() {
    isErrorLiveData = _repo.isErrorLiveData;

    attendanceListLiveData = _repo.attendanceList;

    attendanceRadiusLiveData = _repo.attendanceRadiusDataList;

    punchInListLiveData = _repo.punchInLiveData;

    punchoutListLiveData = _repo.punchOutLiveData;
    viewDialog = _repo.viewDialog;
    viewAttendanceListLiveData = _repo.attendanceViewList;
  }

  callGetAttendanceDetails(Map<String, String> params) {
    _repo.callGetAttendanceDetailsApi(params);
  }

  savePunchInData(Map<String, dynamic> params) {
    _repo.savePunchInAttendance(params);
  }

  savePunchOutData(Map<String, dynamic> params) {
    _repo.savePunchOutAttendance(params);
  }

  callGetAttendanceRadiusData(Map<String, String> params) {
    _repo.getAttendanceRadiusData(params);
  }

  callViewAttendanceDetails(Map<String, String> params) {
    _repo.getViewAttendanceDetails(params);
  }
}
