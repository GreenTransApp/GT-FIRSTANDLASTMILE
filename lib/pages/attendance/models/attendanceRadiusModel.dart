class AttendanceRadiusModel {
  int? commandstatus;
  String? commandmessage;
  String? latposition;
  String? longposition;
  int? attendanceradius;
  String? emplatposition;
  String? emplongposition;
  String? defaultaddress;
  String? errmsg;

  AttendanceRadiusModel(
      {this.commandstatus,
      this.commandmessage,
      this.latposition,
      this.longposition,
      this.attendanceradius,
      this.emplatposition,
      this.emplongposition,
      this.defaultaddress,
      this.errmsg});


  AttendanceRadiusModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    latposition = json['latposition'];
    longposition = json['longposition'];
    attendanceradius = json['attendanceradius'];
    emplatposition = json['emplatposition'];
    emplongposition = json['emplongposition'];
    defaultaddress = json['defaultaddress'];
    errmsg = json['errmsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['latposition'] = this.latposition;
    data['longposition'] = this.longposition;
    data['attendanceradius'] = this.attendanceradius;
    data['emplatposition'] = this.emplatposition;
    data['emplongposition'] = this.emplongposition;
    data['defaultaddress'] = this.defaultaddress;
    data['errmsg'] = this.errmsg;
    return data;
  }

}