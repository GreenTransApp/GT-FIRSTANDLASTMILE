class DeliveryDetailModel {
  int? commandstatus;
  String? commandmessage;
  String? grno;
  String? cngename;
  String? cngemobile;
  String? pcs;
  String? undeliverreason;
  String? deliverystatus;
  String? statusColor;
  int? sequenceno;
  int? planningid;

  String? consignmenttype;
  String? pickupstatus;
  String? reversepickupstatus;
  String? consignmenttypeview;
  int? transactionid;

  DeliveryDetailModel({
    this.commandstatus,
    this.commandmessage,
    this.grno,
    this.cngename,
    this.cngemobile,
    this.pcs,
    this.undeliverreason,
    this.deliverystatus,
    this.statusColor,
    this.sequenceno,
    this.planningid,
    this.consignmenttype,
    this.pickupstatus,
    this.reversepickupstatus,
    this.consignmenttypeview,
    this.transactionid,
  });

  factory DeliveryDetailModel.fromJson(Map<String, dynamic> json) {
    return DeliveryDetailModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      grno: json['grno'],
      cngename: json['cngename'],
      cngemobile: json['cngemobile'],
      pcs: json['pcs'],
      undeliverreason: json['undeliverreason'],
      deliverystatus: json['deliverystatus'],
      statusColor: json['statusColor'],
      sequenceno: json['sequenceno'],
      planningid: json['planningid'],
      consignmenttype: json['consignmenttype'],
      pickupstatus: json['pickupstatus'],
      reversepickupstatus: json['reversepickupstatus'],
      consignmenttypeview: json['consignmenttypeview'],
      transactionid: json['transactionid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'grno': grno,
      'cngename': cngename,
      'cngemobile': cngemobile,
      'pcs': pcs,
      'undeliverreason': undeliverreason,
      'deliverystatus': deliverystatus,
      'statusColor': statusColor,
      'sequenceno': sequenceno,
      'planningid': planningid,
      'consignmenttype': consignmenttype,
      'pickupstatus': pickupstatus,
      'reversepickupstatus': reversepickupstatus,
      'consignmenttypeview': consignmenttypeview,
      'transactionid': transactionid,
    };
  }
}
