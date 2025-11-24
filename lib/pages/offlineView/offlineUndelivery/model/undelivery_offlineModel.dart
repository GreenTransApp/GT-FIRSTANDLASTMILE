class UnDeliveryOfflineModel {
  int? commandstatus;
  String? commandmessage;
  String? prmbranchcode;
  String? prmundeldt;
  String? prmtime;
  String? prmdlvtripsheetno;
  String? prmgrno;
  String? prmreasoncode;
  String? prmactioncode;
  String? prmremarks;
  String? prmusercode;
  String? prmmenucode;
  String? prmsessionid;
  String? prmdrno;
  String? prmimagepath;
  String? prmreason;
  String? prmaction;
  bool? isSelected = false;

  UnDeliveryOfflineModel({
    this.commandstatus,
    this.commandmessage,
    this.prmbranchcode,
    this.prmundeldt,
    this.prmtime,
    this.prmdlvtripsheetno,
    this.prmgrno,
    this.prmreasoncode,
    this.prmactioncode,
    this.prmremarks,
    this.prmusercode,
    this.prmmenucode,
    this.prmsessionid,
    this.prmdrno,
    this.prmimagepath,
    this.prmreason,
    this.prmaction,
  });

  UnDeliveryOfflineModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    prmbranchcode = json['prmbranchcode'];
    prmundeldt = json['prmundeldt'];
    prmtime = json['prmtime'];
    prmdlvtripsheetno = json['prmdlvtripsheetno'];
    prmgrno = json['prmgrno'];
    prmreasoncode = json['prmreasoncode'];
    prmactioncode = json['prmactioncode'];
    prmremarks = json['prmremarks'];
    prmusercode = json['prmusercode'];
    prmmenucode = json['prmmenucode'];
    prmsessionid = json['prmsessionid'];
    prmdrno = json['prmdrno'];
    prmimagepath = json['prmimagepath'];
    prmreason = json['prmreason'];
    prmaction = json['prmaction'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['prmbranchcode'] = prmbranchcode;
    data['prmundeldt'] = prmundeldt;
    data['prmtime'] = prmtime;
    data['prmdlvtripsheetno'] = prmdlvtripsheetno;
    data['prmgrno'] = prmgrno;
    data['prmreasoncode'] = prmreasoncode;
    data['prmactioncode'] = prmactioncode;
    data['prmremarks'] = prmremarks;
    data['prmusercode'] = prmusercode;
    data['prmmenucode'] = prmmenucode;
    data['prmsessionid'] = prmsessionid;
    data['prmdrno'] = prmdrno;
    data['prmimagepath'] = prmimagepath;
    data['prmreason'] = prmreason;
    data['prmaction'] = prmaction;
    return data;
  }
}
