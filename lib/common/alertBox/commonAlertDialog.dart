import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/colors.dart';

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
      title: Text(title),
      icon: icon,
      iconColor: iconColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [Text(msg), Text(address)],
      ),
      actions: [
        Column(
          children: [
            Divider(
              color: CommonColors.disableColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    cancelCallBack.call();
                    // Navigator.pop(context);
                    Get.back();
                  },
                  child: const Text(
                    'cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Container(
                  height: 30.0,
                  width: 1.0,
                  color: CommonColors.disableColor,
                  margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                ),
                TextButton(
                    onPressed: () {
                      okayCallBack.call();
                      // Navigator.pop(context);
                      Get.back();
                    },
                    child: const Text(
                      'okay',
                      style: TextStyle(color: Colors.black),
                    )),
              ],
            ),
          ],
        )
      ],
    );
  }
}
