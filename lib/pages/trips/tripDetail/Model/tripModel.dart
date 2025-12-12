class TripModel {
  int? commandstatus;
  String? commandmessage;
  int? tripid;
  int? totaldrs;
  int? totalconsignment;
  int? deliveredconsignment;
  int? undeliveredconsignment;
  int? totalpickup;
  int? pendingconsignment;
  String? manifestdate;
  String? manifesttime;
  String? manifestdatetime;
  String? tripdispatchdatetime;
  String? tripdispatchdate;
  String? tripdispatchtime;
  String? acceptedflag;
  int? startreadingkm;
  String? startreadingimgpath;
  String? endtripdate;
  String? endtriptime;
  String? endreadingimg;
  int? endreadingkm;
  // String? closetripdatetime;
  int? noofconsign;
  int? deliveredconsign;
  int? undeliveredconsign;
  int? pendingDeliveries;
  int? noofrvpickups;
  int? noofpickups;
  int? pendingIndent;

  TripModel({
    this.commandstatus,
    this.commandmessage,
    this.tripid,
    this.totaldrs,
    this.totalconsignment,
    this.deliveredconsignment,
    this.undeliveredconsignment,
    this.totalpickup,
    this.pendingconsignment,
    this.manifestdate,
    this.manifesttime,
    this.manifestdatetime,
    this.tripdispatchdatetime,
    this.tripdispatchdate,
    this.tripdispatchtime,
    this.acceptedflag,
    this.startreadingkm,
    this.startreadingimgpath,
    this.endtripdate,
    this.endtriptime,
    this.endreadingimg,
    this.endreadingkm,
    this.noofconsign,
    this.deliveredconsign,
    this.undeliveredconsign,
    this.pendingDeliveries,
    this.noofrvpickups,
    this.noofpickups,
    this.pendingIndent,
  });

  TripModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    tripid = json['tripid'];
    totaldrs = json['totaldrs'];
    totalconsignment = json['totalconsignment'];
    deliveredconsignment = json['deliveredconsignment'];
    undeliveredconsignment = json['undeliveredconsignment'];
    totalpickup = json['totalpickup'];
    pendingconsignment = json['pendingconsignment'];
    manifestdate = json['manifestdate']?.toString();
    manifesttime = json['manifesttime']?.toString();
    manifestdatetime = json['manifestdatetime']?.toString();
    tripdispatchdatetime = json['tripdispatchdatetime']?.toString();
    tripdispatchdate = json['tripdispatchdate']?.toString();
    tripdispatchtime = json['tripdispatchtime']?.toString();
    acceptedflag = json['acceptedflag']?.toString();
    startreadingkm = json['startreadingkm'];
    startreadingimgpath = json['startreadingimg'];
    endtripdate = json['endtripdate'];
    endtriptime = json['endtriptime'];
    endreadingimg = json['endreadingimg']?.toString();
    endreadingkm = json['endreadingkm'];
    noofconsign = json['noofconsign'];
    deliveredconsign = json['deliveredconsign'];
    undeliveredconsign = json['undeliveredconsign'];
    pendingDeliveries = json['pendingDeliveries'];
    noofrvpickups = json['noofrvpickups'];
    noofpickups = json['noofpickups'];
    pendingIndent = json['pendingIndent'];
  }

  Map<String, String> toJson() {
    return {
      'commandstatus': commandstatus?.toString() ?? '',
      'commandmessage': commandmessage ?? '',
      'tripid': tripid?.toString() ?? '',
      'totaldrs': totaldrs?.toString() ?? '',
      'totalconsignment': totalconsignment?.toString() ?? '',
      'deliveredconsignment': deliveredconsignment?.toString() ?? '',
      'undeliveredconsignment': undeliveredconsignment?.toString() ?? '',
      'totalpickup': totalpickup?.toString() ?? '',
      'pendingconsignment': pendingconsignment?.toString() ?? '',
      'manifestdate': manifestdate ?? '',
      'manifesttime': manifesttime ?? '',
      'manifestdatetime': manifestdatetime ?? '',
      'tripdispatchdatetime': tripdispatchdatetime ?? '',
      'tripdispatchdate': tripdispatchdate ?? '',
      'tripdispatchtime': tripdispatchtime ?? '',
      'acceptedflag': acceptedflag ?? '',
      'startreadingkm': startreadingkm?.toString() ?? '',
      'startreadingimg': startreadingimgpath ?? '',
      'endtripdate': endtripdate ?? '',
      'endtriptime': endtriptime ?? '',
      'endreadingimg': endreadingimg ?? '',
      'endreadingkm': endreadingkm?.toString() ?? '',
      'noofconsign': noofconsign?.toString() ?? '',
      'deliveredconsign': deliveredconsign?.toString() ?? '',
      'undeliveredconsign': undeliveredconsign?.toString() ?? '',
      'pendingDeliveries': pendingDeliveries?.toString() ?? '',
      'noofrvpickups': noofrvpickups?.toString() ?? '',
      'noofpickups': noofpickups?.toString() ?? '',
      'pendingIndent': pendingIndent?.toString() ?? '',
    };
  }
}
