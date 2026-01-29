import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/debug.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/EwayBillCredentialsModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/ewayBillRespModel.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/grDetailsResponse.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/grGoodsDimensionModel.dart';
import 'package:gtlmd/pages/pickup/model/savePickupRespModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';
import 'package:http/http.dart' as http;

class BookingWithEwayBillRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<EwayBillCredentialsModel>> validateEwayBillList =
      StreamController();
  StreamController<Map<String, dynamic>> refreshEwbLiveData =
      StreamController();
  StreamController<SavePickupRespModel> saveBookingLiveData =
      StreamController();
  StreamController<Map<String, dynamic>> cngrCngeCodeLiveData =
      StreamController();
  StreamController<GrDetailsResponse> grDetailLiveData = StreamController();
  StreamController<EwayBillModelResponse> ewayBillDetailLiveData =
      StreamController();
  StreamController<GrGoodsDimensionModel> goodsDimensionDetailLiveData =
      StreamController();

  Future<void> getEwayBillCreds(Map<String, dynamic> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiPostWithModel("${lmdUrl}GetEwayBillCreds", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          try {
            for (final entry in entries) {
              if (entry.key == "Table") {
                List<dynamic> list = entry.value;
                List<EwayBillCredentialsModel> resultList = List.generate(
                    list.length,
                    (index) => EwayBillCredentialsModel.fromJson(list[index]));
                if (resultList.isNotEmpty &&
                    resultList.first.commandstatus == -1) {
                  isErrorLiveData
                      .add(resultList.first.commandmessage.toString());
                  validateEwayBillList.add(resultList);
                }
              }
            }
          } catch (err) {
            isErrorLiveData.add(err.toString());
          }
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
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

  Future<void> ewaybilllogin(
      Map<String, String> params, String ewaybillno, String compGst) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        final response = await http.post(
          Uri.parse(URL.ewayBillLogin),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(params),
        );
        viewDialog.add(false);
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 1) {
          final resp = body['response'];
          Map<String, String> completeLoginParams = {
            'orgid': resp['orgs'][0]['orgId'].toString(),
            'token': resp['token']
          };
          completeEwayBillLogin(completeLoginParams, ewaybillno, compGst,
              resp['orgs'][0]['orgId'].toString());
        } else {
          isErrorLiveData.add(body['message']);
          return;
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

  Future<void> completeEwayBillLogin(Map<String, String> params,
      String ewaybillno, String compGst, String orgid) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        final response = await http.post(
          Uri.parse(URL.ewayBillCompleteLogin),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(params),
        );
        viewDialog.add(false);
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 1) {
          final resp = body['response'];
          final ewaybilltoken = resp['token'];
          Map<String, String> getDetailParams = {
            'gstin': compGst,
            'ewbNo': ewaybillno,
          };
          getEwayBillDetail(
              getDetailParams, ewaybillno, compGst, ewaybilltoken, orgid);
        } else {
          isErrorLiveData.add(body['message']);
          return;
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

  Future<void> getEwayBillDetail(Map<String, String> params, String ewaybillno,
      String compGst, String ewaybilltoken, String orgid) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        // final response = await http.get(
        //   Uri.parse(URL.getDetailbyEwayBillNo).replace(queryParameters: params),
        //   headers: <String, String>{
        //     'Content-Type': 'application/json; charset=UTF-8',
        //     'Authorization': 'Bearer $ewaybilltoken'
        //   },
        // );
        // viewDialog.add(false);
        // final Map<String, dynamic> body = jsonDecode(response.body);
        // if (body['status'] == 1) {
        //   final resp = body['response'];
        //   final ewaybilltoken = resp['token'];
        Map<String, String> getRefreshParams = {
          'gstin': compGst,
          'ewbNo': ewaybillno
        };
        getRefreshEwb(getRefreshParams, ewaybillno, ewaybilltoken);
        // } else {
        //   isErrorLiveData.add(body['message']);
        //   return;
        // }
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

  Future<void> getRefreshEwb(Map<String, String> params, String ewaybillno,
      String ewaybilltoken) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        final response = await http.get(
          Uri.parse(URL.getRefreshEwb).replace(queryParameters: params),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $ewaybilltoken'
          },
        );
        viewDialog.add(false);
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 1) {
          Map<String, dynamic> response = body['response'];
          // response['ewaybillno'] = ewaybillno;
          refreshEwbLiveData.add(response);
        } else {
          isErrorLiveData.add(body['message']);
          return;
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

  Future<void> saveBooking(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        // CommonResponse resp = await apiGet("${bookingUrl}GetCngrCngeListV2", params);
        CommonResponse resp = await apiPost("${lmdUrl}Booking_Upsert", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          List<dynamic> list = table.values.first;
          // SavePickupRespModel savePickupResponse =
          //     SavePickupRespModel.fromJson(list[0]);

          List<SavePickupRespModel> resultList = List.generate(list.length,
              (index) => SavePickupRespModel.fromJson(list[index]));
          saveBookingLiveData.add(resultList[0]);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
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

  Future<List<dynamic>> getGrDetail(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);
        // CommonResponse resp = await apiGet("${bookingUrl}GetCngrCngeListV2", params);
        CommonResponse resp =
            await apiGet("${lmdUrl}GetBookingDetailsForUpdate", params);

        if (resp.commandStatus == 1) {
          final returnList =
              await compute(_parseGrDetails, resp.dataSet.toString());
          return returnList;
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
        return [];
      } on SocketException catch (_) {
        isErrorLiveData.add("No Internet");
        viewDialog.add(false);
        return [];
      } catch (err) {
        isErrorLiveData.add(err.toString());
        viewDialog.add(false);
        return [];
      }
      // viewDialog.add(false);
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
      return [];
    }
  }

  Future<void> getCngrCngeCode(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        // viewDialog.add(true);

        CommonResponse resp =
            await apiGet("${bookingUrl}getDetailsOnEWBGSTNo", params);

        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          cngrCngeCodeLiveData.add(table);
        } else {
          isErrorLiveData.add(resp.commandMessage!);
        }
        viewDialog.add(false);
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
}

List<dynamic> _parseGrDetails(String dataSet) {
  Map<String, dynamic> table = jsonDecode(dataSet);
  List<dynamic> returnList = [];
  Iterable<MapEntry<String, dynamic>> list = table.entries;
  for (final entry in list) {
    if (entry.key == 'Table') {
      List<dynamic> l = entry.value;
      if (l.isNotEmpty) {
        returnList.add(GrDetailsResponse.fromJson(l[0]));
      }
    } else if (entry.key == 'Table1') {
      List<dynamic> l = entry.value;
      returnList.addAll(
          l.map((item) => EwayBillModelResponse.fromJson(item)).toList());
    } else if (entry.key == 'Table2') {
      List<dynamic> l = entry.value;
      returnList.addAll(
          l.map((item) => GrGoodsDimensionModel.fromJson(item)).toList());
    }
  }
  return returnList;
}
