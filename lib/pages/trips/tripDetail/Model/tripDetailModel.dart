class TripDetailModel {
  final int tripid;
  final String drsno;
  final String manifestdate;
  final String manifesttime;
  final int planningid;
  final int totalconsign;
  final int noofrvpickups;
  final int noofpickups;
  final int pendingconsign;
  final int delivered;
  final int undelivered;
  final String ordertype;

  TripDetailModel({
    required this.tripid,
    required this.drsno,
    required this.manifestdate,
    required this.manifesttime,
    required this.planningid,
    required this.totalconsign,
    required this.noofrvpickups,
    required this.noofpickups,
    required this.pendingconsign,
    required this.delivered,
    required this.undelivered,
    required this.ordertype,
  });

  factory TripDetailModel.fromJson(Map<String, dynamic> json) {
    return TripDetailModel(
      tripid: json['tripid'],
      drsno: json['drsno'],
      manifestdate: json['manifestdate'],
      manifesttime: json['manifesttime'],
      planningid: json['planningid'],
      totalconsign: json['totalconsign'],
      noofrvpickups: json['noofrvpickups'],
      noofpickups: json['noofpickups'],
      pendingconsign: json['pendingconsign'],
      delivered: json['delivered'],
      undelivered: json['undelivered'],
      ordertype: json['ordertype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripid': tripid,
      'drsno': drsno,
      'manifestdate': manifestdate,
      'manifesttime': manifesttime,
      'planningid': planningid,
      'totalconsign': totalconsign,
      'noofrvpickups': noofrvpickups,
      'noofpickups': noofpickups,
      'pendingconsign': pendingconsign,
      'delivered': delivered,
      'undelivered': undelivered,
      'ordertype': ordertype,
    };
  }
}
