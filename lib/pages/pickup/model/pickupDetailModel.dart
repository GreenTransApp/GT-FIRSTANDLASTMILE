class PickupDetailModel {
  final int? commandStatus;
  final String? commandMessage;
  final int? transactionId;
  final String? referenceNo;
  final DateTime? callDate;
  final DateTime? pickDate;
  final String? callTime;
  final String? custCode;
  final String? custName;
  final String? custDeptId;
  final String? orgCode;
  final String? orgName;
  final String? destCode;
  final String? destName;
  final String? cngrCode;
  final String? cngr;
  final String? cngrZipCode;
  final String? cngrAddress;
  final String? cngrCity;
  final String? cngrState;
  final String? cngrCountry;
  final String? pickupLatPosition;
  final String? pickupLongPosition;
  final String? cngrMobileNo;
  final String? cngrEmailId;
  final String? cngeCode;
  final String? cnge;
  final String? cngeZipCode;
  final String? cngeAddress;
  final String? cngeCity;
  final String? cngeState;
  final String? cngeCountry;
  final String? deliveryLatPosition;
  final String? deliveryLongPosition;
  final String? cngeMobileNo;
  final String? cngeEmailId;
  final int? pckgs;
  final double? weight;
  final String? remarks;
  final String? pickupOrDelivery;
  final String? productCode;
  final String? ordernumber;

  PickupDetailModel(
      {this.commandStatus,
      this.commandMessage,
      this.transactionId,
      this.referenceNo,
      this.callDate,
      this.pickDate,
      this.callTime,
      this.custCode,
      this.custName,
      this.custDeptId,
      this.orgCode,
      this.orgName,
      this.destCode,
      this.destName,
      this.cngrCode,
      this.cngr,
      this.cngrZipCode,
      this.cngrAddress,
      this.cngrCity,
      this.cngrState,
      this.cngrCountry,
      this.pickupLatPosition,
      this.pickupLongPosition,
      this.cngrMobileNo,
      this.cngrEmailId,
      this.cngeCode,
      this.cnge,
      this.cngeZipCode,
      this.cngeAddress,
      this.cngeCity,
      this.cngeState,
      this.cngeCountry,
      this.deliveryLatPosition,
      this.deliveryLongPosition,
      this.cngeMobileNo,
      this.cngeEmailId,
      this.pckgs,
      this.weight,
      this.remarks,
      this.pickupOrDelivery,
      this.productCode,
      this.ordernumber});

  factory PickupDetailModel.fromJson(Map<String, dynamic> json) {
    return PickupDetailModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      transactionId: json['transactionid'],
      referenceNo: json['referenceno'].toString(),
      callDate: json['calldt'] != null ? DateTime.parse(json['calldt']) : null,
      pickDate: json['pickdt'] != null ? DateTime.parse(json['pickdt']) : null,
      callTime: json['calltime'].toString(),
      custCode: json['custcode'].toString(),
      custName: json['custname'].toString(),
      custDeptId: json['custdeptid'].toString(),
      orgCode: json['orgcode'].toString(),
      orgName: json['orgname'].toString(),
      destCode: json['destcode'].toString(),
      destName: json['destname'].toString(),
      cngrCode: json['cngrcode'].toString(),
      cngr: json['cngr'].toString(),
      cngrZipCode: json['cngrzipcode'].toString(),
      cngrAddress: json['cngraddress'].toString(),
      cngrCity: json['cngrcity'].toString(),
      cngrState: json['cngrstate'].toString(),
      cngrCountry: json['cngrcountry'].toString(),
      pickupLatPosition: json['pickuplatposition'].toString(),
      pickupLongPosition: json['pickuplongposition'].toString(),
      cngrMobileNo: json['cngrmobileno'].toString(),
      cngrEmailId: json['cngremailid'].toString(),
      cngeCode: json['cngecode'].toString(),
      cnge: json['cnge'].toString(),
      cngeZipCode: json['cngezipcode'].toString(),
      cngeAddress: json['cngeaddress'].toString(),
      cngeCity: json['cngecity'].toString(),
      cngeState: json['cngestate'].toString(),
      cngeCountry: json['cngecountry'].toString(),
      deliveryLatPosition: json['deliverylatposition'].toString(),
      deliveryLongPosition: json['deliverylongposition'].toString(),
      cngeMobileNo: json['cngemobileno'].toString(),
      cngeEmailId: json['cngeemailid'].toString(),
      pckgs: json['pckgs'],
      weight: (json['weight'] as num?)?.toDouble(),
      remarks: json['remarks'].toString(),
      pickupOrDelivery: json['pickupordelivery'].toString(),
      productCode: json['productcode'].toString(),
      ordernumber: json['ordernumber'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage.toString(),
      'transactionid': transactionId,
      'referenceno': referenceNo,
      'calldt': callDate?.toIso8601String(),
      'pickdt': pickDate?.toIso8601String(),
      'calltime': callTime,
      'custcode': custCode,
      'custname': custName,
      'custdeptid': custDeptId,
      'orgcode': orgCode,
      'orgname': orgName,
      'destcode': destCode,
      'destname': destName,
      'cngrcode': cngrCode,
      'cngr': cngr,
      'cngrzipcode': cngrZipCode,
      'cngraddress': cngrAddress,
      'cngrcity': cngrCity,
      'cngrstate': cngrState,
      'cngrcountry': cngrCountry,
      'pickuplatposition': pickupLatPosition,
      'pickuplongposition': pickupLongPosition,
      'cngrmobileno': cngrMobileNo,
      'cngremailid': cngrEmailId,
      'cngecode': cngeCode,
      'cnge': cnge,
      'cngezipcode': cngeZipCode,
      'cngeaddress': cngeAddress,
      'cngecity': cngeCity,
      'cngestate': cngeState,
      'cngecountry': cngeCountry,
      'deliverylatposition': deliveryLatPosition,
      'deliverylongposition': deliveryLongPosition,
      'cngemobileno': cngeMobileNo,
      'cngeemailid': cngeEmailId,
      'pckgs': pckgs,
      'weight': weight,
      'remarks': remarks,
      'pickupordelivery': pickupOrDelivery,
      'productcode': productCode,
      'ordernumber': ordernumber,
    };
  }

  static List<PickupDetailModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PickupDetailModel.fromJson(json)).toList();
  }
}
