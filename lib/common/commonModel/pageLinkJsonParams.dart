class PageLinkJsonParams {
  String? drivercode;
  int? transactionid;
  String? grno;

  PageLinkJsonParams({
    this.drivercode,
    this.transactionid,
    this.grno,
  });

  PageLinkJsonParams.fromJson(Map<String, dynamic> json) {
    drivercode = json['drivercode'];
    transactionid = json['transactionid'];
    grno = json['grno'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['drivercode'] = drivercode;
    data['transactionid'] = transactionid;
    data['grno'] = grno;

    return data;
  }
}
