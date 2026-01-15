import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/base/BaseRepository.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/common/debug.dart';
import 'package:gtlmd/pages/bookingWithEWayBill/models/EwayBillCredentialsModel.dart';
import 'package:gtlmd/service/connectionCheckService.dart';
import 'package:http/http.dart' as http;

class BookingWithEwayBillRepository extends BaseRepository {
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<bool> viewDialog = StreamController();
  StreamController<List<EwayBillCredentialsModel>> validateEwayBillList =
      StreamController();
  StreamController<Map<String, dynamic>> refreshEwbLiveData =
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
            'orgid': resp['orgs'][0]['orgid'],
            'token': resp['token']
          };
          completeEwayBillLogin(completeLoginParams, ewaybillno, compGst,
              resp['orgs'][0]['orgid']);
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
          Map<String, String> getRefreshParams = {
            'orgid': orgid,
            'token': resp['token']
          };
          getRefreshEwb(getRefreshParams, ewaybillno, ewaybilltoken);
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

  Future<void> getRefreshEwb(Map<String, String> params, String ewaybillno,
      String ewaybilltoken) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        final response = await http.post(
          Uri.parse(URL.getRefreshEwb),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(params),
        );
        viewDialog.add(false);
        final Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 1) {
          Map<String, dynamic> response = body['response'];
          response['ewaybillno'] = ewaybillno;
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
}
