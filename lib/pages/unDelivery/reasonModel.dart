class ReasonModel {
  int? commandstatus;
  String? reasoncode;
  String? reasonname;
  String? imagerequired;

  ReasonModel(
      {this.commandstatus,
      this.reasoncode,
      this.reasonname,
      this.imagerequired});

  ReasonModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    reasoncode = json['reasoncode'];
    reasonname = json['reasonname'];
    imagerequired = json['imagerequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['reasoncode'] = this.reasoncode;
    data['reasonname'] = this.reasonname;
    data['imagerequired'] = this.imagerequired;
    return data;
  }
}
