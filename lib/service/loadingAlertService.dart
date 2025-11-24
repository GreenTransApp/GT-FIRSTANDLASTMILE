import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';

class LoadingAlertService {
  late BuildContext context;
  LoadingAlertService({required this.context});

  bool isShowing = false;

  void _showDialog() {
    isShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return _LoadingAlert();
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
      Navigator.pop(context);
    }
  }
}

class _LoadingAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: CommonColors.colorSecondary!, width: 1.5)),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CircularProgressIndicator(
            color: CommonColors.colorSecondary,
          ),
          const Text(
            "Loading... ",
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
//
  }
}
