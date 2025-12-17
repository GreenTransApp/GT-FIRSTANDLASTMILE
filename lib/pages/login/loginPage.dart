import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/login/loginWithOtp.dart';
import 'package:gtlmd/pages/login/models/companySelectionModel.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/viewModel/loginViewModel.dart';
import 'package:gtlmd/pages/offlineView/offlinePassword.dart';

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
      authService.storagePush(
          ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Background decorative circles
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      CommonColors.colorPrimary!,
                      CommonColors.colorPrimary!.withAlpha((0.8 * 255).toInt()),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -50,
              left: 50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      CommonColors.colorPrimary!.withAlpha((0.5 * 255).toInt()),
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      CommonColors.colorPrimary!,
                      CommonColors.colorPrimary!.withAlpha((0.7 * 255).toInt()),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: 100,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      CommonColors.colorPrimary!.withAlpha((0.4 * 255).toInt()),
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),
                        // Logo
                        Image.asset(
                          'assets/images/gtinfinitilogo.png',
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: 80,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Login To Your Account',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Phone Number Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: usermobileController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                              prefixIcon: Container(
                                margin: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: CommonColors.colorPrimary!,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.phone_android,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Password Field
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: isPasswordVisible,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.go,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
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
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                icon: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.grey[600],
                                  size: 20,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              if (isNullOrEmpty(
                                  usermobileController.text.toString())) {
                                failToast("Please Enter Mobile Number.");
                                return;
                              } else {
                                // authenticaionFlow = AuthenticationFlow.forgotPassword;
                                _validateUserMobile();
                              }
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: CommonColors.colorPrimary!,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: CommonColors.colorPrimary!,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () {
                              debugPrint(
                                  'Mobile No. -> ${usermobileController.value.text}');
                              debugPrint(
                                  'Password -> ${passwordController.value.text}');
                              checkUserAndPass();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Login with OTP and Offline Mode buttons in a row
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: CommonColors.colorPrimary!,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    if (isNullOrEmpty(
                                        usermobileController.text.toString())) {
                                      failToast('Please Enter Mobile Number');
                                      return;
                                    } else {
                                      // authenticaionFlow = AuthenticationFlow.loginWithOtp;
                                      _validateUserMobile();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'LOGIN WITH OTP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: Colors.grey[300]!,
                                      width: 1.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.grey[100],
                                  ),
                                  onPressed: () {
                                    goOffline();
                                  },
                                  icon: Icon(
                                    Icons.cloud_off_outlined,
                                    color: Colors.grey[700],
                                    size: 20,
                                  ),
                                  label: Text(
                                    'OFFLINE MODE',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
                // Powered by image at bottom
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Image.asset(
                    'assets/poweredby.png',
                    width: 180,
                    height: 45,
                  ),
                ),
              ],
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
