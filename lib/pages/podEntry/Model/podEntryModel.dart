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
  int? damagepckgs;
  int? deliverpckgs; // added
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

  PodEntryModel({
    this.commandstatus,
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
    this.damagepckgs,
    this.deliverpckgs, // added
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
    this.poddate,
  });

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
    damagepckgs = json['damagepckgs'];
    deliverpckgs = json['deliverpckgs']; // added
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
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['grno'] = grno;
    data['custcode'] = custcode;
    data['custname'] = custname;
    data['orgcode'] = orgcode;
    data['origin'] = origin;
    data['destcode'] = destcode;
    data['destname'] = destname;
    data['saletype'] = saletype;
    data['grdt'] = grdt;
    data['picktime'] = picktime;
    data['cngr'] = cngr;
    data['cnge'] = cnge;
    data['pckgs'] = pckgs;
    data['damagepckgs'] = damagepckgs;
    data['deliverpckgs'] = deliverpckgs; // added
    data['cweight'] = cweight;
    data['receivedt'] = receivedt;
    data['receivetime'] = receivetime;
    data['dlvdt'] = dlvdt;
    data['dlvtime'] = dlvtime;
    data['name'] = name;
    data['relation'] = relation;
    data['phno'] = phno;
    data['sign'] = sign;
    data['stamp'] = stamp;
    data['signimage'] = signimage;
    data['podimage'] = podimage;
    data['remarks'] = remarks;
    data['createid'] = createid;
    data['drsno'] = drsno;
    data['dlvboyname'] = dlvboyname;
    data['poddate'] = poddate;
    return data;
  }
}
