class ConsignmentModel {
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
  String? weight;
  String? address;
  String? startreadingimage;
  String? closereadingimage;
  String? podimage;
  String? signimage;

  ConsignmentModel({
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
    this.weight,
    this.address,
    this.startreadingimage,
    this.closereadingimage,
    this.podimage,
    this.signimage,
  });

  factory ConsignmentModel.fromJson(Map<String, dynamic> json) {
    return ConsignmentModel(
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
      weight: json['weight']?.toString(),
      address: json['address'],
      startreadingimage: json['startreadingimage'],
      closereadingimage: json['closereadingimage'],
      podimage: json['podimage'],
      signimage: json['signimage'],
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
      'weight': weight,
      'address': address,
      'startreadingimage': startreadingimage,
      'closereadingimage': closereadingimage,
      'podimage': podimage,
      'signimage': signimage,
    };
  }
}
