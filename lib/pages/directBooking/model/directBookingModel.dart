class DirectBookingModel {
  int? commandstatus;
  String? commandmessage;
  String? grno;
  String? cngename;
  String? cngeaddress;
  String? cngemobile;
  String? pcs;
  String? undeliverreason;
  String? statusColor;
  String? pickupstatus;
  String? consignmenttype;
  int? transactionid;
  String? manifestno;
  String? manifesttype;
  int? orderid;
  String? reached;
  String? reachedlat;
  String? reachedlong;
  String? generatedGr;
  int? tripid;
  String? deliverylat;
  String? deliverylong;
  String? pickuplat;
  String? pickuplong;

  DirectBookingModel({
    this.commandstatus,
    this.commandmessage,
    this.grno,
    this.cngename,
    this.cngeaddress,
    this.cngemobile,
    this.pcs,
    this.undeliverreason,
    this.statusColor,
    this.pickupstatus,
    this.consignmenttype,
    this.transactionid,
    this.manifestno,
    this.manifesttype,
    this.orderid,
    this.reached,
    this.reachedlat,
    this.reachedlong,
    this.generatedGr,
    this.tripid,
    this.deliverylat,
    this.deliverylong,
    this.pickuplat,
    this.pickuplong,
  });

  factory DirectBookingModel.fromJson(Map<String, dynamic> json) {
    return DirectBookingModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      grno: json['grno'],
      cngename: json['cngename'],
      cngeaddress: json['cngeaddress'],
      cngemobile: json['cngemobile'],
      pcs: json['pcs'],
      undeliverreason: json['undeliverreason'],
      statusColor: json['statusColor'],
      pickupstatus: json['pickupstatus'],
      consignmenttype: json['consignmenttype'],
      transactionid: json['transactionid'],
      manifestno: json['manifestno'],
      manifesttype: json['manifesttype'],
      orderid: json['orderid'],
      reached: json['reached'],
      reachedlat: json['reachedlat'],
      reachedlong: json['reachedlong'],
      generatedGr: json['generatedgr'],
      tripid: json['tripid'],
      deliverylat: json['deliverylat'],
      deliverylong: json['deliverylong'],
      pickuplat: json['pickuplat'],
      pickuplong: json['pickuplong'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'grno': grno,
      'cngename': cngename,
      'cngeaddress': cngeaddress,
      'cngemobile': cngemobile,
      'pcs': pcs,
      'undeliverreason': undeliverreason,
      'statusColor': statusColor,
      'pickupstatus': pickupstatus,
      'consignmenttype': consignmenttype,
      'transactionid': transactionid,
      'manifestno': manifestno,
      'manifesttype': manifesttype,
      'orderid': orderid,
      'reached': reached,
      'reachedlat': reachedlat,
      'reachedlong': reachedlong,
      'generatedgr': generatedGr,
      'tripid': tripid,
      'deliverylat': deliverylat,
      'deliverylong': deliverylong,
      'pickuplat': pickuplat,
      'pickuplong': pickuplong,
    };
  }
}