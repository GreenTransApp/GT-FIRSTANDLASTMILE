class DrsListModel {
  int? planningid;
  String? planningdt;
  String? manifestno;
  String? manifesttype;
  int? tripid;
  String? rejectedbyrider;
  String? drivercode;
  String? createddt;
  int? tripconfirm;
  int? noofconsign;

  DrsListModel({
    this.planningid,
    this.planningdt,
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
      planningid: json['planningid'],
      planningdt: json['planningdt'],
      manifestno: json['manifestno'],
      manifesttype: json['manifesttype'],
      tripid: json['tripid'],
      rejectedbyrider: json['rejectedbyrider'],
      drivercode: json['drivercode'],
      createddt: json['createddt'],
      tripconfirm: json['tripconfirm'],
      noofconsign: json['noofconsign'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'planningid': planningid,
      'planningdt': planningdt,
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
