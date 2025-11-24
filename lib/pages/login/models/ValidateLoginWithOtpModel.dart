class ValidateLoginwithOtpModel {

  int? commandstatus;
  Null? commandmessage;
  String? otp;
  String? smstext;

  ValidateLoginwithOtpModel({
    this.commandstatus,
    this.commandmessage,
    this.otp,
    this.smstext
  });
    ValidateLoginwithOtpModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    otp = json['otp'];
    smstext = json['smstext'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['otp'] = this.otp;
    data['smstext'] = this.smstext;
    return data;
  }
}
