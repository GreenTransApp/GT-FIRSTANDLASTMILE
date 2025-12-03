class TripOrderSummaryModel {
  final int? commandstatus;
  final String? commandmessage;
  final int? dataid;
  final int? planningid;
  final String? planningdraftcode;
  final int? deliverysequenceno;
  final String? grno;
  final String? pickuplat;
  final String? pickuplong;
  final String? deliverylat;
  final String? deliverylong;
  final double? distance;
  final String? address;
  final int? indentid;
  final String? ordertype;
  final int? tripid;
  final String? startreading;
  final String? closereading;
  final String? dispatchdt;
  final String? dispatchtime;
  final String? starttriplocation;
  final String? endtripdt;
  final String? endtriptime;
  final String? closetrip;
  final String? startreadingimage;
  final String? closereadingimage;
  final String? closetriplocation;

  TripOrderSummaryModel({
    this.commandstatus,
    this.commandmessage,
    this.dataid,
    this.planningid,
    this.planningdraftcode,
    this.deliverysequenceno,
    this.grno,
    this.pickuplat,
    this.pickuplong,
    this.deliverylat,
    this.deliverylong,
    this.distance,
    this.address,
    this.indentid,
    this.ordertype,
    this.tripid,
    this.startreading,
    this.closereading,
    this.dispatchdt,
    this.dispatchtime,
    this.starttriplocation,
    this.endtripdt,
    this.endtriptime,
    this.closetrip,
    this.startreadingimage,
    this.closereadingimage,
    this.closetriplocation,
  });

  factory TripOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return TripOrderSummaryModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      dataid: json['dataid'],
      planningid: json['planningid'],
      planningdraftcode: json['planningdraftcode'],
      deliverysequenceno: json['deliverysequenceno'],
      grno: json['grno'],
      pickuplat: json['pickuplat'],
      pickuplong: json['pickuplong'],
      deliverylat: json['deliverylat'],
      deliverylong: json['deliverylong'],
      distance: json['distance']?.toDouble(),
      address: json['Address'],
      indentid: json['indentid'],
      ordertype: json['ordertype'],
      tripid: json['tripid'],
      startreading: json['startreading'],
      closereading: json['closereading'],
      dispatchdt: json['dispatchdt'],
      dispatchtime: json['dispatchtime'],
      starttriplocation: json['starttriplocation'],
      endtripdt: json['endtripdt'],
      endtriptime: json['endtriptime'],
      closetrip: json['closetrip'],
      startreadingimage: json['startreadingimage'],
      closereadingimage: json['closereadingimage'],
      closetriplocation: json['closetriplocation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "commandstatus": commandstatus,
      "commandmessage": commandmessage,
      "dataid": dataid,
      "planningid": planningid,
      "planningdraftcode": planningdraftcode,
      "deliverysequenceno": deliverysequenceno,
      "grno": grno,
      "pickuplat": pickuplat,
      "pickuplong": pickuplong,
      "deliverylat": deliverylat,
      "deliverylong": deliverylong,
      "distance": distance,
      "Address": address,
      "indentid": indentid,
      "ordertype": ordertype,
      "tripid": tripid,
      "startreading": startreading,
      "closereading": closereading,
      "dispatchdt": dispatchdt,
      "dispatchtime": dispatchtime,
      "starttriplocation": starttriplocation,
      "endtripdt": endtripdt,
      "endtriptime": endtriptime,
      "closetrip": closetrip,
      "startreadingimage": startreadingimage,
      "closereadingimage": closereadingimage,
      "closetriplocation": closetriplocation,
    };
  }
}
