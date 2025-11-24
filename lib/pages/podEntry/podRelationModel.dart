class PodRelationsModel {
  int? commandstatus;
  String? commandmessage;
  String? relations;

  PodRelationsModel({this.commandstatus, this.commandmessage, this.relations});

  PodRelationsModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    relations = json['relations'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['relations'] = this.relations;
    return data;
  }
}
