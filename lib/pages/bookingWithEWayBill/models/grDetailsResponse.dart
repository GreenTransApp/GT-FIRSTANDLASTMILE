class GrDetailsResponse {
  final int commandStatus;
  final String? commandMessage;
  final DateTime? grDate;
  final String? pickTime;
  final String? custCode;
  final String? destCode;
  final String? destName;
  final String? productCode;
  final double? totalPackages;
  final double? actualWeight;
  final double? chargedWeight;
  final double? volumetricWeight;
  final String? consignor;
  final String? consignorGstNo;
  final String? consignee;
  final String? consigneeGstNo;
  final String? goods;
  final String? packing;
  final String? grType;
  final String? documentType;
  final int? ticketTransactionId;
  final int? custDeptId;
  final String? pickupBoyName;
  final int? cnmtId;
  final String? modeCode;
  final String? ftl;
  final String? consignorCode;
  final String? consigneeCode;
  final String? remarks;
  final String? grNo;
  final String? loadType;
  final String? custName;
  final String? regNo;
  final String? dlvtype;
  final String? modecode;
  final String? bookingimg;
  final String? signimg;
  final String? orgcode;
  final String? orgname;

  GrDetailsResponse(
      {required this.commandStatus,
      this.commandMessage,
      this.grDate,
      this.pickTime,
      this.custCode,
      this.destCode,
      this.destName,
      this.productCode,
      this.totalPackages,
      this.actualWeight,
      this.chargedWeight,
      this.volumetricWeight,
      this.consignor,
      this.consignorGstNo,
      this.consignee,
      this.consigneeGstNo,
      this.goods,
      this.packing,
      this.grType,
      this.documentType,
      this.ticketTransactionId,
      this.custDeptId,
      this.pickupBoyName,
      this.cnmtId,
      this.modeCode,
      this.ftl,
      this.consignorCode,
      this.consigneeCode,
      this.remarks,
      this.grNo,
      this.loadType,
      this.custName,
      this.regNo,
      this.dlvtype,
      this.modecode,
      this.bookingimg,
      this.signimg,
      this.orgcode,
      this.orgname});

  factory GrDetailsResponse.fromJson(Map<String, dynamic> json) {
    return GrDetailsResponse(
        commandStatus: json['commandstatus'] ?? 0,
        commandMessage: json['commandmessage'],
        grDate: json['grdt'] != null ? DateTime.tryParse(json['grdt']) : null,
        pickTime: json['picktime'],
        custCode: json['custcode'],
        destCode: json['destcode'],
        destName: json['destname'],
        productCode: json['productcode'],
        totalPackages: (json['totpckgs'] as num?)?.toDouble(),
        actualWeight: (json['aweight'] as num?)?.toDouble(),
        chargedWeight: (json['cweight'] as num?)?.toDouble(),
        volumetricWeight: (json['vweight'] as num?)?.toDouble(),
        consignor: json['cngr'],
        consignorGstNo: json['cngrgstno'],
        consignee: json['cnge'],
        consigneeGstNo: json['cngegstno'],
        goods: json['goods'],
        packing: json['packing'],
        grType: json['grtype'],
        documentType: json['documenttype'],
        ticketTransactionId: json['tickettransactionid'],
        custDeptId: json['custdeptid'],
        pickupBoyName: json['pickupboyname'],
        cnmtId: json['cnmtid'],
        modeCode: json['modecode'],
        ftl: json['ftl'],
        consignorCode: json['cngrcode'],
        consigneeCode: json['cngecode'],
        remarks: json['remarks'],
        grNo: json['grno'],
        loadType: json['loadtype'],
        custName: json['custname'],
        regNo: json['regno'],
        dlvtype: json['dlvtype'],
        bookingimg: json['bookingimg'],
        signimg: json['signimg'],
        orgcode: json['orgcode'],
        orgname: json['orgname']);
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'grdt': grDate?.toIso8601String(),
      'picktime': pickTime,
      'custcode': custCode,
      'destcode': destCode,
      'destname': destName,
      'productcode': productCode,
      'totpckgs': totalPackages,
      'aweight': actualWeight,
      'cweight': chargedWeight,
      'vweight': volumetricWeight,
      'cngr': consignor,
      'cngrgstno': consignorGstNo,
      'cnge': consignee,
      'cngegstno': consigneeGstNo,
      'goods': goods,
      'packing': packing,
      'grtype': grType,
      'documenttype': documentType,
      'tickettransactionid': ticketTransactionId,
      'custdeptid': custDeptId,
      'pickupboyname': pickupBoyName,
      'cnmtid': cnmtId,
      'modecode': modeCode,
      'ftl': ftl,
      'cngrcode': consignorCode,
      'cngecode': consigneeCode,
      'remarks': remarks,
      'grno': grNo,
      'loadtype': loadType,
      'custname': custName,
      'regno': regNo,
      'dlvtype': dlvtype,
      'bookingimg': bookingimg,
      'signimg': signimg,
      'orgcode': orgcode,
      'orgname': orgname
    };
  }
}
