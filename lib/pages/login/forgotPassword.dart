import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:gtlmd/pages/login/models/UpdatePasswordModel.dart';
import 'package:gtlmd/pages/login/viewModel/loginViewModel.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  late LoadingAlertService loadingAlertService;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confimPasswordController = TextEditingController();
  LoginViewModel viewModel = LoginViewModel();
  late CommonUpdateModel updatePasswordModel = CommonUpdateModel();
// final authService = AuthenticationService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
        (_) => loadingAlertService = LoadingAlertService(context: context));
    setObservers();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setObservers() {
    viewModel.isErrorLiveData.stream.listen((errMsg) {
      failToast(errMsg);
    });
    viewModel.viewDialog.stream.listen((showLoading) {
      if (showLoading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }
    });
    viewModel.updatePasswordLiveData.stream.listen((updatepassword) {
      if (updatepassword == 1) {
        // validateUserLogin();
        Get.off(() => const LoginPage());
      } else {
        failToast("Something went wrong");
      }
    });

    viewModel.validateUserLoginLiveData.stream.listen((resp) {
      debugPrint(resp.toString());
      if (resp.commandstatus == 1) {
        // Get.off(HomeScreen());
        authService.login(context);
      } else {
        failToast(resp.commandmessage.toString() ?? "Something went wrong");
      }
      // hideProgressBar();
    });
  }

  void validateAndChangePassword() {
    if (newPasswordController.value.text == '') {
      failToast('Please provide a new password');
    } else if (confimPasswordController.value.text == '') {
      failToast('Please confirm password');
    } else if (newPasswordController.value.text !=
        confimPasswordController.value.text) {
      failToast('Confirm Password Not  Same As New Password.');
    } else {
      _UpdateUserPassword();
      // all conditions are satisfied, call the API to change password
    }
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

  Future<void> _UpdateUserPassword() async {
    Map<String, String> params = {
      "prmcompanyid": userCredsModel.companyid.toString(),
      "prmoldpassword": userCredsModel.userpassword.toString(),
      "prmnewpassword": newPasswordController.text,
      "prmusercode": userCredsModel.username.toString()
    };
    viewModel.UpdatePassword(params);
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        prefixIcon: const Icon(Icons.key_rounded),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ Let Scaffold adjust when keyboard opens
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        title: const Text(
          "Forgot Password",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: GestureDetector(
          onTap: () =>
              FocusScope.of(context).unfocus(), // tap outside to hide keyboard
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(
                    "assets/forgotPasswordIllustration.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 32),

                // 🔹 New Password Field
                _buildPasswordField(
                  controller: newPasswordController,
                  label: "New Password",
                ),
                const SizedBox(height: 20),

                // 🔹 Confirm Password Field
                _buildPasswordField(
                  controller: confimPasswordController,
                  label: "Confirm Password",
                ),
                const SizedBox(height: 40),

                // 🔹 Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CommonColors.colorPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                    onPressed: validateAndChangePassword,
                    child: const Text(
                      'UPDATE',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
