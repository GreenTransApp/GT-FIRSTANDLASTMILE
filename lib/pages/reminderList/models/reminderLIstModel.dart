class ReminderListModel {
  int? sno;
  String? alertid;
  String? alertdate;
  String? subject;
  String? alerttext;
  String? alertfrom;
  String? readstatus;
  String? url;
  String? groupid;
  String? totalpendingfollowup;

  ReminderListModel({
    this.sno,
    this.alertid,
    this.alertdate,
    this.subject,
    this.alerttext,
    this.alertfrom,
    this.readstatus,
    this.url,
    this.groupid,
    this.totalpendingfollowup,
  });

  ReminderListModel.fromJson(Map<String, dynamic> json) {
    sno = json['sno'];
    alertid = json['alertid']?.toString();
    alertdate = json['alertdate']?.toString();
    subject = json['subject'];
    alerttext = json['alerttext'];
    alertfrom = json['alertfrom'];
    readstatus = json['readstatus'];
    url = json['url'];
    groupid = json['groupid']?.toString();
    totalpendingfollowup = json['totalpendingfollowup']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sno'] = sno;
    data['alertid'] = alertid;
    data['alertdate'] = alertdate;
    data['subject'] = subject;
    data['alerttext'] = alerttext;
    data['alertfrom'] = alertfrom;
    data['readstatus'] = readstatus;
    data['url'] = url;
    data['groupid'] = groupid;
    data['totalpendingfollowup'] = totalpendingfollowup;
    return data;
  }
}
