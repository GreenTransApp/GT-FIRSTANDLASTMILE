class LoginModel {
  int? commandstatus;
  String? commandmessage;
  int? companyid;
  String? displayname;
  String? location;
  String? dbname;
  String? serverip;
  String? dbpassword;
  String? connstring;
  String? compname;
  String? logoimage;
  String? grouplogin;
  String? mobileno;
  String? username;
  String? password;
  String? ewayuserid;
  String? ewaypassword;
  String? enableeway;
  String? compgstin;
  String? smtpfrom;
  String? host;
  int? port;
  String? emailusername;
  String? emailpassword;
  String? ewayurl;
  String? divisionlogin;
  String? logilockeruserid;
  String? logilockerpassword;

  LoginModel(
      {this.commandstatus,
      this.commandmessage,
      this.companyid,
      this.displayname,
      this.location,
      this.dbname,
      this.serverip,
      this.dbpassword,
      this.connstring,
      this.compname,
      this.logoimage,
      this.grouplogin,
      this.mobileno,
      this.username,
      this.password,
      this.ewayuserid,
      this.ewaypassword,
      this.enableeway,
      this.compgstin,
      this.smtpfrom,
      this.host,
      this.port,
      this.emailusername,
      this.emailpassword,
      this.ewayurl,
      this.divisionlogin,
      this.logilockeruserid,
      this.logilockerpassword});

  LoginModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    companyid = json['companyid'];
    displayname = json['displayname'];
    location = json['location'];
    dbname = json['dbname'];
    serverip = json['serverip'];
    dbpassword = json['dbpassword'];
    connstring = json['connstring'];
    compname = json['compname'];
    logoimage = json['logoimage'];
    grouplogin = json['grouplogin'];
    mobileno = json['mobileno'];
    username = json['username'];
    password = json['password'];
    ewayuserid = json['ewayuserid'];
    ewaypassword = json['ewaypassword'];
    enableeway = json['enableeway'];
    compgstin = json['compgstin'];
    smtpfrom = json['smtpfrom'];
    host = json['host'];
    port = json['port'];
    emailusername = json['emailusername'];
    emailpassword = json['emailpassword'];
    ewayurl = json['ewayurl'];
    divisionlogin = json['divisionlogin'];
    logilockeruserid = json['logilockeruserid'];
    logilockerpassword = json['logilockerpassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['companyid'] = this.companyid;
    data['displayname'] = this.displayname;
    data['location'] = this.location;
    data['dbname'] = this.dbname;
    data['serverip'] = this.serverip;
    data['dbpassword'] = this.dbpassword;
    data['connstring'] = this.connstring;
    data['compname'] = this.compname;
    data['logoimage'] = this.logoimage;
    data['grouplogin'] = this.grouplogin;
    data['mobileno'] = this.mobileno;
    data['username'] = this.username;
    data['password'] = this.password;
    data['ewayuserid'] = this.ewayuserid;
    data['ewaypassword'] = this.ewaypassword;
    data['enableeway'] = this.enableeway;
    data['compgstin'] = this.compgstin;
    data['smtpfrom'] = this.smtpfrom;
    data['host'] = this.host;
    data['port'] = this.port;
    data['emailusername'] = this.emailusername;
    data['emailpassword'] = this.emailpassword;
    data['ewayurl'] = this.ewayurl;
    data['divisionlogin'] = this.divisionlogin;
    data['logilockeruserid'] = this.logilockeruserid;
    data['logilockerpassword'] = this.logilockerpassword;
    return data;
  }
}
