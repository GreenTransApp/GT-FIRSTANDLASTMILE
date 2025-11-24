class ReversePickupModel {
  int? commandstatus;
  String? commandmessage;
  String? orderno;
  String? orderdt;
  String? itemname;
  String? itemcode;
  String? skucode;
  String? articalimgpath;
  String? shippername;
  String? shippercode;
  String? mobileno;
  String? returncode;
  String? deliverygrno;
  int? pckgs;
  int? pcs;
  String? gweight;

  ReversePickupModel(
      {this.commandstatus,
      this.commandmessage,
      this.orderno,
      this.orderdt,
      this.itemname,
      this.itemcode,
      this.skucode,
      this.articalimgpath,
      this.shippername,
      this.shippercode,
      this.mobileno,
      this.returncode,
      this.deliverygrno,
      this.pckgs,
      this.pcs,
      this.gweight});

  ReversePickupModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    orderno = json['orderno'];
    orderdt = json['orderdt'];
    itemname = json['itemname'];
    itemcode = json['itemcode'];
    skucode = json['skucode'];
    articalimgpath = json['articalimgpath'];
    shippername = json['shippername'];
    shippercode = json['shippercode'];
    mobileno = json['mobileno'];
    returncode = json['returncode'];
    deliverygrno = json['deliverygrno'];
    pckgs = json['pckgs'];
    pcs = json['pcs'];
    gweight = json['gweight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['orderno'] = this.orderno;
    data['orderdt'] = this.orderdt;
    data['itemname'] = this.itemname;
    data['itemcode'] = this.itemcode;
    data['skucode'] = this.skucode;
    data['articalimgpath'] = this.articalimgpath;
    data['shippername'] = this.shippername;
    data['shippercode'] = this.shippercode;
    data['mobileno'] = this.mobileno;
    data['returncode'] = this.returncode;
    data['deliverygrno'] = this.deliverygrno;
    data['pckgs'] = this.pckgs;
    data['pcs'] = this.pcs;
    data['gweight'] = this.gweight;
    return data;
  }
}
