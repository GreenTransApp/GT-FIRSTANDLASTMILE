class viewAttendanceModel {
  int? commandstatus;
  String? commandmessage;
  int? sno;
  String? date;
  String? fulldt;
  String? wkdayname;
  String? attendancestatus;
  String? color;

  viewAttendanceModel(
      {this.commandstatus,
      this.commandmessage,
      this.sno,
      this.date,
      this.fulldt,
      this.wkdayname,
      this.attendancestatus,
      this.color});

  viewAttendanceModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    sno = json['sno'];
    date = json['date'];
    fulldt = json['fulldt'];
    wkdayname = json['wkdayname'];
    attendancestatus = json['attendancestatus'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['sno'] = this.sno;
    data['date'] = this.date;
    data['fulldt'] = this.fulldt;
    data['wkdayname'] = this.wkdayname;
    data['attendancestatus'] = this.attendancestatus;
    data['color'] = this.color;
    return data;
  }
}
