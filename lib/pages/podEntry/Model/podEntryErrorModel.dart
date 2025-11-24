class PodEntryErrorModel {
  int? commandstatus;
  String? commandmessage;

  PodEntryErrorModel({this.commandstatus, this.commandmessage});

  PodEntryErrorModel.fromJson(Map<String, dynamic> json) {
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
