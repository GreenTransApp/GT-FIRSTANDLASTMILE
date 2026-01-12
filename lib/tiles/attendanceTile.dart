// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/attendance/models/attendanceModel.dart';
import 'package:intl/intl.dart';

class AttendanceTile extends StatefulWidget {
  final AttendanceModel attendanceModel;

  AttendanceTile({
    super.key,
    required this.attendanceModel,
  });

  @override
  State<AttendanceTile> createState() => _AttendanceTileState();
}

class _AttendanceTileState extends State<AttendanceTile> {
  late void Function() cancelCallBack;
  var formatter = DateFormat('HH:mm');
  late DateTime currentTime = DateTime.now();
  late DateTime dateDt;
  late DateTime inTimeDT;
  late DateTime outTimeDT;
  String elapsedTime = "";
  late String singleInTime;
  late String singleOutTime;
  late Color cardColor;
  bool showPunchIn = false;
  bool showPunchOut = false;
  bool showElapsedTime = false;
  int colorToInt = 0;
  String defaultImage =
      "https://greentrans.in:446/GreenTransApp/imageplace.jpg";
  String getDateDifferenceFromNow(DateTime compareTo) {
    Duration duration = DateTime.now().difference(compareTo);
    int inSeconds = duration.inSeconds;
    setState(() {
      if (inSeconds < 0) {
        showElapsedTime = false;
      } else {
        showElapsedTime = true;
      }
    });
    int hours = inSeconds ~/ 3600;
    int minutes = (inSeconds % 3600) ~/ 60;
    int seconds = inSeconds % 60;
    String answer = "";
    if (hours > 0) {
      answer += "$hours Hrs ";
    }
    if (minutes > 0) {
      answer += "$minutes Mins ";
    }
    if (seconds > 0) {
      answer += "$seconds Secs ";
    }
    return answer;
  }

  void updateElapsedTimePeriodically() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedTime = getDateDifferenceFromNow(inTimeDT);
      });
    });
  }

  void shouldShowlpasedTime(DateTime compareWith) {
    Duration duration = DateTime.now().difference(compareWith);
    if (duration.inDays == 0 &&
        widget.attendanceModel.attendancestatus == "Present" &&
        widget.attendanceModel.outtime == null) {
      showElapsedTime = true;
    } else {
      showElapsedTime = false;
    }
  }

  @override
  void initState() {
    super.initState();

    dateDt = getDateTimeBack(widget.attendanceModel.dt);
    inTimeDT = getDateTimeBack(widget.attendanceModel.intime);
    outTimeDT = getDateTimeBack(widget.attendanceModel.outtime);
    singleInTime = formatter.format(inTimeDT);
    singleOutTime = formatter.format(outTimeDT);
    shouldShowlpasedTime(dateDt);
    if (showElapsedTime) {
      elapsedTime = getDateDifferenceFromNow(inTimeDT);
      updateElapsedTimePeriodically();
    }

    cardColor = widget.attendanceModel.attendancestatus == "Present"
        ? CommonColors.green600!
        : (widget.attendanceModel.attendancestatus == "Absent"
            ? CommonColors.dangerColor!
            : CommonColors.weeklyOffColor);

    // colorToInt = int.parse("0xFF${widget.attendaceModel.colorcode?.substring(1, (widget.attendaceModel.colorcode?.length)! - 1)}");
    if (widget.attendanceModel.intime != null) {
      showPunchIn = true;
      // successToast(widget.attendaceModel.outtime.toString());
    }
    if (widget.attendanceModel.outtime != null) {
      showPunchOut = true;
    }
    debugPrint(inTimeDT.day.toString());
  }

  @override
  void dispose() async {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
        // Status Card
        Container(
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.05 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with status and profile
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding),
            child: Row(
              children: [
                // Status indicator
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.smallHorizontalPadding,
                      vertical: SizeConfig.smallVerticalPadding),
                  decoration: BoxDecoration(
                    color: cardColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: cardColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: SizeConfig.smallHorizontalSpacing),
                      Text(
                        getDayInWeek(dateDt) == "Sunday"
                            ? "WeeklyOff"
                            : widget.attendanceModel.attendancestatus ==
                                    "Present"
                                ? "Present"
                                : "Absent",
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
                          fontWeight: FontWeight.w500,
                          color: cardColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Profile image
                GestureDetector(
                  onTap: () {
                    // Handle profile tap
                    showDialogWithImage(
                        context, widget.attendanceModel.imagepath!,
                        isLocal: false);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF4CAF50),
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        isNullOrEmpty(widget.attendanceModel.imagepath)
                            ? 'assets/images/puser.png'
                            : widget.attendanceModel.imagepath!,
                        fit: BoxFit.cover,
                        width: 50,
                        height: 50,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.person,
                                size: SizeConfig.largeIconSize),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Date and time info
          Padding(
            padding: EdgeInsets.all(SizeConfig.largeRadius),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.horizontalPadding,
                      vertical: SizeConfig.verticalPadding),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF3F51B5).withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: const Color(0xFF3F51B5),
                    size: SizeConfig.largeIconSize,
                  ),
                ),
                SizedBox(width: SizeConfig.smallHorizontalSpacing),
                Text(
                  "${getMonthInWords(dateDt)} ${dateDt.day.toString()}, ${getDayInWeek(dateDt)}",
                  style: TextStyle(
                    fontSize: SizeConfig.mediumTextSize,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E3A59),
                  ),
                ),
              ],
            ),
          ),

          // Hours info
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.horizontalPadding,
                vertical: SizeConfig.verticalPadding),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
            ),
            margin:
                EdgeInsets.symmetric(horizontal: SizeConfig.horizontalPadding),
            child: Column(
              children: [
                // Working hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Working Hours',
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      (widget.attendanceModel.workinghours == null ||
                              widget.attendanceModel.workinghours == "")
                          ? "00:00:00"
                          : widget.attendanceModel.workinghours.toString(),
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E3A59),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: SizeConfig.mediumVerticalSpacing),
                // Extra hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Extra Hours',
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      widget.attendanceModel.extrahours == null ||
                              widget.attendanceModel.extrahours == ""
                          ? "00:00:00 "
                          : widget.attendanceModel.extrahours.toString(),
                      style: TextStyle(
                        fontSize: SizeConfig.smallTextSize,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E3A59),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: showElapsedTime,
                    child: SizedBox(height: SizeConfig.mediumVerticalSpacing)),
                Visibility(
                  visible: showElapsedTime,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Elapsed Hours',
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        elapsedTime == "" || elapsedTime == "0"
                            ? "0 Secs"
                            : elapsedTime,
                        style: TextStyle(
                          fontSize: SizeConfig.smallTextSize,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2E3A59),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // Check-in info
          Visibility(
            visible: showPunchIn,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.horizontalPadding,
                  vertical: SizeConfig.verticalPadding),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    decoration: BoxDecoration(
                      color: cardColor.withAlpha((0.2 * 255).round()),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.largeRadius),
                    ),
                    child: Icon(
                      Icons.directions_run,
                      color: cardColor,
                      size: SizeConfig.largeIconSize,
                    ),
                  ),
                  SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDayInWeek(dateDt) == "Sunday"
                              ? "Weekly Off"
                              : 'Checked in at $singleInTime',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: SizeConfig.smallTextSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E3A59),
                          ),
                        ),
                        Visibility(
                            visible: getDayInWeek(dateDt) != "Sunday",
                            child: SizedBox(
                                height: SizeConfig.smallVerticalSpacing)),
                        Visibility(
                          visible: getDayInWeek(dateDt) != "Sunday",
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(
                                  "${widget.attendanceModel.ingpslocation}",
                                  style: TextStyle(
                                    fontSize: SizeConfig.smallTextSize,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Visibility(
            visible: showPunchOut,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.horizontalPadding,
                  vertical: SizeConfig.verticalPadding),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.horizontalPadding,
                        vertical: SizeConfig.verticalPadding),
                    decoration: BoxDecoration(
                      color: CommonColors.dangerColor!
                          .withAlpha((0.2 * 255).round()),
                      borderRadius:
                          BorderRadius.circular(SizeConfig.largeRadius),
                    ),
                    child: Image.asset(
                      "assets/images/punchoutIcon.png",
                      height: 24,
                      width: 24,
                      color: CommonColors.dangerColor,
                    ),
                  ),
                  SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDayInWeek(dateDt) == "Sunday"
                              ? "Weekly Off"
                              : 'Checked out at $singleOutTime',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: SizeConfig.mediumTextSize,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF2E3A59),
                          ),
                        ),
                        Visibility(
                            visible: getDayInWeek(dateDt) != "Sunday",
                            child: SizedBox(
                                height: SizeConfig.smallVerticalSpacing)),
                        Visibility(
                          visible: getDayInWeek(dateDt) != "Sunday",
                          child: SizedBox(
                            // padding: const EdgeInsets.only(right: 12),
                            width: 400,
                            child: Wrap(children: [
                              Text(
                                widget.attendanceModel.outgpslocation ??
                                    "Not Available",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: SizeConfig.smallTextSize,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: SizeConfig.mediumVerticalSpacing),
        ],
      ),
    );
  }
}
