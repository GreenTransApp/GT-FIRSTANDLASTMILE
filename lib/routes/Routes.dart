import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:gtlmd/pages/attendance/attendanceScreen.dart';
import 'package:gtlmd/pages/home/homeScreenPage.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:gtlmd/pages/profile/profilePage.dart';
import 'package:gtlmd/pages/updateVersionScreen/updateVersionScreen.dart';
import 'package:gtlmd/routes/RoutesName.dart';

class Routes {
  static goToPage(String pageRoute, String? pageName) {
    switch (pageRoute) {
      case RoutesName.login:
        /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const LoginPage()),
              (route) => false);
        }); */
        Get.offAll(const LoginPage());

      case RoutesName.home:
        /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => HomeScreen()),
              (route) => false);
        }); */
        Get.offAll(HomeScreen());

      case RoutesName.update:
        Get.offAll(const UpdateVersionScreen());
        break;

      case RoutesName.attendance:
        /* WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => const AttendanceScreen()));
        }); */
        Get.to(const AttendanceScreen());

      case RoutesName.profile:
        Get.to(ProfileScreen());
    }
  }
}
