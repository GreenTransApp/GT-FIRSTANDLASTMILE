import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Environment.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    Lottie.asset(
                      'assets/password.json',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 32),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
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
                            borderRadius: BorderRadius.circular(32),
                          ),
                          label: const Text("Password"),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: const BorderSide(color: Colors.black),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                        ),
                        controller: passwordController,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      width: double.infinity,
                      height: 69,
                      padding: const EdgeInsets.all(5),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            shape: const WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32)))),
                            backgroundColor: WidgetStatePropertyAll(
                                CommonColors.colorPrimary),
                          ),
                          onPressed: () {
                            verifyPassword();
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: CommonColors.white),
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
                'assets/poweredby.png',
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
    String? offlineCredsStr = await authService.storageGet(ENV.offlineLoginCredsTag);
    try {
      offlineCreds = jsonDecode(offlineCredsStr.toString());
    } catch (err) {
      debugPrint(err.toString());
    }
    print(offlineCredsStr);
  }
}
