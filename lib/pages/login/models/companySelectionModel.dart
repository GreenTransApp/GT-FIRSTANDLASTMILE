class CompanySelectionModel {
  int? commandstatus;
  int? companyid;
  String? compname;
  String? logopath;
  String? connstring;

  CompanySelectionModel(
      {this.commandstatus,
      this.companyid,
      this.compname,
      this.logopath,
      this.connstring});

  CompanySelectionModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    companyid = json['companyid'];
    compname = json['compname'];
    logopath = json['logopath'];
    connstring = json['connstring'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['companyid'] = this.companyid;
    data['compname'] = this.compname;
    data['logopath'] = this.logopath;
    data['connstring'] = this.connstring;
    return data;
  }
}
