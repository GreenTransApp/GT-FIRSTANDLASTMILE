class PodEntryOFflineRespModel {
  int? commandstatus;
  String? commandmessage;
  String? grno;

  PodEntryOFflineRespModel({this.commandstatus, this.commandmessage});

  PodEntryOFflineRespModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    grno = json['grno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['grno'] = this.grno;
    return data;
  }
}
