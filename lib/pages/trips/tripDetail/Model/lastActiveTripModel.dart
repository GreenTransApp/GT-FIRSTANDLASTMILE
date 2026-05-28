class LastActiveTripModel {
  int? commandstatus;
  String? commandmessage;

  int? tripid;

  int? laststartreadingkm;
  int? lastendreadingkm;

  String? lasttripdispatchdate;
  String? lasttripdispatchtime;

  String? readingdiff;
  String? odometerbypass;

  LastActiveTripModel({
    this.commandstatus,
    this.commandmessage,
    this.tripid,
    this.laststartreadingkm,
    this.lastendreadingkm,
    this.lasttripdispatchdate,
    this.lasttripdispatchtime,
    this.readingdiff,
    this.odometerbypass,
  });

  LastActiveTripModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage']?.toString();

    tripid = json['tripid'];

    laststartreadingkm = json['laststartreadingkm'];
    lastendreadingkm = json['lastendreadingkm'];

    lasttripdispatchdate = json['lasttripdispatchdate']?.toString();

    lasttripdispatchtime = json['lasttripdispatchtime']?.toString();

    readingdiff = json['readingdiff'];

    odometerbypass = json['odometerbypass']?.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'tripid': tripid,
      'laststartreadingkm': laststartreadingkm,
      'lastendreadingkm': lastendreadingkm,
      'lasttripdispatchdate': lasttripdispatchdate,
      'lasttripdispatchtime': lasttripdispatchtime,
      'readingdiff': readingdiff,
      'odometerbypass': odometerbypass,
    };
  }
}
