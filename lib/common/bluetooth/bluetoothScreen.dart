import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/optionMenu/stickerPrinting/model/StickerModel.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'dart:io';
import 'package:flutter/services.dart';

final bluetoothChannel = MethodChannel('bluetooth_channel');

class BluetoothScreen extends StatefulWidget {
  List<StickerListModel> stickerList = [];
  BluetoothScreen({super.key, required this.stickerList});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  late final FlutterReactiveBle flutterReactiveBle;

  BleStatus _currentStatus = BleStatus.unknown;
  StreamSubscription<BleStatus>? _statusSubscription;
  bool _isScanningWaitingForReady = false;

  StreamSubscription? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  List<DiscoveredDevice> devices = [];
  bool _isScanning = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    debugPrint('Sticker List: ${widget.stickerList.length}');
    flutterReactiveBle = FlutterReactiveBle();
    _subscribeToBluetoothStatus();
    scan();
  }

  void _subscribeToBluetoothStatus() {
    _statusSubscription = flutterReactiveBle.statusStream.listen((status) {
      debugPrint('Bluetooth Status: $status');
      setState(() {
        _currentStatus = status;
      });
      if (status == BleStatus.ready && _isScanningWaitingForReady) {
        _isScanningWaitingForReady = false;
        scan();
      }
    });
  }

  scan() async {
    debugPrint('Scanning');

    if (_currentStatus != BleStatus.ready) {
      bool enabled = await _ensureBluetoothEnabled();
      if (!enabled) {
        debugPrint('Bluetooth not enabled, cannot scan');
        return;
      }
      // If we just enabled it, status might take a moment to update to ready
      if (_currentStatus != BleStatus.ready) {
        _isScanningWaitingForReady = true;
        return;
      }
    }

    PermissionStatus status = await requestPermission();
    if (status.isGranted || status.isLimited) {
      PermissionStatus connectStatus = await requestConnectPermission();
      if (connectStatus.isGranted || connectStatus.isLimited) {
        setState(() {
          _isScanning = true;
          devices = [];
        });
        _scanSubscription = flutterReactiveBle.scanForDevices(
            withServices: [],
            scanMode: ScanMode.balanced,
            requireLocationServicesEnabled: false).listen((device) {
          if (!devices.any((d) => d.id == device.id) &&
              device.name.isNotEmpty) {
            debugPrint('Bluetooth LE Device: ${device.name}');
            devices.add(device);
            setState(() {});
          }
        }, onError: (error) {
          setState(() {
            _isScanning = false;
          });
          debugPrint('Bluetooth LE Error: $error');
        }, onDone: () {
          setState(() {
            _isScanning = false;
          });
          debugPrint('Bluetooth LE Scan Done');
        });

        Future.delayed(const Duration(seconds: 20), () {
          stopScan();
          debugPrint('Bluetooth scan stopped after 20 seconds');
        });
      }
    }
  }

  Future<bool> _ensureBluetoothEnabled() async {
    if (_currentStatus == BleStatus.poweredOff) {
      if (Platform.isAndroid) {
        try {
          final bool? result =
              await bluetoothChannel.invokeMethod('enableBluetooth');
          return result ?? false;
        } catch (e) {
          debugPrint('Error enabling bluetooth: $e');
          Get.snackbar(
            'Bluetooth Error',
            'Please turn on Bluetooth manually',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      } else {
        Get.snackbar(
          'Bluetooth Off',
          'Please turn on Bluetooth from settings',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return false;
      }
    } else if (_currentStatus == BleStatus.unauthorized) {
      Get.snackbar(
        'Permission Required',
        'Bluetooth permission is required for scanning',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } else if (_currentStatus == BleStatus.locationServicesDisabled) {
      Get.snackbar(
        'Location Off',
        'Please turn on Location services for Bluetooth scanning',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return _currentStatus == BleStatus.ready;
  }

  stopScan() {
    _scanSubscription?.cancel();
    setState(() {
      _isScanning = false;
    });
    debugPrint('Bluetooth scan stopped');
  }

  Future<PermissionStatus> requestPermission() async {
    if (Platform.isIOS) {
      PermissionStatus status = await Permission.bluetooth.request();
      if (status.isGranted) {
        debugPrint("Bluetooth Permission Granted (iOS)");
      } else {
        debugPrint("Bluetooth Permission Status (iOS)");
      }
      return status;
    }
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
    if (Platform.isIOS) {
      return PermissionStatus.granted;
    }
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

  void connectToDevice(DiscoveredDevice device) {
    setState(() {
      _isConnecting = true;
    });
    _connectionSubscription?.cancel();
    _connectionSubscription =
        flutterReactiveBle.connectToDevice(id: device.id).listen((connection) {
      debugPrint(
          'Connection state for ${device.name}: ${connection.connectionState}');
      if (connection.connectionState == DeviceConnectionState.connected) {
        setState(() {
          connectedDevice = device;
          _isConnecting = false;
        });
        stopScan(); // stop scanning after connection
        Get.snackbar(
          'Connected',
          'Successfully connected to ${device.name}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else if (connection.connectionState ==
          DeviceConnectionState.disconnected) {
        setState(() {
          if (connectedDevice?.id == device.id) {
            connectedDevice = null;
          }
          _isConnecting = false;
        });
      }
    }, onError: (error) {
      setState(() {
        _isConnecting = false;
      });
      debugPrint('Connection error: $error');
      Get.snackbar(
        'Connection Error',
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    });
  }

  Future<List<int>> _generatePrintData(StickerListModel m) async {
    List<int> bytes = [];

    // Mock Data
    var compName = savedUser.compname.toString();
    // const m = {
    //   "stickerno": "123456789012",
    //   "grno": "GR123",
    //   "grdt": "22/12/2025",
    //   "originname": "NEW YORK",
    //   "destinationname": "LONDON",
    //   "packageid": "PKG001",
    //   "pckgs": "10",
    //   "weight": "500kg"
    // };

    String cmd = "";
    cmd += "SIZE 76 mm,75 mm\r\n";
    cmd += "GAP 4 mm,0 mm\r\n";
    cmd += "SPEED 5\r\n";
    cmd += "DENSITY 10\r\n";
    cmd += "DIRECTION 1\r\n";
    cmd += "CLS\r\n";

    // BOX: top spacing + 3mm, right spacing +1.5mm
    // cmd.push("BOX 4,119,540,526,3\r\n");
    cmd += "BOX 4,119,540,526,3\r\n";

    const X_LEFT = 38;
    const X_RIGHT = 317;
    const SHIFT = 23;

    // Company Name
    cmd += 'BLOCK $X_LEFT,${131 + SHIFT},500,90,"2",0,1,1.2,"$compName"\r\n';

    // Barcode
    cmd +=
        'BARCODE $X_LEFT,${184 + SHIFT},"128",90,1,0,3,6,"${m.stickerno}"\r\n';

    // Details
    cmd += 'TEXT $X_LEFT,${310 + SHIFT},"2",0,1,1,"GR | ${m.grno}"\r\n';
    cmd += 'TEXT $X_LEFT,${350 + SHIFT},"2",0,1,1,"GR-DT | ${m.grdt}"\r\n';
    cmd +=
        'TEXT $X_LEFT,${390 + SHIFT},"2",0,1,1,"ORIGIN | ${m.originname}"\r\n';
    cmd +=
        'TEXT $X_LEFT,${430 + SHIFT},"2",0,1,1,"DESTINATION | ${m.destinationname}"\r\n';
    cmd +=
        'TEXT $X_LEFT,${470 + SHIFT},"2",0,1,1,"PCKGS | ${m.packageid}/${(m.pckgs!.toInt()).toString()}"\r\n';
    cmd += 'TEXT $X_RIGHT,${470 + SHIFT},"2",0,1,1,"WEIGHT | ${m.weight}"\r\n';

    cmd += "PRINT 1\r\n";

    try {
      bytes = utf8.encode(cmd);
    } catch (e) {
      debugPrint("Error encoding TSPL data: $e");
    }

    return bytes;
  }

  Future<void> _printReceipt(StickerListModel model) async {
    if (connectedDevice == null) {
      debugPrint('No device connected');
      return;
    }

    try {
      final data = await _generatePrintData(model);
      final services =
          await flutterReactiveBle.discoverServices(connectedDevice!.id);

      // Find a writable characteristic
      QualifiedCharacteristic? writableCharacteristic;
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.isWritableWithResponse ||
              characteristic.isWritableWithoutResponse) {
            writableCharacteristic = QualifiedCharacteristic(
              serviceId: service.serviceId,
              characteristicId: characteristic.characteristicId,
              deviceId: connectedDevice!.id,
            );
            break;
          }
        }
        if (writableCharacteristic != null) break;
      }

      if (writableCharacteristic != null) {
        // Write data in chunks
        const chunkSize = 20; // Standard BLE MTU size, can be optimized
        for (var i = 0; i < data.length; i += chunkSize) {
          var end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
          final chunk = data.sublist(i, end);
          await flutterReactiveBle.writeCharacteristicWithResponse(
            writableCharacteristic,
            value: chunk,
          );
        }
        debugPrint('Print job sent');
      } else {
        debugPrint('No writable characteristic found');
      }
    } catch (e) {
      debugPrint('Error printing: $e');
    }
  }

  void disconnect() async {
    await _connectionSubscription?.cancel();
    setState(() {
      connectedDevice = null;
    });
    debugPrint('Disconnected');
  }

  Widget _buildStatusHeader() {
    String statusText = "Disconnected";
    Color statusColor = Colors.grey;
    IconData statusIcon = Icons.bluetooth_disabled;

    if (_currentStatus == BleStatus.poweredOff) {
      statusText = "Bluetooth is Powered Off";
      statusColor = Colors.red;
      statusIcon = Icons.bluetooth_disabled;
    } else if (_currentStatus == BleStatus.unauthorized) {
      statusText = "Bluetooth Permission Denied";
      statusColor = Colors.red;
      statusIcon = Icons.security;
    } else if (_currentStatus == BleStatus.locationServicesDisabled) {
      statusText = "Location Services Disabled";
      statusColor = Colors.orange;
      statusIcon = Icons.location_off;
    } else if (_isScanning) {
      statusText = "Searching for Devices...";
      statusColor = Colors.blue;
      statusIcon = Icons.search;
    } else if (_isConnecting) {
      statusText = "Connecting...";
      statusColor = Colors.orange;
      statusIcon = Icons.bluetooth_searching;
    } else if (connectedDevice != null) {
      statusText = "Connected to ${connectedDevice!.name}";
      statusColor = Colors.green;
      statusIcon = Icons.bluetooth_connected;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        border: Border(bottom: BorderSide(color: statusColor.withOpacity(0.3))),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: statusColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              statusText,
              style: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          if (_isScanning || _isConnecting)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Sort devices: connected device first
    final sortedDevices = List<DiscoveredDevice>.from(devices);
    if (connectedDevice != null) {
      sortedDevices.removeWhere((d) => d.id == connectedDevice!.id);
      sortedDevices.insert(0, connectedDevice!);
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        title: const Text('Bluetooth Devices'),
        actions: [
          // if (connectedDevice != null)
          //   IconButton(
          //     icon: const Icon(Icons.print),
          //     onPressed: _printReceipt,
          //     tooltip: 'Print Test Receipt',
          //   ),
        ],
      ),
      body: Column(
        children: [
          _buildStatusHeader(),
          Expanded(
            child: sortedDevices.isEmpty && !_isScanning
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bluetooth,
                            size: 64, color: Colors.grey.shade300),
                        const SizedBox(height: 16),
                        const Text(
                          'No devices found',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: scan,
                          child: const Text('Start Scanning'),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: sortedDevices.length,
                    itemBuilder: (context, index) {
                      final device = sortedDevices[index];
                      final isConnected = connectedDevice?.id == device.id;

                      return Card(
                        elevation: isConnected ? 4 : 1,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isConnected
                              ? const BorderSide(color: Colors.green, width: 2)
                              : BorderSide.none,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isConnected
                                ? Colors.green
                                : Colors.blue.shade100,
                            child: Icon(
                              isConnected ? Icons.print : Icons.bluetooth,
                              color: isConnected ? Colors.white : Colors.blue,
                            ),
                          ),
                          title: Text(
                            device.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(device.id),
                          trailing: isConnected
                              ? ElevatedButton(
                                  onPressed: disconnect,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red.shade50,
                                    foregroundColor: Colors.red,
                                    elevation: 0,
                                  ),
                                  child: const Text('Disconnect'),
                                )
                              : _isConnecting
                                  ? null
                                  : Icon(Icons.chevron_right,
                                      color: Colors.grey.shade400),
                          onTap: (isConnected || _isConnecting)
                              ? null
                              : () => connectToDevice(device),
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: Icon(_isScanning ? Icons.stop : Icons.search),
                      label:
                          Text(_isScanning ? 'Stop Scanning' : 'Scan Devices'),
                      onPressed: _isScanning ? stopScan : scan,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  if (connectedDevice != null) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text('Print Receipt'),
                        onPressed: () async {
                          for (var sticker in widget.stickerList) {
                            await _printReceipt(sticker);
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _statusSubscription?.cancel();
    _scanSubscription?.cancel();
    // disconnect();
    super.dispose();
  }
}
