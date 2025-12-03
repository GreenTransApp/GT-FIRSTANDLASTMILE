class RouteUpdateModel {
  int? commandstatus; // Command status, type int
  String? commandmessage; // Command message, type String
  int? planningid; // Planning ID, type int

  // Constructor
  RouteUpdateModel({
    this.commandstatus,
    this.commandmessage,
    this.planningid,
  });

  // From JSON Constructormk8
  RouteUpdateModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    planningid = json['planningid'];
  }

  // To JSON Method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['planningid'] = planningid;
    return data;
  }
}
