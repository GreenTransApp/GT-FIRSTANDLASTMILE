class UpdateDeliveryModel {
  int? commandstatus;
  String? commandmessage;
  String? grNo;
  String? stickerno;

  UpdateDeliveryModel(
      {this.commandstatus, this.commandmessage, this.grNo, this.stickerno});

  UpdateDeliveryModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    grNo = json['grNo'];
    stickerno = json['stickerno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['grNo'] = this.grNo;
    data['stickerno'] = this.stickerno;
    return data;
  }
}
