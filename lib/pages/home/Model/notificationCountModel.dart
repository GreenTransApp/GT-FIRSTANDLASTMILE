class NotificationCountModel {
  int? commandstatus;
  String? commandmessage;
  String? approvalcount;
  String? remindercount;
  String? totalcount;

  NotificationCountModel(
      {this.commandstatus,
      this.commandmessage,
      this.approvalcount,
      this.remindercount,
      this.totalcount});

  NotificationCountModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage']?.toString();
    approvalcount = json['approvalcount']?.toString();
    remindercount = json['remindercount'].toString();
    totalcount = json['totalcount'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['approvalcount'] = approvalcount;
    data['remindercount'] = remindercount;
    data['totalcount'] = totalcount;
    return data;
  }
}
