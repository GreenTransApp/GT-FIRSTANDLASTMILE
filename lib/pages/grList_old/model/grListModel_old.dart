class GrListModel_old {
  int? commandstatus;
  String? commandmessage;
  String? documentNo;
  String? date;
  String? origin;
  String? destination;
  String? noOfPackages;

  GrListModel_old(
      {this.documentNo,
      this.date,
      this.origin,
      this.destination,
      this.noOfPackages});

  GrListModel_old.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    documentNo = json['documentno'];
    date = json['date'];
    origin = json['origin'];
    destination = json['destination'];
    noOfPackages = json['noOfPackages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['documentno'] = this.documentNo;
    data['date'] = this.date;
    data['origin'] = this.origin;
    data['destination'] = this.destination;
    data['noOfPackages'] = this.noOfPackages;

    return data;
  }
}
