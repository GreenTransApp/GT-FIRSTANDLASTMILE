import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  late final FlutterReactiveBle flutterReactiveBle;

  @override
  void initState() {
    super.initState();
    flutterReactiveBle = FlutterReactiveBle();
    scan();
  }

  StreamSubscription? _scanSubscription;
  StreamSubscription<ConnectionStateUpdate>? _connectionSubscription;
  List<DiscoveredDevice> devices = [];
  DiscoveredDevice? _connectedDevice;

  scan() async {
    debugPrint('Scanning');

    PermissionStatus status = await requestPermission();
    if (status.isGranted || status.isLimited) {
      PermissionStatus connectStatus = await requestConnectPermission();
      if (connectStatus.isGranted || connectStatus.isLimited) {
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
          debugPrint('Bluetooth LE Error: $error');
        }, onDone: () {
          debugPrint('Bluetooth LE Scan Done');
        });

        Future.delayed(const Duration(seconds: 20), () {
          _scanSubscription?.cancel();
          debugPrint('Bluetooth scan stopped after 20 seconds');
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

  void connectToDevice(DiscoveredDevice device) {
    _connectionSubscription?.cancel();
    _connectionSubscription =
        flutterReactiveBle.connectToDevice(id: device.id).listen((connection) {
      debugPrint(
          'Connection state for ${device.name}: ${connection.connectionState}');
      if (connection.connectionState == DeviceConnectionState.connected) {
        setState(() {
          _connectedDevice = device;
        });
      } else if (connection.connectionState ==
          DeviceConnectionState.disconnected) {
        setState(() {
          if (_connectedDevice?.id == device.id) {
            _connectedDevice = null;
          }
        });
      }
    }, onError: (error) {
      debugPrint('Connection error: $error');
    });
  }

  Future<List<int>> _generatePrintData() async {
    List<int> bytes = [];

    // Mock Data
    const compName = "TEST COMPANY";
    const m = {
      "stickerno": "123456789012",
      "grno": "GR123",
      "grdt": "22/12/2025",
      "originname": "NEW YORK",
      "destinationname": "LONDON",
      "packageid": "PKG001",
      "pckgs": "10",
      "weight": "500kg"
    };

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
        'BARCODE $X_LEFT,${184 + SHIFT},"128",90,1,0,3,6,"${m['stickerno']}"\r\n';

    // Details
    cmd += 'TEXT $X_LEFT,${310 + SHIFT},"2",0,1,1,"GR | ${m['grno']}"\r\n';
    cmd += 'TEXT $X_LEFT,${350 + SHIFT},"2",0,1,1,"GR-DT | ${m['grdt']}"\r\n';
    cmd +=
        'TEXT $X_LEFT,${390 + SHIFT},"2",0,1,1,"ORIGIN | ${m['originname']}"\r\n';
    cmd +=
        'TEXT $X_LEFT,${430 + SHIFT},"2",0,1,1,"DESTINATION | ${m['destinationname']}"\r\n';
    cmd +=
        'TEXT $X_LEFT,${470 + SHIFT},"2",0,1,1,"PCKGS | ${m['packageid']}/${m['pckgs']}"\r\n';
    cmd +=
        'TEXT $X_RIGHT,${470 + SHIFT},"2",0,1,1,"WEIGHT | ${m['weight']}"\r\n';

    cmd += "PRINT 1\r\n";

    try {
      bytes = utf8.encode(cmd);
    } catch (e) {
      debugPrint("Error encoding TSPL data: $e");
    }

    return bytes;
  }

  void _printReceipt() async {
    if (_connectedDevice == null) {
      debugPrint('No device connected');
      return;
    }

    try {
      final data = await _generatePrintData();
      final services =
          await flutterReactiveBle.discoverServices(_connectedDevice!.id);

      // Find a writable characteristic
      QualifiedCharacteristic? writableCharacteristic;
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.isWritableWithResponse ||
              characteristic.isWritableWithoutResponse) {
            writableCharacteristic = QualifiedCharacteristic(
              serviceId: service.serviceId,
              characteristicId: characteristic.characteristicId,
              deviceId: _connectedDevice!.id,
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
      _connectedDevice = null;
    });
    debugPrint('Disconnected');
  }

  @override
  Widget build(BuildContext context) {
    // Sort devices: connected device first
    final sortedDevices = List<DiscoveredDevice>.from(devices);
    if (_connectedDevice != null) {
      sortedDevices.removeWhere((d) => d.id == _connectedDevice!.id);
      sortedDevices.insert(0, _connectedDevice!);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
      ),
      body: sortedDevices.isEmpty
          ? const Center(child: Text('No Devices Found'))
          : Column(
              children: [
                ElevatedButton(
                  onPressed: _connectedDevice != null
                      ? () {
                          _printReceipt();
                        }
                      : null,
                  child: const Text('Print'),
                ),
                Expanded(
                  child: ListView.separated(
                      itemCount: sortedDevices.length,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        final device = sortedDevices[index];
                        final isConnected = _connectedDevice?.id == device.id;

                        return ListTile(
                          tileColor: isConnected
                              ? Colors.green.withOpacity(0.2)
                              : null,
                          onTap: () {
                            if (!isConnected) {
                              connectToDevice(device);
                            }
                          },
                          contentPadding: const EdgeInsets.all(8),
                          title: Text(device.name),
                          trailing: isConnected
                              ? TextButton(
                                  onPressed: disconnect,
                                  child: const Text('Disconnect',
                                      style: TextStyle(color: Colors.red)),
                                )
                              : null,
                        );
                      }),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    super.dispose();
  }
}
