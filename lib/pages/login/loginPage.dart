import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/home/homeScreenPage.dart';
import 'package:gtlmd/pages/login/loginWithOtp.dart';
import 'package:gtlmd/pages/login/models/companySelectionModel.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/viewModel/loginViewModel.dart';
import 'package:gtlmd/pages/offlineView/offlinePassword.dart';
import 'package:gtlmd/service/authenticationService.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoadingAlertService loadingAlertService;
  double padValue = 0.0;
  TextEditingController usermobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<CompanySelectionModel> companyList = List.empty(growable: true);

  LoginViewModel viewModel = LoginViewModel();
  // final LoginViewModel loginViewModel = LoginViewModel();

  bool passwordVisible = true;
  String? userMobile = "";
  bool isProgressBarShowing = false;
  String? nameUserErr;
  String? passErr;
  bool isPasswordVisible = false;
  // final authService = AuthenticationService();
  @override
  void initState() {
    super.initState();
    if (ENV.isDebugging) {
      usermobileController.text = ENV.debuggingUserName.toUpperCase();
      passwordController.text = ENV.debuggingPassword.toUpperCase();
    }
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
  }

  void setObservers() {
    viewModel.loginResponseLiveData.stream.listen((resp) {
      debugPrint('Login resp live data');
      LoginModel loginCredsModel =
          LoginModel(username: resp.username, password: resp.password);
      authService.storagePush(ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
      companyId = savedLogin.companyid.toString();
      validateUserLogin();
    });

    viewModel.validateUserLoginLiveData.stream.listen((resp) {
      debugPrint(resp.toString());
      if (resp.commandstatus == 1) {
        hideProgressBar();
        // Get.to(HomeScreen());
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => HomeScreen()),
        //     (route) => false);
        authService.login(context);
      }
      hideProgressBar();
    });

    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(isNullOrEmpty(errMsg.toString()) == true
          ? "Something went Wrong."
          : errMsg.toString());
      hideProgressBar();
    });
    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.userCredsLiveData.stream.listen((userCreds) {
      if (userCreds.commandstatus == 1) {
        userCredsModel = userCreds;
        Get.to(
            () => LoginWithOtp(usermobileno: usermobileController.value.text));
      } else {
        failToast(isNullOrEmpty(userCreds.commandmessage.toString()) == true
            ? "Something went wrong"
            : userCreds.commandmessage.toString());
      }
    });
  }

  Future<void> userLogin() async {
    Map<String, String> params = {
      "prmusername": usermobileController.text,
      "prmpassword": passwordController.text,
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.appVersionDate,
      "prmdeviceid": getUuid()
    };
    viewModel.loginUser(params);
  }

  void checkControllerIsEmpty() {
    if (usermobileController.text.isEmpty || passwordController.text.isEmpty) {
      hideProgressBar();
    } else {
      showProgressBar();
    }
  }

  void validateUserLogin() {
    Map<String, String> params = {
      "prmconstring": savedLogin.companyid.toString(),
      "prmusername": savedLogin.username.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdeviceid": getUuid()
    };
    viewModel.validateUserForLogin(params);
  }

  void _validateUserMobile() {
    if (isNullOrEmpty(usermobileController.text)) {
      failToast("Please Enter User Mobile Number");
      return;
    }
    debugPrint("Validating Device: ${usermobileController.value.text}");

    Map<String, String> params = {
      "prmmobileno": usermobileController.value.text
    };
    viewModel.validateUserMobileFromD2D(params);
  }

  @override
  Widget build(BuildContext context) {
    ScreenDimension.width = MediaQuery.of(context).size.width;
    ScreenDimension.height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset:
          true, // Let scaffold adjust when keyboard is visible
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(32),
              child: Image.asset(
                "assets/gtinfinit_logo.png",
                width: MediaQuery.sizeOf(context).width * 0.7,
                height: 100,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 4,
                        children: [
                          const Text(
                            'Phone No.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                              height: 72,
                              child: TextField(
                                  enabled: true,
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.person_3_rounded,
                                        color: CommonColors.appBarColor,
                                      ),
                                      border: OutlineInputBorder(),
                                      label: Text("Phone Number"),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(32),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.black),
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.never),
                                  controller: usermobileController,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next)),
                          const Text(
                            'Password',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 72,
                            child: TextField(
                              obscureText: isPasswordVisible,
                              enabled: true,
                              decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isPasswordVisible =
                                              !isPasswordVisible;
                                        });
                                      },
                                      icon: isPasswordVisible == true
                                          ? const Icon(
                                              Icons.visibility_rounded,
                                              color: CommonColors.appBarColor,
                                            )
                                          : const Icon(
                                              Icons.visibility_off_rounded,
                                              color: CommonColors.appBarColor)),
                                  prefixIcon: const Icon(
                                    Icons.key_rounded,
                                    color: CommonColors.appBarColor,
                                  ),
                                  border: const OutlineInputBorder(),
                                  label: const Text("Password"),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32),
                                    ),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32),
                                    ),
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never),
                              controller: passwordController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.go,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (isNullOrEmpty(
                                  usermobileController.text.toString())) {
                                failToast("Please Ente Mobile Number.");
                                return;
                              } else {
                                authenticaionFlow =
                                    AuthenticationFlow.forgotPassword;
                                _validateUserMobile();
                              }
                            },
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, bottom: 10, right: 10),
                                child: Text(
                                  'Forgot Password ?',
                                  style: TextStyle(
                                      color: CommonColors.disableColor),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 69,
                            padding: const EdgeInsets.all(5),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: const WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32)))),
                                  backgroundColor: WidgetStatePropertyAll(
                                      CommonColors.colorPrimary),
                                ),
                                onPressed: () {
                                  debugPrint(
                                      'Mobile No. -> ${usermobileController.value.text}');
                                  debugPrint(
                                      'Password -> ${passwordController.value.text}');
                                  checkUserAndPass();
                                },
                                child: Text(
                                  'Login'.toUpperCase(),
                                  style: TextStyle(color: CommonColors.white),
                                )),
                          ),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width,
                            height: 50,
                            child: Center(
                              child: Text(
                                "OR",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: CommonColors.disableColor),
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 69,
                            padding: const EdgeInsets.all(5),
                            child: OutlinedButton(
                                style: ButtonStyle(
                                  side: WidgetStatePropertyAll(
                                    BorderSide(
                                      color: CommonColors
                                          .colorPrimary!, // or any color you want
                                      width:
                                          1.5, // optional: thickness of the border
                                    ),
                                  ),
                                  shape: const WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(32),
                                      ),
                                    ),
                                  ),
                                  /* backgroundColor: WidgetStatePropertyAll(
                                      CommonColors.colorPrimary) */
                                ),
                                onPressed: () {
                                  if (isNullOrEmpty(
                                      usermobileController.text.toString())) {
                                    failToast('Please Enter Mobile Number');
                                    return;
                                  } else {
                                    authenticaionFlow =
                                        AuthenticationFlow.loginWithOtp;
                                    _validateUserMobile();
                                  }
                                },
                                child: Text(
                                  'Login with OTP'.toUpperCase(),
                                  style: TextStyle(
                                      color: CommonColors.colorPrimary!),
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: 69,
                            padding: const EdgeInsets.all(5),
                            child: OutlinedButton.icon(
                              style: ButtonStyle(
                                shape: const WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(32),
                                    ),
                                  ),
                                ),
                                side: WidgetStatePropertyAll(
                                  BorderSide(
                                    color: CommonColors
                                        .colorPrimary!, // Correct place for border color
                                    width: 1.5, // Optional: thickness
                                  ),
                                ),
                              ),
                              onPressed: () {
                                goOffline();
                              },
                              label: Text(
                                "Offline Mode",
                                style:
                                    TextStyle(color: CommonColors.colorPrimary),
                              ),
                              icon: Icon(
                                Icons.cloud_off,
                                color: CommonColors.colorPrimary,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Image.asset(
                width: 200,
                height: 50,
                'assets/poweredby.png',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showProgressBar() {
    if (isProgressBarShowing) {
      debugPrint("Progress Already Showing.");
    }
    setState(() {
      isProgressBarShowing = true;
    });
  }

  void hideProgressBar() {
    if (!isProgressBarShowing) {
      debugPrint("Progress Already Hidden.");
    }
    setState(() {
      isProgressBarShowing = false;
    });
  }

  void checkUserAndPass() {
    if (usermobileController.value.text.isEmpty &&
        passwordController.value.text.isEmpty) {
      failToast('Username and password is required');
      return;
    } else if (usermobileController.value.text.isEmpty) {
      failToast('Username is required');
      return;
    } else if (passwordController.value.text.isEmpty) {
      failToast('Password is required');
      return;
    } else if (usermobileController.value.text.length < 10) {
      failToast('Enter a valid mobile number');
      return;
    }
    userLogin();
  }

  void goOffline() {
    if (usermobileController.text.toString().isEmpty) {
      failToast("Please enter mobile number");
    } else if (usermobileController.text.toString().length != 10) {
      failToast("Please enter a valid mobile number");
    } else {
      Get.to(() => OfflinePasswordScreen(
          username: usermobileController.text.toString()));
    }
  }
}
