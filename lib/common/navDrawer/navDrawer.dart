import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/alertBox/commonAlertDialog.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/navDrawer/navDrawerModel.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/navigateRoutes/Routes.dart';
import 'package:gtlmd/navigateRoutes/RoutesName.dart';
import 'package:gtlmd/optionMenu/deliveryPerformance/deliveryPerformancePage.dart';
import 'package:gtlmd/pages/attendance/attendanceScreen.dart';
import 'package:gtlmd/optionMenu/tripMis/tripMis.dart';
import 'package:gtlmd/pages/trips/closeTrip/closeTrip.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallDevice = screenWidth <= 360;

    okayCallBack() {
      Future.delayed(Duration.zero, () {
        authService.logout(context);
      });
    }

    void cancelPopup() {
      Get.back();
    }

    logout() {
      commonAlertDialog(context, "ALERT!", "Are you sure you want to logout?",
          "", const Icon(Icons.logout), okayCallBack,
          cancelCallBack: cancelPopup);
    }

    final currentRoute = Get.currentRoute;

    return Drawer(
      backgroundColor: CommonColors.white ?? Colors.white,
      child: Column(
        children: [
          // Modern Header with Gradient
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.paddingOf(context).top + 20,
              bottom: 20,
              left: SizeConfig.horizontalPadding,
              right: SizeConfig.horizontalPadding,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  CommonColors.colorPrimary ?? const Color(0xFF2934AB),
                  (CommonColors.colorPrimary ?? const Color(0xFF2934AB))
                      .withAlpha((0.8 * 255).toInt()),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: (CommonColors.white ?? Colors.white)
                        .withAlpha((0.2 * 255).toInt()),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: SizeConfig.extraLargeRadius * 0.8,
                    backgroundColor: CommonColors.white ?? Colors.white,
                    child: ClipOval(
                      child: Image.network(
                        savedLogin.logoimage.toString(),
                        width: SizeConfig.extraLargeRadius * 1.6,
                        height: SizeConfig.extraLargeRadius * 1.6,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/icon.png",
                            fit: BoxFit.contain,
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        savedUser.displayusername!,
                        style: TextStyle(
                          color: CommonColors.white ?? Colors.white,
                          fontSize: SizeConfig.mediumTextSize,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        savedUser.username ?? "User",
                        style: TextStyle(
                          color: (CommonColors.white ?? Colors.white)
                              .withAlpha((0.8 * 255).toInt()),
                          fontSize: SizeConfig.smallTextSize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Navigation Items
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SideMenuItem(
                    isSmallDevice: isSmallDevice,
                    title: 'Dashboard',
                    isSelected: currentRoute == RoutesName.home,
                    leadingIcon: const Icon(Symbols.dashboard_rounded),
                    press: () {
                      Navigator.pop(context);
                      if (currentRoute != RoutesName.home) {
                        Routes.goToPage(RoutesName.home, "Dashboard");
                      }
                    },
                  ),
                  if (employeeid != null) ...[
                    SideMenuItem(
                      isSmallDevice: isSmallDevice,
                      title: 'View Attendance',
                      leadingIcon: const ImageIcon(
                          AssetImage('assets/images/attendance.png')),
                      press: () {
                        Navigator.pop(context);
                        Get.to(const AttendanceScreen());
                      },
                    ),
                  ],
                  SideMenuItem(
                    isSmallDevice: isSmallDevice,
                    title: 'Closed Trips',
                    leadingIcon: const Icon(Symbols.no_crash_rounded),
                    press: () {
                      Navigator.pop(context);
                      Get.to(const CloseTrip());
                    },
                  ),
                  SideMenuItem(
                    isSmallDevice: isSmallDevice,
                    title: 'Trip MIS',
                    leadingIcon: const Icon(Symbols.cognition_2_rounded),
                    press: () {
                      Navigator.pop(context);
                      Get.to(const TripMis());
                    },
                  ),
                  SideMenuItem(
                    isSmallDevice: isSmallDevice,
                    title: 'Delivery Performance',
                    leadingIcon: const Icon(Symbols.analytics),
                    press: () {
                      Navigator.pop(context);
                      Get.to(const DeliveryPerformancePage());
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom Actions
          const Divider(height: 1),
          SideMenuItem(
            isSmallDevice: isSmallDevice,
            title: 'Log-Out',
            leadingIcon: const Icon(Symbols.logout_rounded),
            press: () {
              logout();
            },
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 12),
        ],
      ),
    );
  }
}
