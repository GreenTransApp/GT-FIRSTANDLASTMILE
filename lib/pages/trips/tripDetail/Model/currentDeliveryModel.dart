class CurrentDeliveryModel {
  int? commandstatus;
  String? commandmessage;
  String? drsno;
  String? manifestdate;
  String? manifesttime;
  String? manifestdatetime;
  String? dispatchdatetime;
  String? dispatchtime;
  String? dispatchdt;
  int? noofconsign;
  int? deliveredconsign;
  int? pendingconsign;
  int? undeliveredconsign;
  String? dispatchflag;
  int? startreadingkm;
  String? startreadingimgpath;
  int? planningid;
  int? totpickup;
  String? closeTripDate;
  String? closeTripTime;
  String? closeReadingImagePath;
  int? closeReadingKm;
  String? closetripdatetime;
  bool? tripconfirm;

  CurrentDeliveryModel({
    this.commandstatus,
    this.commandmessage,
    this.drsno,
    this.manifestdate,
    this.manifesttime,
    this.manifestdatetime,
    this.dispatchdatetime,
    this.dispatchtime,
    this.dispatchdt,
    this.noofconsign,
    this.deliveredconsign,
    this.pendingconsign,
    this.undeliveredconsign,
    this.dispatchflag,
    this.startreadingkm,
    this.startreadingimgpath,
    this.planningid,
    this.totpickup,
    this.closeTripDate,
    this.closeTripTime,
    this.closeReadingImagePath,
    this.closeReadingKm,
    this.closetripdatetime,
    this.tripconfirm = false,
  });

  CurrentDeliveryModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    drsno = json['drsno'];
    manifestdate = json['manifestdate']?.toString();
    manifesttime = json['manifesttime']?.toString();
    manifestdatetime = json['manifestdatetime']?.toString();
    dispatchdatetime = json['dispatchdatetime']?.toString();
    dispatchtime = json['dispatchtime']?.toString();
    dispatchdt = json['dispatchdt']?.toString();
    noofconsign = json['noofconsign'];
    deliveredconsign = json['deliveredconsign'];
    pendingconsign = json['pendingconsign'];
    undeliveredconsign = json['undeliveredconsign'];
    dispatchflag = json['dispatchflag']?.toString();
    startreadingkm = json['startreadingkm'];
    startreadingimgpath = json['startreadingimg']?.toString();
    planningid = json['planningid'];
    totpickup = json['totpickup'];
    closeTripDate = json['closetripdt']?.toString();
    closeTripTime = json['closetriptime']?.toString();
    closeReadingImagePath = json['endreadingimg']?.toString();
    closeReadingKm = json['closereadingkm'];
    closetripdatetime = json['closetripdatetime']?.toString();
    tripconfirm = json['tripconfirm'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['drsno'] = drsno;
    data['date'] = manifestdate;
    data['manifesttime'] = manifesttime;
    data['manifestdatetime'] = manifestdatetime;
    data['dispatchdatetime'] = dispatchdatetime;
    data['dispatchtime'] = dispatchtime;
    data['dispatchdt'] = dispatchdt;
    data['noofconsign'] = noofconsign;
    data['deliveredconsign'] = deliveredconsign;
    data['pendingconsign'] = pendingconsign;
    data['undeliveredconsign'] = undeliveredconsign;
    data['dispatchflag'] = dispatchflag;
    data['startreadingkm'] = startreadingkm;
    data['startreadingimg'] = startreadingimgpath;
    data['planningid'] = planningid;
    data['totpickup'] = totpickup;
    data['closetripdt'] = closeTripDate;
    data['closetriptime'] = closeTripTime;
    data['endreadingimg'] = closeReadingImagePath;
    data['closereadingkm'] = closeReadingKm;
    data['closetripdatetime'] = closetripdatetime;
    data['tripconfirm'] = tripconfirm;
    return data;
  }
}
