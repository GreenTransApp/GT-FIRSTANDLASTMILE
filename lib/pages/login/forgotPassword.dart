import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/login/loginPage.dart';

import 'package:gtlmd/pages/login/models/UserCredsModel.dart';
import 'package:gtlmd/pages/login/viewModel/forgotPasswordProvider.dart';
import 'package:provider/provider.dart';

class Forgotpassword extends StatefulWidget {
  final UserCredsModel? userCreds;
  const Forgotpassword({super.key, this.userCreds});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  late LoadingAlertService loadingAlertService;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confimPasswordController = TextEditingController();
  ForgotPasswordProvider? _provider;

  @override
  void initState() {
    super.initState();
    loadingAlertService = LoadingAlertService(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _provider = context.read<ForgotPasswordProvider>();
      _provider?.clearError();
      _provider?.addListener(_onStateChanged);
    });
  }

  @override
  void dispose() {
    _provider?.removeListener(_onStateChanged);
    newPasswordController.dispose();
    confimPasswordController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted || _provider == null) return;
    final status = _provider!.status;
    final error = _provider!.errorMessage;

    if (status == ForgotPasswordStatus.loading) {
      loadingAlertService.showLoading();
    } else {
      loadingAlertService.hideLoading();
    }

    if (status == ForgotPasswordStatus.error && error != null) {
      failToast(error);
      _provider!.clearError();
    }

    if (status == ForgotPasswordStatus.passwordUpdated) {
      if (_provider!.updatePasswordResponse == 1) {
        successToast("Password updated successfully");
        _provider!.resetState();
        Get.offAll(() => const LoginPage());
      }
    }
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
    final creds = widget.userCreds ?? userCredsModel;
    Map<String, String> params = {
      "prmcompanyid": creds.companyid.toString(),
      "prmoldpassword": creds.userpassword.toString(),
      "prmnewpassword": newPasswordController.text,
      "prmusercode": creds.username.toString()
    };
    context.read<ForgotPasswordProvider>().updatePassword(params);
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
          borderSide: BorderSide(color: CommonColors.grey300!),
        ),
        focusedBorder: OutlineInputBorder(
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
    return Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.transparent,
              image: DecorationImage(
                image: AssetImage('assets/images/loginFooter.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.extraLargeHorizontalPadding,
                    vertical: SizeConfig.extraLargeVerticalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: SizeConfig.verticalPadding),
                    Text(
                      'Create new password',
                      style: TextStyle(
                          fontSize: SizeConfig.largeTextSize,
                          color: CommonColors.appBarColor,
                          fontWeight: FontWeight.bold),
                      softWrap: true,
                    ),
                    Text(
                      "Your password must  be different from "
                      "previously used password.",
                      style: TextStyle(
                        fontSize: SizeConfig
                            .extraSmallTextSize, // smaller than heading
                        color: CommonColors.grey600,
                        // height: 1.4,
                      ),
                      softWrap: true,
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      'assets/images/infinitilogo.png',
                      width: SizeConfig.extraLargeRadius * 6.4,
                      height: SizeConfig.extraLargeRadius * 2.5,
                    ),
                    Image.asset(
                      "assets/images/forgotPasswordIllustration.png",
                      width: MediaQuery.sizeOf(context).width * 0.5,
                      height: MediaQuery.sizeOf(context).height * 0.3,
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
                    const SizedBox(height: 20),
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
  }
}
