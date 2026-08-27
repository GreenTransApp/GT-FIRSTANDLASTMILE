import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/selectionBottomSheets/divisionSelection.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/login/forgotPassword.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:gtlmd/pages/login/viewModel/loginWithOtpProvider.dart';

class LoginWithOtp extends StatefulWidget {
  final String usermobileno;
  final UserCredsModel? userCreds;
  final AuthenticationFlow? flow;

  const LoginWithOtp({
    super.key,
    required this.usermobileno,
    this.userCreds,
    this.flow,
  });

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  late LoadingAlertService loadingAlertService;
  final TextEditingController first = TextEditingController();
  final TextEditingController second = TextEditingController();
  final TextEditingController third = TextEditingController();
  final TextEditingController fourth = TextEditingController();

  int _seconds = 119;
  Timer? _timer;
  bool _showButton = false;
  LoginWithOtpProvider? _otpProvider;

  @override
  void initState() {
    super.initState();
    loadingAlertService = LoadingAlertService(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _otpProvider = context.read<LoginWithOtpProvider>();
      _otpProvider?.clearStatus();
      _otpProvider?.addListener(_onStateChanged);
      _getLoginOtp();
    });
  }

  @override
  void dispose() {
    _otpProvider?.removeListener(_onStateChanged);
    _timer?.cancel();
    first.dispose();
    second.dispose();
    third.dispose();
    fourth.dispose();
    super.dispose();
  }

  void _getLoginOtp() {
    _resetAndStartTimer();
    debugPrint("_getLoginOtp called");
    final creds = widget.userCreds ?? userCredsModel;
    Map<String, String> params = {
      "prmcompanyid": creds.companyid.toString(),
      "prmmobileno": widget.usermobileno
    };
    context.read<LoginWithOtpProvider>().validateLoginWithOtp(params);
  }

  void _onVerifyPressed() {
    String otp = first.text + second.text + third.text + fourth.text;
    final provider = context.read<LoginWithOtpProvider>();

    if (otp.length < 4) {
      failToast('Please enter OTP Correctly');
      return;
    }

    if (otp != provider.otpResponse?.otp) {
      failToast("Entered OTP is Invalid, Please Try Again");
      return;
    }

    final activeFlow = widget.flow ?? authenticationFlow;
    if (activeFlow == AuthenticationFlow.forgotPassword) {
      _timer?.cancel();
      _timer = null;
      provider.clearStatus();
      Get.off(() =>
          Forgotpassword(userCreds: widget.userCreds ?? userCredsModel));
    } else {
      _userLogin();
    }
  }

  Future<void> _userLogin() async {
    String deviceId = await getDeviceId();
    final creds = widget.userCreds ?? userCredsModel;
    Map<String, String> params = {
      "prmusername": creds.username.toString(),
      "prmpassword": creds.userpassword.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.appVersionDate,
      "prmdeviceid": deviceId
    };
    context.read<LoginWithOtpProvider>().loginUser(params);
  }

  Future<void> _validateUserLogin() async {
    String deviceId = await getDeviceId();
    final creds = widget.userCreds ?? userCredsModel;
    Map<String, String> params = {
      "prmconstring": creds.companyid.toString(),
      "prmusername": creds.username.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdeviceid": deviceId
    };
    context.read<LoginWithOtpProvider>().validateUserForLogin(params);
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
    context.read<LoginWithOtpProvider>().validateDivision(params);
  }

  void _onStateChanged() {
    if (!mounted || _otpProvider == null) return;
    final status = _otpProvider!.status;
    final error = _otpProvider!.errorMessage;

    if (status == LoginWithOtpStatus.loading) {
      loadingAlertService.showLoading();
    } else {
      loadingAlertService.hideLoading();
    }

    if (status == LoginWithOtpStatus.error && error != null) {
      failToast(error);
      _otpProvider!.clearStatus();
    }

    if (status == LoginWithOtpStatus.validatedFromD2d) {
      final resp = _otpProvider!.loginResponse;
      if (resp != null) {
        LoginModel loginCredsModel =
            LoginModel(username: resp.username, password: resp.password);
        authService.storagePush(
            ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
        _validateUserLogin();
      }
    } else if (status == LoginWithOtpStatus.companyValidated) {
      final userResp = _otpProvider!.userResponse;
      if (userResp != null && userResp.commandstatus == 1) {
        _timer?.cancel();
        _timer = null;
        final creds = widget.userCreds ?? userCredsModel;
        if (savedLogin.divisionlogin != null &&
            savedLogin.divisionlogin == 'Y') {
          Map<String, String> params = {
            "prmcompanyid": creds.companyid.toString(),
            "prmbranchcode": userResp.loginbranchcode.toString(),
            "prmusername": userResp.username.toString(),
          };
          showDivisionSelectionBottomSheet(context, "Select Division",
              (division) {
            _validateDivision(
                creds.companyid.toString(),
                userResp.usercode.toString(),
                userResp.loginbranchcode.toString(),
                division.accdivisionid.toString(),
                userResp.sessionid.toString());
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
          _navigate();
        }
      }
    } else if (status == LoginWithOtpStatus.divisionValidated) {
      final divResp = _otpProvider!.divisionResponse;
      if (divResp != null && divResp.commandstatus == 1) {
        _navigate();
      } else if (divResp != null) {
        failToast(divResp.commandmessage ?? "Division validation failed");
      }
    }
  }

  void _navigate() {
    final activeFlow = widget.flow ?? authenticationFlow;
    switch (activeFlow) {
      case AuthenticationFlow.forgotPassword:
        _otpProvider?.clearStatus();
        Get.off(() =>
            Forgotpassword(userCreds: widget.userCreds ?? userCredsModel));
        break;
      case AuthenticationFlow.loginWithOtp:
        authService.login(context);
        break;
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        _timer?.cancel();
        setState(() {
          _showButton = true;
        });
      }
    });
  }

  void _resetAndStartTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _seconds = 119;
      _showButton = false;
    });
    _startTimer();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          resizeToAvoidBottomInset: false,
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
          body: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.extraLargeHorizontalPadding,
                  vertical: SizeConfig.extraLargeVerticalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: SizeConfig.verticalPadding),
                  Text(
                    'Enter OTP',
                    style: TextStyle(
                        fontSize: SizeConfig.largeTextSize,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: SizeConfig
                            .extraSmallTextSize, // smaller than heading
                        color: CommonColors.grey600,
                      ), // Default style
                      children: <TextSpan>[
                        const TextSpan(
                            text:
                                'Please Enter the verification code sent to '),
                        TextSpan(
                          text: widget.usermobileno,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CommonColors.appBarColor),
                        ),
                      ],
                    ),
                  ),
                  Image.asset(
                    'assets/images/infinitilogo.png',
                    width: SizeConfig.extraLargeRadius * 6.4,
                    height: SizeConfig.extraLargeRadius * 2.5,
                  ),
                  // SizedBox(height: SizeConfig.largeVerticalSpacing,),
                  Image.asset(
                    "assets/images/loginwithotpIllustration.png",
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    height: MediaQuery.sizeOf(context).height * 0.3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Enter OTP",
                            style: TextStyle(
                              color: CommonColors.grey600,
                            ),
                          ),
                          Text(
                            _formatTime(_seconds) == '00:00'
                                ? ''
                                : _formatTime(_seconds),
                            style: TextStyle(
                                color: CommonColors.colorPrimary!,
                                fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(width: SizeConfig.smallHorizontalSpacing),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _otpDigitField(first),
                          const SizedBox(width: 12),
                          _otpDigitField(second),
                          const SizedBox(width: 12),
                          _otpDigitField(third),
                          const SizedBox(width: 12),
                          _otpDigitField(fourth),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: _showButton ? _getLoginOtp : null,
                            child: RichText(
                              text: TextSpan(
                                style: TextStyle(
                                  fontSize: SizeConfig
                                      .extraSmallTextSize, // smaller than heading
                                  color: CommonColors.grey600,
                                  height: 1.4,
                                ), // Default style
                                children: <TextSpan>[
                                  const TextSpan(
                                      text: "Didn't receive OTP code? "),
                                  TextSpan(
                                    text: " Resend Code",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: _showButton
                                            ? CommonColors.colorPrimary
                                            : CommonColors.grey600),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.mediumVerticalSpacing,
                      ),
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)),
                              backgroundColor: CommonColors.colorPrimary2,
                            ),
                            onPressed: _onVerifyPressed,
                            child: const Text(
                              'Verify & Proceeds',
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }

  Widget _otpDigitField(TextEditingController controller) {
    return SizedBox(
      height: 70,
      width: 70,
      child: Center(
        child: TextFormField(
          autofocus: true,
          cursorColor: CommonColors.colorPrimary,
          cursorWidth: 1,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          decoration: InputDecoration(
            hintText: "*",
            hintStyle: TextStyle(color: CommonColors.grey300),
            filled: true,
            fillColor: CommonColors.white!,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: CommonColors.white!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: CommonColors.colorPrimary!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: CommonColors.white!),
            ),
            contentPadding: EdgeInsets.zero,
          ),
          controller: controller,
          style: Theme.of(context).textTheme.headlineSmall,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
      ),
    );
  }
}
