class MidMileTripDetailModel {
  final int? commandstatus;
  final String? commandmessage;

  final int? sno;
  final int? tripId;
  final int? tripDetailId;

  final String? manifestNo;
  final String? manifestDt;
  final String? manifestTime;

  final String? orgcode;
  final String? destcode;
  final String? orgname;
  final String? destname;

  final String? despatchtype;
  final String? modecode;

  final String? arrivalDt;
  final String? arrivalTime;
  final String? pickupdeparteddate;
  final String? pickupdepartedtime;

  final String? totpckgs;
  final double? vweight;
  final double? aweight;
  final int? totgr;

  final String? deliverystatus;
  final String? vehiclearrivalstatus;
  final String? deliverystatusupdateon;

  final int? arrivalKm;
  final String? vehiclearrivalupdateon;

  final String? grno;

  MidMileTripDetailModel({
    this.commandstatus,
    this.commandmessage,
    this.sno,
    this.tripId,
    this.tripDetailId,
    this.manifestNo,
    this.manifestDt,
    this.manifestTime,
    this.orgcode,
    this.destcode,
    this.orgname,
    this.destname,
    this.despatchtype,
    this.modecode,
    this.arrivalDt,
    this.arrivalTime,
    this.pickupdeparteddate,
    this.pickupdepartedtime,
    this.totpckgs,
    this.vweight,
    this.aweight,
    this.totgr,
    this.deliverystatus,
    this.vehiclearrivalstatus,
    this.deliverystatusupdateon,
    this.arrivalKm,
    this.vehiclearrivalupdateon,
    this.grno,
  });

  factory MidMileTripDetailModel.fromJson(Map<String, dynamic> json) {
    return MidMileTripDetailModel(
      commandstatus: (json['commandstatus'] as num?)?.toInt(),
      commandmessage: json['commandmessage'],

      sno: (json['sno'] as num?)?.toInt(),
      tripId: (json['tripid'] as num?)?.toInt(),
      tripDetailId: (json['tripdetailid'] as num?)?.toInt(),

      manifestNo: json['manifestno'],
      manifestDt: json['manifestdt'],
      manifestTime: json['manifesttime'],

      orgcode: json['orgcode'],
      destcode: json['destcode'],
      orgname: json['orgname'],
      destname: json['destname'],

      despatchtype: json['despatchtype'],
      modecode: json['modecode'],

      arrivalDt: json['arrivaldt'],
      arrivalTime: json['arrivaltime'],
      pickupdeparteddate: json['pickupdeparteddate'],
      pickupdepartedtime: json['pickupdepartedtime'],

      totpckgs: json['totpckgs'] ,
      vweight: (json['vweight'] as num?)?.toDouble(),
      aweight: (json['aweight'] as num?)?.toDouble(),
      totgr: (json['totgr'] as num?)?.toInt(),

      deliverystatus: json['deliverystatus'],
      vehiclearrivalstatus: json['vehiclearrivalstatus'],
      deliverystatusupdateon: json['deliverystatusupdateon'],

      arrivalKm: (json['arrivalkm'] as num?)?.toInt(),
      vehiclearrivalupdateon: json['vehiclearrivalupdateon'],

      grno: json['grno'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,

      'sno': sno,
      'tripid': tripId,
      'tripdetailid': tripDetailId,

      'manifestno': manifestNo,
      'manifestdt': manifestDt,
      'manifesttime': manifestTime,

      'orgcode': orgcode,
      'destcode': destcode,
      'orgname': orgname,
      'destname': destname,

      'despatchtype': despatchtype,
      'modecode': modecode,

      'arrivaldt': arrivalDt,
      'arrivaltime': arrivalTime,
      'pickupdeparteddate': pickupdeparteddate,
      'pickupdepartedtime': pickupdepartedtime,

      'totpckgs': totpckgs,
      'vweight': vweight,
      'aweight': aweight,
      'totgr': totgr,

      'deliverystatus': deliverystatus,
      'vehiclearrivalstatus': vehiclearrivalstatus,
      'deliverystatusupdateon': deliverystatusupdateon,

      'arrivalkm': arrivalKm,
      'vehiclearrivalupdateon': vehiclearrivalupdateon,

      'grno': grno,
    };
  }
}