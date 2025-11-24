import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/attendance/models/attendanceRadiusModel.dart';
import 'package:gtlmd/pages/attendance/models/punchInModel.dart';
import 'package:gtlmd/pages/attendance/models/punchOutMode.dart';
import 'package:gtlmd/pages/attendance/models/viewAttendanceModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';

class AttendanceRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<AttendanceModel>> attendanceList = StreamController();
  StreamController<AttendanceRadiusModel> attendanceRadiusDataList =
      StreamController();
  StreamController<PunchInModel> punchInLiveData = StreamController();
  StreamController<PunchoutModel> punchOutLiveData = StreamController();

  StreamController<List<viewAttendanceModel>> attendanceViewList =
      StreamController();

  Future<void> callGetAttendanceDetailsApi(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    // List<AttendanceModel> finalList = List.empty(growable: true);
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${hrBaseUrl}AttendenceDetailsWithUserImage", params);

        if (resp.commandStatus == 1) {
          // String dataSet = resp.dataSet.toString();
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<AttendanceModel> resultList = List.generate(
              list.length, (index) => AttendanceModel.fromJson(list[index]));
          debugPrint(resultList[0].toString());
          attendanceList.add(resultList);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> savePunchInAttendance(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiPost("${hrBaseUrl}/PunchInWithUserImage", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          // debugPrint(table.entries.first.value);
          List<dynamic> list = table.values.first;
          List<PunchInModel> resultList = List.generate(
              list.length, (index) => PunchInModel.fromJson(list[index]));
          PunchInModel punchinResponse = resultList[0];
          punchInLiveData.add(punchinResponse);
        } else {
          isErrorLiveData.add(resp.commandMessage.toString());
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> savePunchOutAttendance(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp = await apiPost("${hrBaseUrl}PunchoutV3", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<PunchoutModel> resultList = List.generate(
              list.length, (index) => PunchoutModel.fromJson(list[index]));
          PunchoutModel punchoutResponse = resultList[0];
          punchOutLiveData.add(punchoutResponse);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getAttendanceRadiusData(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${dashboardBaseUrl}GetAttendanceRadiusData", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          List<AttendanceRadiusModel> resultList = List.generate(list.length,
              (index) => AttendanceRadiusModel.fromJson(list[index]));

          attendanceRadiusDataList.add(resultList[0]);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getViewAttendanceDetails(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      // List<AttendanceModel> finalList = List.empty(growable: true);
      try {
        CommonResponse resp =
            await apiGet("${hrBaseUrl}getEmployeeAttendance", params);

        if (resp.commandStatus == 1) {
          // String dataSet = resp.dataSet.toString();
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;

          List<viewAttendanceModel> resultList = List.generate(list.length,
              (index) => viewAttendanceModel.fromJson(list[index]));

          if (resultList[0].commandstatus == -1) {
            isErrorLiveData.add(resultList[0].commandmessage.toString());
          }
          debugPrint(resultList[0].toString());
          attendanceViewList.add(resultList);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
      } catch (err) {
        debugPrint("View Attendance: $err");
        viewDialog.add(false);
      }
      viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }
}
