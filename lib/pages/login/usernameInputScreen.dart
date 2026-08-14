import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtlmd/api/HttpCalls.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/environment.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
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
    if (usernameController.text.contains(RegExp(r'[a-zA-Z]'))) {
      failToast("Please Enter Valid Mobile Number");
      return;
    }
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
        Get.to(() =>
            LoginWithOtp(usermobileno: usernameController.text.toString()));
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
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.extraLargeHorizontalPadding),
                      margin: EdgeInsets.symmetric(
                        // horizontal: MediaQuery.sizeOf(context).width * 0.01,
                        vertical: MediaQuery.sizeOf(context).height * 0.1,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Welcome Back!',
                            style: TextStyle(
                                fontSize: SizeConfig.largeTextSize,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                            softWrap: true,
                          ),
                          Text(
                            "Let's login for explore continues",
                            // "Don't worry! It happens. Please enter the mobile number "
                            // "associated with your account.",
                            style: TextStyle(
                              fontSize: SizeConfig
                                  .extraSmallTextSize, // smaller than heading
                              color: CommonColors.grey600,
                              height: 1.4,
                            ),
                            softWrap: true,
                          ),

                          const SizedBox(height: 12),
                          // Container(
                          //   height: 69,
                          //   margin: EdgeInsets.symmetric(
                          //       horizontal: MediaQuery.sizeOf(context).width * 0.1),
                          //   child: inputField(TextInputType.number, usernameController,
                          //       "username", null, null, true, 32),
                          // ),

                          Image.asset(
                            'assets/images/infinitilogo.png',
                            width: SizeConfig.extraLargeRadius * 6.9,
                            height: SizeConfig.extraLargeRadius * 2.9,
                          ),

                          Image.asset(
                            "assets/images/userInputIllustration.png",
                            width: MediaQuery.sizeOf(context).width * 0.7,
                            height: MediaQuery.sizeOf(context).height * 0.4,
                          ),
                          _buildFormField(
                            // label: 'Received By',
                            label: "Mobile Number",
                            isRequired: true,
                            icon: Icons.phone_android,
                            child: TextFormField(
                              cursorColor: CommonColors.colorPrimary,
                              controller: usernameController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              style: TextStyle(
                                  fontSize: SizeConfig.mediumTextSize),
                              decoration:
                                  _inputDecoration("Enter mobile  number", null
                                      // usernameController.text.isNotEmpty
                                      //     ? IconButton(
                                      //         icon: const Icon(Icons.clear),
                                      //         onPressed: () {
                                      //           usernameController.clear();
                                      //           setState(() {});
                                      //         },
                                      //       )
                                      //     : null,
                                      ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter mobile number';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            height: 50,
                            // margin: EdgeInsets.symmetric(
                            //     horizontal: MediaQuery.sizeOf(context).width * 0.1),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  backgroundColor: CommonColors.colorPrimary2,
                                ),
                                onPressed: () {
                                  if (usernameController.text.isEmpty) {
                                    failToast('Please enter mobile No.');
                                    // } else if (usernameController.text.length != 10) {
                                    //   failToast('Please provide a valid username');
                                  } else {
                                    _validateUserMobile();
                                  }
                                },
                                child: Text(
                                  'Submit',
                                  style: TextStyle(color: CommonColors.White),
                                )),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.sizeOf(context).height * 0.01),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Remember password? ",
                            style: TextStyle(fontSize: 16),
                          ),
                          InkWell(
                            onTap: () {
                              Get.off(() => const LoginPage());
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: CommonColors.colorPrimary),
                            ),
                          )
                        ],
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

  Widget _buildFormField({
    required String label,
    required bool isRequired,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                size: SizeConfig.mediumIconSize,
                color: const Color(0xFF64748B)),
            SizedBox(width: SizeConfig.smallHorizontalSpacing),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.w500,
                      color: CommonColors.darkCyanBlue!,
                    ),
                  ),
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: CommonColors.red!,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: SizeConfig.smallVerticalSpacing),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, IconButton? suffixIcon) {
    return InputDecoration(
      suffixIcon: suffixIcon,
      hintText: hint,
      hintStyle: TextStyle(
          color: CommonColors.grey400!, fontSize: SizeConfig.mediumTextSize),
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide:
            BorderSide(color: CommonColors.primaryColorShade!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1.5),
      ),
    );
  }
}
