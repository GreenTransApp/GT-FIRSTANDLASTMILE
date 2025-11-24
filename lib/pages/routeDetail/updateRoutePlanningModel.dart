class UpdateRoutePlanningModel {
  int? commandstatus;
  String? commandmessage;
  int? planningid;

  UpdateRoutePlanningModel(
      {this.commandstatus, this.commandmessage, this.planningid});

  UpdateRoutePlanningModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    planningid = json['planningid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['planningid'] = this.planningid;
    return data;
  }
}
