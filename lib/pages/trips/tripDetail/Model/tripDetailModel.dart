class TripDetailModel {
  String? manifestno;
  String? manifesttype;
  String? manifestdate;
  String? manifesttime;
  String? dispatchdt;
  String? dispatchtime;
  String? dispatchflag;
  int? planningid;
  int? noofconsign;
  int? deliveredconsign;
  int? undeliveredconsign;
  int? pendingDeliveries;
  int? noofrvpickups;
  int? noofpickups;

  TripDetailModel({
    this.manifestno,
    this.manifesttype,
    this.manifestdate,
    this.manifesttime,
    this.dispatchdt,
    this.dispatchtime,
    this.dispatchflag,
    this.planningid,
    this.noofconsign,
    this.deliveredconsign,
    this.undeliveredconsign,
    this.pendingDeliveries,
    this.noofrvpickups,
    this.noofpickups,
  });

  TripDetailModel.fromJson(Map<String, dynamic> json) {
    manifestno = json['manifestno'];
    manifesttype = json['manifesttype'];
    manifestdate = json['manifestdate'];
    manifesttime = json['manifesttime'];
    dispatchdt = json['dispatchdt'];
    dispatchtime = json['dispatchtime'];
    dispatchflag = json['dispatchflag'];
    planningid = json['planningid'];
    noofconsign = json['noofconsign'];
    deliveredconsign = json['deliveredconsign'];
    undeliveredconsign = json['undeliveredconsign'];
    pendingDeliveries = json['pendingDeliveries'];
    noofrvpickups = json['noofrvpickups'];
    noofpickups = json['noofpickups'];
  }

  Map<String, dynamic> toJson() {
    return {
      'manifestno': manifestno,
      'manifesttype': manifesttype,
      'manifestdate': manifestdate,
      'manifesttime': manifesttime,
      'dispatchdt': dispatchdt,
      'dispatchtime': dispatchtime,
      'dispatchflag': dispatchflag,
      'planningid': planningid,
      'noofconsign': noofconsign,
      'deliveredconsign': deliveredconsign,
      'undeliveredconsign': undeliveredconsign,
      'pendingDeliveries': pendingDeliveries,
      'noofrvpickups': noofrvpickups,
      'noofpickups': noofpickups,
    };
  }
}
