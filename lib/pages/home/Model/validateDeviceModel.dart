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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['validlogin'] = this.validlogin;
    data['singledevice'] = this.singledevice;
    data['requiredaupdate'] = this.requiredaupdate;
    data['executiveid'] = this.executiveid;
    data['employeeid'] = this.employeeid;
    return data;
  }
}
