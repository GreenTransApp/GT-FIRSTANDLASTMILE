import 'package:flutter/widgets.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class Bluetooth {
  scan() async {
    debugPrint('Scanning');
    final flutterReactiveBle = FlutterReactiveBle();
    PermissionStatus status = await requestPermission();
    if (status.isGranted || status.isLimited) {
      PermissionStatus connectStatus = await requestConnectPermission();
      if (connectStatus.isGranted || connectStatus.isLimited) {
        flutterReactiveBle.scanForDevices(
            withServices: [],
            scanMode: ScanMode.balanced,
            requireLocationServicesEnabled: false).listen((device) {
          if (device.name.isNotEmpty) {
            debugPrint('Bluetooth LE Device: ${device.name}');
          }
        }, onError: (error) {
          debugPrint('Bluetooth LE Error: $error');
        }, onDone: () {
          debugPrint('Bluetooth LE Scan Done');
        });
      }
    }
  }

  Future<PermissionStatus> requestPermission() async {
    PermissionStatus status = await Permission.bluetoothScan.request();
    if (status.isDenied) {
      debugPrint('Bluetooth Scan Denied');
    } else if (status.isGranted) {
      debugPrint('Bluetooth Scan Granted');
    } else if (status.isPermanentlyDenied) {
      debugPrint('Bluetooth Scan Permanently Denied');
    } else if (status.isLimited) {
      debugPrint('Bluetooth Scan Limited');
    }

    return status;
  }

  Future<PermissionStatus> requestConnectPermission() async {
    PermissionStatus status = await Permission.bluetoothConnect.request();
    if (status.isDenied) {
      debugPrint('Bluetooth Connect Denied');
    } else if (status.isGranted) {
      debugPrint('Bluetooth Connect Granted');
    } else if (status.isPermanentlyDenied) {
      debugPrint('Bluetooth Connect Permanently Denied');
    } else if (status.isLimited) {
      debugPrint('Bluetooth Connect Limited');
    }

    return status;
  }
}
