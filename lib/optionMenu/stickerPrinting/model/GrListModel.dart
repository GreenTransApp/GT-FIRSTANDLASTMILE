class GrListModel {
  int? commandstatus;
  String? commandmessage;

  String? grno;
  String? bookingdt;
  String? orgname;
  String? destname;
  String? bookingtime;
  int? boyid;

  String? pickupboyname;
  String? cngrname;
  String? cngrcode;
  String? cngename;
  String? cngecode;

  double? pckgs;
  String? orgcode;
  String? destcode;

  GrListModel({
    this.commandstatus,
    this.commandmessage,
    this.grno,
    this.bookingdt,
    this.orgname,
    this.destname,
    this.bookingtime,
    this.boyid,
    this.pickupboyname,
    this.cngrname,
    this.cngrcode,
    this.cngename,
    this.cngecode,
    this.pckgs,
    this.orgcode,
    this.destcode,
  });

  GrListModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];

    grno = json['grno'];
    bookingdt = json['bookingdt'];
    orgname = json['orgname'];
    destname = json['destname'];
    bookingtime = json['bookingtime'];
    boyid = json['boyid'];

    pickupboyname = json['pickupboyname'];
    cngrname = json['cngrname'];
    cngrcode = json['cngrcode'];
    cngename = json['cngename'];
    cngecode = json['cngecode'];

    pckgs = json['pckgs'];
    orgcode = json['orgcode'];
    destcode = json['destcode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;

    data['grno'] = grno;
    data['bookingdt'] = bookingdt;
    data['orgname'] = orgname;
    data['destname'] = destname;
    data['bookingtime'] = bookingtime;
    data['boyid'] = boyid;

    data['pickupboyname'] = pickupboyname;
    data['cngrname'] = cngrname;
    data['cngrcode'] = cngrcode;
    data['cngename'] = cngename;
    data['cngecode'] = cngecode;

    data['pckgs'] = pckgs;
    data['orgcode'] = orgcode;
    data['destcode'] = destcode;

    return data;
  }
}
