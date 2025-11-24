class UpsertTripResponseModel {
  int? commandstatus;
  String? commandmessage;
  int? tripid;
  String? tripstatus;

  UpsertTripResponseModel({
    this.commandstatus,
    this.commandmessage,
    this.tripid,
    this.tripstatus,
  });

  UpsertTripResponseModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    tripid = json['tripid'];
    tripstatus = json['tripstatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['tripid'] = tripid;
    data['tripstatus'] = tripstatus;
    return data;
  }
}
