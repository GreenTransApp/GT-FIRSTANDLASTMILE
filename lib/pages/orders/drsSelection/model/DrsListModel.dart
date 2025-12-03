class DrsListModel {
  int? commandstatus;
  String? commandmessage;
  int? planningid;
  String? planningdt;
  String? planningdraftcode;
  String? manifestno;
  String? manifesttype;
  String? tripid;
  String? rejectedbyrider;
  String? drivercode;
  String? createddt;
  bool? tripconfirm;
  String? noofconsign;

  DrsListModel({
    this.commandstatus,
    this.commandmessage,
    this.planningid,
    this.planningdt,
    this.planningdraftcode,
    this.manifestno,
    this.manifesttype,
    this.tripid,
    this.rejectedbyrider,
    this.drivercode,
    this.createddt,
    this.tripconfirm,
    this.noofconsign,
  });

  factory DrsListModel.fromJson(Map<String, dynamic> json) {
    return DrsListModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      planningid: json['planningid'],
      planningdt: json['planningdt'],
      planningdraftcode: json['planningdraftcode'],
      manifestno: json['manifestno'],
      manifesttype: json['manifesttype'],
      tripid: json['tripid'],
      rejectedbyrider: json['rejectedbyrider'],
      drivercode: json['drivercode'],
      createddt: json['createddt'],
      tripconfirm: json['tripconfirm'] == null
          ? null
          : (json['tripconfirm'] == 1 || json['tripconfirm'] == true),
      noofconsign: json['noofconsign']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'planningid': planningid,
      'planningdt': planningdt,
      'planningdraftcode': planningdraftcode,
      'manifestno': manifestno,
      'manifesttype': manifesttype,
      'tripid': tripid,
      'rejectedbyrider': rejectedbyrider,
      'drivercode': drivercode,
      'createddt': createddt,
      'tripconfirm': tripconfirm,
      'noofconsign': noofconsign,
    };
  }
}
