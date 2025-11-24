// ignore_for_file: prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/Colors.dart';
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
    final dateFormat = DateFormat('MMM d, EEEE');
    return
        // Status Card
        Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with status and profile
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Status indicator
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: cardColor.withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(30),
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
                      const SizedBox(width: 6),
                      Text(
                        getDayInWeek(dateDt) == "Sunday"
                            ? "WeeklyOff"
                            : widget.attendanceModel.attendancestatus ==
                                    "Present"
                                ? "Present"
                                : "Absent",
                        style: TextStyle(
                          fontSize: 14,
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
                            child: const Icon(Icons.person, size: 30),
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
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color:
                        const Color(0xFF3F51B5).withAlpha((0.1 * 255).round()),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: Color(0xFF3F51B5),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  "${getMonthInWords(dateDt)} ${dateDt.day.toString()}, ${getDayInWeek(dateDt)}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF2E3A59),
                  ),
                ),
              ],
            ),
          ),

          // Hours info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Working hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Working Hours',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      (widget.attendanceModel.workinghours == null ||
                              widget.attendanceModel.workinghours == "")
                          ? "00:00:00"
                          : widget.attendanceModel.workinghours.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E3A59),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Extra hours
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Extra Hours',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                    Text(
                      widget.attendanceModel.extrahours == null ||
                              widget.attendanceModel.extrahours == ""
                          ? "00:00:00 "
                          : widget.attendanceModel.extrahours.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2E3A59),
                      ),
                    ),
                  ],
                ),
                Visibility(
                    visible: showElapsedTime,
                    child: const SizedBox(height: 12)),
                Visibility(
                  visible: showElapsedTime,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Elapsed Hours',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        elapsedTime == "" || elapsedTime == "0"
                            ? "0 Secs"
                            : elapsedTime,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2E3A59),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Check-in info
          Visibility(
            visible: showPunchIn,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: cardColor.withAlpha((0.2 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.directions_run,
                      color: cardColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDayInWeek(dateDt) == "Sunday"
                              ? "Weekly Off"
                              : 'Checked in at ${singleInTime ?? "00:00"}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        Visibility(
                            visible: getDayInWeek(dateDt) != "Sunday",
                            child: const SizedBox(height: 4)),
                        Visibility(
                          visible: getDayInWeek(dateDt) != "Sunday",
                          child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.start,
                              children: [
                                Text(
                                  "${widget.attendanceModel.ingpslocation}" ??
                                      "Not Available",
                                  style: TextStyle(
                                    fontSize: 14,
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: CommonColors.dangerColor!
                          .withAlpha((0.2 * 255).round()),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      "assets/images/punchoutIcon.png",
                      height: 24,
                      width: 24,
                      color: CommonColors.dangerColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          getDayInWeek(dateDt) == "Sunday"
                              ? "Weekly Off"
                              : 'Checked out at ${singleOutTime ?? "00:00"}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF2E3A59),
                          ),
                        ),
                        Visibility(
                            visible: getDayInWeek(dateDt) != "Sunday",
                            child: const SizedBox(height: 4)),
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
                                  fontSize: 14,
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

          const SizedBox(height: 20),
        ],
      ),
    );

/*     
     Card(
        shadowColor: cardColor,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            side: BorderSide(color: cardColor, width: 0.7)),
        elevation: 8,
        child: Container(
          // color: Colors.amber,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: CommonColors.weeklyOffColor,
                        size: 40,
                      )
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                dateDt.day.toString(),
                                style: TextStyle(
                                  color: cardColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                widget.attendanceModel.attendancestatus
                                        ?.toUpperCase() ??
                                    "Absent".toUpperCase(),
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: cardColor,
                                  // color: Color(colorToInt)
                                ),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: ClipOval(
                                child: Container(
                                  height: 50,
                                  width: 50,
                                  child: InkWell(
                                    onTap: () {
                                      showDialogWithImage(context,
                                          widget.attendanceModel.imagepath!);
                                    },
                                    child: Image.network(
                                      isNullOrEmpty(widget
                                                  .attendanceModel.imagepath
                                                  .toString()) ==
                                              true
                                          ? defaultImage
                                          : widget.attendanceModel.imagepath
                                              .toString(),
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return CircleAvatar(
                                          child: Icon(Icons.person),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    getMonthInWords(dateDt).substring(0, 3),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Text(
                                    getDayInWeek(dateDt).substring(0, 3),
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Working Hours : ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    "Extra Hours  : ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    (widget.attendanceModel.workinghours ==
                                                null ||
                                            widget.attendanceModel
                                                    .workinghours ==
                                                "")
                                        ? "00:00:00"
                                        : widget.attendanceModel.workinghours
                                            .toString(),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    softWrap: false,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    widget.attendanceModel.extrahours == null ||
                                            widget.attendanceModel.extrahours ==
                                                ""
                                        ? "00:00:00 "
                                        : widget.attendanceModel.extrahours
                                            .toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: showElapsedTime,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              elapsedTime == "" || elapsedTime == "0"
                                  ? "0 Secs"
                                  : elapsedTime,
                              style: TextStyle(
                                  color: CommonColors.colorPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: showPunchIn,
                child: Column(
                  children: [
                    const Divider(
                      thickness: 0.5,
                      color: Colors.grey,
                    ),
                    Row(
                      children: [
                        // Icon(Icons.person),
                        Image.asset(
                          "assets/images/punchinIcon.png",
                          height: 30,
                          color: CommonColors.successColor,
                        ),

                        Expanded(
                            flex: 3,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              //  color: Colors.blue,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    Text(
                                      singleInTime ?? "00:00",
                                      style: TextStyle(
                                          color: CommonColors.colorPrimary,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ]),
                                  Text(
                                      textAlign: TextAlign.start,
                                      widget.attendanceModel.ingpslocation ??
                                          "Not Available",
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ))
                      ],
                    ),
                    Visibility(
                      visible: showPunchOut,
                      child: Row(
                        children: [
                          // Icon(Icons.person),
                          Image.asset(
                            "assets/images/punchoutIcon.png",
                            height: 30,
                            color: CommonColors.dangerColor,
                          ),

                          Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                //  color: Colors.blue,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(
                                        singleOutTime,
                                        style: TextStyle(
                                            color: CommonColors.colorPrimary,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                                    Text(
                                        textAlign: TextAlign.start,
                                        widget.attendanceModel.outgpslocation ??
                                            "Not Available",
                                        overflow: TextOverflow.ellipsis),
                                  ],
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));

 */
  }
}
