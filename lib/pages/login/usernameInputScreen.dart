import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/loadingAlertWithCancel.dart';
import 'package:gtlmd/common/toast.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:gtlmd/pages/login/loginWithOtp.dart';
import 'package:gtlmd/pages/login/models/enums.dart';
import 'package:gtlmd/pages/login/viewModel/forgotPasswordProvider.dart';
import 'package:gtlmd/pages/login/viewModel/loginWithOtpProvider.dart';
import 'package:provider/provider.dart';

class UsernameInputScreen extends StatefulWidget {
  final AuthenticationFlow? flow;

  const UsernameInputScreen({super.key, this.flow});

  @override
  State<UsernameInputScreen> createState() => _UsernameInputScreenState();
}

class _UsernameInputScreenState extends State<UsernameInputScreen> {
  late LoadingAlertService loadingAlertService;
  final TextEditingController usernameController = TextEditingController();

  ForgotPasswordProvider? _fpProvider;
  LoginWithOtpProvider? _otpProvider;

  @override
  void initState() {
    super.initState();
    loadingAlertService = LoadingAlertService(context: context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final activeFlow = widget.flow ?? authenticationFlow;
      if (activeFlow == AuthenticationFlow.forgotPassword) {
        _fpProvider = context.read<ForgotPasswordProvider>();
        _fpProvider?.clearError();
        _fpProvider?.addListener(_onStateChanged);
      } else {
        _otpProvider = context.read<LoginWithOtpProvider>();
        _otpProvider?.clearStatus();
        _otpProvider?.addListener(_onStateChanged);
      }
    });
  }

  @override
  void dispose() {
    _fpProvider?.removeListener(_onStateChanged);
    _otpProvider?.removeListener(_onStateChanged);
    usernameController.dispose();
    super.dispose();
  }

  void _onStateChanged() {
    if (!mounted) return;
    final activeFlow = widget.flow ?? authenticationFlow;

    if (activeFlow == AuthenticationFlow.forgotPassword &&
        _fpProvider != null) {
      final status = _fpProvider!.status;
      final error = _fpProvider!.errorMessage;

      if (status == ForgotPasswordStatus.loading) {
        loadingAlertService.showLoading();
      } else {
        loadingAlertService.hideLoading();
      }

      if (status == ForgotPasswordStatus.error && error != null) {
        failToast(error);
        _fpProvider!.clearError();
      }

      if (status == ForgotPasswordStatus.mobileValidated) {
        final creds = _fpProvider!.userCredsResponse;
        if (creds != null && creds.commandstatus == 1) {
          userCredsModel = creds;
          _fpProvider!.resetState();
          Get.to(() => LoginWithOtp(
                usermobileno: creds.usermobile.toString(),
                userCreds: creds,
                flow: activeFlow,
              ));
        } else if (creds != null) {
          failToast(creds.commandmessage ?? "Something went wrong");
        }
      }
    } else if (_otpProvider != null) {
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

      if (status == LoginWithOtpStatus.mobileValidated) {
        final creds = _otpProvider!.userCredsResponse;
        if (creds != null && creds.commandstatus == 1) {
          userCredsModel = creds;
          _otpProvider!.clearStatus();
          Get.to(() => LoginWithOtp(
                usermobileno: creds.usermobile.toString(),
                userCreds: creds,
                flow: activeFlow,
              ));
        } else if (creds != null) {
          failToast(creds.commandmessage ?? "Something went wrong");
        }
      }
    }
  }

  void _validateUserMobile() {
    if (usernameController.text.contains(RegExp(r'[a-zA-Z]'))) {
      failToast("Please Enter Valid Mobile Number");
      return;
    }
    debugPrint("Validating Device: ${usernameController.text}");
    Map<String, String> params = {
      "prmmobileno": usernameController.text.toString()
    };

    final activeFlow = widget.flow ?? authenticationFlow;
    if (activeFlow == AuthenticationFlow.forgotPassword) {
      context.read<ForgotPasswordProvider>().validateUserMobileFromD2D(params);
    } else {
      context.read<LoginWithOtpProvider>().validateUserMobileFromD2D(params);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: CommonColors.grey50,
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
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.verticalPadding,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.extraLargeVerticalPadding,
                    horizontal: SizeConfig.extraLargeHorizontalPadding),
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
                    Image.asset(
                      'assets/images/infinitilogo.png',
                      width: SizeConfig.extraLargeRadius * 6.6,
                      height: SizeConfig.extraLargeRadius * 2.4,
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
                        style: TextStyle(fontSize: SizeConfig.mediumTextSize),
                        decoration:
                            _inputDecoration("Enter mobile  number", null),
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
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: CommonColors.colorPrimary2,
                          ),
                          onPressed: () {
                            if (usernameController.text.isEmpty) {
                              failToast('Please enter mobile No.');
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
                            fontSize: 16, color: CommonColors.colorPrimary),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
