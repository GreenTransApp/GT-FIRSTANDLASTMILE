class DrsDateTimeUpdateModel {
  int? commandstatus;
  String? commandmessage;
  int? tripid;
  String? tripstatus;

  DrsDateTimeUpdateModel({
    this.commandstatus,
    this.commandmessage,
    this.tripid,
    this.tripstatus,
  });

  DrsDateTimeUpdateModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    // drsno = json['drsno'];
    tripid = json['tripid'];
    tripstatus = json['tripstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['tripid'] = tripid;
    data['tripstatus'] = tripstatus;
    return data;
  }
}
