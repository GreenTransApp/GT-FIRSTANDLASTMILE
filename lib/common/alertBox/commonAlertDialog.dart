import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';

bool isDialogShowing = false;
void noCallBack() {}

closeAlert(context) {
  if (isDialogShowing) {
    isDialogShowing = true;
    // Navigator.pop(context);
    Get.back();
  }
  isDialogShowing = false;
}

Future<dynamic> commonAlertDialog(BuildContext context, String title,
    String msg, String address, Icon icon, void Function() okayCallBack,
    {void Function() cancelCallBack = noCallBack,
    Color iconColor = Colors.black,
    int timer = 0}) async {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return CommonAlertDialog(
            futureContext: context,
            title: title,
            msg: msg,
            address: address,
            okayCallBack: okayCallBack,
            icon: icon);
      });
}

class CommonAlertDialog extends StatefulWidget {
  late BuildContext futureContext;
  late String title;
  late String msg;
  late String address;
  late void Function() okayCallBack;
  void Function() cancelCallBack = () => {};
  Color iconColor = Colors.black;
  late Icon icon = icon;
  late int timer = 0;

  CommonAlertDialog(
      {Key? key,
      required this.futureContext,
      required this.title,
      required this.msg,
      required this.address,
      required this.okayCallBack,
      cancelCallBack,
      this.iconColor = Colors.black,
      required this.icon,
      this.timer = 0})
      : super(key: key);
  @override
  State<CommonAlertDialog> createState() => _CommonAlertDialogState();
}

class _CommonAlertDialogState extends State<CommonAlertDialog> {
  int selectedRadio = 0;
  late BuildContext futureContext;
  late String title;
  late String msg;
  late String address;
  late void Function() okayCallBack;
  late void Function() cancelCallBack = () => {};
  late Color iconColor;
  late Icon icon;
  late int timer = 0;

  @override
  void initState() {
    super.initState();
    futureContext = widget.futureContext;
    title = widget.title;
    msg = widget.msg;
    address = widget.address;
    okayCallBack = widget.okayCallBack;
    cancelCallBack = widget.cancelCallBack;
    iconColor = widget.iconColor;
    icon = widget.icon;
    timer = widget.timer;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      ),
      backgroundColor: CommonColors.white,
      surfaceTintColor: CommonColors.white,
      titlePadding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      title: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: IconTheme(
              data: IconThemeData(
                size: SizeConfig.extraLargeIconSize,
                color: iconColor,
              ),
              child: icon,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: SizeConfig.largeTextSize,
              color: CommonColors.textPrimary,
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            msg,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: SizeConfig.mediumTextSize,
              color: CommonColors.textSecondary,
              height: 1.4,
            ),
          ),
          if (address.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              address,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: SizeConfig.smallTextSize,
                color: CommonColors.textSecondary.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
      actionsPadding: const EdgeInsets.only(bottom: 24, left: 20, right: 20),
      actions: [
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  cancelCallBack.call();
                  Get.back();
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: CommonColors.textSecondary.withOpacity(0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.smallRadius),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: CommonColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: SizeConfig.smallTextSize,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  okayCallBack.call();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CommonColors.colorPrimary,
                  elevation: 0,
                  side: BorderSide(
                    color: CommonColors.colorPrimary!
                        .withAlpha((0.2 * 255).toInt()),
                    width: 2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.smallRadius),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'OKAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: SizeConfig.smallTextSize,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
