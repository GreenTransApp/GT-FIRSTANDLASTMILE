import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:lottie/lottie.dart';

bool _isDialogShowing = false;

void noCallBack() {}

void closeAlert(context) {
  if (_isDialogShowing) {
    _isDialogShowing = true;
    Navigator.pop(context);
  }
  _isDialogShowing = false;
}

Future<dynamic> showSuccessAlert(BuildContext context, String title, String msg,
    void Function() okayCallBack) async {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return SuccessAlert(
          futureContext: context,
          title: title,
          msg: msg,
          okayCallBack: okayCallBack,
        );
      });
}

class SuccessAlert extends StatefulWidget {
  late BuildContext futureContext;
  late String title;
  late String msg;
  late void Function() okayCallBack;

  SuccessAlert({
    Key? key,
    required this.futureContext,
    required this.title,
    required this.msg,
    required this.okayCallBack,
  }) : super(key: key);
  @override
  State<SuccessAlert> createState() => _SuccessAlertState();
}

class _SuccessAlertState extends State<SuccessAlert> {
  int selectedRadio = 0;
  late BuildContext futureContext;
  late String title;
  late String msg;
  late void Function() okayCallBack;

  @override
  void initState() {
    super.initState();
    futureContext = widget.futureContext;
    title = widget.title;
    msg = widget.msg;
    okayCallBack = widget.okayCallBack;
  }

  @override
  Widget build(BuildContext context) {
    _isDialogShowing = true;
    // successToast(_isDialogShowing.toString());

    return AlertDialog(
      title: Center(
          child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18,
            color: CommonColors.successColor,
            fontWeight: FontWeight.bold),
      )),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/greenCheck.json", width: 100, height: 100),
          Text(
            msg,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  okayCallBack.call();
                  Navigator.pop(context);
                },
                child: Text(
                  "Okay",
                  style: TextStyle(color: CommonColors.colorPrimary),
                )),
          ],
        ),
      ],
    );
  }
}
