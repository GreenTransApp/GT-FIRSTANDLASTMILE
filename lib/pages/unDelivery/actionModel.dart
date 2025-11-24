class ActionModel {
  int? commandstatus;
  String? reasoncode;
  String? reasonname;

  ActionModel({this.commandstatus, this.reasoncode, this.reasonname});

  ActionModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    reasoncode = json['reasoncode'];
    reasonname = json['reasonname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['reasoncode'] = this.reasoncode;
    data['reasonname'] = this.reasonname;
    return data;
  }
}
