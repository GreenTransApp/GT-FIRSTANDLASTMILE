class PodStickerModel {
  int? commandstatus;
  String? commandmessage;
  String? stickerno;
  String? grno;
  String? bookingdt;
  String? origin;
  String? destination;
  String? cngr;
  String? cnge;
  double? actualweight;
  double? chargeweight;
  bool? isreceived;

  PodStickerModel({
    this.commandstatus,
    this.commandmessage,
    this.stickerno,
    this.grno,
    this.bookingdt,
    this.origin,
    this.destination,
    this.cngr,
    this.cnge,
    this.actualweight,
    this.chargeweight,
    this.isreceived,
  });

  PodStickerModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    stickerno = json['stickerno'];
    grno = json['grno'];
    bookingdt = json['bookingdt'];
    origin = json['origin'];
    destination = json['destination'];
    cngr = json['cngr'];
    cnge = json['cnge'];
    actualweight = json['actualweight']?.toDouble();
    chargeweight = json['chargeweight']?.toDouble();
    isreceived = json['isreceived'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['stickerno'] = stickerno;
    data['grno'] = grno;
    data['bookingdt'] = bookingdt;
    data['origin'] = origin;
    data['destination'] = destination;
    data['cngr'] = cngr;
    data['cnge'] = cnge;
    data['actualweight'] = actualweight;
    data['chargeweight'] = chargeweight;
    data['isreceived'] = isreceived;
    return data;
  }
}
