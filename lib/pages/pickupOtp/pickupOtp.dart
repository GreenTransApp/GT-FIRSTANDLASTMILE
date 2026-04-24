import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/login/models/ValidateLoginWithOtpModel.dart';
import 'package:gtlmd/pages/pickupOtp/pickupOtpViewModel.dart';

class PickupOtp extends StatefulWidget {
  const PickupOtp({super.key});

  @override
  State<PickupOtp> createState() => _PickupOtpState();
}

class _PickupOtpState extends State<PickupOtp> {
  late LoadingAlertService loadingAlertService;
  TextEditingController first = TextEditingController();
  TextEditingController second = TextEditingController();
  TextEditingController third = TextEditingController();
  TextEditingController fourth = TextEditingController();

  PickupOtpViewModel viewModel = PickupOtpViewModel();
  ValidateLoginwithOtpModel otpModel = ValidateLoginwithOtpModel();

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

    setObservers();
  }

  setObservers() {
    viewModel.validateOtp.stream.listen((model) {
      otpModel = model;
    });

    viewModel.isLoading.stream.listen((isLoading) {
      if (isLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });

    viewModel.isErrorLiveData.stream.listen((error) {
      failToast(error);
    });
  }

  void _getLoginOtp() {
    _resetAndStartTimer();
    debugPrint("_getLoginOtp called");
    Map<String, String> params = {
      "prmcompanyid": savedUser.companyid.toString(),
      "prmmobileno": savedUser.mobileno.toString()
    };
    viewModel.validateLoginWithOtp(params);
  }

  void _onVerifyPressed() {
    String otp = first.text + second.text + third.text + fourth.text;

    if (otp.length < 4) {
      failToast('Please enter OTP Correctly');
      return;
    }

    if (otp != otpModel.otp) {
      failToast("Entered OTP is Invalid, Please Try Again");
    } else {
      Get.back();
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: CommonColors.white,
          onPressed: () => Get.back(),
        ),
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'Enter OTP',
          style: TextStyle(color: CommonColors.white),
        ),
        elevation: 2,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
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
                      Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery.sizeOf(context).width * 0.1),
                        child: Text(
                          _formatTime(_seconds) == '00:00'
                              ? ''
                              : _formatTime(_seconds),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
                  onTap: _showButton ? _getLoginOtp : null,
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                        fontSize: 16,
                        color: _showButton
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
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                backgroundColor: CommonColors.colorPrimary,
              ),
              onPressed: _onVerifyPressed,
              child: const Text(
                'Verify',
                style: TextStyle(color: Colors.white),
              )),
        ),
      ],
    );
  }

  Widget _otpDigitField(TextEditingController controller) {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        shape: BoxShape.circle,
      ),
      child: Center(
        child: TextField(
          cursorColor: CommonColors.colorPrimary,
          cursorWidth: 1,
          onChanged: (value) {
            if (value.length == 1) {
              FocusScope.of(context).nextFocus();
            }
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.blueGrey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.blueGrey[100]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.blueGrey[100]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(color: Colors.blueGrey[100]!),
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
