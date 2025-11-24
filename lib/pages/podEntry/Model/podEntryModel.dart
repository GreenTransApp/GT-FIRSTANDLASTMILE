class PodEntryModel {
  int? commandstatus;
  String? commandmessage;
  String? grno;
  String? custcode;
  String? custname;
  String? orgcode;
  String? origin;
  String? destcode;
  String? destname;
  String? saletype;
  String? grdt;
  String? picktime;
  String? cngr;
  String? cnge;
  String? pckgs;
  double? cweight;
  String? receivedt;
  String? receivetime;
  String? dlvdt;
  String? dlvtime;
  String? name;
  String? relation;
  String? phno;
  String? sign = 'N';
  String? stamp = 'N';
  String? signimage;
  String? podimage;
  String? remarks;
  String? createid;
  String? drsno;
  String? dlvboyname;
  String? poddate;

  PodEntryModel(
      {this.commandstatus,
      this.commandmessage,
      this.grno,
      this.custcode,
      this.custname,
      this.orgcode,
      this.origin,
      this.destcode,
      this.destname,
      this.saletype,
      this.grdt,
      this.picktime,
      this.cngr,
      this.cnge,
      this.pckgs,
      this.cweight,
      this.receivedt,
      this.receivetime,
      this.dlvdt,
      this.dlvtime,
      this.name,
      this.relation,
      this.phno,
      this.sign,
      this.stamp,
      this.signimage,
      this.podimage,
      this.remarks,
      this.createid,
      this.drsno,
      this.dlvboyname,
      this.poddate});

  PodEntryModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    grno = json['grno'];
    custcode = json['custcode'];
    custname = json['custname'];
    orgcode = json['orgcode'];
    origin = json['origin'];
    destcode = json['destcode'];
    destname = json['destname'];
    saletype = json['saletype'];
    grdt = json['grdt'];
    picktime = json['picktime'];
    cngr = json['cngr'];
    cnge = json['cnge'];
    pckgs = json['pckgs'];
    cweight = json['cweight'];
    receivedt = json['receivedt'];
    receivetime = json['receivetime'];
    dlvdt = json['dlvdt'];
    dlvtime = json['dlvtime'];
    name = json['name'];
    relation = json['relation'];
    phno = json['phno'];
    sign = json['sign'];
    stamp = json['stamp'];
    signimage = json['signimage'];
    podimage = json['podimage'];
    remarks = json['remarks'];
    createid = json['createid'];
    drsno = json['drsno'];
    dlvboyname = json['dlvboyname'];
    poddate = json['poddate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['grno'] = this.grno;
    data['custcode'] = this.custcode;
    data['custname'] = this.custname;
    data['orgcode'] = this.orgcode;
    data['origin'] = this.origin;
    data['destcode'] = this.destcode;
    data['destname'] = this.destname;
    data['saletype'] = this.saletype;
    data['grdt'] = this.grdt;
    data['picktime'] = this.picktime;
    data['cngr'] = this.cngr;
    data['cnge'] = this.cnge;
    data['pckgs'] = this.pckgs;
    data['cweight'] = this.cweight;
    data['receivedt'] = this.receivedt;
    data['receivetime'] = this.receivetime;
    data['dlvdt'] = this.dlvdt;
    data['dlvtime'] = this.dlvtime;
    data['name'] = this.name;
    data['relation'] = this.relation;
    data['phno'] = this.phno;
    data['sign'] = this.sign;
    data['stamp'] = this.stamp;
    data['signimage'] = this.signimage;
    data['podimage'] = this.podimage;
    data['remarks'] = this.remarks;
    data['createid'] = this.createid;
    data['drsno'] = this.drsno;
    data['dlvboyname'] = this.dlvboyname;
    data['poddate'] = this.poddate;
    return data;
  }
}
