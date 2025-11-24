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
import 'package:gtlmd/pages/login/viewModel/loginViewModel.dart';

class UsernameInputScreen extends StatefulWidget {
  const UsernameInputScreen({super.key});

  @override
  State<UsernameInputScreen> createState() => _UsernameInputScreenState();
}

class _UsernameInputScreenState extends State<UsernameInputScreen> {
  // late UserCredsModel userCredsModel = UserCredsModel();
  LoginViewModel viewModel = LoginViewModel();
  late LoadingAlertService loadingAlertService;
  TextEditingController usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (ENV.isDebugging) {
      usernameController.text = ENV.debuggingUserName.toUpperCase();
    }
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
  }

  void _validateUserMobile() {
    debugPrint("Validating Device: ${usernameController.value.text}");

    Map<String, String> params = {"prmmobileno": usernameController.value.text};
    viewModel.validateUserMobileFromD2D(params);
  }

  setObservers() {
    viewModel.userCredsLiveData.stream.listen((userCreds) {
      if (userCreds.commandstatus == 1) {
        userCredsModel = userCreds;
        Get.to(() => LoginWithOtp(usermobileno: usernameController.value.text));
      } else {
        failToast(
            userCreds.commandmessage.toString() ?? "Something went wrong");
      }
    });

    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });
    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width * 0.01,
            vertical: MediaQuery.sizeOf(context).height * 0.1,
          ),
          child: Column(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter username:',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
              Container(
                height: 69,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.1),
                child: inputField(TextInputType.number, usernameController,
                    "username", null, null, true, 32),
              ),
              Container(
                width: double.infinity,
                height: 69,
                margin: EdgeInsets.symmetric(
                    horizontal: MediaQuery.sizeOf(context).width * 0.1),
                child: ElevatedButton(
                    style: ButtonStyle(
                      shape: const WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                      backgroundColor:
                          WidgetStatePropertyAll(CommonColors.colorPrimary),
                    ),
                    onPressed: () => {
                          if (usernameController.value.text.isEmpty)
                            {
                              // navigate()
                              failToast('Please provide the username')
                            }
                          else if (usernameController.value.text.length != 10)
                            {failToast('Please provide a valid username')}
                          else
                            {_validateUserMobile()}
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
  }
}
