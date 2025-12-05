class DrsListModel {
  int? commandstatus;
  String? commandmessage;
  int? sno;
  int? planningid;
  String? planningdt;
  String? manifestno;
  String? manifesttype;
  String? tripid;
  String? rejectedbyrider;
  String? drivercode;
  String? createddt;
  String? planningdt1;
  bool? tripconfirm;
  String? noofconsign;

  DrsListModel({
    this.commandstatus,
    this.commandmessage,
    this.sno,
    this.planningid,
    this.planningdt,
    this.manifestno,
    this.manifesttype,
    this.tripid,
    this.rejectedbyrider,
    this.drivercode,
    this.createddt,
    this.planningdt1,
    this.tripconfirm,
    this.noofconsign,
  });

  DrsListModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    sno = json['sno'];
    planningid = json['planningid'];
    planningdt = json['planningdt'];
    manifestno = json['manifestno'];
    manifesttype = json['manifesttype'];
    tripid = json['tripid'];
    rejectedbyrider = json['rejectedbyrider'];
    drivercode = json['drivercode'];
    createddt = json['createddt'];
    planningdt1 = json['planningdt1'];
    tripconfirm = json['tripconfirm'] == null
        ? null
        : (json['tripconfirm'] == 1 || json['tripconfirm'] == true);
    noofconsign = json['noofconsign']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['sno'] = sno;
    data['planningid'] = planningid;
    data['planningdt'] = planningdt;
    data['manifestno'] = manifestno;
    data['manifesttype'] = manifesttype;
    data['tripid'] = tripid;
    data['rejectedbyrider'] = rejectedbyrider;
    data['drivercode'] = drivercode;
    data['createddt'] = createddt;
    data['planningdt1'] = planningdt1;
    data['tripconfirm'] = tripconfirm;
    data['noofconsign'] = noofconsign;
    return data;
  }
}
