class UserCredsModel {
  int? commandstatus;
  Null? commandmessage;
  String? userpassword;
  String? emailid;
  int? companyid;
  String? username; // Added username field

  UserCredsModel(
      {this.commandstatus,
      this.commandmessage,
      this.userpassword,
      this.emailid,
      this.companyid,
      this.username}); // Included in constructor

  UserCredsModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    userpassword = json['userpassword'];
    emailid = json['emailid'];
    companyid = json['companyid'];
    username = json['username']; // Mapped in fromJson
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['userpassword'] = userpassword;
    data['emailid'] = emailid;
    data['companyid'] = companyid;
    data['username'] = username; // Added to toJson
    return data;
  }
}
