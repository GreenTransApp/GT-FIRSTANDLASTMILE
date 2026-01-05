import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/navDrawer/navDrawerModel.dart';
import 'package:gtlmd/navigateRoutes/Routes.dart';
import 'package:gtlmd/navigateRoutes/RoutesName.dart';
import 'package:gtlmd/pages/attendance/attendanceScreen.dart';
import 'package:gtlmd/optionMenu/tripMis/tripMis.dart';
import 'package:gtlmd/pages/trips/closeTrip/closeTrip.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallDevice = screenWidth <= 360;
    // final authService = AuthenticationService();

    void _logout(BuildContext context) {
      authService.storageClear();
      Routes.goToPage(RoutesName.login, "Login");
    }

    void _updateScreen(BuildContext context) {
      authService.storageClear();
      Routes.goToPage(RoutesName.update, "Update");
    }

    okayCallBack() {
      Future.delayed(Duration.zero, () {
        // Get.off(const LoginPage());
        // authService.storageRemove(ENV.userPrefTag);
        // authService.storageRemove(ENV.loginPrefTag);
        authService.logout(context);
      });
    }

    void cancelPopup() {
      // Navigator.pop(context);
      Get.back();
    }

    logout() {
      commonAlertDialog(context, "ALERT!", "Are you sure you want to logout?",
          "", const Icon(Icons.logout), okayCallBack,
          cancelCallBack: cancelPopup);
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              child: Container(
            decoration: BoxDecoration(
                color: CommonColors.colorPrimary,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ListTile(
              leading: CircleAvatar(
                radius: isSmallDevice ? 22 : 25,
                backgroundColor: CommonColors.dangerColor,
                child: Image.network(
                  savedLogin.logoimage.toString(),
                  errorBuilder: (context, error, stackTrace) {
                    return CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/images/defaultimage.png"),
                      radius: isSmallDevice ? 30 : 35,
                    );
                  },
                  fit: BoxFit.fill,
                ),
              ),

//  CircleAvatar(
//                 backgroundImage: AssetImage(
//                    ),
//                 radius: 40,
//               ),
              title: Text(
                savedLogin.compname ?? "Data Not Found",
                style: TextStyle(
                    color: CommonColors.white,
                    fontSize: isSmallDevice ? 14 : 16),
              ),
              subtitle: Text(savedUser.username ?? "Data Not Found",
                  style: TextStyle(
                      color: CommonColors.white,
                      fontSize: isSmallDevice ? 12 : 14)),
            ),
          )),
          SideMenuItem(
              isSmallDevice: isSmallDevice,
              title: 'DashBoard',
              leadingIcon:
                  const ImageIcon(AssetImage('assets/images/dashboards.png')),
              press: () {
                // Get.to(HomeScreen());
                Navigator.pop(context);
              }),
          const Divider(
            thickness: 1,
          ),
          Visibility(
            visible: employeeid != null,
            child: Column(
              children: [
                SideMenuItem(
                    isSmallDevice: isSmallDevice,
                    title: 'View Attendance',
                    leadingIcon: const ImageIcon(
                        AssetImage('assets/images/attendance.png')),
                    press: () {
                      Get.to(const AttendanceScreen());
                    }),
                const Divider(
                  thickness: 1,
                ),
              ],
            ),
          ),
          SideMenuItem(
              isSmallDevice: isSmallDevice,
              title: 'Closed Trips',
              leadingIcon:
                  const ImageIcon(AssetImage('assets/images/truck.png')),
              press: () {
                Get.to(const CloseTrip());
              }),
          const Divider(
            thickness: 1,
          ),
          SideMenuItem(
              isSmallDevice: isSmallDevice,
              title: 'Trip MIS',
              leadingIcon:
                  const ImageIcon(AssetImage('assets/images/truck.png')),
              press: () {
                Get.to(const TripMis());
              }),
          const Divider(
            thickness: 1,
          ),
          SideMenuItem(
              isSmallDevice: isSmallDevice,
              title: 'Log-Out',
              leadingIcon:
                  const ImageIcon(AssetImage('assets/images/exit.png')),
              press: () {
                logout();
              }),
        ],
      ),
    );
  }
}
