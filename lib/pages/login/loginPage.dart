import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/selectionBottomSheets/divisionSelection.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';

import 'package:gtlmd/pages/login/loginWithOtp.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/usernameInputScreen.dart';
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
  final TextEditingController usermobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  LoginProvider? _loginProvider;

  @override
  void initState() {
    super.initState();
    if (ENV.isDebugging) {
      usermobileController.text = ENV.debuggingUserName.toUpperCase();
      passwordController.text = ENV.debuggingPassword.toUpperCase();
    }
    loadingAlertService = LoadingAlertService(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loginProvider = context.read<LoginProvider>();
      _loginProvider?.resetState();
      _loginProvider?.addListener(_onStateChanged);
    });
  }

  @override
  void dispose() {
    _loginProvider?.removeListener(_onStateChanged);
    usermobileController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted || _loginProvider == null) return;
    final status = _loginProvider!.status;
    final error = _loginProvider!.errorMessage;

    if (status == LoginStatus.loading) {
      loadingAlertService.showLoading();
    } else {
      loadingAlertService.hideLoading();
    }

    if (status == LoginStatus.error && error != null) {
      failToast(error);
      _loginProvider!.clearError();
    }

    if (status == LoginStatus.validatedFromD2d) {
      final resp = _loginProvider!.loginResponse;
      if (resp != null) {
        LoginModel loginCredsModel =
            LoginModel(username: resp.username, password: resp.password);
        authService.storagePush(
            ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
        _validateUserLogin(resp.companyid.toString(), resp.username.toString());
      }
    } else if (status == LoginStatus.companyValidated) {
      final userResp = _loginProvider!.userResponse;
      if (userResp != null && userResp.commandstatus == 1) {
        if (savedLogin.divisionlogin != null &&
            savedLogin.divisionlogin == 'Y') {
          Map<String, String> params = {
            "prmcompanyid": savedLogin.companyid.toString(),
            "prmbranchcode": userResp.loginbranchcode.toString(),
            "prmusername": userResp.username.toString(),
          };

          showDivisionSelectionBottomSheet(context, "Select Division",
              (division) {
            _validateDivision(
                savedLogin.companyid.toString(),
                userResp.usercode.toString(),
                userResp.loginbranchcode.toString(),
                division.accdivisionid.toString(),
                userResp.sessionid.toString());
            _loginProvider!.selectedDivision = division;
          }, params);
        } else {
          Map<String, dynamic> divisiondata = {
            "accdivisionid": 0,
            "accdivisionname": "",
            "commandstatus": "1",
            "commandmessage": null
          };
          authService.storagePush(
              ENV.divisionPrefTag, jsonEncode(divisiondata));
          savedUser.logindivisionid = 0;
          savedUser.logindivisionname = "";
          authService.login(context);
        }
      }
    } else if (status == LoginStatus.divisionValidated) {
      final divResp = _loginProvider!.divisionResponse;
      if (divResp != null && divResp.commandstatus == 1) {
        if (_loginProvider!.selectedDivision != null) {
          authService.storagePush(ENV.divisionPrefTag,
              jsonEncode(_loginProvider!.selectedDivision));
          savedUser.logindivisionid =
              _loginProvider!.selectedDivision!.accdivisionid;
          savedUser.logindivisionname =
              _loginProvider!.selectedDivision!.accdivisionname;
        }
        authService.login(context);
      } else if (divResp != null) {
        failToast(divResp.commandmessage ?? "Division validation failed");
      }
    }
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
    }

    String deviceId = await getDeviceId();
    if (!mounted) return;

    Map<String, String> params = {
      "prmusername": usermobileController.text,
      "prmpassword": passwordController.text,
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.appVersionDate,
      "prmdeviceid": deviceId
    };

    context.read<LoginProvider>().loginUser(params);
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
      "prmsessionid": sessionid
    };
    context.read<LoginProvider>().validateDivision(params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 100, // Explicit height for the footer
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            // Use NetworkImage for testing, or AssetImage for local files
            image: AssetImage('assets/images/loginFooter.png'),
            fit: BoxFit
                .fill, // Ensures the image stretches to fill the container
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                        vertical: SizeConfig.verticalPadding,
                        horizontal: SizeConfig.horizontalPadding),
                    child: Column(
                      children: [
                        Text(
                          'Login To Account',
                          style: TextStyle(
                              fontSize: SizeConfig.largeTextSize,
                              color: CommonColors.appBarColor,
                              fontWeight: FontWeight.bold),
                          softWrap: true,
                        ),
                        Text(
                          "Sign in to continue to your account ",
                          style: TextStyle(
                            fontSize: SizeConfig
                                .extraSmallTextSize, // smaller than heading
                            color: CommonColors.grey600,
                            // height: 1.4,
                          ),
                          softWrap: true,
                        ),
                        // const SizedBox(height: 10),
                        // Image.asset(
                        //   'assets/images/infinitilogo.png',
                        //   width: SizeConfig.extraLargeRadius * 6.4,
                        //   height: SizeConfig.extraLargeRadius * 2.5,
                        // ),
                        Image.asset(
                          "assets/images/loginIllustration.png",
                          width: MediaQuery.sizeOf(context).width * 0.3,
                          height: MediaQuery.sizeOf(context).height * 0.3,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            // boxShadow: [
                            //   BoxShadow(
                            //     color: Colors.black.withOpacity(0.08),
                            //     blurRadius: 10,
                            //     offset: const Offset(0, 4),
                            //   ),
                            // ],
                          ),
                          child: TextField(
                            controller: usermobileController,
                            // keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Mobile Number or User Name',
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
                              border: const OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 16),
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
                        const SizedBox(height: 20),
                        // Password Field
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
                                  color: Colors.grey[300],
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
                        const SizedBox(height: 2),
                        // Forgot Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            // onPressed: () => _validateUserMobile(
                            //     AuthenticationFlow.forgotPassword),
                            onPressed: () {
                              authenticationFlow =
                                  AuthenticationFlow.forgotPassword;
                              Get.to(() => const UsernameInputScreen(
                                  flow: AuthenticationFlow.forgotPassword));
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: CommonColors.colorPrimary!,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Login Button
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
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    side: BorderSide(
                                      color: CommonColors.colorPrimary!,
                                      width: 2.0,
                                    ),
                                    backgroundColor: CommonColors.white!,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                                  onPressed: () {
                                    authenticationFlow =
                                        AuthenticationFlow.loginWithOtp;
                                    Get.to(() => const UsernameInputScreen(
                                        flow: AuthenticationFlow.loginWithOtp));
                                  },
                                  icon: const Icon(
                                    Icons.lock_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  label: Text(
                                    'LOGIN WITH OTP',
                                    style: TextStyle(
                                      color: CommonColors.colorPrimary,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(
                                      color: CommonColors.colorPrimary2,
                                      width: 2.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: CommonColors.white,
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
                                      color: CommonColors.colorPrimary2,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
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
                    "assets/poweredBy.png",
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

  void _goOffline() {
    if (usermobileController.text.isEmpty) {
      failToast("Please enter usrname to continue in offline mode");
    } else {
      Get.to(() => OfflinePasswordScreen(username: usermobileController.text));
    }
  }
}
