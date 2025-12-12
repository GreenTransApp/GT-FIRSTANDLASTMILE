import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/commonResponse.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigDetailModel.dart';
import 'package:gtlmd/pages/orders/drsSelection/model/DrsListModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/currentDeliveryModel.dart';

import 'package:gtlmd/service/connectionCheckService.dart';

class BaseRepository {
  StreamController<bool> viewDialog = StreamController();
  StreamController<String> isErrorLiveData = StreamController();
  StreamController<String> accResp = StreamController();
  StreamController<String> compAccPara = StreamController();
  StreamController<MapConfigDetailModel> mapConfigDetail = StreamController();
  StreamController<String> scannedCode = StreamController();
  StreamController<List<DrsListModel>> deliveryLiveData =
      StreamController();
  // StreamController<List<CurrentDeliveryModel>> deliveryLiveData =
  //     StreamController();

  // StreamController<UpdateDeliveryModel> savePodCommonLiveData =
  //     StreamController();
  // StreamController<UpdateDeliveryModel> saveUnDeliveryList = StreamController();

  static const platform = MethodChannel('scan_channel');

  Future<String> scanBarcode() async {
    String barcode = "";
    try {
      platform.setMethodCallHandler((call) async {
        if (call.method == "onBarcodeScanned") {
          barcode = call.arguments as String;
          scannedCode.add(barcode);
          // print("Scanned barcode: $barcode");
        }
      });
    } catch (e) {
      // print("Error scanning barcode: $e");
      isErrorLiveData.add("Error scanning barcode: ${e.toString()}");
    }
    return barcode;
  }

  Future<void> getValueFromAccPara(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp = await apiGet("${bookingUrl}GetKey", params);
        final rawMessage = resp.message?.toString() ?? "";
        print("Raw response message: $rawMessage");

        if (resp.commandStatus == 1) {
          accResp.add(rawMessage);
        } else {
          isErrorLiveData.add(resp.commandMessage ?? "Unknown error");
        }
      } catch (err) {
        isErrorLiveData.add("Exception: ${err.toString()}");
      } finally {
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getValueFromCompAccPara(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        CommonResponse resp =
            await apiGet("${bookingUrl}GetValueFromCompAccPara", params);
        final rawMessage = resp.message?.toString() ?? "";
        print("Raw response message: $rawMessage");

        if (resp.commandStatus == 1) {
          compAccPara.add(rawMessage);
        } else {
          isErrorLiveData.add(resp.commandMessage ?? "Unknown error");
        }
      } catch (err) {
        isErrorLiveData.add("Exception: ${err.toString()}");
      } finally {
        viewDialog.add(false);
      }
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getMapConfig(Map<String, String> params) async {
    viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;

    if (hasInternet) {
      try {
        // viewDialog.add(true);
        CommonResponse resp = await apiGet("${lmdUrl}/getMapConfig", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list2 = entry.value;
              List<MapConfigDetailModel> resultList = List.generate(
                  list2.length,
                  (index) => MapConfigDetailModel.fromJson(list2[index]));

              // var data = resultList;
              mapConfigDetail.add(resultList[0]);
            }
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
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  Future<void> getDrsList(Map<String, String> params) async {
    // viewDialog.add(true);
    final hasInternet = await NetworkStatusService().hasConnection;
    if (hasInternet) {
      try {
        viewDialog.add(true);
        // CommonResponse resp = await apiGet("${lmdUrl}/GetDrsListV2", params);
        CommonResponse resp = await apiGet("${lmdUrl}/GetDrsList", params);
        if (resp.commandStatus == 1) {
          Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
          Iterable<MapEntry<String, dynamic>> entries = table.entries;
          for (final entry in entries) {
            if (entry.key == "Table") {
              List<dynamic> list2 = entry.value;
              List<DrsListModel> resultList = List.generate(list2.length,    (index) => DrsListModel.fromJson(list2[index]));
              deliveryLiveData.add(resultList);
            }
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
    } else {
      viewDialog.add(false);
      isErrorLiveData.add("No Internet available");
    }
  }

  // Future<void> savePodEntryOffline(Map<String, dynamic> params) async {
  //   viewDialog.add(true);
  //   CommonResponse resp = await apiPost("${lmdUrl}SavePodOffline", params);
  //   viewDialog.add(false);
  //   try {
  //     if (resp.commandStatus == 1) {
  //       Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
  //       Iterable<MapEntry<String, dynamic>> entries = table.entries;
  //       List<dynamic> list = table.values.first;
  //       List<UpdateDeliveryModel> resultList = List.generate(
  //           list.length, (index) => UpdateDeliveryModel.fromJson(list[index]));
  //       UpdateDeliveryModel response = resultList[0];

  //       if (response.commandstatus == 1) {
  //         savePodCommonLiveData.add(resultList[0]);
  //       } else {
  //         isErrorLiveData.add(response.commandmessage!);
  //       }
  //     } else {
  //       isErrorLiveData.add(resp.commandMessage.toString());
  //     }
  //   } catch (err) {
  //     isErrorLiveData.add(err.toString());
  //   }
  // }

  // Future<void> updateUndeliveryOffline(Map<String, dynamic> params) async {
  //   viewDialog.add(true);
  //   CommonResponse resp =
  //       await apiPost("${lmdUrl}UpdateUndeliveryOffline", params);
  //   viewDialog.add(false);
  //   if (resp.commandStatus == 1) {
  //     Map<String, dynamic> table = jsonDecode(resp.dataSet.toString());
  //     List<dynamic> list = table.values.first;
  //     List<UpdateDeliveryModel> resultList = List.generate(
  //         list.length, (index) => UpdateDeliveryModel.fromJson(list[index]));
  //     UpdateDeliveryModel validateResponse = resultList[0];
  //     // ValidateDeviceModel.fromJson(resultList[0]);
  //     if (validateResponse.commandstatus == 1) {
  //       saveUnDeliveryList.add(resultList[0]);
  //     } else {
  //       isErrorLiveData.add(validateResponse.commandmessage!);
  //     }
  //   } else {
  //     isErrorLiveData.add(resp.commandMessage.toString());
  //   }
  //   // saveUnDeliveryLiveData.add(resp);
  // }
}
