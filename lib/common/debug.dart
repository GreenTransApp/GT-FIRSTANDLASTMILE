class SESSION {
  // static bool isDebugging = true;
  static bool isDebugging = false;
}

class URL {
  static const imageBaseUrl = "https://greentrans.in:446/";
  // static const baseUrl = "https://greentrans.in:444/API";
  static const baseUrl = "http://192.168.1.252:45455/API";
  // static const baseUrl = "http://192.168.1.253:45457/API";

  static const ewayBillLogin =
      "https://api.easywaybill.in/ezewb/v1/auth/initlogin";
  static const ewayBillCompleteLogin =
      "https://api.easywaybill.in/ezewb/v1/auth/completelogin";
  static const getDetailbyEwayBillNo =
      "https://api.easywaybill.in/ezewb/v1/ewb/data";
  static const getRefreshEwb =
      'https://api.easywaybill.in/ezewb/v1/ewb/refreshEwb';
}

class USER {
  // GreenTransTesting
  // static String debuggingUserName = "9015819980";
  // static String debuggingPassword = "12345678";

// //--------------LMD-----------------
  static String debuggingUserName = "9718004651";
  static String debuggingPassword = "12345678";

// //--------------Smart Ship-----------------
  // static String debuggingUserName = "7300964400";
  // static String debuggingPassword = "12345678";
}
