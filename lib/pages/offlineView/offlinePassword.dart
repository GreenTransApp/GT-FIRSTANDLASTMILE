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
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(
        //     "Enter Password",
        //     style: TextStyle(color: CommonColors.white),
        //   ),
        //   leading: IconButton(
        //       onPressed: () {
        //         Get.back();
        //       },
        //       icon: Icon(
        //         Icons.arrow_back,
        //         color: CommonColors.white,
        //       )),
        //   backgroundColor: CommonColors.colorPrimary,
        // ),
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
                      // SizedBox(height: SizeConfig.largeVerticalSpacing),
                      // Lottie.asset(
                      //   'assets/password.json',
                      //   width: 200,
                      //   height: 200,
                      // ),
                      SizedBox(height: SizeConfig.largeVerticalSpacing),
                        Text(
                        'Welcome Back!',
                        style: TextStyle(
                            fontSize: SizeConfig.largeTextSize,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                        softWrap: true,
                      ),
                      Text(
                        "Let's login for explore continues",
                        // "Don't worry! It happens. Please enter the mobile number "
                        // "associated with your account.",
                        style: TextStyle(
                          fontSize: SizeConfig
                              .extraSmallTextSize, // smaller than heading
                          color: CommonColors.grey600,
                          height: 1.4,
                        ),
                        softWrap: true,
                      ),
                      Image.asset(
                        'assets/images/infinitilogo.png',
                        width: SizeConfig.extraLargeRadius * 6.6,
                        height: SizeConfig.extraLargeRadius * 2.4,
                      ),
                     
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.horizontalPadding),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Password',
                            style: TextStyle(
      
                              fontWeight: FontWeight.bold,
                              fontSize: SizeConfig.smallTextSize,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Container(
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: SizeConfig.horizontalPadding),
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: SizeConfig.verticalPadding,
                      //       horizontal: SizeConfig.horizontalPadding),
                      //   height: 72,
                      //   child: TextField(
                      //     // Add isPasswordVisible if you want toggle
                      //     // obscureText: true,
                      //     decoration: InputDecoration(
                      //       prefixIcon: const Icon(
                      //         Icons.key_rounded,
                      //         color: CommonColors.appBarColor,
                      //       ),
                      //       border: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(
                      //             SizeConfig.extraLargeRadius),
                      //       ),
                      //       label: const Text("Password"),
                      //       enabledBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(
                      //             SizeConfig.extraLargeRadius),
                      //         borderSide: const BorderSide(color: Colors.black),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderRadius: BorderRadius.circular(
                      //             SizeConfig.extraLargeRadius),
                      //         borderSide: const BorderSide(color: Colors.black),
                      //       ),
                      //       floatingLabelBehavior: FloatingLabelBehavior.never,
                      //     ),
                      //     controller: passwordController,
                      //     cursorColor: Colors.black,
                      //     keyboardType: TextInputType.text,
                      //   ),
                      // ),
                            Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              // boxShadow: [
                              //   BoxShadow(
                              //     color: Colors.black.withOpacity(0.05),
                              //     blurRadius: 10,
                              //     offset: const Offset(0, 4),
                              //   ),
                              // ],
                            ),
                            child: TextField(
                              controller: passwordController,
                           
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: SizeConfig.smallTextSize,
                                ),
                                prefixIcon: Container(
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: CommonColors.colorPrimary!,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                
                              
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.mediumRadius),
                                  borderSide:
                                      BorderSide(color: CommonColors.grey300!),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                      SizeConfig.mediumRadius),
                                  borderSide: BorderSide(
                                      color: CommonColors.colorPrimary!),
                                ),
                              ),
                            ),
                          ),
                    
                      SizedBox(height: SizeConfig.mediumVerticalSpacing),
                      // Container(
                      //   width: double.infinity,
                      //   height: 69,
                      //   margin: EdgeInsets.symmetric(
                      //       horizontal: SizeConfig.horizontalPadding),
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: SizeConfig.smallHorizontalPadding,
                      //       vertical: SizeConfig.smallVerticalPadding),
                      //   child: ElevatedButton(
                      //       style: ButtonStyle(
                      //         shape: WidgetStatePropertyAll(
                      //             RoundedRectangleBorder(
                      //                 borderRadius: BorderRadius.all(
                      //                     Radius.circular(
                      //                         SizeConfig.extraLargeRadius)))),
                      //         backgroundColor: WidgetStatePropertyAll(
                      //             CommonColors.colorPrimary),
                      //       ),
                      //       onPressed: () {
                      //         verifyPassword();
                      //       },
                      //       child: Text(
                      //         'SUBMIT',
                      //         style: TextStyle(
                      //             color: CommonColors.white,
                      //             fontSize: SizeConfig.largeTextSize),
                      //       )),
                      // ),
                    SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CommonColors.colorPrimary2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: (){
                                verifyPassword();
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
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
