class TripOrderSummaryModel {
  int? commandstatus;
  String? commandmessage;
  String? grno;
  String? contactperson;
  String? contactno;
  String? pcs;
  String? undeliverreason;
  String? statusColor;
  String? deliverystatus;
  int? sequenceno;
  String? pickupstatus;
  String? reversepickupstatus;
  String? consignmenttype;
  String? consignmenttypeview;
  int? transactionid;
  String? dispatchdt;
  String? dispatchtime;

  TripOrderSummaryModel({
    this.commandstatus,
    this.commandmessage,
    this.grno,
    this.contactperson,
    this.contactno,
    this.pcs,
    this.undeliverreason,
    this.statusColor,
    this.deliverystatus,
    this.sequenceno,
    this.pickupstatus,
    this.reversepickupstatus,
    this.consignmenttype,
    this.consignmenttypeview,
    this.transactionid,
    this.dispatchdt,
    this.dispatchtime,
  });

  factory TripOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return TripOrderSummaryModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      grno: json['grno'],
      contactperson: json['contactperson'],
      contactno: json['contactno'],
      pcs: json['pcs'],
      undeliverreason: json['undeliverreason'],
      statusColor: json['statusColor'],
      deliverystatus: json['deliverystatus'],
      sequenceno: json['sequenceno'],
      pickupstatus: json['pickupstatus'],
      reversepickupstatus: json['reversepickupstatus'],
      consignmenttype: json['consignmenttype'],
      consignmenttypeview: json['consignmenttypeview'],
      transactionid: json['transactionid'],
      dispatchdt: json['dispatchdt'],
      dispatchtime: json['dispatchtime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'grno': grno,
      'contactperson': contactperson,
      'contactno': contactno,
      'pcs': pcs,
      'undeliverreason': undeliverreason,
      'statusColor': statusColor,
      'deliverystatus': deliverystatus,
      'sequenceno': sequenceno,
      'pickupstatus': pickupstatus,
      'reversepickupstatus': reversepickupstatus,
      'consignmenttype': consignmenttype,
      'consignmenttypeview': consignmenttypeview,
      'transactionid': transactionid,
      'dispatchdt': dispatchdt,
      'dispatchtime': dispatchtime,
    };
  }
}
