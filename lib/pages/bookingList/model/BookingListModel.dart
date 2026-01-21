class BookingListModel {
  int? commandstatus;
  String? commandmessage;

  String? grno;
  String? grdt;
  String? destname;
  double? tamount;
  String? createid;

  String? pickuppoint;
  String? vehiclecode;
  String? regno;
  String? vehicletypecode;
  String? vehicletypename;

  String? drivercode;
  String? drivername;
  String? drivermob;

  BookingListModel({
    this.commandstatus,
    this.commandmessage,
    this.grno,
    this.grdt,
    this.destname,
    this.tamount,
    this.createid,
    this.pickuppoint,
    this.vehiclecode,
    this.regno,
    this.vehicletypecode,
    this.vehicletypename,
    this.drivercode,
    this.drivername,
    this.drivermob,
  });

  BookingListModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];

    grno = json['grno'];
    grdt = json['grdt'];
    destname = json['destname'];
    tamount = json['tamount'] != null
        ? double.tryParse(json['tamount'].toString())
        : 0.0;
    createid = json['createid'];

    pickuppoint = json['pickuppoint'];
    vehiclecode = json['vehiclecode'];
    regno = json['regno'];
    vehicletypecode = json['vehicletypecode'];
    vehicletypename = json['vehicletypename'];

    drivercode = json['drivercode'];
    drivername = json['drivername'];
    drivermob = json['drivermob'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;

    data['grno'] = grno;
    data['grdt'] = grdt;
    data['destname'] = destname;
    data['tamount'] = tamount;
    data['createid'] = createid;

    data['pickuppoint'] = pickuppoint;
    data['vehiclecode'] = vehiclecode;
    data['regno'] = regno;
    data['vehicletypecode'] = vehicletypecode;
    data['vehicletypename'] = vehicletypename;

    data['drivercode'] = drivercode;
    data['drivername'] = drivername;
    data['drivermob'] = drivermob;

    return data;
  }
}
