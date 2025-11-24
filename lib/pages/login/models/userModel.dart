class UserModel {
  int? commandstatus;
  String? commandmessage;
  String? compcode;
  String? usercode;
  String? username;
  String? defaultbranchcode;
  String? defaultbranchname;
  String? usergroupcode;
  String? sessionid;
  String? ledcode;
  String? ledname;
  String? logindatetime;
  String? stncode;
  String? stnname;
  String? custcode;
  String? companytype;
  int? companyid;
  String? empdob;
  String? empname;
  String? empdepartment;
  String? empdeignation;
  String? custname;
  String? unapprovedstrs;
  String? controlcode;
  String? password;
  String? currency;
  String? cscode;
  String? genablemodegroup;
  String? loginbranchtype;
  String? loginbranchcode;
  String? loginbranchname;
  String? appactivedate;
  int? employeeid;
  int? executiveid;
  String? dashboardnewdt;
  String? companyid1;
  String? compname;

  // ✅ Newly added fields
  String? mobileno;
  String? emailid;
  String? displayusername;

  UserModel({
    this.commandstatus,
    this.commandmessage,
    this.compcode,
    this.usercode,
    this.username,
    this.defaultbranchcode,
    this.defaultbranchname,
    this.usergroupcode,
    this.sessionid,
    this.ledcode,
    this.ledname,
    this.logindatetime,
    this.stncode,
    this.stnname,
    this.custcode,
    this.companytype,
    this.companyid,
    this.empdob,
    this.empname,
    this.empdepartment,
    this.empdeignation,
    this.custname,
    this.unapprovedstrs,
    this.controlcode,
    this.password,
    this.currency,
    this.cscode,
    this.genablemodegroup,
    this.loginbranchtype,
    this.loginbranchcode,
    this.loginbranchname,
    this.appactivedate,
    this.employeeid,
    this.executiveid,
    this.dashboardnewdt,
    this.companyid1,
    this.compname,
    this.mobileno,
    this.emailid,
    this.displayusername,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    compcode = json['compcode'];
    usercode = json['usercode'];
    username = json['username'];
    defaultbranchcode = json['defaultbranchcode'];
    defaultbranchname = json['defaultbranchname'];
    usergroupcode = json['usergroupcode'];
    sessionid = json['sessionid'];
    ledcode = json['ledcode'];
    ledname = json['ledname'];
    logindatetime = json['logindatetime'];
    stncode = json['stncode'];
    stnname = json['stnname'];
    custcode = json['custcode'];
    companytype = json['companytype'];
    companyid = json['companyid'];
    empdob = json['empdob'];
    empname = json['empname'];
    empdepartment = json['empdepartment'];
    empdeignation = json['empdeignation'];
    custname = json['custname'];
    unapprovedstrs = json['unapprovedstrs'];
    controlcode = json['controlcode'];
    password = json['password'];
    currency = json['currency'];
    cscode = json['cscode'];
    genablemodegroup = json['genablemodegroup'];
    loginbranchtype = json['loginbranchtype'];
    loginbranchcode = json['loginbranchcode'];
    loginbranchname = json['loginbranchname'];
    appactivedate = json['appactivedate'];
    employeeid = json['employeeid'];
    executiveid = json['executiveid'];
    dashboardnewdt = json['dashboardnewdt'];
    companyid1 = json['companyid1'];
    compname = json['compname'];
    mobileno = json['mobileno'];
    emailid = json['emailid'];
    displayusername = json['displayusername'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['compcode'] = compcode;
    data['usercode'] = usercode;
    data['username'] = username;
    data['defaultbranchcode'] = defaultbranchcode;
    data['defaultbranchname'] = defaultbranchname;
    data['usergroupcode'] = usergroupcode;
    data['sessionid'] = sessionid;
    data['ledcode'] = ledcode;
    data['ledname'] = ledname;
    data['logindatetime'] = logindatetime;
    data['stncode'] = stncode;
    data['stnname'] = stnname;
    data['custcode'] = custcode;
    data['companytype'] = companytype;
    data['companyid'] = companyid;
    data['empdob'] = empdob;
    data['empname'] = empname;
    data['empdepartment'] = empdepartment;
    data['empdeignation'] = empdeignation;
    data['custname'] = custname;
    data['unapprovedstrs'] = unapprovedstrs;
    data['controlcode'] = controlcode;
    data['password'] = password;
    data['currency'] = currency;
    data['cscode'] = cscode;
    data['genablemodegroup'] = genablemodegroup;
    data['loginbranchtype'] = loginbranchtype;
    data['loginbranchcode'] = loginbranchcode;
    data['loginbranchname'] = loginbranchname;
    data['appactivedate'] = appactivedate;
    data['employeeid'] = employeeid;
    data['executiveid'] = executiveid;
    data['dashboardnewdt'] = dashboardnewdt;
    data['companyid1'] = companyid1;
    data['compname'] = compname;
    data['mobileno'] = mobileno;
    data['emailid'] = emailid;
    data['displayusername'] = displayusername;
    return data;
  }
}
