import 'package:flutter/material.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/login/forgotPassword.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:gtlmd/pages/login/loginWithOtp.dart';
import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:get/get.dart';
// import 'package:gtlmd/pages/login/viewModel/loginViewModel.dart';

import 'package:provider/provider.dart';
import 'package:gtlmd/pages/login/viewModel/loginProvider.dart';

class UsernameInputScreen extends StatefulWidget {
  const UsernameInputScreen({super.key});

  @override
  State<UsernameInputScreen> createState() => _UsernameInputScreenState();
}

class _UsernameInputScreenState extends State<UsernameInputScreen> {
  late LoadingAlertService loadingAlertService;
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (ENV.isDebugging) {
      usernameController.text = ENV.debuggingUserName.toUpperCase();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      context.read<LoginProvider>().clearError();
    });
  }

  void _validateUserMobile() {
    debugPrint("Validating Device: ${usernameController.text}");
    Map<String, String> params = {"prmmobileno": usernameController.text};
    context.read<LoginProvider>().validateUserMobileFromD2D(params);
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
      if (provider.userCredsResponse != null &&
          provider.userCredsResponse!.commandstatus == 1) {
        userCredsModel = provider.userCredsResponse!;
        Get.to(() => LoginWithOtp(usermobileno: usernameController.text));
      } else if (provider.userCredsResponse != null) {
        failToast(provider.userCredsResponse!.commandmessage ??
            "Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleStateChange(provider.status, provider.errorMessage, provider);
        });

        return Scaffold(
          body: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width * 0.01,
                vertical: MediaQuery.sizeOf(context).height * 0.1,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Enter username:',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 69,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.1),
                    child: inputField(TextInputType.number, usernameController,
                        "username", null, null, true, 32),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    height: 69,
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width * 0.1),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          backgroundColor: CommonColors.colorPrimary,
                        ),
                        onPressed: () {
                          if (usernameController.text.isEmpty) {
                            failToast('Please provide the username');
                          } else if (usernameController.text.length != 10) {
                            failToast('Please provide a valid username');
                          } else {
                            _validateUserMobile();
                          }
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(color: CommonColors.White),
                        )),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
