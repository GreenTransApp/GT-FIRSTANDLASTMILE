import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/textFormatter/upperCaseTextFormatter.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatefulWidget {
  final void Function(String, String) callBack;
  //  final VoidCallback onPressed;

  const DatePicker(
      {super.key,
      //  required this.onPressed
      required this.callBack});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

enum DatePickerType { fromDt, toDt }

class _DatePickerState extends State<DatePicker> {
  late String fromDt;
  late String toDt;

  DateTime dateTimeFromDt = DateTime.now();
  DateTime dateTimeToDt = DateTime.now();

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dateTimeFromDt = dashboardFromDt;
    dateTimeToDt = dashboardToDt;
    String formattedFromDate = DateFormat('dd-MM-yyyy').format(dateTimeFromDt);
    String formattedToDate = DateFormat('dd-MM-yyyy').format(dateTimeToDt);
    fromDateController.text = formattedFromDate;
    toDateController.text = formattedToDate;
    fromDt = dateTimeFromDt.toString();
    toDt = dateTimeToDt.toString();
  }

  Future<void> openDatePicker(DatePickerType pickerType) async {
    if (pickerType == DatePickerType.fromDt) {
      DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                primary: CommonColors.colorPrimary!,
              )),
              child: child!);
        },
      );

      if (pickedDate != null) {
        // print(pickedDate);
        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        // print(formattedDate);
        setState(() {
          fromDateController.text = formattedDate;
          fromDt = pickedDate.toString();
        });
      } else {
        // setState(() {
        //   pickedDate = DateTime.now();
        //   String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate!);
        //   fromDateController.text = formattedDate;
        //   fromDt=pickedDate.toString();
        //   successToast(fromDt);
        // });
      }
    } else if (pickerType == DatePickerType.toDt) {
      DateTime? dropDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
        builder: (context, child) {
          return Theme(
              data: Theme.of(context).copyWith(
                  colorScheme: ColorScheme.light(
                primary: CommonColors.colorPrimary!,
              )),
              child: child!);
        },
      );

      if (dropDate != null) {
        // print(dropDate);
        String formattedDate = DateFormat('dd-MM-yyyy').format(dropDate);
        // print(formattedDate);
        setState(() {
          toDateController.text = formattedDate;
          toDt = dropDate.toString();
        });
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // Scaffold(
        //   persistentFooterButtons: [
        //     Container(
        //       height: 60,
        //       child: CommonButton(
        //           title: "Submit",
        //           color: CommonColors.colorPrimary!,
        //           onTap: () {
        //             //  successToast(fromDt);

        //             widget.callBack.call(fromDt, toDt);
        //             // Navigator.pop(context);
        //             Get.back();

        //             // successToast($dateFunction(fromDt,toDt))   ;
        //             //  widget.callBack.call(dateFunction(fromDt,toDt));
        //           }),
        //     ),
        //   ],
        //   body:
        Container(
      margin: const EdgeInsets.only(top: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Select Date Range',
            style: TextStyle(
                color: CommonColors.appBarColor.withAlpha((0.6 * 255).toInt()),
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.largeTextSize),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: SizeConfig.smallVerticalSpacing),
          Text(
            'Choose your start and end dates',
            style: TextStyle(
                color: CommonColors.appBarColor.withAlpha((0.6 * 255).toInt())),
            textAlign: TextAlign.center,
          ),
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.smallHorizontalPadding,
                            vertical: SizeConfig.smallVerticalPadding),
                        child: Text.rich(
                          TextSpan(
                            text: 'FROM DATE',
                            style: TextStyle(
                                color: CommonColors.appBarColor,
                                fontSize: SizeConfig.smallTextSize),
                            children: <InlineSpan>[
                              TextSpan(
                                text: ' *',
                                style:
                                    TextStyle(color: CommonColors.dangerColor),
                              )
                            ],
                          ),
                        ),
                      ),
                      TextField(
                        readOnly: true,
                        controller: fromDateController,
                        inputFormatters: [UpperCaseTextFormatter()],
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.black,
                        obscureText: false,
                        style: TextStyle(fontSize: SizeConfig.smallTextSize),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.largeRadius),
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.largeRadius),
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.largeRadius),
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.calendar_month,
                                color: CommonColors.appBarColor,
                                size: SizeConfig.extraLargeIconSize,
                              ),
                              onPressed: () async {
                                openDatePicker(DatePickerType.fromDt);
                              }),
                          filled: true,
                          fillColor: Colors.white,
                          // hintText:,
                        ),
                        onTap: () async {
                          openDatePicker(DatePickerType.fromDt);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: SizeConfig.smallHorizontalPadding,
                            vertical: SizeConfig.smallVerticalPadding),
                        child: Text.rich(TextSpan(
                            text: 'TO DATE',
                            style:
                                TextStyle(fontSize: SizeConfig.smallIconSize),
                            children: <InlineSpan>[
                              TextSpan(
                                text: ' *',
                                style:
                                    TextStyle(color: CommonColors.dangerColor),
                              )
                            ])),
                      ),
                      TextField(
                        readOnly: true,
                        controller: toDateController,
                        inputFormatters: [UpperCaseTextFormatter()],
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.black,
                        obscureText: false,
                        style: TextStyle(fontSize: SizeConfig.smallTextSize),
                        decoration: InputDecoration(
                          labelStyle:
                              TextStyle(fontSize: SizeConfig.smallTextSize),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.largeRadius),
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.largeRadius),
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                          ),
                          disabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.largeRadius),
                            borderSide: const BorderSide(
                                width: 0.5, color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.calendar_month,
                                color: CommonColors.appBarColor,
                                size: SizeConfig.extraLargeIconSize,
                              ),
                              onPressed: () async {
                                openDatePicker(DatePickerType.fromDt);
                              }),
                          filled: true,
                          fillColor: Colors.white,
                          // hintText:,
                        ),
                        onTap: () async {
                          openDatePicker(DatePickerType.toDt);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),
          // Container(
          //   margin: EdgeInsets.symmetric(
          //       horizontal: SizeConfig.screenWidth * 0.2),
          //   height: ,
          //   child: CommonButton(
          //       title: "Submit",
          //       color: CommonColors.colorPrimary!,
          //       onTap: () {
          //         //  successToast(fromDt);

          //         widget.callBack.call(fromDt, toDt);
          //         // Navigator.pop(context);
          //         Get.back();

          //         // successToast($dateFunction(fromDt,toDt))   ;
          //         //  widget.callBack.call(dateFunction(fromDt,toDt));
          //       }),
          // ),
          Container(
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
                widget.callBack.call(fromDt, toDt);
                // Navigator.pop(context);
                Get.back();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: CommonColors.colorPrimary,
                foregroundColor: CommonColors.White,
                padding: EdgeInsets.symmetric(
                    horizontal: SizeConfig.horizontalPadding,
                    vertical: SizeConfig.verticalPadding),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
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
        ],
      ),
    );
  }
}

Future<void> showDatePickerBottomSheet(
    BuildContext context, void Function(String, String) callBack) async {
  return showModalBottomSheet(
      context: context,
      // color is applied to main screen when modal bottom screen is displayed
      // barrierColor: Colors.greenAccent,
      //background color for modal bottom screen
      backgroundColor: Colors.white,
      showDragHandle: true,
      //elevates modal bottom screen
      elevation: 10,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      builder: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return DatePicker(callBack: callBack);
      });
}
