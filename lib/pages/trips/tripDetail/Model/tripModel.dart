class TripModel {
  int? commandstatus;
  String? commandmessage;
  int? tripid;
  int? planningid;

  String? tripdispatchdate;
  String? tripdispatchtime;
  String? tripdispatchdatetime;

  int? startreadingkm;
  int? endreadingkm;

  String? startreadingimg;
  String? endreadingimg;

  String? endtripdate;
  String? endtriptime;

  String? drivercode;

  int? noofconsign;
  int? deliveredconsign;
  int? undeliveredconsign;
  int? noofrvpickups;
  int? noofpickups;
  int? pendingconsign;

  String? manifestdate;
  String? manifesttime;
  String? manifestdatetime;

  TripModel({
    this.commandstatus,
    this.commandmessage,
    this.tripid,
    this.planningid,
    this.tripdispatchdate,
    this.tripdispatchtime,
    this.tripdispatchdatetime,
    this.startreadingkm,
    this.endreadingkm,
    this.startreadingimg,
    this.endreadingimg,
    this.endtripdate,
    this.endtriptime,
    this.drivercode,
    this.noofconsign,
    this.deliveredconsign,
    this.undeliveredconsign,
    this.noofrvpickups,
    this.noofpickups,
    this.pendingconsign,
    this.manifestdate,
    this.manifesttime,
    this.manifestdatetime,
  });

  TripModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    tripid = json['tripid'];
    planningid = json['planningid'];

    tripdispatchdate = json['tripdispatchdate']?.toString();
    tripdispatchtime = json['tripdispatchtime']?.toString();
    tripdispatchdatetime = json['tripdispatchdatetime']?.toString();

    startreadingkm = json['startreadingkm'];
    endreadingkm = json['endreadingkm'];

    startreadingimg = json['startreadingimg']?.toString();
    endreadingimg = json['endreadingimg']?.toString();

    endtripdate = json['endtripdate']?.toString();
    endtriptime = json['endtriptime']?.toString();

    drivercode = json['drivercode']?.toString();

    noofconsign = json['noofconsign'];
    deliveredconsign = json['deliveredconsign'];
    undeliveredconsign = json['undeliveredconsign'];
    noofrvpickups = json['noofrvpickups'];
    noofpickups = json['noofpickups'];
    pendingconsign = json['pendingconsign'];

    manifestdate = json['manifestdate']?.toString();
    manifesttime = json['manifesttime']?.toString();
    manifestdatetime = json['manifestdatetime']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'tripid': tripid,
      'planningid': planningid,
      'tripdispatchdate': tripdispatchdate,
      'tripdispatchtime': tripdispatchtime,
      'tripdispatchdatetime': tripdispatchdatetime,
      'startreadingkm': startreadingkm,
      'endreadingkm': endreadingkm,
      'startreadingimg': startreadingimg,
      'endreadingimg': endreadingimg,
      'endtripdate': endtripdate,
      'endtriptime': endtriptime,
      'drivercode': drivercode,
      'noofconsign': noofconsign,
      'deliveredconsign': deliveredconsign,
      'undeliveredconsign': undeliveredconsign,
      'noofrvpickups': noofrvpickups,
      'noofpickups': noofpickups,
      'pendingconsign': pendingconsign,
      'manifestdate': manifestdate ?? '',
      'manifesttime': manifesttime ?? '',
      'manifestdatetime': manifestdatetime ?? '',
    };
  }
}
