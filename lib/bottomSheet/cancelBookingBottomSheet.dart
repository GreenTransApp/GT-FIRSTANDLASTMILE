import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/size_config.dart';

class CancelBookingBottomSheet extends StatefulWidget {
  String grno;
  void Function(dynamic) onConfirm;
  void Function() onCancel;
  CancelBookingBottomSheet(
      {super.key,
      required this.grno,
      required this.onConfirm,
      required this.onCancel});

  @override
  State<CancelBookingBottomSheet> createState() =>
      _CancelBookingBottomSheetState();
}

class _CancelBookingBottomSheetState extends State<CancelBookingBottomSheet> {
  TextEditingController cancelReasonController = TextEditingController();

  @override
  void dispose() {
    cancelReasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: CommonColors.colorPrimary,
        foregroundColor: CommonColors.White,
        title: const Text('Cancel Booking'),
        centerTitle: true,
        leading: const Text(''),
      ),
      body: Column(
        children: [
          SizedBox(
            height: SizeConfig.largeVerticalSpacing,
          ),
          Text(
            'GR NO : ${widget.grno}',
            style: TextStyle(
              fontSize: SizeConfig.largeTextSize,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: SizeConfig.largeVerticalSpacing,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding),
            child: SizedBox(
              height: 200,
              child: TextField(
                minLines: null,
                maxLines: null,
                expands: true,
                controller: cancelReasonController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
                  ),
                  hintText: 'Enter Cancel Reason',
                ),
              ),
            ),
          ),
        ],
      ),
      persistentFooterButtons: [
        Row(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(SizeConfig.largeRadius),
                    bottomRight: Radius.circular(SizeConfig.largeRadius),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    widget.onCancel();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: CommonColors.appBarColor,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.largeRadius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: SizeConfig.largeHorizontalSpacing,
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(SizeConfig.largeRadius),
                    bottomRight: Radius.circular(SizeConfig.largeRadius),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    // remarks = cancelReasonController.text;
                    widget.onConfirm(cancelReasonController.text);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CommonColors.primaryColorShade,
                    foregroundColor: CommonColors.White,
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(SizeConfig.largeRadius),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.w500,
                    ),
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

Future<void> showCancelBookingBottomSheet<T>(
  BuildContext context,
  void Function(dynamic) onConfirm,
  void Function() onCancel,
  String grno,
) async {
  return showModalBottomSheet<void>(
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.60,
          child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: CancelBookingBottomSheet(
                onConfirm: onConfirm,
                onCancel: onCancel,
                grno: grno,
              )),
        );
      });
}
