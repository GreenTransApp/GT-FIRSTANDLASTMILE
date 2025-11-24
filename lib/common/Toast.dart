import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gtlmd/common/Colors.dart';

const int commonTimeInSecForIosWeb = 1;
const double commonFontSize = 20.0;
const Toast commonToastLength = Toast.LENGTH_SHORT;
const Toast commonFailToastLength = Toast.LENGTH_LONG;

void successToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: commonToastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: commonTimeInSecForIosWeb,
      fontSize: commonFontSize,
      // backgroundColor: Colors.green,
      backgroundColor: CommonColors.successColor,
      textColor: Colors.white);
}

void failToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: commonFailToastLength,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: commonTimeInSecForIosWeb,
      fontSize: commonFontSize,
      // backgroundColor: Colors.red,
      backgroundColor: CommonColors.red600,
      textColor: Colors.white);
}
