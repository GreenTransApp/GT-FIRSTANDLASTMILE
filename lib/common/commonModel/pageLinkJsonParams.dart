class PageLinkJsonParams {
  String? drivercode;
  int? transactionid;
  String? grno;
  String? orderid;

  PageLinkJsonParams(
      {this.drivercode, this.transactionid, this.grno, this.orderid});

  PageLinkJsonParams.fromJson(Map<String, dynamic> json) {
    drivercode = json['drivercode'];
    transactionid = json['transactionid'];
    grno = json['grno'];
    orderid = json['orderid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['drivercode'] = drivercode;
    data['transactionid'] = transactionid;
    data['grno'] = grno;
    data['orderid'] = orderid;
    return data;
  }
}
