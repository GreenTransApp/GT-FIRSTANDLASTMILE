class AttendanceModel {
  int? commandstatus;
  String? dt;
  String? intime;
  String? outtime;
  String? workinghours;
  String? extrahours;
  String? ingpslocation;
  String? outgpslocation;
  String? attendancestatus;
  String? colorcode;
  String? attendancedisplaytxt;
  String? imagepath;
  String? createdon;

  AttendanceModel({
    this.commandstatus,
    this.dt,
    this.intime,
    this.outtime,
    this.workinghours,
    this.extrahours,
    this.ingpslocation,
    this.outgpslocation,
    this.attendancestatus,
    this.colorcode,
    this.attendancedisplaytxt,
    this.imagepath,
    this.createdon,
  });

  AttendanceModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    dt = json['dt'];
    intime = json['intime'];
    outtime = json['outtime'];
    workinghours = json['workinghours'];
    extrahours = json['extrahours'];
    ingpslocation = json['ingpslocation'];
    outgpslocation = json['outgpslocation'];
    attendancestatus = json['attendancestatus'];
    colorcode = json['colorcode'];
    attendancedisplaytxt = json['attendancedisplaytxt'];
    imagepath = json['imagepath'];
    createdon = json['createdon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commandstatus'] = commandstatus;
    data['dt'] = dt;
    data['intime'] = intime;
    data['outtime'] = outtime;
    data['workinghours'] = workinghours;
    data['extrahours'] = extrahours;
    data['ingpslocation'] = ingpslocation;
    data['outgpslocation'] = outgpslocation;
    data['attendancestatus'] = attendancestatus;
    data['colorcode'] = colorcode;
    data['attendancedisplaytxt'] = attendancedisplaytxt;
    data['imagepath'] = imagepath;
    data['createdon'] = createdon;
    return data;
  }
}
