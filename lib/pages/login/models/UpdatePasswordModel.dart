class CommonUpdateModel {
  int? CommandStatus;
  String? CommandMessage;

  CommonUpdateModel({this.CommandStatus, this.CommandMessage});

  CommonUpdateModel.fromJson(Map<String, dynamic> json) {
    CommandStatus = json['commandstatus'];
    CommandMessage = json['commandmessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CommandStatus'] = CommandStatus;
    data['commandmessage'] = CommandMessage;
    return data;
  }
}
