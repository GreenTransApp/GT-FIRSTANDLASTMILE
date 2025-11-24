import 'package:gtlmd/common/app.dart';
import 'package:gtlmd/common/debug.dart';

class ENV {
  static bool isDebugging = SESSION.isDebugging;

  static String debuggingUserName = USER.debuggingUserName;
  static String debuggingPassword = USER.debuggingPassword;

  static String imageBaseUrl =
      "https://greentrans.in:446/GreenTransApp/NewApp/";
  static String appVersion = APP.APP_VERSION;
  static String appVersionDate = APP.APP_VERSION_DT;
  static String deviceDate = APP.DEVICE_DT;
  // static String deviceId = "LAST_MILE_DELIVERY_APP";
  static String appName = APP.APP_NAME;

  static String basePrefTag = appName;
  static String userPrefTag = "${basePrefTag}_USER";
  static String loginPrefTag = "${basePrefTag}_LOGIN";
  static String loginCredsPrefTag = "${basePrefTag}_LOGINCREDS";
  static String offlineLoginCredsTag = "${basePrefTag}_OFFLINELOGINCREDS";
  static String offlineLoginIdTag = "${basePrefTag}_OFFLINELOGINID";
  static String offlineLoginPassTag = "${basePrefTag}_OFFLINELOGINPASS";
}
