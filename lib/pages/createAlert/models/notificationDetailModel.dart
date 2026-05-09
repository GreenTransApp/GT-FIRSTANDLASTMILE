class NotificationDetailModel {
  String? commandstatus;
  String? commandmessage;
  String? createid;
  String? username;
  String? notificationid;
  String? notificationdt;
  String? notificationtime;
  String? eventid;
  String? notificationfor;
  String? notificationsubject;
  String? notificationtext;
  String? notificationtype;
  String? status;
  String? groupid;
  String? logindate;
  String? documentNo; // displayname as DocumentNo

  NotificationDetailModel({
    this.commandstatus,
    this.commandmessage,
    this.createid,
    this.username,
    this.notificationid,
    this.notificationdt,
    this.notificationtime,
    this.eventid,
    this.notificationfor,
    this.notificationsubject,
    this.notificationtext,
    this.notificationtype,
    this.status,
    this.groupid,
    this.logindate,
    this.documentNo,
  });

  NotificationDetailModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus']?.toString();
    commandmessage = json['commandmessage']?.toString();
    createid = json['createid']?.toString();
    username = json['username']?.toString();
    notificationid = json['notificationid']?.toString();
    notificationdt = json['notificationdt']?.toString();
    notificationtime = json['notificationtime']?.toString();
    eventid = json['eventid']?.toString();
    notificationfor = json['notificationfor']?.toString();
    notificationsubject = json['notificationsubject'];
    notificationtext = json['notificationtext'];
    notificationtype = json['notificationtype'];
    status = json['status']?.toString();
    groupid = json['groupid']?.toString();
    logindate = json['logindate']?.toString();
    documentNo = json['DocumentNo']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['createid'] = createid;
    data['username'] = username;
    data['notificationid'] = notificationid;
    data['notificationdt'] = notificationdt;
    data['notificationtime'] = notificationtime;
    data['eventid'] = eventid;
    data['notificationfor'] = notificationfor;
    data['notificationsubject'] = notificationsubject;
    data['notificationtext'] = notificationtext;
    data['notificationtype'] = notificationtype;
    data['status'] = status;
    data['groupid'] = groupid;
    data['logindate'] = logindate;
    data['DocumentNo'] = documentNo;
    return data;
  }
}