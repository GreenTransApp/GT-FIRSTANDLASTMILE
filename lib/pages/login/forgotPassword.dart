import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/login/loginPage.dart';

import 'package:provider/provider.dart';
import 'package:gtlmd/pages/login/viewModel/loginProvider.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  late LoadingAlertService loadingAlertService;
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confimPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingAlertService = LoadingAlertService(context: context);
      context.read<LoginProvider>().clearError();
    });
  }

  void validateAndChangePassword() {
    if (newPasswordController.text.isEmpty) {
      failToast('Please provide a new password');
    } else if (confimPasswordController.text.isEmpty) {
      failToast('Please confirm password');
    } else if (newPasswordController.text != confimPasswordController.text) {
      failToast('Confirm Password Not Same As New Password.');
    } else {
      _updateUserPassword();
    }
  }

  void _updateUserPassword() {
    Map<String, String> params = {
      "prmcompanyid": userCredsModel.companyid.toString(),
      "prmoldpassword": userCredsModel.userpassword.toString(),
      "prmnewpassword": newPasswordController.text,
      "prmusercode": userCredsModel.username.toString()
    };
    context.read<LoginProvider>().updatePassword(params);
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
      if (provider.updatePasswordResponse == 1) {
        Get.off(() => const LoginPage());
      }
    }
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
        suffixIcon: const Icon(Icons.lock_outline),
        enabledBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
        focusedBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _handleStateChange(provider.status, provider.errorMessage, provider);
        });

        return Scaffold(
          resizeToAvoidBottomInset: true,
          // appBar: AppBar(
          //   backgroundColor: CommonColors.colorPrimary,
          //   title: const Text(
          //     "Forgot Password",
          //     style:
          //         TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          //   ),
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back, color: Colors.white),
          //     onPressed: () => Navigator.pop(context),
          //   ),
          // ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding:
                     EdgeInsets.symmetric(horizontal:SizeConfig.extraLargeHorizontalPadding , vertical: SizeConfig.extraLargeVerticalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   height: MediaQuery.of(context).size.height * 0.3,
                    //   child: Image.asset(
                    //     "assets/forgotPasswordIllustration.png",
                    //     fit: BoxFit.contain,
                    //   ),
                    // ),
                      Text(
                          'Create new password',
                          style: TextStyle(fontSize: SizeConfig.largeTextSize, color: CommonColors.appBarColor,fontWeight: FontWeight.bold),
                         softWrap: true,
                        ),
                        Text(
                  "Your password must  be different from "
                  "previously used password.",
                  style: TextStyle(
                    fontSize: SizeConfig.extraSmallTextSize, // smaller than heading
                    color: CommonColors.grey600,
                    height: 1.4,
                  ),
                  softWrap: true,
                              ),
                    const SizedBox(height: 32),
                     Image.asset(
                        'assets/images/infinitilogo.png',
                        width: SizeConfig.extraLargeRadius * 6.9,
                        height: SizeConfig.extraLargeRadius * 2.9,
                      ),
                      Image.asset(
                  "assets/images/forgotPasswordIllustration.png",
                  width: MediaQuery.sizeOf(context).width * 0.7,
                  height: MediaQuery.sizeOf(context).height * 0.4,
                                    ),
                     
                    _buildPasswordField(
                      controller: newPasswordController,
                      label: "New Password",
                    ),
                    const SizedBox(height: 20),
                    _buildPasswordField(
                      controller: confimPasswordController,
                      label: "Confirm Password",
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CommonColors.colorPrimary2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: validateAndChangePassword,
                        child: const Text(
                          'Save',
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
      },
    );
  }
}
