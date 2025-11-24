import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/textFormatter/upperCaseTextFormatter.dart';
import 'package:get/get.dart';
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
    // TODO: implement initState
    super.initState();
    String formattedFromDate = DateFormat('dd-MM-yyyy').format(dateTimeFromDt);
    fromDateController.text = formattedFromDate;
    toDateController.text = formattedFromDate;
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
        print(pickedDate);
        String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);
        print(formattedDate);
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
        print(dropDate);
        String formattedDate = DateFormat('dd-MM-yyyy').format(dropDate);
        print(formattedDate);
        setState(() {
          toDateController.text = formattedDate;
          toDt = dropDate.toString();
        });
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: CommonColors.colorPrimary,
        title: Text(
          'PERIOD SELECTION',
          style: TextStyle(color: CommonColors.white),
        ),
        systemOverlayStyle: CommonColors.systemUiOverlayStyle,
      ),
      persistentFooterButtons: [
        Container(
          height: 60,
          child: CommonButton(
              title: "Submit",
              color: CommonColors.colorPrimary!,
              onTap: () {
                //  successToast(fromDt);

                widget.callBack.call(fromDt, toDt);
                // Navigator.pop(context);
                Get.back();

                // successToast($dateFunction(fromDt,toDt))   ;
                //  widget.callBack.call(dateFunction(fromDt,toDt));
              }),
        ),
      ],
      body: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text.rich(
                            TextSpan(text: 'From Date', children: <InlineSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: CommonColors.dangerColor),
                          )
                        ])),
                      ),
                      TextField(
                        readOnly: true,
                        controller: fromDateController,
                        inputFormatters: [UpperCaseTextFormatter()],
                        keyboardType: TextInputType.multiline,
                        cursorColor: Colors.black,
                        obscureText: false,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.calendar_month,
                                color: Colors.green,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text.rich(
                            TextSpan(text: 'To Date', children: <InlineSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: CommonColors.dangerColor),
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
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.5, color: Colors.grey),
                          ),
                          suffixIcon: IconButton(
                              icon: const Icon(
                                Icons.calendar_month,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                openDatePicker(DatePickerType.toDt);
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
      backgroundColor: Colors.yellow,
      //elevates modal bottom screen
      elevation: 10,
      // gives rounded corner to modal bottom screen
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (BuildContext context) {
        // UDE : SizedBox instead of Container for whitespaces
        return DatePicker(callBack: callBack);
      });
}
