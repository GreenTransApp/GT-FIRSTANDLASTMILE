import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/common/textFormatter/upperCaseTextFormatter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateTimePicker extends StatefulWidget {
  final void Function(String, String) callBack;
  //  final VoidCallback onPressed;

  const DateTimePicker(
      {super.key,
      //  required this.onPressed
      required this.callBack});

  @override
  State<DateTimePicker> createState() => _DatePickerTimeState();
}

enum DatePickerType { Date, Time }

class _DatePickerTimeState extends State<DateTimePicker> {
  late String date;
  late String time;

  DateTime dateTimeFromDt = DateTime.now();
  DateTime dateTimeToDt = DateTime.now();

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String formattedFromDate = DateFormat('dd-MM-yyyy').format(dateTimeFromDt);
    dateController.text = formattedFromDate;
    timeController.text = DateFormat('HH:mm').format(DateTime.now());
    date = dateTimeFromDt.toString();
    time = DateFormat('HH:mm').format(DateTime.now());
  }

  Future<void> openPicker(DatePickerType pickerType) async {
    if (pickerType == DatePickerType.Date) {
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
          dateController.text = formattedDate;
          date = pickedDate.toString();
        });
      } else {}
    } else if (pickerType == DatePickerType.Time) {
      final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(DateTime.now()),
          builder: (context, child) {
            return Theme(
                data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                  primary: CommonColors.colorPrimary!,
                )),
                child: child!);
          });
      if (picked != null) {
        setState(() {
          timeController.text =
              '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
        });
      }
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
          'DATE TIME SELECTION',
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

                widget.callBack.call(date, time);
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
                            TextSpan(text: 'Date', children: <InlineSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: CommonColors.dangerColor),
                          )
                        ])),
                      ),
                      TextField(
                        readOnly: true,
                        controller: dateController,
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
                                openPicker(DatePickerType.Date);
                              }),
                          filled: true,
                          fillColor: Colors.white,
                          // hintText:,
                        ),
                        onTap: () async {
                          openPicker(DatePickerType.Date);
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
                            TextSpan(text: 'Time', children: <InlineSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(color: CommonColors.dangerColor),
                          )
                        ])),
                      ),
                      TextField(
                        readOnly: true,
                        controller: timeController,
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
                                openPicker(DatePickerType.Time);
                              }),
                          filled: true,
                          fillColor: Colors.white,
                          // hintText:,
                        ),
                        onTap: () async {
                          openPicker(DatePickerType.Time);
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

Future<void> showDateTimePickerBottomSheet(
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
        return DateTimePicker(callBack: callBack);
      });
}
