class ConsignmentEnquiryModel {
  String? commandstatus;
  String? commandmessage;

  String? indentId;
  String? documentType;

  String? orgCode;
  String? orgName;
  String? grDt;
  String? pickTime;
  String? invoiceCode;

  String? cnmtNo1;
  String? cnmtNo2;
  String? grNo;
  String? contractType;

  String? pickupPoint;
  String? pickupPincodeDataId;
  String? pickupPincode;
  String? pickupPointAlias;
  String? pMark;

  double? pickupLatitude;
  double? pickupLongitude;
  String? pickupAddress;

  String? destCode;
  String? destName;

  String? deliveryPoint;
  String? deliveryPincodeDataId;
  String? deliveryPincode;
  String? deliveryPointAlias;

  double? deliveryLatitude;
  double? deliveryLongitude;
  String? deliveryAddress;

  String? grType;
  String? expectedDeliveryDt;

  String? custCode;
  String? custName;
  String? custGstNo;

  String? custDeptId;
  String? custDeptName;
  String? custDeptGstNo;

  String? collectionStn;
  String? collectionStnName;

  String? billingBranchName;
  String? billingBranchCode;

  String? referenceNo;

  String? cngrDocumentType;
  String? cngrGstNo;
  String? cngrDocNoCode;
  String? cngrCode;
  String? cngr;
  String? cngrName;
  String? cngrAddress;
  String? cngrCity;
  String? cngrCityCode;
  String? cngrZipCode;
  String? cngrState;
  String? cngrCountry;
  String? cngrTelNo;
  String? cngrEmail;
  String? cngrDealerCode;

  String? cngeDocumentType;
  String? cngeGstNo;
  String? cngeDocNoCode;
  String? cngeCode;
  String? cnge;
  String? cngeName;
  String? cngeAddress;
  String? cngeCity;
  String? cngeCityCode;
  String? cngeZipCode;
  String? cngeState;
  String? cngeCountry;
  String? cngeTelNo;
  String? cngeEmail;
  String? cngeDealerCode;

  String? loadType;
  String? productCode;
  String? dlvType;
  String? freightOn;

  double? valGoods;
  double? ncv;
  double? dryIceQty;

  String? pickupVehicleNo;
  String? driverDetail;
  String? containerNo;
  String? containerTypeName;

  String? modeCode;
  String? modeName;
  String? vendCode;
  String? vendName;

  String? vehicleTypeCode;
  String? vehicleTypeName;

  String? mainDriverCode;
  String? mainDriverName;
  String? mainDriverMobile;
  String? mainDriverLcNo;
  String? mainDriverLcValidateUpto;

  double? transitDays;
  double? transitKms;
  double? addTransitKms;
  double? distance;

  String? executiveCode;
  String? executiveName;

  String? shipmentNo;
  String? pickupType;
  String? autoManifest;

  String? manualRates;
  double? rate;
  double? freight;
  String? rateDataId;

  double? oAmount;
  double? subTotal;
  double? advance;
  double? balance;
  double? tAmount;

  double? totalInvVal;
  double? totalPckgs;
  double? totalQty;
  double? totalVWeight;
  double? totalAWeight;
  double? totalCWeight;

  String? riskType;
  String? policyNo;
  String? policyDt;
  String? insuranceCo;

  String? remarks;
  String? recStatus;
  String? ocrId;
  String? volFactor;

  String? allowPickupDeliveryPoint;
  int? cngrTelNoLen;
  int? cngeTelNoLen;
  int? cngrZipCodeLen;
  int? cngeZipCodeLen;

  ConsignmentEnquiryModel({
    this.commandstatus,
    this.commandmessage,
    this.indentId,
    this.documentType,
    this.orgCode,
    this.orgName,
    this.grDt,
    this.pickTime,
    this.invoiceCode,
    this.cnmtNo1,
    this.cnmtNo2,
    this.grNo,
    this.contractType,
    this.pickupPoint,
    this.pickupPincodeDataId,
    this.pickupPincode,
    this.pickupPointAlias,
    this.pMark,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupAddress,
    this.destCode,
    this.destName,
    this.deliveryPoint,
    this.deliveryPincodeDataId,
    this.deliveryPincode,
    this.deliveryPointAlias,
    this.deliveryLatitude,
    this.deliveryLongitude,
    this.deliveryAddress,
    this.grType,
    this.expectedDeliveryDt,
    this.custCode,
    this.custName,
    this.custGstNo,
    this.custDeptId,
    this.custDeptName,
    this.custDeptGstNo,
    this.collectionStn,
    this.collectionStnName,
    this.billingBranchName,
    this.billingBranchCode,
    this.referenceNo,
    this.cngrDocumentType,
    this.cngrGstNo,
    this.cngrDocNoCode,
    this.cngrCode,
    this.cngr,
    this.cngrName,
    this.cngrAddress,
    this.cngrCity,
    this.cngrCityCode,
    this.cngrZipCode,
    this.cngrState,
    this.cngrCountry,
    this.cngrTelNo,
    this.cngrEmail,
    this.cngrDealerCode,
    this.cngeDocumentType,
    this.cngeGstNo,
    this.cngeDocNoCode,
    this.cngeCode,
    this.cnge,
    this.cngeName,
    this.cngeAddress,
    this.cngeCity,
    this.cngeCityCode,
    this.cngeZipCode,
    this.cngeState,
    this.cngeCountry,
    this.cngeTelNo,
    this.cngeEmail,
    this.cngeDealerCode,
    this.loadType,
    this.productCode,
    this.dlvType,
    this.freightOn,
    this.valGoods,
    this.ncv,
    this.dryIceQty,
    this.pickupVehicleNo,
    this.driverDetail,
    this.containerNo,
    this.containerTypeName,
    this.modeCode,
    this.modeName,
    this.vendCode,
    this.vendName,
    this.vehicleTypeCode,
    this.vehicleTypeName,
    this.mainDriverCode,
    this.mainDriverName,
    this.mainDriverMobile,
    this.mainDriverLcNo,
    this.mainDriverLcValidateUpto,
    this.transitDays,
    this.transitKms,
    this.addTransitKms,
    this.distance,
    this.executiveCode,
    this.executiveName,
    this.shipmentNo,
    this.pickupType,
    this.autoManifest,
    this.manualRates,
    this.rate,
    this.freight,
    this.rateDataId,
    this.oAmount,
    this.subTotal,
    this.advance,
    this.balance,
    this.tAmount,
    this.totalInvVal,
    this.totalPckgs,
    this.totalQty,
    this.totalVWeight,
    this.totalAWeight,
    this.totalCWeight,
    this.riskType,
    this.policyNo,
    this.policyDt,
    this.insuranceCo,
    this.remarks,
    this.recStatus,
    this.ocrId,
    this.volFactor,
    this.allowPickupDeliveryPoint,
    this.cngrTelNoLen,
    this.cngeTelNoLen,
    this.cngrZipCodeLen,
    this.cngeZipCodeLen,
  });

  factory ConsignmentEnquiryModel.fromJson(Map<String, dynamic> json) {
    double? toDouble(dynamic value) =>
        double.tryParse(value?.toString() ?? '');

    return ConsignmentEnquiryModel(
      commandstatus: json['commandstatus']?.toString(),
      commandmessage: json['commandmessage'],
      indentId: json['indentid']?.toString(),
      documentType: json['documenttype'],
      orgCode: json['orgcode'],
      orgName: json['orgname'],
      grDt: json['grdt'],
      pickTime: json['picktime'],
      invoiceCode: json['invoicecode'],
      cnmtNo1: json['cnmtno1'],
      cnmtNo2: json['cnmtno2'],
      grNo: json['grno'],
      contractType: json['contracttype'],
      pickupPoint: json['pickuppoint'],
      pickupPincodeDataId: json['pickuppincodedataid']?.toString(),
      pickupPincode: json['pickuppincode'],
      pickupPointAlias: json['pickuppointalias'],
      pMark: json['pmark'],
      pickupLatitude: toDouble(json['pickuplatitude']),
      pickupLongitude: toDouble(json['pickuplongitude']),
      pickupAddress: json['pickupaddress'],
      destCode: json['destcode'],
      destName: json['destname'],
      deliveryPoint: json['deliverypoint'],
      deliveryPincodeDataId: json['deliverypincodedataid']?.toString(),
      deliveryPincode: json['deliverypincode'],
      deliveryPointAlias: json['deliverypointalias'],
      deliveryLatitude: toDouble(json['deliverylatitude']),
      deliveryLongitude: toDouble(json['deliverylongitude']),
      deliveryAddress: json['dlvaddress'],
      grType: json['grtype'],
      expectedDeliveryDt: json['expecteddeliverydt'],
      custCode: json['custcode'],
      custName: json['custname'],
      custGstNo: json['custgstno'],
      custDeptId: json['custdeptid']?.toString(),
      custDeptName: json['custdeptname'],
      custDeptGstNo: json['custdeptgstno'],
      collectionStn: json['collectionstn'],
      collectionStnName: json['collectionstnname'],
      billingBranchName: json['billingbranchname'],
      billingBranchCode: json['billingbranchcode'],
      referenceNo: json['referenceno'],
      cngrDocumentType: json['cngrdocumenttype'],
      cngrGstNo: json['cngrgstno'],
      cngrDocNoCode: json['cngrdocnocode'],
      cngrCode: json['cngrcode'],
      cngr: json['cngr'],
      cngrName: json['cngrname'],
      cngrAddress: json['cngraddress'],
      cngrCity: json['cngrcity'],
      cngrCityCode: json['cngrcitycode'],
      cngrZipCode: json['cngrzipcode'],
      cngrState: json['cngrstate'],
      cngrCountry: json['cngrcountry'],
      cngrTelNo: json['cngrtelno'],
      cngrEmail: json['cngremail'],
      cngrDealerCode: json['cngrdealercode'],
      cngeDocumentType: json['cngedocumenttype'],
      cngeGstNo: json['cngegstno'],
      cngeDocNoCode: json['cngedocnocode'],
      cngeCode: json['cngecode'],
      cnge: json['cnge'],
      cngeName: json['cngename'],
      cngeAddress: json['cngeaddress'],
      cngeCity: json['cngecity'],
      cngeCityCode: json['cngecitycode'],
      cngeZipCode: json['cngezipcode'],
      cngeState: json['cngestate'],
      cngeCountry: json['cngecountry'],
      cngeTelNo: json['cngetelno'],
      cngeEmail: json['cngeemail'],
      cngeDealerCode: json['cngedealercode'],
      loadType: json['loadtype'],
      productCode: json['productcode'],
      dlvType: json['dlvtype'],
      freightOn: json['freighton'],
      valGoods: toDouble(json['valgoods']),
      ncv: toDouble(json['ncv']),
      dryIceQty: toDouble(json['dryiceqty']),
      pickupVehicleNo: json['pickupvehicleno'],
      driverDetail: json['driverdetail'],
      containerNo: json['containerno'],
      containerTypeName: json['containertypename'],
      modeCode: json['modecode'],
      modeName: json['modename'],
      vendCode: json['vendcode'],
      vendName: json['vendname'],
      vehicleTypeCode: json['vehicletypecode'],
      vehicleTypeName: json['vehicletypename'],
      mainDriverCode: json['maindrivercode'],
      mainDriverName: json['maindrivername'],
      mainDriverMobile: json['maindrivermobile'],
      mainDriverLcNo: json['maindriverlcno'],
      mainDriverLcValidateUpto: json['maindriverlcvalidateupto'],
      transitDays: toDouble(json['transitdays']),
      transitKms: toDouble(json['transitkms']),
      addTransitKms: toDouble(json['addtransitkms']),
      distance: toDouble(json['distance']),
      executiveCode: json['executivecode'],
      executiveName: json['executivename'],
      shipmentNo: json['shipmentno'],
      pickupType: json['pickuptype'],
      autoManifest: json['automanifest'],
      manualRates: json['manualrates']?.toString(),
      rate: toDouble(json['rate']),
      freight: toDouble(json['freight']),
      rateDataId: json['ratedataid']?.toString(),
      oAmount: toDouble(json['oamount']),
      subTotal: toDouble(json['subtotal']),
      advance: toDouble(json['advance']),
      balance: toDouble(json['balance']),
      tAmount: toDouble(json['tamount']),
      totalInvVal: toDouble(json['totalinvval']),
      totalPckgs: toDouble(json['totalpckgs']),
      totalQty: toDouble(json['totalqty']),
      totalVWeight: toDouble(json['totalvweight']),
      totalAWeight: toDouble(json['totalaweight']),
      totalCWeight: toDouble(json['totalcweight']),
      riskType: json['risktype'],
      policyNo: json['policyno'],
      policyDt: json['policydt'],
      insuranceCo: json['insuranceco'],
      remarks: json['remarks'],
      recStatus: json['recstatus'],
      ocrId: json['ocrid']?.toString(),
      volFactor: json['volfactor']?.toString(),
      allowPickupDeliveryPoint: json['allowpickupdeliverypoint'],
      cngrTelNoLen: int.tryParse(json['cngrtelnolen']?.toString() ?? ''),
      cngeTelNoLen: int.tryParse(json['cngetelnolen']?.toString() ?? ''),
      cngrZipCodeLen:
          int.tryParse(json['cngrzipcodelen']?.toString() ?? ''),
      cngeZipCodeLen:
          int.tryParse(json['cngezipcodelen']?.toString() ?? ''),
    );
  }
}