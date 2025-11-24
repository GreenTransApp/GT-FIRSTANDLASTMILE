import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';

import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/environment.dart';

import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/pages/home/homeScreenPage.dart';
import 'package:gtlmd/pages/login/loginPage.dart';
import 'package:get/get.dart';
import 'package:gtlmd/pages/profile/widgets/contactInfoCard.dart';
import 'package:gtlmd/pages/profile/widgets/profileCard.dart';
import 'package:gtlmd/service/authenticationService.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CommonColors.white,
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
            onPressed: () {
              Get.off(HomeScreen());
            },
            icon: Icon(
              Icons.arrow_back,
              color: CommonColors.white,
            )),
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          "Profile",
          style: TextStyle(color: CommonColors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ProfileCard(
                  context,
                  isNullOrEmpty(savedLogin.logoimage)
                      ? ''
                      : savedLogin.logoimage.toString()),
              const SizedBox(
                height: 50,
              ),
              ContactInfoCard(context),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [
        InkWell(
          onTap: () {
            logout();
          },
          child: Container(
            padding: const EdgeInsets.all(12.0),
            margin: const EdgeInsets.symmetric(horizontal: 12),
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
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  "Sign Out",
                  style: TextStyle(color: CommonColors.red500, fontSize: 18),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
