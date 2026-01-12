import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/offlineView/offlineDrsOption.dart';
import 'package:gtlmd/service/authenticationService.dart';
import 'package:lottie/lottie.dart';

class OfflinePasswordScreen extends StatefulWidget {
  String username;
  OfflinePasswordScreen({super.key, required this.username});

  @override
  State<OfflinePasswordScreen> createState() => _OfflinePasswordScreenState();
}

class _OfflinePasswordScreenState extends State<OfflinePasswordScreen> {
  TextEditingController passwordController = TextEditingController();
  late Map<String, dynamic>? offlineCreds;
  // final authService = AuthenticationService();
  @override
  void initState() {
    super.initState();
    if (ENV.isDebugging) {
      passwordController.text = ENV.debuggingPassword;
    }
    fetchLoginPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enter Password",
          style: TextStyle(color: CommonColors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              color: CommonColors.white,
            )),
        backgroundColor: CommonColors.colorPrimary,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.largeVerticalSpacing),
                    Lottie.asset(
                      'assets/password.json',
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: SizeConfig.largeVerticalSpacing),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.horizontalPadding),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: SizeConfig.largeTextSize,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.horizontalPadding),
                      padding: EdgeInsets.symmetric(
                          vertical: SizeConfig.verticalPadding,
                          horizontal: SizeConfig.horizontalPadding),
                      height: 72,
                      child: TextField(
                        // Add isPasswordVisible if you want toggle
                        // obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.key_rounded,
                            color: CommonColors.appBarColor,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.extraLargeRadius),
                          ),
                          label: const Text("Password"),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.extraLargeRadius),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                                SizeConfig.extraLargeRadius),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        controller: passwordController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(height: SizeConfig.mediumVerticalSpacing),
                    Container(
                      width: double.infinity,
                      height: 69,
                      margin: EdgeInsets.symmetric(
                          horizontal: SizeConfig.horizontalPadding),
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.horizontalPadding,
                          vertical: SizeConfig.verticalPadding),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            SizeConfig.extraLargeRadius)))),
                            backgroundColor: WidgetStatePropertyAll(
                                CommonColors.colorPrimary),
                          ),
                          onPressed: () {
                            verifyPassword();
                          },
                          child: Text(
                            'SUBMIT',
                            style: TextStyle(
                                color: CommonColors.white,
                                fontSize: SizeConfig.largeTextSize),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom logo - not scrollable
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                'assets/poweredBy.png',
                width: 200,
                height: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void verifyPassword() {
    if (passwordController.text.isEmpty) {
      failToast("Please enter the password");
    } else if (offlineCreds == null) {
      failToast(
          "You need to at-least login once in the application before using this feature");
    } else {
      if (offlineCreds![ENV.offlineLoginIdTag].toString().isEmpty &&
          offlineCreds![ENV.offlineLoginPassTag].toString().isEmpty) {
        failToast(
            "You need to at-least login once in the application before using this feature");
      } else if (offlineCreds![ENV.offlineLoginIdTag].toString() ==
              widget.username &&
          passwordController.text.toString() ==
              offlineCreds![ENV.offlineLoginPassTag].toString()) {
        // successToast("Welcome");
        Get.to(() => const OfflineDrsOption());
      } else {
        failToast("Invalid username or password");
      }
    }
  }

  void fetchLoginPrefs() async {
    String? offlineCredsStr =
        await authService.storageGet(ENV.offlineLoginCredsTag);
    try {
      offlineCreds = jsonDecode(offlineCredsStr.toString());
    } catch (err) {
      debugPrint(err.toString());
    }
    print(offlineCredsStr);
  }
}
