import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/profile/widgets/contactInfoCard.dart';
import 'package:gtlmd/pages/profile/widgets/profileCard.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> with WidgetsBindingObserver {
  //  final authService = AuthenticationService();
  logout() {
    commonAlertDialog(context, "ALERT!", "Are you sure you want to logout?", "",
        const Icon(Icons.logout), okayCallBack,
        cancelCallBack: cancelPopup);
  }

  okayCallBack() {
    Future.delayed(Duration.zero, () {
      /* Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false); */
      // Get.off(const LoginPage());
      // storageRemove(ENV.userPrefTag);
      // storageRemove(ENV.loginPrefTag);
      authService.logout(context);
    });
  }

  void cancelPopup() {
    // Navigator.pop(context);
    Get.back();
  }

  Widget signOut(bool isSmallDevice) {
    return InkWell(
      onTap: () {
        logout();
      },
      child: Container(
        padding: EdgeInsets.all(isSmallDevice ? 8.0 : 12.0),
        margin: EdgeInsets.symmetric(horizontal: isSmallDevice ? 8 : 12),
        decoration: BoxDecoration(
            color: CommonColors.white,
            border: Border.all(
                color: CommonColors.red!.withAlpha((0.2 * 255).round())),
            borderRadius: const BorderRadius.all(Radius.circular(12))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: CommonColors.red500,
              size: isSmallDevice ? 20 : 24,
            ),
            SizedBox(
              width: isSmallDevice ? 6 : 8,
            ),
            Text(
              "Sign Out",
              style: TextStyle(
                  color: CommonColors.red500,
                  fontSize: isSmallDevice ? 15 : 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Scaffold(
      backgroundColor: CommonColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.mediumHorizontalSpacing,
                vertical: SizeConfig.mediumVerticalSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfileCard(
                    context,
                    isNullOrEmpty(savedLogin.logoimage)
                        ? ''
                        : savedLogin.logoimage.toString(),
                    isSmallDevice),
                SizedBox(
                  height: SizeConfig.mediumVerticalSpacing,
                ),
                ContactInfoCard(context, isSmallDevice),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.paddingOf(context).bottom + 16,
          left: SizeConfig.horizontalPadding,
          right: SizeConfig.horizontalPadding,
        ),
        child: signOut(isSmallDevice),
      ),
    );
  }
}
