import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/home/homeScreenPage.dart';
import 'package:gtlmd/pages/login/forgotPassword.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginCredsModel.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:gtlmd/pages/login/viewModel/loginViewModel.dart';
import 'package:get/get.dart';
import 'package:gtlmd/service/authenticationService.dart';

class LoginWithOtp extends StatefulWidget {
  late String usermobileno;
  int _seconds = 119;
  Timer? _timer;
  bool _showButton = false;

  LoginWithOtp({super.key, required this.usermobileno});

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  final LoginViewModel viewModel = LoginViewModel();
  late LoadingAlertService loadingAlertService;
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController fourth = TextEditingController();
  late ValidateLoginwithOtpModel validateotpModel = ValidateLoginwithOtpModel();
// final authService = AuthenticationService();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
    _getLoginOtp();
  }

  setObservers() {
    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.validateOtpLiveData.stream.listen((validate) {
      validateotpModel = validate;
      if (validateotpModel.commandstatus == 1) {
        debugPrint("OTP is: ${extractLoginOtp(validateotpModel.smstext!)}");
      } else {
        debugPrint("command status is: ${validateotpModel.commandstatus}");
      }
    });

    viewModel.validateUserLoginLiveData.stream.listen((resp) {
      debugPrint(resp.toString());
      if (resp.commandstatus == 1) {
        // hideProgressBar();
        // Get.to(HomeScreen());
        navigate();
      } else {
        failToast(resp.commandmessage ?? "Something went wrong");
      }
      // hideProgressBar();
    });
    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });

    viewModel.loginResponseLiveData.stream.listen((resp) {
      debugPrint('Login resp live data');
      LoginModel loginCredsModel =
          LoginModel(username: resp.username, password: resp.password);
      authService.storagePush(
          ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
      companyId = savedLogin.companyid.toString();
      validateUserLogin();
    });
  }

  void _getLoginOtp() {
    // failToast('data not found');
    _resetAndStartTimer();
    debugPrint("_getLoginOtp called");
    Map<String, String> params = {
      "prmcompanyid": userCredsModel.companyid.toString(),
      // "prmusercode": widget.usermobileno,
      "prmmobileno": userCredsModel.username.toString()
    };
    debugPrint("Validating Device: ");

    viewModel.validateLoginWithOtp(params);
    _startTimer();
  }

  String extractLoginOtp(String text) {
    // Use a regular expression to find the OTP.
    RegExp regExp = RegExp(r'OTP\s*for\s*login\s*is\s*(\d+)');
    Match? match = regExp.firstMatch(text);

    if (match != null) {
      return match.group(1)!; // Return the captured OTP.
    } else {
      return ''; // Return an empty string if OTP is not found.
    }
  }

  Future<void> userLogin() async {
    Map<String, String> params = {
      "prmusername": userCredsModel.username.toString(),
      "prmpassword": userCredsModel.userpassword.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.appVersionDate,
      "prmdeviceid": getUuid()
    };
    viewModel.loginUser(params);
  }

  void validateUserLogin() {
    Map<String, String> params = {
      "prmconstring": userCredsModel.companyid.toString(),
      "prmusername": userCredsModel.username.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdeviceid": getUuid()
    };
    viewModel.validateUserForLogin(params);
  }

  void validateEnteredOtp() {
    String otp = '';
    otp += first.value.text;
    otp += second.value.text;
    otp += third.value.text;
    otp += fourth.value.text;
    debugPrint('OTP -> $otp');
    if (otp != validateotpModel.otp) {
      failToast("Entered OTP is Invalid,Please Try Again");
    } else {
      // navigate();
      // validateUserLogin();
      userLogin();
    }
  }

  navigate() {
    switch (authenticaionFlow) {
      case AuthenticationFlow.forgotPassword:
        // Get.to(const Forgotpassword());
        Get.off(const Forgotpassword());
      case AuthenticationFlow.loginWithOtp:
        // Get.off(HomeScreen());
        // Navigator.pushAndRemoveUntil(
        //     context,
        //     MaterialPageRoute(builder: (context) => HomeScreen()),
        //     (route) => false);
        authService.login(context);
    }
  }

  void _startTimer() {
    widget._timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget._seconds > 0) {
        setState(() {
          widget._seconds--;
        });
      } else {
        widget._timer?.cancel(); // Cancel the timer
        setState(() {
          widget._showButton = true;
        });
      }
    });
  }

  void _resetAndStartTimer() {
    widget._timer?.cancel(); // Cancel existing timer before starting a new one
    widget._timer = null;
    setState(() {
      widget._seconds = 119;
      widget._showButton = false;
    });
    _startTimer();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    super.dispose();
    widget._timer?.cancel();
    widget._timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: CommonColors.white,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'Enter OTP',
          style: TextStyle(color: CommonColors.white),
        ),
        elevation: 2,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 12,
        children: [
          // Container(
          //   decoration: BoxDecoration(
          //       image: const DecorationImage(
          //         image: AssetImage('assets/icon.png'),
          //         fit: BoxFit.cover,
          //       ),
          //       borderRadius: const BorderRadius.all(
          //         Radius.circular(12),
          //       ),
          //       border: Border.all(
          //         color: CommonColors.colorPrimary!,
          //       )),
          //   margin: EdgeInsets.symmetric(
          //       horizontal: MediaQuery.sizeOf(context).width * 0.04,
          //       vertical: MediaQuery.sizeOf(context).height * 0.02),
          //   padding: const EdgeInsets.all(4),
          //   width: MediaQuery.sizeOf(context).width,
          //   height: 150,
          // ),
          Image.asset(
            "assets/otpIllustration.png",
            width: MediaQuery.sizeOf(context).width * 0.7,
            height: MediaQuery.sizeOf(context).height * 0.4,
          ),

          Expanded(
            child: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    spacing: 12,
                    children: [
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100], // background color
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: TextField(
                            cursorColor: CommonColors.colorPrimary,
                            cursorWidth: 1,
                            onChanged: (value) {
                              debugPrint('Value changed for 1: $value');
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } /* else if (value.length == 0) {
                            FocusScope.of(context).previousFocus();
                          } */
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blueGrey[100],
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                            ),
                            controller: first,
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100]!, // background color
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: CommonColors.colorPrimary,
                            onChanged: (value) {
                              debugPrint('Value changed for 2: $value');
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } /* else if (value.length == 0) {
                                FocusScope.of(context).previousFocus();
                              } */
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blueGrey[100],
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                            ),
                            controller: second,
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100]!, // background color
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: CommonColors.colorPrimary,
                            onChanged: (value) {
                              debugPrint('Value changed for 3: $value');
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              } /* else if (value.length == 0) {
                                FocusScope.of(context).previousFocus();
                              } */
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blueGrey[100],
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                            ),
                            controller: third,
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 65,
                        width: 65,
                        decoration: BoxDecoration(
                          color: Colors.blueGrey[100]!, // background color
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: TextField(
                            cursorWidth: 1,
                            cursorColor: CommonColors.colorPrimary,
                            onChanged: (value) {
                              /* if (value.length == 1) {
                            FocusScope.of(context).nextFocus();
                          } else  */
                              debugPrint('Value changed for 4: $value');
                              /* if (value.length == 0) {
                                FocusScope.of(context).previousFocus();
                              } else */
                              if (value.length == 1) {
                                FocusScope.of(context).nextFocus();
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blueGrey[100],
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(32)),
                                borderSide:
                                    BorderSide(color: Colors.blueGrey[100]!),
                              ),
                            ),
                            controller: fourth,
                            style: Theme.of(context).textTheme.headlineSmall,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(1),
                              FilteringTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: MediaQuery.sizeOf(context).width * 0.1),
                        child: Text(
                          _formatTime(widget._seconds) == '00:00'
                              ? ''
                              : _formatTime(widget._seconds),
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     Container(
          //       margin: EdgeInsets.symmetric(
          //           horizontal: MediaQuery.sizeOf(context).width * 0.2),
          //       child: Text(
          //         _formatTime(widget._seconds) == '00:00'
          //             ? ''
          //             : _formatTime(widget._seconds),
          //         style: TextStyle(color: Colors.black, fontSize: 16),
          //       ),
          //     ),
          //   ],
          // ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.sizeOf(context).height * 0.01),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Didn't receive any sms? ",
                  style: TextStyle(fontSize: 16),
                ),
                InkWell(
                  onTap: () => {
                    setState(() {
                      if (widget._showButton) {
                        // _resetAndStartTimer();
                        _getLoginOtp();
                      }
                    })
                  },
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                        fontSize: 16,
                        color: widget._showButton == true
                            ? CommonColors.colorPrimary
                            : CommonColors.disabled),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Container(
          width: double.infinity,
          height: 69,
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 6),
          child: ElevatedButton(
              style: ButtonStyle(
                shape: const WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)))),
                backgroundColor:
                    WidgetStatePropertyAll(CommonColors.colorPrimary),
              ),
              onPressed: () {
                if (first.value.text.isEmpty ||
                    second.value.text.isEmpty ||
                    third.value.text.isEmpty ||
                    fourth.value.text.isEmpty) {
                  failToast('Please enter OTP Correctly');
                } else {
                  validateEnteredOtp();
                }
              },
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }
}
