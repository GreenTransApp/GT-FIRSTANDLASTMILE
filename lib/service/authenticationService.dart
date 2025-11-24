 import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/pages/home/homeScreenPage.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:gtlmd/routes/Routes.dart';
import 'package:gtlmd/routes/RoutesName.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService {
   AuthService() {
    isLogin(); 
  }

 BehaviorSubject<bool?> isAuthenticated = BehaviorSubject<bool?>.seeded(null);
  String token = '';

void storagePush(String key, String value) async {
  final prefs = await SharedPreferences.getInstance();
  debugPrint("Storage KEY: $key");
  debugPrint("Storage VAL: $value");
  await prefs.setString(key, value);
}

  Future<void> isLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(ENV.userPrefTag);
    if (token != null) {
      isAuthenticated.add(true);
    } else {
      isAuthenticated.add(false);
    }
  }

Future<String?> storageGet(String key) async {
  final prefs = await SharedPreferences.getInstance();
  final String? resp = prefs.getString(key);
  return resp;
}

void storageRemove(String key) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(key);
}

void storageClear() async {
  // final prefs = await SharedPreferences.getInstance();
  storageRemove(ENV.userPrefTag);
  storageRemove(ENV.loginPrefTag);
  // await prefs.clear();
}

void login(BuildContext context) {
    isAuthenticated.add(true);
       Get.off( HomeScreen());
  }
   
    void logout(BuildContext context) {
    storageClear();
    Routes.goToPage(RoutesName.login, "Login");
  }
 }