class MidMileTripDetailModel {
  final int? commandstatus;
  final String? commandmessage;
  final int? dataId;
  final int? tripId;
  final int? tripDetailId;
  final String? documentType;
  final String? documentNo;
  final String? lhcNo;
  final String? grno;
  final String? grdt;
  final String? origin;
  final String? destination;
  final String? cnge;
  final String? cngetelno;
  final double? totpckgs;
  final double? aWeight;
  final double? cWeight;
  final String? manifestNo;
  final String? billNo;
  final String? manifestType;
  final int? seqNo;
  final String? unloadingStnCode;
  final String? arrivalDt;
  final String? arrivalTime;
  final String? unloadDt;
  final String? unloadTime;
  final String? transshipmentStation;
  final double? arrivalLat;
  final double? arrivalLong;
  final int? arrivalKm;
  final int? arrivalReadingImageId;
  final String? despatchtype;
  final String? modecode;
  final String? pickupdeparteddate;
  final String? pickupdepartedtime;
  final String? deliverystatusupdateon;
  final String? deliverystatus;
  final String? vehiclearrivalstatus;
  final String? destcode;
  final String? orgcode;
  final String? vehiclearrivalupdateon;
  

  MidMileTripDetailModel({
    this.commandstatus,
    this.commandmessage,
    this.dataId,
    this.tripId,
    this.tripDetailId,
    this.documentType,
    this.documentNo,
    this.lhcNo,
    this.grno,
    this.grdt,
    this.origin,
    this.destination,
    this.cnge,
    this.cngetelno,
    this.totpckgs,
    this.aWeight,
    this.cWeight,
    this.manifestNo,
    this.billNo,
    this.manifestType,
    this.seqNo,
    this.unloadingStnCode,
    this.arrivalDt,
    this.arrivalTime,
    this.unloadDt,
    this.unloadTime,
    this.transshipmentStation,
    this.arrivalLat,
    this.arrivalLong,
    this.arrivalKm,
    this.arrivalReadingImageId,
    this.despatchtype,
    this.modecode,
    this.pickupdeparteddate,
    this.pickupdepartedtime,
    this.deliverystatusupdateon,
    this.deliverystatus,
    this.vehiclearrivalstatus,
    this.orgcode,
    this.destcode,
    this.vehiclearrivalupdateon
    
  });

  factory MidMileTripDetailModel.fromJson(Map<String, dynamic> json) {
    return MidMileTripDetailModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      dataId: json['dataid'],
      tripId: json['tripid'],
      tripDetailId: json['tripdetailid'],
      documentType: json['documenttype'],
      documentNo: json['documentno'],
      lhcNo: json['lhcno'],
      grno: json['grno'],
      grdt: json['grdt'],
      origin: json['origin'],
      destination: json['destination'],
      cnge: json['cnge'],
      cngetelno: json['cngetelno'],
      totpckgs: json['totpckgs'] as double?,
      aWeight: (json['aweight'] as num?)?.toDouble(),
      cWeight: (json['cweight'] as num?)?.toDouble(),
      manifestNo: json['manifestno'],
      billNo: json['billno'],
      manifestType: json['manifesttype'],
      seqNo: json['seqno'],
      unloadingStnCode: json['unloadingstncode'],
      arrivalDt: json['arrivaldt'],
      arrivalTime: json['arrivaltime'],
      unloadDt: json['unloaddt'],
      unloadTime: json['unloadtime'],
      transshipmentStation: json['transshipmentstation'],
      arrivalLat: (json['arrivallat'] as num?)?.toDouble(),
      arrivalLong: (json['arrivallong'] as num?)?.toDouble(),
      arrivalKm: (json['arrivalkm'])?.toInt(),
      arrivalReadingImageId: json['arrivalreadingimageid'],
      despatchtype: json['despatchtype'],
      modecode: json['modecode'],
      pickupdeparteddate: json['pickupdeparteddate'],
      pickupdepartedtime: json['pickupdepartedtime'],
      deliverystatusupdateon: json['deliverystatusupdateon'],
      deliverystatus: json['deliverystatus'],
      vehiclearrivalstatus: json['vehiclearrivalstatus'],
      orgcode: json['orgcode'],
      destcode: json['destcode'],
      vehiclearrivalupdateon: json['vehiclearrivalupdateon'],
      
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'dataid': dataId,
      'tripid': tripId,
      'tripdetailid': tripDetailId,
      'documenttype': documentType,
      'documentno': documentNo,
      'lhcno': lhcNo,
      'grno': grno,
      'grdt': grdt,
      'origin': origin,
      'destination': destination,
      'cnge': cnge,
      'cngetelno': cngetelno,
      'totpckgs': totpckgs,
      'aweight': aWeight,
      'cweight': cWeight,
      'manifestno': manifestNo,
      'billno': billNo,
      'manifesttype': manifestType,
      'seqno': seqNo,
      'unloadingstncode': unloadingStnCode,
      'arrivaldt': arrivalDt,
      'arrivaltime': arrivalTime,
      'unloaddt': unloadDt,
      'unloadtime': unloadTime,
      'transshipmentstation': transshipmentStation,
      'arrivallat': arrivalLat,
      'arrivallong': arrivalLong,
      'arrivalkm': arrivalKm,
      'arrivalreadingimageid': arrivalReadingImageId,
      'despatchtype': despatchtype,
      'modecode': modecode,
      'pickupdeparteddate': pickupdeparteddate,
      'pickupdepartedtime': pickupdepartedtime,
      'deliverystatusupdateon': deliverystatusupdateon,
      'deliverystatus': deliverystatus,
      'vehiclearrivalstatus': vehiclearrivalstatus,
      'orgcode':orgcode,
      'destcode':destcode,
      'vehiclearrivalupdateon':vehiclearrivalupdateon,
      

    };
  }
}
