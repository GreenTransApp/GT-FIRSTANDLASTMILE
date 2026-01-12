import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:gtlmd/design_system/size_config.dart';

class LoadingAlertService {
  late BuildContext context;
  static bool isShowing = false;

  LoadingAlertService({
    required this.context,
  });

  void _showDialog() {
    isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return __LoadingAlert(
          cancelCallBack: cancelLoading,
        );
      },
    );
  }

  void showLoading() {
    if (!isShowing) {
      _showDialog();
    }
  }

  void hideLoading() {
    if (isShowing) {
      isShowing = false;
      // Navigator.pop(context);
      Get.back();
    }
  }

  void cancelLoading() {
    if (isShowing) {
      isShowing = false;
      // Navigator.pop(context);
      Get.back();
    }
  }
}

class __LoadingAlert extends StatelessWidget {
  final VoidCallback cancelCallBack;

  const __LoadingAlert({required this.cancelCallBack});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(
              vertical: SizeConfig.largeVerticalPadding,
              horizontal: SizeConfig.largeHorizontalPadding),
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.largeVerticalPadding,
              horizontal: SizeConfig.largeHorizontalPadding),
          decoration: BoxDecoration(
            color: CommonColors.White,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha((0.1 * 255).toInt()),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: CommonColors.colorPrimary!.withAlpha((0.1 * 255).toInt()),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: SizeConfig.largeHorizontalSpacing,
                    height: SizeConfig.largeVerticalSpacing,
                    child: CircularProgressIndicator(
                      color: CommonColors.colorPrimary!
                          .withAlpha((0.2 * 255).toInt()),
                      strokeWidth: 3,
                      value: 1.0, // Background circle
                    ),
                  ),
                  SizedBox(
                    width: SizeConfig.largeHorizontalSpacing,
                    height: SizeConfig.largeVerticalSpacing,
                    child: CircularProgressIndicator(
                      color: CommonColors.colorPrimary,
                      strokeWidth: 3,
                    ),
                  ),
                  Icon(
                    Icons.sync,
                    color: CommonColors.colorPrimary,
                    size: SizeConfig.largeIconSize,
                  ),
                ],
              ),
              SizedBox(height: SizeConfig.mediumVerticalSpacing),
              Text(
                'Please wait...',
                style: TextStyle(
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Processing your request',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: SizeConfig.smallTextSize,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
