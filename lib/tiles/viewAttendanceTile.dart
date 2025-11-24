import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/pages/attendance/models/viewAttendanceModel.dart';

class viewAttendanceTile extends StatefulWidget {
  final viewAttendanceModel viewAttModel;

  viewAttendanceTile({super.key, required this.viewAttModel});

  @override
  State<viewAttendanceTile> createState() => _viewAttendanceTileState();
}

class _viewAttendanceTileState extends State<viewAttendanceTile> {
  late DateTime attendancedate;
  late Color? cardColor;
// late String weekdays;
//  var formatter = DateFormat('yyy/MM/dd');
//   var singleDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attendancedate = getDateTimeBack(widget.viewAttModel.fulldt);
    //  singleDate=formatter.format(attendancedate);

    cardColor = widget.viewAttModel.attendancestatus == "Present"
        ? CommonColors.successColor
        : (widget.viewAttModel.attendancestatus == "Absent"
            ? CommonColors.dangerColor
            : CommonColors.weeklyOffColor);

    debugPrint(cardColor.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: cardColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Icon(
                      Icons.calendar_month,
                      size: 40,
                      color: Colors.white,
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Text(
                      attendancedate.day.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                      ),
                    ),
                    Text(
                      getMonthInWords(attendancedate).substring(0, 3),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      attendancedate.year.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.viewAttModel.attendancestatus!.toUpperCase(),
                        // widget.viewAttModel.attendancestatus ?? "Absent",
                        style: const TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.viewAttModel.wkdayname!.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 23,
                          color: Colors.white,
                        ),
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
