class ValidateDeviceModel {
  int? commandstatus;
  String? commandmessage;
  String? validlogin;
  String? singledevice;
  String? requiredaupdate;
  int? executiveid;
  int? employeeid;

  ValidateDeviceModel(
      {this.commandstatus,
      this.commandmessage,
      this.validlogin,
      this.singledevice,
      this.requiredaupdate,
      this.executiveid,
      this.employeeid});

  ValidateDeviceModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    validlogin = json['validlogin'];
    singledevice = json['singledevice'];
    requiredaupdate = json['requiredaupdate'];
    executiveid = json['executiveid'];
    employeeid = json['employeeid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['validlogin'] = validlogin;
    data['singledevice'] = singledevice;
    data['requiredaupdate'] = requiredaupdate;
    data['executiveid'] = executiveid;
    data['employeeid'] = employeeid;
    return data;
  }
}
