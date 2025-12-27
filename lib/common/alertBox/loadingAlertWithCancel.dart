import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:get/get.dart';

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

  __LoadingAlert({required this.cancelCallBack});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmallDevice = screenWidth <= 360;

    // return AlertDialog(
    //   shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(15.0),
    //       side: BorderSide(color: CommonColors.colorPrimary!, width: 1.5)),
    //   title: Column(
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.symmetric(vertical: isSmallDevice ? 8 : 10),
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             SizedBox(
    //               width: isSmallDevice ? 20 : 24,
    //               height: isSmallDevice ? 20 : 24,
    //               child: CircularProgressIndicator(
    //                 color: CommonColors.colorPrimary,
    //                 strokeWidth: isSmallDevice ? 2.5 : 3.0,
    //               ),
    //             ),
    //             Text(
    //               'Loading...',
    //               style: TextStyle(
    //                   fontSize: isSmallDevice ? 13 : 15,
    //                   fontWeight: FontWeight.bold),
    //             )
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    return Center(
      child: Container(
        color: Colors.transparent.withAlpha(5),
        child: SizedBox(
          width: isSmallDevice ? 24 : 40,
          height: isSmallDevice ? 24 : 40,
          child: CircularProgressIndicator(
            color: CommonColors.colorPrimary,
            strokeWidth: isSmallDevice ? 2.5 : 4.0,
          ),
        ),
      ),
    );
  }
}
