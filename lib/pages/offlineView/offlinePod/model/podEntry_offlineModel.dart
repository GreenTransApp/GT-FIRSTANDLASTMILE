class PodEntryOfflineModel {
  int? commandstatus;
  String? commandmessage;
  String? prmloginbranchcode;
  String? prmgrno;
  String? prmdlvdt;
  String? prmdlvtime;
  String? prmname;
  String? prmrelation;
  String? prmphno;
  String? prmsign = 'N';
  String? prmstamp = 'N';
  String? prmremarks;
  String? prmusercode;
  String? prmpodimageurl;
  String? prmsighnimageurl;
  String? prmsessionid;
  String? prmdelayreason;
  String? prmdeliveryboy;
  String? prmmenucode;
  String? prmpoddt;
  String? prmdrsno;
  int? prmboyid;
  int? prmdeliverpckgs;
  int? prmdamagepckgs;
  String? prmdamagereasonid;
  // String? prmdamageimgstr;
  String? prmdamageimg1;
  String? prmdamageimg2;
  bool? isSelected = false;

  PodEntryOfflineModel(
      {this.commandstatus,
      this.commandmessage,
      this.prmloginbranchcode,
      this.prmgrno,
      this.prmdlvdt,
      this.prmdlvtime,
      this.prmname,
      this.prmrelation,
      this.prmphno,
      this.prmsign,
      this.prmstamp,
      this.prmremarks,
      this.prmusercode,
      this.prmpodimageurl,
      this.prmsighnimageurl,
      this.prmsessionid,
      this.prmdelayreason,
      this.prmdeliveryboy,
      this.prmmenucode,
      this.prmpoddt,
      this.prmdrsno,
      this.prmboyid,
      this.prmdeliverpckgs,
      this.prmdamagepckgs,
      this.prmdamagereasonid,
      // this.prmdamageimgstr,
      this.prmdamageimg1,
      this.prmdamageimg2});

  PodEntryOfflineModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    prmloginbranchcode = json['prmloginbranchcode'];
    prmgrno = json['prmgrno'];
    prmdlvdt = json['prmdlvdt'];
    prmdlvtime = json['prmdlvtime'];
    prmname = json['prmname'];
    prmrelation = json['prmrelation'];
    prmphno = json['prmphno'];
    prmsign = json['prmsign'];
    prmstamp = json['prmstamp'];
    prmremarks = json['prmremarks'];
    prmusercode = json['prmusercode'];
    prmpodimageurl = json['prmpodimageurl'];
    prmsighnimageurl = json['prmsighnimageurl'];
    prmsessionid = json['prmsessionid'];
    prmdelayreason = json['prmdelayreason'];
    prmdeliveryboy = json['prmdeliveryboy'];
    prmmenucode = json['prmmenucode'];
    prmpoddt = json['prmpoddt'];
    prmdrsno = json['prmdrsno'];
    prmboyid = json['prmboyid'];
    prmdeliverpckgs = json['prmdeliverpckgs'];
    prmdamagepckgs = json['prmdamagepckgs'];
    prmdamagereasonid = json['prmdamagereasonid'];
    // prmdamageimgstr = json['prmdamageimgstr'];
    prmdamageimg1 = json['prmdamageimg1'];
    prmdamageimg2 = json['prmdamageimg2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['prmloginbranchcode'] = prmloginbranchcode;
    data['prmgrno'] = prmgrno;
    data['prmdlvdt'] = prmdlvdt;
    data['prmdlvtime'] = prmdlvtime;
    data['prmname'] = prmname;
    data['prmrelation'] = prmrelation;
    data['prmphno'] = prmphno;
    data['prmsign'] = prmsign;
    data['prmstamp'] = prmstamp;
    data['prmremarks'] = prmremarks;
    data['prmusercode'] = prmusercode;
    data['prmpodimageurl'] = prmpodimageurl;
    data['prmsighnimageurl'] = prmsighnimageurl;
    data['prmsessionid'] = prmsessionid;
    data['prmdelayreason'] = prmdelayreason;
    data['prmdeliveryboy'] = prmdeliveryboy;
    data['prmmenucode'] = prmmenucode;
    data['prmpoddt'] = prmpoddt;
    data['prmdrsno'] = prmdrsno;
    data['prmboyid'] = prmboyid;
    data['prmdeliverpckgs'] = prmdeliverpckgs;
    data['prmdamagepckgs'] = prmdamagepckgs;
    data['prmdamagereasonid'] = prmdamagereasonid;
    // data['prmdamageimgstr'] = prmdamageimgstr;
    data['prmdamageimg1'] = prmdamageimg1;
    data['prmdamageimg2'] = prmdamageimg2;
    return data;
  }
}
