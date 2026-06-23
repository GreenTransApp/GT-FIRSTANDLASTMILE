class ReasonModel {
  int? commandstatus;
  String? reasoncode;
  String? reasonname;
  String? imagerequired;
  String? reasontype;

  ReasonModel(
      {this.commandstatus,
      this.reasoncode,
      this.reasonname,
      this.imagerequired,
      this.reasontype});

  ReasonModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    reasoncode = json['reasoncode'];
    reasonname = json['reasonname'];
    imagerequired = json['imagerequired'];
    reasontype = json['reasontype'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['reasoncode'] = this.reasoncode;
    data['reasonname'] = this.reasonname;
    data['imagerequired'] = this.imagerequired;
    data['reasontype'] = this.reasontype;
    return data;
  }
}
