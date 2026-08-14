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
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/models/loginModel.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';
import 'package:gtlmd/pages/login/viewModel/loginProvider.dart';

class LoginWithOtp extends StatefulWidget {
  final String usermobileno;

  const LoginWithOtp({super.key, required this.usermobileno});

  @override
  State<LoginWithOtp> createState() => _LoginWithOtpState();
}

class _LoginWithOtpState extends State<LoginWithOtp> {
  late LoadingAlertService loadingAlertService;
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController fourth = TextEditingController();

  int _seconds = 119;
  Timer? _timer;
  bool _showButton = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      _getLoginOtp();
    });
  }

  void _getLoginOtp() {
    _resetAndStartTimer();
    debugPrint("_getLoginOtp called");
    Map<String, String> params = {
      "prmcompanyid": userCredsModel.companyid.toString(),
      "prmmobileno": widget.usermobileno
    };
    context.read<LoginProvider>().validateLoginWithOtp(params);
  }

  void _onVerifyPressed() {
    String otp = first.text + second.text + third.text + fourth.text;
    final provider = context.read<LoginProvider>();

    if (otp.length < 4) {
      failToast('Please enter OTP Correctly');
      return;
    }

    if (otp != provider.otpResponse?.otp) {
      failToast("Entered OTP is Invalid, Please Try Again");
    } else {
      _userLogin();
    }
  }

  Future<void> _userLogin() async {
    String deviceId = await getDeviceId();
    Map<String, String> params = {
      "prmusername": userCredsModel.username.toString(),
      "prmpassword": userCredsModel.userpassword.toString(),
      "prmappversion": ENV.appVersion,
      "prmappversiondt": ENV.appVersionDate,
      "prmdevicedt": ENV.appVersionDate,
      // "prmdeviceid": getUuid()
      "prmdeviceid": deviceId
    };
    context.read<LoginProvider>().loginUser(params);
  }

  Future<void> _validateUserLogin() async {
    String deviceId = await getDeviceId();
    Map<String, String> params = {
      "prmconstring": userCredsModel.companyid.toString(),
      "prmusername": userCredsModel.username.toString(),
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

  void _handleStateChange(
      LoginStatus status, String? error, LoginProvider provider) {
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
      if (provider.otpResponse != null) {
        // OTP received, already handled in extracting logic if needed or just wait for it
        // Original code logged: extractLoginOtp(validateotpModel.smstext!)
      } else if (provider.loginResponse != null) {
        final resp = provider.loginResponse!;
        LoginModel loginCredsModel =
            LoginModel(username: resp.username, password: resp.password);
        authService.storagePush(
            ENV.loginCredsPrefTag, jsonEncode(loginCredsModel));
        _validateUserLogin();
      } else if (provider.userResponse != null) {
        if (provider.userResponse!.commandstatus == 1) {
          // final userResp = provider.userResponse!;
          // // Stop timer after successful validation
          _timer?.cancel();
          _timer = null;

          // // _navigate();
          // Map<String, String> params = {
          //   "prmcompanyid": savedLogin.companyid.toString(),
          //   "prmbranchcode": userResp.loginbranchcode.toString(),
          //   "prmusername": userResp.username.toString(),
          // };
          // provider
          //     .clearUserResponse(); // Clear to prevent repeated bottom sheet
          // showDivisionSelectionBottomSheet(context, "Select Division",
          //     (division) {
          //   // authService.login(context);
          //   _validateDivision(
          //       savedLogin.companyid.toString(),
          //       userResp.usercode.toString(),
          //       userResp.loginbranchcode.toString(),
          //       division.accdivisionid.toString(),
          //       userResp.sessionid.toString());
          //   provider.selectedDivision = division;
          // }, params);
          if (savedLogin.divisionlogin != null &&
              savedLogin.divisionlogin == 'Y') {
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
      } else if (provider.divisionResponse != null) {
        if (provider.divisionResponse!.commandstatus == 1) {
          authService.storagePush(
              ENV.divisionPrefTag, jsonEncode(provider.selectedDivision));
          savedUser.logindivisionid = provider.selectedDivision!.accdivisionid;
          savedUser.logindivisionname =
              provider.selectedDivision!.accdivisionname;
          // authService.login(context);
          provider
              .clearDivisionResponse(); // Clear to prevent repeated navigation
          _navigate();
        } else {
          failToast(provider.divisionResponse!.commandmessage ??
              "Division validation failed");
        }
      }
    }
  }

  void _navigate() {
    switch (authenticationFlow) {
      case AuthenticationFlow.forgotPassword:
        Get.off(() => const Forgotpassword());
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
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleStateChange(provider.status, provider.errorMessage, provider);
        });

        return Scaffold(
          // backgroundColor: ,
          resizeToAvoidBottomInset: false,
          // appBar: AppBar(
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back),
          //     color: CommonColors.white,
          //     onPressed: () => Get.back(),
          //   ),
          //   backgroundColor: CommonColors.colorPrimary,
          //   title: Text(
          //     'Enter OTP',
          //     style: TextStyle(color: CommonColors.white),
          //   ),
          //   elevation: 2,
          // ),
          body: SingleChildScrollView(
            child: Container(
                 width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: SizeConfig.extraLargeHorizontalPadding,
                      vertical: SizeConfig.extraLargeVerticalPadding
                      ),
                      margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.01,
                        // vertical: MediaQuery.sizeOf(context).height * 0.1,
                      ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Image.asset(
                  //   "assets/otpIllustration.png",
                  //   width: MediaQuery.sizeOf(context).width * 0.7,
                  //   height: MediaQuery.sizeOf(context).height * 0.4,
                  // ),
              
                               
                  Text(
                              'Enter OTP',
                              style: TextStyle(fontSize: SizeConfig.largeTextSize, color: Colors.black,fontWeight: FontWeight.bold),
                             softWrap: true,
                            ),
                  //  Text(
                  //     ""
                  //     "${widget.usermobileno}",
                  //     style: TextStyle(
                  //       fontSize: SizeConfig.extraSmallTextSize, // smaller than heading
                  //       color: CommonColors.grey600,
                  //       height: 1.4,
                  //     ),
                  //     ),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                                            fontSize: SizeConfig.extraSmallTextSize, // smaller than heading
                                            color: CommonColors.grey600,
                                            height: 1.4,
                                          ), // Default style
                          children:  <TextSpan>[
                            TextSpan(text: 'Please Enter the verification code sent to '),
                            TextSpan(
                              text: "${widget.usermobileno}", 
                              style: TextStyle(fontWeight: FontWeight.bold, color: CommonColors.appBarColor),
                            ),
                          
                          ],
                        ),
                      ),
                   Image.asset(
                        'assets/images/infinitilogo.png',
                        width: SizeConfig.extraLargeRadius * 6.9,
                        height: SizeConfig.extraLargeRadius * 2.9,
                      ),
                      // SizedBox(height: SizeConfig.largeVerticalSpacing,),
                     Image.asset(
                  "assets/images/loginwithotpIllustration.png",
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                                    ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                         Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                            Text("Enter OTP",style: TextStyle(  color: CommonColors.grey600,),),
                             Text(
                                  _formatTime(_seconds) == '00:00'
                                      ? ''
                                      : _formatTime(_seconds),
                                  style:  TextStyle(
                                      color: CommonColors.colorPrimary!, fontSize: 16),
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
                      
                       SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                     
                        InkWell(
                             onTap: _showButton ? _getLoginOtp : null,
                          child: RichText(
                                                text: TextSpan(
                          style: TextStyle(
                                            fontSize: SizeConfig.extraSmallTextSize, // smaller than heading
                                            color: CommonColors.grey600,
                                            height: 1.4,
                                          ), // Default style
                          children:  <TextSpan>[
                            TextSpan(text: "Didn't receive OTP code? "),
                            TextSpan(
                              text: " Resend Code", 
                              style:TextStyle(
                                fontSize: 16,
                                color: _showButton
                                    ? CommonColors.colorPrimary
                                    : CommonColors.grey600),
                            ),
                          
                          ],
                                                ),
                                              ),
                        ),
                         
                         
                      //       const Text(
                      //   "Didn't receive any sms? ",
                      //   style: TextStyle(fontSize: 16),
                      // ),
                      // InkWell(
                      //   onTap: _showButton ? _getLoginOtp : null,
                      //   child: Text(
                      //     "Resend Code",
                      //     style: TextStyle(
                      //         fontSize: 16,
                      //         color: _showButton
                      //             ? CommonColors.colorPrimary
                      //             : CommonColors.disabled),
                      //   ),
                      // )
                          
                        ],
                      ),
            SizedBox(height: SizeConfig.mediumVerticalSpacing,),
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
                  // Padding(
                  //   padding: EdgeInsets.symmetric(
                  //       vertical: MediaQuery.sizeOf(context).height * 0.01),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
            
                  //     children: [
                  //       const Text(
                  //         "Didn't receive any sms? ",
                  //         style: TextStyle(fontSize: 16),
                  //       ),
                  //       InkWell(
                  //         onTap: _showButton ? _getLoginOtp : null,
                  //         child: Text(
                  //           "Resend Code",
                  //           style: TextStyle(
                  //               fontSize: 16,
                  //               color: _showButton
                  //                   ? CommonColors.colorPrimary
                  //                   : CommonColors.disabled),
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          // persistentFooterButtons: [
          //   Container(
          //     width: double.infinity,
          //     height: 69,
          //     padding: const EdgeInsets.only(
          //         left: 20, right: 20, top: 12, bottom: 6),
          //     child: ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(32)),
          //           backgroundColor: CommonColors.colorPrimary,
          //         ),
          //         onPressed: _onVerifyPressed,
          //         child: const Text(
          //           'Verify',
          //           style: TextStyle(color: Colors.white),
          //         )),
          //   ),
          // ],
        );
      },
    );
  }

  Widget _otpDigitField(TextEditingController controller) {
    return SizedBox(
       height: 70,
      width: 70,
      child: Center(
        child: TextField(
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
