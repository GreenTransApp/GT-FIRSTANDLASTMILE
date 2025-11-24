class PunchInModel {
  int? commandstatus;
  String? commandmessage;

  PunchInModel({this.commandstatus, this.commandmessage});

  PunchInModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    return data;
  }
}