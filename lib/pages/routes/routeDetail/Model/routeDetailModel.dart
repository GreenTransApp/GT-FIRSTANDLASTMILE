class RouteDetailModel {
  int? commandstatus;
  String? commandmessage;
  String? grno;
  String? cnge;
  String? address;
  double? deliverylat;
  double? deliverylong;
  double? pickuplat;
  double? pickuplong;
  String? cngr;
  String? pcs;
  String? distance;
  int? sequenceid;
  String? cngemobile;
  String? acceptedStatus;
  String? planningdraftcode;
  int? planningid;
  String? consignmenttype;
  String? consignmenttypeview;
  bool? checked;
  int? indentid;

  RouteDetailModel({
    this.commandstatus,
    this.commandmessage,
    this.grno,
    this.cnge,
    this.address,
    this.deliverylat,
    this.deliverylong,
    this.pickuplat,
    this.pickuplong,
    this.cngr,
    this.pcs,
    this.distance,
    this.sequenceid,
    this.cngemobile,
    this.acceptedStatus,
    this.planningdraftcode,
    this.planningid,
    this.consignmenttype,
    this.consignmenttypeview,
    this.checked = false,
    this.indentid,
  });

  RouteDetailModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    grno = json['grno'];
    cnge = json['cnge'];
    address = json['address'];
    deliverylat = (json['deliverylat'] is String)
        ? double.tryParse(json['deliverylat'])
        : (json['deliverylat'] as num?)?.toDouble();
    deliverylong = (json['deliverylong'] is String)
        ? double.tryParse(json['deliverylong'])
        : (json['deliverylong'] as num?)?.toDouble();
    pickuplat = (json['pickuplat'] is String)
        ? double.tryParse(json['pickuplat'])
        : (json['pickuplat'] as num?)?.toDouble();
    pickuplong = (json['pickuplong'] is String)
        ? double.tryParse(json['pickuplong'])
        : (json['pickuplong'] as num?)?.toDouble();
    cngr = json['cngr'];
    pcs = json['pcs'];
    distance = json['distance'];
    sequenceid = json['sequenceid'];
    cngemobile = json['cngemobile'];
    acceptedStatus = json['acceptedStatus'];
    planningdraftcode = json['planningdraftcode'];
    planningid = json['planningid'];
    consignmenttype = json['consignmenttype'];
    consignmenttypeview = json['consignmenttypeview'];
    checked = json['checked'] ?? false;
    indentid = json['indentid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['grno'] = grno;
    data['cnge'] = cnge;
    data['address'] = address;
    data['deliverylat'] = deliverylat;
    data['deliverylong'] = deliverylong;
    data['pickuplat'] = pickuplat;
    data['pickuplong'] = pickuplong;
    data['cngr'] = cngr;
    data['pcs'] = pcs;
    data['distance'] = distance;
    data['sequenceid'] = sequenceid;
    data['cngemobile'] = cngemobile;
    data['acceptedStatus'] = acceptedStatus;
    data['planningdraftcode'] = planningdraftcode;
    data['planningid'] = planningid;
    data['consignmenttype'] = consignmenttype;
    data['consignmenttypeview'] = consignmenttypeview;
    data['checked'] = checked;
    data['indentid'] = indentid;
    return data;
  }
}
