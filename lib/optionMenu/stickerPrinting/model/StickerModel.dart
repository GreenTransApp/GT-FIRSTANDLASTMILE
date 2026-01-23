class StickerListModel {
  int? commandstatus;
  String? commandmessage;

  String? compname;
  String? imagepath;
  String? customercaretelno;

  String? grno;
  int? packageid;
  String? allocatedto;
  String? stickerno;
  String? bookingdt;

  String? orgcode;
  String? destcode;
  String? originname;
  String? destinationname;

  double? pckgs;
  String? grdt;
  double? weight;

  String? customer;
  bool? selectedsticker;

  StickerListModel({
    this.commandstatus,
    this.commandmessage,
    this.compname,
    this.imagepath,
    this.customercaretelno,
    this.grno,
    this.packageid,
    this.allocatedto,
    this.stickerno,
    this.bookingdt,
    this.orgcode,
    this.destcode,
    this.originname,
    this.destinationname,
    this.pckgs,
    this.grdt,
    this.weight,
    this.customer,
    this.selectedsticker = false,
  });

  /// FROM JSON
  StickerListModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];

    compname = json['compname'];
    imagepath = json['imagepath'];
    customercaretelno = json['customercaretelno'];

    grno = json['grno'];
    packageid = json['packageid'];
    allocatedto = json['allocatedto'];
    stickerno = json['stickerno'];
    bookingdt = json['bookingdt'];

    orgcode = json['orgcode'];
    destcode = json['destcode'];
    originname = json['originname'];
    destinationname = json['destinationname'];

    pckgs = json['pckgs'];
    grdt = json['grdt'];
    weight = json['weight'] != null
        ? double.tryParse(json['weight'].toString())
        : null;

    customer = json['customer'];
    selectedsticker = json['checked'] ?? false;
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;

    data['compname'] = compname;
    data['imagepath'] = imagepath;
    data['customercaretelno'] = customercaretelno;

    data['grno'] = grno;
    data['packageid'] = packageid;
    data['allocatedto'] = allocatedto;
    data['stickerno'] = stickerno;
    data['bookingdt'] = bookingdt;

    data['orgcode'] = orgcode;
    data['destcode'] = destcode;
    data['originname'] = originname;
    data['destinationname'] = destinationname;

    data['pckgs'] = pckgs;
    data['grdt'] = grdt;
    data['weight'] = weight;

    data['customer'] = customer;
    data['selectedsticker'] = selectedsticker;
    return data;
  }
}
