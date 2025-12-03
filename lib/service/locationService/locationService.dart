import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/firebase_options.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/pages/trips/tripDetail/Model/tripModel.dart';


import 'package:gtlmd/service/fireBaseService/fireBase.dart';
import 'package:gtlmd/service/fireBaseService/firebaseLocationUpload.dart';
import 'package:gtlmd/service/locationService/locationRepository.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();
  StreamSubscription<Position>? _position;

  Future<void> init() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'location_channel',
        channelName: 'Live Location Service',
        channelDescription: 'Tracking user location in foreground',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        // eventAction: ForegroundTaskEventAction.repeat(30000), // 30 seconds
        eventAction: ForegroundTaskEventAction.repeat(60000), // 1 minute
        autoRunOnBoot: false,
        autoRunOnMyPackageReplaced: false,
        allowWakeLock: true,
        allowWifiLock: true,
      ),
    );
  }

  Future<void> requestPermissions() async {
    final notifGranted = await requestAppPermission(Permission.notification);
    if (!notifGranted) return;
    // Check if location service is ON
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    // Check location permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return; // User still denied
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings(); // Ask user to enable manually
      return;
    }

    // Permission granted
    print('Location permission granted!');
  }

  Future<void> startService(
    List<TripModel> activeTripList,
    UserModel userdata,
  ) async {
    await requestPermissions();

    if (await FlutterForegroundTask.isRunningService) {
      // return;
      await FlutterForegroundTask.stopService();
    }

    //  CRITICAL: Extract data that needs to be passed to isolate
    final tripList =
        activeTripList.map((trip) => trip.tripid.toString()).toList();
    // final executiveId = userdata.executiveid.toString();
    // final companyId = userdata.companyid.toString();
    final userData = userdata;

    //  Create a Map with the data to pass to the isolate
    final dataToPass = {
      'tripList': tripList,
      // 'executiveId': executiveId,
      // 'companyId': companyId,
      'userData': userData.toJson(),
    };

    print('Starting service with data: $dataToPass');

    await FlutterForegroundTask.startService(
      notificationTitle: 'Location Tracking Active',
      notificationText: 'Your location is being tracked.',
      callback: startCallback,
    );

    // Send data to the isolate after service starts
    await Future.delayed(
        Duration(milliseconds: 500)); // Small delay to ensure service is ready
    FlutterForegroundTask.sendDataToTask(dataToPass);
  }

  Future<void> stopService() async {
    if (await FlutterForegroundTask.isRunningService) {
      await _position?.cancel();
      _position = null;
      await FlutterForegroundTask.stopService();
      print("Foreground service stopped manually");
    } else {
      print("No foreground service running");
    }
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  StreamSubscription<Position>? _positionStream;
  LocationRepository _repo = LocationRepository();

  //  Store data received from main isolate
  List<String> tripList = [];
  // String? executiveId;
  // String? companyId;
  bool _dataReceived = false;
  UserModel? userData;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    print('TaskHandler onStart called');

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('Firebase initialized in foreground task.');
    }

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((position) {
      print('Foreground Location: ${position.latitude}, ${position.longitude}');
    });
  }

  @override
  Future<void> onRepeatEvent(DateTime timestamp) async {
    // Check if data has been received before processing
    if (!_dataReceived) {
      print('Waiting for data from main isolate...');
      return;
    }

    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    }

    if (userData!.executiveid.toString() == null ||
        tripList.isEmpty ||
        userData!.companyid.toString() == null) {
      print('Skipping location upload: missing user or trip list.');
      print(
          'ExecutiveId: ${userData!.executiveid.toString()}, tripList: $tripList');
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition();
      // final lat = position.latitude.toStringAsFixed(5);
      // final lon = position.longitude.toStringAsFixed(5);
      final lat = position.latitude;
      final lon = position.longitude;
      final time = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

      final firebaseData = FireBase(
        timeStamp: time,
        latitude: lat.toString(),
        longitude: lon.toString(),
      );

      await FirebaseLocationUpload().saveToServer(
        // executiveId!,
        // companyId!,
        userData!,
        tripList,
        firebaseData,
      );

      updateDriverLiveLocation(userData!, tripList, firebaseData);

      print(
          "Location uploaded successfully: $lat, $lon for executive: ${userData!.executiveid.toString()} for trips: $tripList");
    } catch (e) {
      print(" Error getting/uploading location: $e");
    }
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isRetrying) async {
    await _positionStream?.cancel();
    _positionStream = null;
    print('Foreground task destroyed. Retrying: $isRetrying');

    if (isRetrying) {
      await FlutterForegroundTask.stopService();
    }
  }

  @override
  void onReceiveData(Object data) {
    //  CRITICAL: Receive data from main isolate
    print(' Received data in TaskHandler: $data');

    if (data is Map) {
      try {
        // Extract the data
        if (data['tripList'] is List) {
          tripList = List<String>.from(data['tripList']);
        }
        // executiveId = data['executiveId']?.toString();
        // companyId = data['companyId']?.toString();
        // userData = data['userData'];
        userData =
            UserModel.fromJson(Map<String, dynamic>.from(data['userData']));
        ;
        _dataReceived = true;

        print(' Data successfully loaded in TaskHandler:');
        // print('   - ExecutiveId: $executiveId');
        print('   - ExecutiveId: $userData');
        print('   - DRS List: $tripList');
      } catch (e) {
        print(' Error parsing received data: $e');
      }
    }
  }

  updateDriverLiveLocation(
      UserModel userData, List<String> tripList, FireBase firebase) {
    List<String> tripStrList = List.empty(growable: true);
    for (int i = 0; i < tripList.length; i++) {
      String tripId = tripList[i];
      tripStrList.add(tripId);
    }

    Map<String, String> params = {
      "prmcompanyid": userData.companyid.toString(),
      "prmusercode": userData.usercode.toString(),
      "prmbranchcode": userData.loginbranchcode.toString(),
      "prmboyid": userData.executiveid.toString(),
      "prmtripidstr": tripStrList.join(",") + ",",
      "prmlatitude": firebase.latitude.toString(),
      "prmlongitude": firebase.longitude.toString(),
      "prmsessionid": userData.sessionid.toString(),
    };

    _repo.upsertDriverLocation(params);
  }
}
