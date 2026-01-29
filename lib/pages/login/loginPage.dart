import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/selectionBottomSheets/divisionSelection.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/login/loginWithOtp.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/viewModel/loginProvider.dart';
import 'package:gtlmd/pages/offlineView/offlinePassword.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoadingAlertService loadingAlertService;
  TextEditingController usermobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    if (ENV.isDebugging) {
      usermobileController.text = ENV.debuggingUserName.toUpperCase();
      passwordController.text = ENV.debuggingPassword.toUpperCase();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      loadingAlertService = LoadingAlertService(context: context);

      // Clear any previous errors or state if needed
      context.read<LoginProvider>().resetState();
    });
  }

  Future<void> _onLoginPressed() async {
    if (usermobileController.text.isEmpty && passwordController.text.isEmpty) {
      failToast('Username and password are required');
      return;
    } else if (usermobileController.text.isEmpty) {
      failToast('Username required');
      return;
    } else if (passwordController.text.isEmpty) {
      failToast('Password required');
      return;
    } else if (usermobileController.text.length < 10) {
      failToast('Invalid Mobile Number');
      return;
    }

    String deviceId = await getDeviceId();
    if (!mounted) return;

    Map<String, String> params = {
      "prmusername": usermobileController.text,
      "prmpassword": passwordController.text,
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.appVersionDate,
      // "prmdeviceid": getUuid()
      "prmdeviceid": deviceId
    };

    context.read<LoginProvider>().loginUser(params);
  }

  void _validateUserMobile(AuthenticationFlow flow) {
    if (isNullOrEmpty(usermobileController.text)) {
      failToast("Please Enter User Mobile Number");
      return;
    }

    // Update the flow global variable as needed by existing app logic
    authenticationFlow = flow;

    Map<String, String> params = {"prmmobileno": usermobileController.text};
    context.read<LoginProvider>().validateUserMobileFromD2D(params);
  }

  void _handleStateChange(
      LoginStatus status, String? error, LoginProvider provider) {
    if (!mounted) return;
    if (status == LoginStatus.loading) {
      loadingAlertService.showLoading();
    } else {
      loadingAlertService.hideLoading();
    }

    if (status == LoginStatus.error && error != null) {
      failToast(error);
      provider.clearError();
    }

    if (status == LoginStatus.success) {
      // Handle navigation based on which action was performed
      if (provider.loginResponse != null) {
        final resp = provider.loginResponse!;
        LoginModel loginCredsModel =
            LoginModel(username: resp.username, password: resp.password);
        authService.storagePush(
            ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
        provider.clearLoginResponse();

        // Following original logic: validateUserLogin after successful login
        _validateUserLogin(resp.companyid.toString(), resp.username.toString());
      } else if (provider.userResponse != null) {
        if (provider.userResponse!.commandstatus == 1) {
          final userResp = provider.userResponse!;
          // authService.login(context);
          Map<String, String> params = {
            "prmcompanyid": savedLogin.companyid.toString(),
            "prmbranchcode": userResp.loginbranchcode.toString(),
            "prmusername": userResp.username.toString(),
          };
          provider.clearUserResponse();

          showDivisionSelectionBottomSheet(context, "Select Division",
              (division) {
            // authService.login(context);
            _validateDivision(
                savedLogin.companyid.toString(),
                userResp.usercode.toString(),
                userResp.loginbranchcode.toString(),
                division.accdivisionid.toString(),
                userResp.sessionid.toString());
            provider.selectedDivision = division;
          }, params);
        }
      } else if (provider.userCredsResponse != null) {
        if (provider.userCredsResponse!.commandstatus == 1) {
          userCredsModel = provider.userCredsResponse ?? userCredsModel;
          provider.clearUserCredsResponse();
          Get.to(() => LoginWithOtp(usermobileno: usermobileController.text));
        } else {
          failToast(provider.userCredsResponse!.commandmessage ??
              "Something went wrong");
        }
      } else if (provider.divisionResponse != null) {
        if (provider.divisionResponse!.commandstatus == 1) {
          authService.storagePush(
              ENV.divisionPrefTag, jsonEncode(provider.selectedDivision));
          savedUser.logindivisionid = provider.selectedDivision!.accdivisionid;
          savedUser.logindivisionname =
              provider.selectedDivision!.accdivisionname;
          provider.clearDivisionResponse();
          authService.login(context);
        } else {
          failToast(provider.divisionResponse!.commandmessage ??
              "Division validation failed");
        }
      }
    }
  }

  Future<void> _validateUserLogin(
      String companyIdVal, String usernameVal) async {
    String deviceId = await getDeviceId();
    if (!mounted) return;
    Map<String, String> params = {
      "prmconstring": companyIdVal,
      "prmusername": usernameVal,
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      // "prmdeviceid": getUuid()
      "prmdeviceid": deviceId
    };
    context.read<LoginProvider>().validateUserForLogin(params);
  }

  Future<void> _validateDivision(String companyId, String usercode,
      String branchcode, String divisionid, String sessionid) async {
    Map<String, String> params = {
      "connstring": companyId,
      "prmusercode": usercode,
      "prmbranchcode": branchcode,
      "prmdivisionid": divisionid,
      // "prmdeviceid": getUuid()
      "prmsessionid": sessionid
    };
    context.read<LoginProvider>().validateDivision(params);
  }

  @override
  Widget build(BuildContext context) {
    // Listen to provider changes for navigation and toasts
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        // We use a post frame callback or a listener to handle navigation/toasts
        // But for simplicity in this refactor, we can handle it here or in a multi-listener

        // Using a scheduler to handle effects
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleStateChange(provider.status, provider.errorMessage, provider);
        });

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: [
                // Background decorative circles (kept as is)
                Positioned(
                  top: -100,
                  left: -100,
                  child: Container(
                    width: 230,
                    height: 230,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          CommonColors.colorPrimary!,
                          CommonColors.colorPrimary!
                              .withAlpha((0.8 * 255).toInt()),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: -50,
                  left: 50,
                  child: Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CommonColors.colorPrimary!
                          .withAlpha((0.5 * 255).toInt()),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -120,
                  right: -100,
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          CommonColors.colorPrimary!,
                          CommonColors.colorPrimary!
                              .withAlpha((0.7 * 255).toInt()),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  right: 50,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: CommonColors.colorPrimary!
                          .withAlpha((0.4 * 255).toInt()),
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
                              'assets/icon.png',
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
                                  hintText: 'Mobile Number',
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
                                obscureText: !isPasswordVisible,
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
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
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
                                onPressed: () => _validateUserMobile(
                                    AuthenticationFlow.forgotPassword),
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
                                onPressed: _onLoginPressed,
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
                                        backgroundColor:
                                            CommonColors.colorPrimary!,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        elevation: 0,
                                      ),
                                      onPressed: () => _validateUserMobile(
                                          AuthenticationFlow.loginWithOtp),
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
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        backgroundColor: Colors.grey[100],
                                      ),
                                      onPressed: _goOffline,
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
                        'assets/poweredBy.png',
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
      },
    );
  }

  void _goOffline() {
    if (usermobileController.text.isEmpty) {
      failToast("Please enter mobile number");
    } else if (usermobileController.text.length != 10) {
      failToast("Please enter a valid mobile number");
    } else {
      Get.to(() => OfflinePasswordScreen(username: usermobileController.text));
    }
  }
}
