class TripMisJsonParams {
  String? fromdt;
  String? todt;
  String? branchname;
  String? branchcode;
  String? ridername;
  String? ridercode;
  String? drsno;
  String? cnno;

  TripMisJsonParams({
    this.fromdt,
    this.todt,
    this.branchname,
    this.branchcode,
    this.ridername,
    this.ridercode,
    this.drsno,
    this.cnno,
  });

  TripMisJsonParams.fromJson(Map<String, dynamic> json) {
    fromdt = json['fromdt'];
    todt = json['todt'];
    branchname = json['branchname'];
    branchcode = json['branchcode'];
    ridername = json['ridername'];
    ridercode = json['ridercode'];
    drsno = json['drsno'];
    cnno = json['cnno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fromdt'] = fromdt;
    data['todt'] = todt;
    data['branchname'] = branchname;
    data['branchcode'] = branchcode;
    data['ridername'] = ridername;
    data['ridercode'] = ridercode;
    data['drsno'] = drsno;
    data['cnno'] = cnno;
    return data;
  }
}
