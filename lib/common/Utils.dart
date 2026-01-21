import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io' as Io;
import 'dart:io';
import 'dart:math';

import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart'
    show DiscoveredDevice;
import 'package:get/get.dart';
import 'package:get_ip_address/get_ip_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/bottomSheet/commonBottomSheets.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:gtlmd/pages/home/Model/validateDeviceModel.dart';
import 'package:gtlmd/pages/login/models/LoginCredsModel.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/companySelectionModel.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/models/userModel.dart';
import 'package:gtlmd/pages/mapView/models/mapConfigJsonModel.dart';
import 'package:gtlmd/service/authenticationService.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const METHOD_CHANNEL = MethodChannel('com.map_api_key.flutter');
//  String GOOGLE_MAPS_API_KEY = "AIzaSyBAVL3a5xqVrQOnkvQbs8cgJ-V2tLnpb3E"; //jeena biker  api key
String GOOGLE_MAPS_API_KEY = "";
// String GOOGLE_MAPS_API_KEY = "";

// String toDatePicker;

LoginModel savedLogin = LoginModel();
ValidateDeviceModel savedValidateDevice = ValidateDeviceModel();
String? saveInStorageLogin = "";
String? saveInStorageUser = "";
// String? companyId = "";
AuthenticationFlow authenticaionFlow = AuthenticationFlow.loginWithOtp;
UserModel savedUser = UserModel();
AuthenticationFlow authenticationFlow = AuthenticationFlow.loginWithOtp;
UserCredsModel userCredsModel = UserCredsModel();
AttendanceModel todayAttendance = AttendanceModel();
int? executiveid = null;
int? employeeid = null;
DiscoveredDevice? connectedDevice;

// List<CurrentDeliveryModel> activeDrsList = List.empty(growable: true);
class ScreenDimension {
  static double width = 0.0;
  static double height = 0.0;
}

final authService = AuthenticationService();
DateTime dashboardFromDt = DateTime.now();
DateTime dashboardToDt = DateTime.now();

// String getDateDifferenceFromNow(DateTime date1) {
//   Duration diff = DateTime.now().difference(date1);
//   int rawMinutes = diff.inMinutes;
//   if (rawMinutes < 60) return rawMinutes.toString();
//   double rawInHours = (rawMinutes / 60).toDouble();
//   if (rawInHours > 23) return "+ 24 Hrs";
//   int floorInMinutes = rawInHours.floor();
//   double minDiffInDecimals = rawInHours - floorInMinutes;
//   if (minDiffInDecimals > 0.00) {
//     double remainingMins = minDiffInDecimals * 60;
//     // if()
//     return "$floorInMinutes Hrs $remainingMins Mins";
//   }
//   return "$floorInMinutes Hrs";
// }

// String getDateDifferenceFromNow(DateTime date1) {
//   Duration diff = DateTime.now().difference(date1);
//   int rawMinutes = diff.inMinutes;
//   if (rawMinutes < 60) return rawMinutes.toString();
//   double rawInHours = (rawMinutes / 60).toDouble();
//   if (rawInHours > 23) return "+ 24 Hrs";
//   int floorInMinutes = rawInHours.floor();
//   double minDiffInDecimals = rawInHours - floorInMinutes;
//   if (minDiffInDecimals > 0.00) {
//     int remainingMins = (minDiffInDecimals * 60).toInt();
//     return "$floorInMinutes Hrs $remainingMins Mins";
//   }
//   return "$floorInMinutes Hrs";
// }

DateTime getCurrentDt() {
  return DateTime.now();
}

DateTime getDateTimeBack(String? dtTime) {
  if (dtTime != null) {
    return DateTime.parse(dtTime);
  }
  return DateTime.now();
}

String getDayInWeek(DateTime dt) {
  int day = dt.weekday;
  String dayInStr = "Sunday";
  switch (day) {
    case 1:
      {
        dayInStr = "Monday";
        break;
      }
    case 2:
      {
        dayInStr = "Tuesday";
        break;
      }
    case 3:
      {
        dayInStr = "Wednesday";
        break;
      }
    case 4:
      {
        dayInStr = "Thursday";
        break;
      }
    case 5:
      {
        dayInStr = "Friday";
        break;
      }
    case 6:
      {
        dayInStr = "Saturday";
        break;
      }
    case 7:
      {
        dayInStr = "Sunday";
        break;
      }
  }
  return dayInStr;
}

String getMonthInWords(DateTime dt) {
  String month = "January";
  int monthInt = dt.month;
  switch (monthInt) {
    case 1:
      {
        month = "January";
        break;
      }
    case 2:
      {
        month = "Feburary";
        break;
      }
    case 3:
      {
        month = "March";
        break;
      }
    case 4:
      {
        month = "April";
        break;
      }
    case 5:
      {
        month = "May";
        break;
      }
    case 6:
      {
        month = "June";
        break;
      }
    case 7:
      {
        month = "July";
        break;
      }
    case 8:
      {
        month = "August";
        break;
      }
    case 9:
      {
        month = "September";
        break;
      }
    case 10:
      {
        month = "October";
        break;
      }
    case 11:
      {
        month = "November";
        break;
      }
    case 12:
      {
        month = "December";
        break;
      }
  }
  return month;
}

String formatDate(int timestamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp);
  List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  String dayOfWeek;
  if (date.weekday == 7) {
    dayOfWeek = days[0];
  } else {
    dayOfWeek = days[date.weekday]; // weekday starts from 1 (Monday)
  }
  int dayOfMonth = date.day;
  String month = months[date.month - 1]; // month starts from 1
  int year = date.year;

  return '$dayOfWeek, $dayOfMonth $month $year';
}

double distance(double lat1, double lon1, double lat2, double lon2) {
  const r = 6372.8; // Earth radius in kilometers

  final dLat = _toRadians(lat2 - lat1);
  final dLon = _toRadians(lon2 - lon1);
  final lat1Radians = _toRadians(lat1);
  final lat2Radians = _toRadians(lat2);

  // final a = pow(dLat) + cos(lat1Radians) * cos(lat2Radians) * pow(dLon);
  var a = pow(sin((dLat / 2)), 2) +
      cos(lat1Radians) * cos(lat2Radians) * pow(sin(dLon / 2), 2);
  final c = 2 * asin(sqrt(a));

  return (r * c) * 1000;
}

double _toRadians(double degrees) => degrees * pi / 180;

getUuid() {
  const uuid = Uuid();
  return uuid.v4();
}

Future<String?> getIpAddress() async {
  Permission.location.request();
  final networkInfo = await NetworkInfo();
  var ipAddress = await networkInfo.getWifiIP();
  return ipAddress;
}

Future<String?> getDeviceIp() async {
  Permission.location.request();
  var deviceIp = IpAddress(type: RequestType.text);
  dynamic data = await deviceIp.getIpAddress();
  debugPrint("device ip---" + data);
  return data;
}

Future<String?> getIp() async {
  Permission.location.request();
  final deviceIpAddress = await Ipify.ipv4(format: Format.TEXT);
  return deviceIpAddress;
}

// distance(lat1, lat2, lon1, lon2) {
//   lon1 =  lon1 * Math.PI / 180;
//   lon2 = lon2 * Math.PI / 180;
//   lat1 = lat1 * Math.PI / 180;
//   lat2 = lat2 * Math.PI / 180;

//   // Haversine formula
//   let dlon = lon2 - lon1;
//   let dlat = lat2 - lat1;
//   let a = Math.pow(Math.sin(dlat / 2), 2)
//   + Math.cos(lat1) * Math.cos(lat2)
//   * Math.pow(Math.sin(dlon / 2),2);

//   let c = 2 * Math.asin(Math.sqrt(a));

//   // Radius of earth in kilometers. Use 3956
//   // for miles
//   let r = 6371;

//   // calculate the result
//   return(c * r);
// }

// void selectScreen(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => AlertDialog(
//       content: const Text(
//         "Select your view",
//         textAlign: TextAlign.center,
//       ),
//       actions: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => UserBottomNavigator()),
//                     (Route<dynamic> route) => false);
//               },
//               child: Container(
//                 color: Colors.blue,
//                 padding: const EdgeInsets.all(14),
//                 child: const Text(
//                   "User View",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => const DriverBottomNavigator()),
//                     (Route<dynamic> route) => false);
//               },
//               child: Container(
//                 color: Colors.blue,
//                 padding: const EdgeInsets.all(14),
//                 child: const Text(
//                   "Driver View",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

Future<void> setGoogleMapApiKey(String mapKey) async {
  Map<String, dynamic> requestData = {"mapKey": mapKey};

  METHOD_CHANNEL.invokeMethod('setGoogleMapKey', requestData).then((value) {});
}

void printParams(Map<String, dynamic> params) async {
  dev.log("Printing Params: {");
  params.forEach((key, value) {
    dev.log("    $key -> ${value == null ? "Null" : value.toString()}");
  });
  dev.log("}");
}

bool isNullOrEmpty(String? check) {
  switch (check) {
    case null || "null" || "Null" || "NULL" || "":
      return true;
    default:
      return false;
  }
}

// Fetch login credentials from shared preferneces
Future<LoginCredsModel> getLoginCreds() async {
  String? rawStorageLoginCreds =
      await AuthenticationService().storageGet(ENV.loginCredsPrefTag);
  LoginCredsModel loginCredsModel = LoginCredsModel();

  if (rawStorageLoginCreds != null) {
    Map<String, dynamic> te = jsonDecode(rawStorageLoginCreds);
    loginCredsModel = LoginCredsModel.fromJson(te);
  }

  return loginCredsModel;
}

Future<LoginModel> getLoginData() async {
  final String? rawStorageUser =
      await AuthenticationService().storageGet(ENV.loginPrefTag);

  if (rawStorageUser != null) {
    savedLogin = await compute(_parseLoginInBackground, rawStorageUser);
  }

  return savedLogin;
}

LoginModel _parseLoginInBackground(String rawJson) {
  final Map<String, dynamic> jsonMap = jsonDecode(rawJson);
  return LoginModel.fromJson(jsonMap);
}

void callCompanyBottomSheetDialog(BuildContext context,
    List<CompanySelectionModel> data, final void Function(dynamic) callBack) {
  List<CommonDataModel<CompanySelectionModel>> dataList =
      List.empty(growable: true);
  for (int i = 0; i < data.length; i++) {
    dataList.add(
      CommonDataModel(
        data.elementAt(i).compname.toString(),
        data.elementAt(i),
      ),
    );
  }
  showCommonBottomSheet(context, "Company Selection", callBack, dataList);
}

Future<UserModel> getUserData() async {
  String? rawStorageUser =
      await AuthenticationService().storageGet(ENV.userPrefTag);
  if (rawStorageUser != null) {
    savedUser = _getUserDataInBackground(rawStorageUser);
  }
  return savedUser;
}

UserModel _getUserDataInBackground(String rawJson) {
  final Map<String, dynamic> jsonMap = jsonDecode(rawJson);
  return UserModel.fromJson(jsonMap);
}

inputField(
    TextInputType? inputType,
    TextEditingController controller,
    String? lable,
    Icon? suffixIcon,
    Icon? prefixIcon,
    bool isEnabled,
    double? radius) {
  return TextField(
    enabled: isEnabled,
    decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border: const OutlineInputBorder(),
        label: Text(lable ?? ""),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 4),
          ),
          borderSide: const BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 4),
          ),
          borderSide: const BorderSide(color: Colors.black),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never),
    controller: controller,
    cursorColor: Colors.black,
    keyboardType: inputType,
  );
}

updateAuthenticationFlow(AuthenticationFlow flow) {
  authenticaionFlow = flow;
}

Color StringToHexaColor(String hexColor) {
  final hexCode = hexColor.replaceAll('#', '');
  return Color(int.parse('FF$hexCode', radix: 16));
}

String convertFilePathToBase64(String? sent) {
  String base64Path = "";

  if (sent != null) {
    try {
      final bytes = Io.File(sent).readAsBytesSync();
      base64Path = base64Encode(bytes);
      debugPrint(" base 64 path : ${base64Path.toString().substring(0, 100)}");
    } catch (e) {
      debugPrint("Error converting file to base64: $e");
    }
  } else {
    debugPrint("Error: sent parameter is null.");
  }

  debugPrint("BASE 64 LEN: ${base64Path.length}");
  debugPrint("Original Len: ${sent!.length}");
  return base64Path;
}

String formatTimeString(String timeString) {
  try {
    if (timeString.toLowerCase().contains("am") ||
        timeString.toLowerCase().contains("pm")) {
      DateTime date = DateFormat("hh:mm a").parse(timeString);
      return DateFormat("HH:mm").format(date);
    } else {
      return timeString;
    }
  } catch (e) {
    debugPrint("formatTimeString Error: $e");
    return timeString;
  }
}

inputFieldWithHeading(
  TextInputType inputType,
  TextEditingController controller,
  String label,
  Icon? prefixIcon,
  Icon? suffixIcon,
  String heading,
  bool isRequired,
  bool isEnabled,
) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isRequired == true
            ? RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  style: const TextStyle(),
                  children: <TextSpan>[
                    TextSpan(
                      text: heading,
                      style: const TextStyle(color: CommonColors.appBarColor),
                    ),
                    TextSpan(
                      text: '*',
                      style: TextStyle(color: CommonColors.dangerColor),
                    ),
                  ],
                ),
              )
            : Text(heading),
        inputField(
            inputType, controller, label, suffixIcon, prefixIcon, isEnabled, 4)
      ],
    ),
  );
}

String Timeformatter(DateTime? date) {
  String result = "";
  result = "${date!.toLocal()}".split(' ')[0].toString();

  return result;
}

Future<T?> showGenericDialog<T>(
  BuildContext context,
  List<T> itemList,
  String Function(T) displayTextExtractor, // Function to get display text
) async {
  T? _selectedValue; // Generic selected value

  T? result = await showDialog<T>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select an Item'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: itemList.map((item) {
                  return RadioListTile<T>(
                    title:
                        Text(displayTextExtractor(item)), // Use the extractor
                    value: item,
                    groupValue: _selectedValue,
                    onChanged: (T? value) {
                      setState(() {
                        _selectedValue = value;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  // Navigator.of(context).pop();
                  Get.back();
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
/*                     Navigator.of(context).pop(_selectedValue != null
                        ? displayTextExtractor(_selectedValue!)
                        : null); // Return display text */
                  Get.back(result: _selectedValue);
                },
              ),
            ],
          );
        },
      );
    },
  );

  return result;
}

void showDialogWithImage(
  BuildContext context,
  String? imagePath, {
  bool isLocal = false,
}) {
  const String defaultImagePath =
      'https://greentrans.in:446/GreenTransApp/imageplace.jpg';

  final bool useDefault = imagePath == null || imagePath.isEmpty;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.04,
                vertical: MediaQuery.sizeOf(context).height * 0.08,
              ),
              width: double.infinity,
              child: useDefault
                  ? Image.network(defaultImagePath, fit: BoxFit.cover)
                  : isLocal
                      ? Image.file(
                          File(imagePath!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(defaultImagePath,
                                fit: BoxFit.cover);
                          },
                        )
                      : Image.network(
                          imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(defaultImagePath,
                                fit: BoxFit.cover);
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                                child: CircularProgressIndicator());
                          },
                        ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.red, // replace with CommonColors if needed
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

String convert2SmallDateTime(String inputDate) {
  try {
    DateTime dateTime;
    try {
      dateTime = DateTime.parse(inputDate);
    } catch (e) {
      dateTime = DateFormat('dd-MM-yyyy').parseStrict(inputDate);
    }
    return DateFormat('yyyy-MM-dd').format(dateTime);
  } catch (e) {
    return '';
  }
}

String stringToDateTime(String date, String currentFormat) {
  try {
    DateTime dateTime = DateFormat(currentFormat).parseStrict(date);
    return DateFormat('yyyy-MM-dd').format(dateTime);
  } catch (e) {
    return '';
  }
}

Future<String> selectTime(BuildContext context) async {
  final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      builder: (context, child) {
        return Theme(
            data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
              primary: CommonColors.colorPrimary!,
            )),
            child: child!);
      });

  String pickedTime =
      '${picked!.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

  return pickedTime;
  // if (picked != null) {
  //   setState(() {
  //     _unDeliveryTimeController.text =
  //         '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
  //   });
  // }
}

Future<String> selectDate(BuildContext context) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
  );
  String pickeddt = DateFormat('dd-MM-yyyy').format(pickedDate!);

  return pickeddt;
}

Future<List<int>> fetchTotalRouteDistance(
    List<dynamic> routeDetail, MapConfigJsonModel mapconfig) async {
  if (GOOGLE_MAPS_API_KEY.isEmpty) {}
  List<LatLng> allPoints = List.empty(growable: true);
  List<int> updatedDistances = List.empty(growable: true);

  for (int i = 0; i < routeDetail.length; i++) {
    allPoints
        .add(LatLng(routeDetail[i].deliverylat!, routeDetail[i].deliverylong!));
  }
  List<LatLng> waypoints = allPoints.sublist(1, allPoints.length - 1);

  int totalDistanceInMeters = 0;
  // String url =
  //     'https://maps.googleapis.com/maps/api/directions/json?origin=${allPoints[0].latitude},${allPoints[0].longitude}&destination=${allPoints[allPoints.length - 1].latitude},${allPoints[allPoints.length - 1].longitude}&waypoints=$waypointsstring&key=$GOOGLE_MAPS_API_KEY&waypoints=optimize:true|$waypointsstring&avoid=highways';

  final url =
      Uri.parse('https://routes.googleapis.com/directions/v2:computeRoutes');
  // final response = await http.get(Uri.parse(url));
  String accessToken = GOOGLE_MAPS_API_KEY;

  final headers = {
    'Content-Type': 'application/json',
    'X-Goog-Api-Key': accessToken,
    'X-Goog-FieldMask':
        '*', // Use field mask to specify which parts of the response you want
  };

  final body = {
    "origin": {
      "location": {
        "latLng": {
          "latitude": allPoints[0].latitude,
          "longitude": allPoints[0].longitude
        }
      }
    },
    "destination": {
      "location": {
        "latLng": {
          "latitude": allPoints[allPoints.length - 1].latitude,
          "longitude": allPoints[allPoints.length - 1].longitude
        }
      }
    },
    "intermediates": List.generate(
      waypoints.length,
      (index) => {
        "location": {
          "latLng": {
            "latitude": waypoints[index].latitude,
            "longitude": waypoints[index].longitude
          }
        }
      },
    ),
    "routeModifiers": {
      "avoidTolls": mapconfig.avoidtolls == 'Y',
      "avoidHighways": mapconfig.avoidhighways == 'Y',
      "avoidFerries": mapconfig.avoidferries == 'Y'
    },
    "routingPreference": mapconfig.trafficmode!.toString().toUpperCase(),
    "travelMode": mapconfig.travelmode!.toUpperCase(),
    "computeAlternativeRoutes": mapconfig.alternativeroutes == 'Y',
    // "polylineQuality": "HIGH_QUALITY",
    // "units": "METRIC"
  };

  final response =
      await http.post(url, headers: headers, body: jsonEncode(body));
  // final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    try {
      if ((data['routes'] as List).isNotEmpty) {
        final route = data['routes'][0];

        for (var leg in route['legs']) {
          // Safely check if 'distanceMeters' is present
          if (leg.containsKey('distanceMeters')) {
            int dis = leg['distanceMeters'] as int;
            updatedDistances.add(dis);
            totalDistanceInMeters += dis;
          } else {
            debugPrint(
                "Missing distanceMeters in leg. Possibly a zero-distance leg.");
          }
        }

        if (totalDistanceInMeters == 0) {
          debugPrint(
              "Total distance is zero. Start and destination might be the same.");
        }
      }
    } catch (e) {
      debugPrint("Error parsing response: $e");
    }
    // Total distance will be at index 0 and distance from point 1 to point 2 etc will start from index 1
    updatedDistances.insert(0, totalDistanceInMeters);
    return updatedDistances;
    // return totalDistanceInMeters / 1000;
  } else {
    return [];
  }
}

Future<bool> requestAppPermission(Permission permission,
    {String? reason}) async {
  try {
    debugPrint('Checking ${permission.toString()} status...');

    PermissionStatus status = await permission.status;

    if (status.isGranted) {
      debugPrint(' ${permission.toString()} already granted');
      return true;
    }
    if (status.isDenied || status.isRestricted) {
      debugPrint(' Requesting ${permission.toString()} permission...');
      final newStatus = await permission.request();

      if (newStatus.isGranted) {
        debugPrint(' ${permission.toString()} granted after request');
        return true;
      } else if (newStatus.isPermanentlyDenied) {
        debugPrint(
            ' ${permission.toString()} permanently denied. Opening settings...');
        await openAppSettings();
        return false;
      } else {
        debugPrint(' ${permission.toString()} denied by user');
        return false;
      }
    }

    if (status.isPermanentlyDenied) {
      debugPrint(
          '${permission.toString()} permanently denied. Opening settings...');
      await openAppSettings();
      return false;
    }

    debugPrint(' Unknown permission state for ${permission.toString()}');
    return false;
  } catch (e) {
    debugPrint(' Error requesting permission: $e');
    return false;
  }
}

Future<String> getDeviceId() async {
  final prefs = await SharedPreferences.getInstance();

  String? id = prefs.getString('device_uuid');
  if (id == null) {
    id = const Uuid().v4();
    await prefs.setString('device_uuid', id);
  }
  return id;
}

enum ApiCallingStatus { initial, loading, success, error }
