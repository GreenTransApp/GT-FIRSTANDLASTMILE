class UpdateDeliveryModel {
  int? commandstatus;
  String? commandmessage;
  String? grNo;

  UpdateDeliveryModel({this.commandstatus, this.commandmessage});

  UpdateDeliveryModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    grNo = json['grNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['grNo'] = this.grNo;
    return data;
  }
}
