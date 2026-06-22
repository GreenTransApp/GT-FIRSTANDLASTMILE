class OtexPickupInfoModel {
  final int? commandStatus;
  final String? commandMessage;

  final int? indentId;
  final String? grdt;
  final String? time;
  final String? orgCode;
  final String? orgName;

  final String? pickDt;
  final String? pickTime;

  final String? invoiceCode;

  final String? pickupPoint;
  final int? pickupPincodeDataId;
  final String? pickupPincode;
  final String? pickupAddress;

  final String? destCode;
  final String? destName;

  final String? deliveryPoint;
  final int? deliveryPincodeDataId;
  final String? deliveryPincode;
  final String? deliveryAddress;

  final String? grType;
  final String? bookingTypeName;
  final String? bookingTypeCode;

  final String? custCode;
  final String? custName;
  final String? custGstNo;

  final int? custDeptId;
  final String? custDeptName;
  final String? custDeptGstNo;

  final String? referenceNo;

  final String? cngrGstNo;
  final String? cngrDocNoCode;
  final String? cngrCode;
  final String? cngr;
  final String? cngrName;
  final String? cngrAddress;
  final String? cngrCity;
  final String? cngrCityCode;
  final String? cngrZipCode;
  final String? cngrState;
  final String? cngrCountry;
  final String? cngrMobileNo;
  final String? cngrEmailId;

  final String? cngeGstNo;
  final String? cngeDocNoCode;
  final String? cngeCode;
  final String? cnge;
  final String? cngeName;
  final String? cngeAddress;
  final String? cngeCity;
  final String? cngeCityCode;
  final String? cngeZipCode;
  final String? cngeState;
  final String? cngeCountry;
  final String? cngeMobileNo;
  final String? cngeEmailId;

  final String? productCode;
  final String? productName;

  final String? dlvType;
  final String? deliveryTypeName;
  final String? deliveryTypeCode;

  final String? vehicleCode;
  final String? modeName;

  final String? vendCode;
  final String? vendName;

  final String? vehicleTypeCode;
  final String? vehicleTypeName;

  final String? driverCode;
  final String? mainDriverName;
  final String? driverMobileNo;
  final String? mainDriverLcNo;
  final String? mainDriverLcValidateUpto;

  final dynamic distance;

  final int? executiveId;
  final String? executiveName;

  final num? rate;
  final num? freight;
  final num? oAmount;
  final num? subTotal;
  final num? balance;
  final num? tAmount;

  final int? totalQty;
  final num? totalVWeight;
  final num? totalAWeight;
  final num? totalCWeight;

  final String? remarks;
  final String? recStatus;

  final int? ocrId;
  final num? volFactor;

  final String? allowPickupDeliveryPoint;

  final int? cngrTelNoLen;
  final int? cngeTelNoLen;
  final int? cngrZipCodeLen;
  final int? cngeZipCodeLen;

  final int? pcs;
  final String? documentType;
  final String? recstatus;
  final String? loadTypeName;
  final String? loadTypeCode;
  final String? orderid;
  final double? weight;
  final String? packing;
  final String? packingcode;
  final String? goods;
  final String? grtype;
  final String? invoiceimage;
  final String? autoSendEmail;

  OtexPickupInfoModel(
      {this.commandStatus,
      this.commandMessage,
      this.indentId,
      this.grdt,
      this.time,
      this.orgCode,
      this.orgName,
      this.pickDt,
      this.pickTime,
      this.invoiceCode,
      this.pickupPoint,
      this.pickupPincodeDataId,
      this.pickupPincode,
      this.pickupAddress,
      this.destCode,
      this.destName,
      this.deliveryPoint,
      this.deliveryPincodeDataId,
      this.deliveryPincode,
      this.deliveryAddress,
      this.grType,
      this.bookingTypeName,
      this.bookingTypeCode,
      this.custCode,
      this.custName,
      this.custGstNo,
      this.custDeptId,
      this.custDeptName,
      this.custDeptGstNo,
      this.referenceNo,
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
      this.cngrMobileNo,
      this.cngrEmailId,
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
      this.cngeMobileNo,
      this.cngeEmailId,
      this.productCode,
      this.productName,
      this.dlvType,
      this.deliveryTypeName,
      this.deliveryTypeCode,
      this.vehicleCode,
      this.modeName,
      this.vendCode,
      this.vendName,
      this.vehicleTypeCode,
      this.vehicleTypeName,
      this.driverCode,
      this.mainDriverName,
      this.driverMobileNo,
      this.mainDriverLcNo,
      this.mainDriverLcValidateUpto,
      this.distance,
      this.executiveId,
      this.executiveName,
      this.rate,
      this.freight,
      this.oAmount,
      this.subTotal,
      this.balance,
      this.tAmount,
      this.totalQty,
      this.totalVWeight,
      this.totalAWeight,
      this.totalCWeight,
      this.remarks,
      this.recStatus,
      this.ocrId,
      this.volFactor,
      this.allowPickupDeliveryPoint,
      this.cngrTelNoLen,
      this.cngeTelNoLen,
      this.cngrZipCodeLen,
      this.cngeZipCodeLen,
      this.pcs,
      this.documentType,
      this.recstatus,
      this.loadTypeName,
      this.loadTypeCode,
      this.orderid,
      this.weight,
      this.packing,
      this.packingcode,
      this.goods,
      this.grtype,
      this.invoiceimage,
      this.autoSendEmail});

  factory OtexPickupInfoModel.fromJson(Map<String, dynamic> json) {
    return OtexPickupInfoModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      indentId: json['indentid'],
      grdt: json['grdt'],
      time: json['time'],
      orgCode: json['orgcode'],
      orgName: json['orgname'],
      pickDt: json['pickdt'],
      pickTime: json['picktime'],
      invoiceCode: json['invoicecode'],
      pickupPoint: json['pickuppoint'],
      pickupPincodeDataId: json['pickuppincodedataid'],
      pickupPincode: json['pickuppincode'],
      pickupAddress: json['pickupaddress'],
      destCode: json['destcode'],
      destName: json['destname'],
      deliveryPoint: json['deliverypoint'],
      deliveryPincodeDataId: json['deliverypincodedataid'],
      deliveryPincode: json['deliverypincode'],
      deliveryAddress: json['deliveryaddress'],
      grType: json['grtype'],
      bookingTypeName: json['bookingtypename'],
      bookingTypeCode: json['bookingtypecode'],
      custCode: json['custcode'],
      custName: json['custname'],
      custGstNo: json['custgstno'],
      custDeptId: json['custdeptid'],
      custDeptName: json['custdeptname'],
      custDeptGstNo: json['custdeptgstno'],
      referenceNo: json['referenceno'],
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
      cngrMobileNo: json['cngrmobileno'],
      cngrEmailId: json['cngremailid'],
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
      cngeMobileNo: json['cngemobileno'],
      cngeEmailId: json['cngeemailid'],
      productCode: json['productcode'],
      productName: json['productname'],
      dlvType: json['dlvtype'],
      deliveryTypeName: json['deliverytypename'],
      deliveryTypeCode: json['deliverytypecode'],
      vehicleCode: json['vehiclecode'],
      modeName: json['modename'],
      vendCode: json['vendcode'],
      vendName: json['vendname'],
      vehicleTypeCode: json['vehicletypecode'],
      vehicleTypeName: json['vehicletypename'],
      driverCode: json['drivercode'],
      mainDriverName: json['maindrivername'],
      driverMobileNo: json['drivermobileno'],
      mainDriverLcNo: json['maindriverlcno'],
      mainDriverLcValidateUpto: json['maindriverlcvalidateupto'],
      distance: json['distance'],
      executiveId: json['executiveid'],
      executiveName: json['executivename'],
      rate: json['rate'],
      freight: json['freight'],
      oAmount: json['oamount'],
      subTotal: json['subtotal'],
      balance: json['balance'],
      tAmount: json['tamount'],
      totalQty: json['totalqty'],
      totalVWeight: json['totalvweight'],
      totalAWeight: json['totalaweight'],
      totalCWeight: json['totalcweight'],
      remarks: json['remarks'],
      recStatus: json['recstatus'],
      ocrId: json['ocrid'],
      volFactor: json['volfactor'],
      allowPickupDeliveryPoint: json['allowpickupdeliverypoint'],
      cngrTelNoLen: json['cngrtelnolen'],
      cngeTelNoLen: json['cngetelnolen'],
      cngrZipCodeLen: json['cngrzipcodelen'],
      cngeZipCodeLen: json['cngezipcodelen'],
      pcs: json['pcs'],
      documentType: json['documentType'],
      recstatus: json['recstatus'],
      loadTypeName: json['loadtypename'],
      loadTypeCode: json['loadtype'],
      orderid: json['orderid'],
      weight: json['weight'],
      packing: json['packing'],
      packingcode: json['packingcode'],
      goods: json['goods'],
      grtype: json['grtype'],
      invoiceimage: json['invoiceimage'],
      autoSendEmail: json['autosendemail'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'indentid': indentId,
      'grdt': grdt,
      'picktime': time,
      'orgcode': orgCode,
      'orgname': orgName,
      'pickdt': pickDt,
      'invoicecode': invoiceCode,
      'pickuppoint': pickupPoint,
      'pickuppincodedataid': pickupPincodeDataId,
      'pickuppincode': pickupPincode,
      'pickupaddress': pickupAddress,
      'destcode': destCode,
      'destname': destName,
      'deliverypoint': deliveryPoint,
      'deliverypincodedataid': deliveryPincodeDataId,
      'deliverypincode': deliveryPincode,
      'deliveryaddress': deliveryAddress,
      'grtype': grType,
      'bookingtypename': bookingTypeName,
      'bookingtypecode': bookingTypeCode,
      'custcode': custCode,
      'custname': custName,
      'custgstno': custGstNo,
      'custdeptid': custDeptId,
      'custdeptname': custDeptName,
      'custdeptgstno': custDeptGstNo,
      'referenceno': referenceNo,
      'cngrgstno': cngrGstNo,
      'cngrdocnocode': cngrDocNoCode,
      'cngrcode': cngrCode,
      'cngr': cngr,
      'cngrname': cngrName,
      'cngraddress': cngrAddress,
      'cngrcity': cngrCity,
      'cngrcitycode': cngrCityCode,
      'cngrzipcode': cngrZipCode,
      'cngrstate': cngrState,
      'cngrcountry': cngrCountry,
      'cngrmobileno': cngrMobileNo,
      'cngremailid': cngrEmailId,
      'cngegstno': cngeGstNo,
      'cngedocnocode': cngeDocNoCode,
      'cngecode': cngeCode,
      'cnge': cnge,
      'cngename': cngeName,
      'cngeaddress': cngeAddress,
      'cngecity': cngeCity,
      'cngecitycode': cngeCityCode,
      'cngezipcode': cngeZipCode,
      'cngestate': cngeState,
      'cngecountry': cngeCountry,
      'productcode': productCode,
      'productname': productName,
      'dlvtype': dlvType,
      'deliverytypename': deliveryTypeName,
      'deliverytypecode': deliveryTypeCode,
      'vehiclecode': vehicleCode,
      'modename': modeName,
      'vendcode': vendCode,
      'vendname': vendName,
      'vehicletypecode': vehicleTypeCode,
      'vehicletypename': vehicleTypeName,
      'drivercode': driverCode,
      'maindrivername': mainDriverName,
      'drivermobileno': driverMobileNo,
      'maindriverlcno': mainDriverLcNo,
      'maindriverlcvalidateupto': mainDriverLcValidateUpto,
      'distance': distance,
      'executiveid': executiveId,
      'executivename': executiveName,
      'rate': rate,
      'freight': freight,
      'oamount': oAmount,
      'subtotal': subTotal,
      'balance': balance,
      'tamount': tAmount,
      'totalqty': totalQty,
      'totalvweight': totalVWeight,
      'totalaweight': totalAWeight,
      'totalcweight': totalCWeight,
      'remarks': remarks,
      'recstatus': recStatus,
      'ocrid': ocrId,
      'volfactor': volFactor,
      'allowpickupdeliverypoint': allowPickupDeliveryPoint,
      'cngrtelnolen': cngrTelNoLen,
      'cngetelnolen': cngeTelNoLen,
      'cngrzipcodelen': cngrZipCodeLen,
      'cngezipcodelen': cngeZipCodeLen,
      'pcs': pcs,
      'documenttype': documentType,
      'loadtypename': loadTypeName,
      'loadtype': loadTypeCode,
      'orderid': orderid,
      'weight': weight,
      'packing': packing,
      'packingcode': packingcode,
      'goods': goods,
      'invoiceimage': invoiceimage,
      'autosendemail': autoSendEmail,
    };
  }

  OtexPickupInfoModel copyWith({
    int? commandStatus,
    String? commandMessage,
    int? indentId,
    String? grdt,
    String? time,
    String? orgCode,
    String? orgName,
    String? pickDt,
    String? pickTime,
    String? invoiceCode,
    String? pickupPoint,
    int? pickupPincodeDataId,
    String? pickupPincode,
    String? pickupaddress,
    String? destCode,
    String? destName,
    String? deliveryPoint,
    int? deliveryPincodeDataId,
    String? deliveryPincode,
    String? deliveryaddress,
    String? grtype,
    String? bookingTypeName,
    String? bookingTypeCode,
    String? custCode,
    String? custName,
    String? custGstNo,
    int? custDeptId,
    String? custDeptName,
    String? custDeptGstNo,
    String? referenceNo,
    String? cngrGstNo,
    String? cngrDocNoCode,
    String? cngrCode,
    String? cngr,
    String? cngrName,
    String? cngrAddress,
    String? cngrCity,
    String? cngrCityCode,
    String? cngrZipCode,
    String? cngrState,
    String? cngrCountry,
    String? cngrMobileNo,
    String? cngrEmailId,
    String? cngeGstNo,
    String? cngeDocNoCode,
    String? cngeCode,
    String? cnge,
    String? cngeName,
    String? cngeAddress,
    String? cngeCity,
    String? cngeCityCode,
    String? cngeZipCode,
    String? cngeState,
    String? cngeCountry,
    String? cngeMobileNo,
    String? cngeEmailId,
    String? productCode,
    String? productName,
    String? dlvType,
    String? deliveryTypeName,
    String? deliveryTypeCode,
    String? vehicleCode,
    String? modeName,
    String? vendCode,
    String? vendName,
    String? vehicleTypeCode,
    String? vehicleTypeName,
    String? driverCode,
    String? mainDriverName,
    String? driverMobileNo,
    String? mainDriverLcNo,
    String? mainDriverLcValidateUpto,
    dynamic distance,
    int? executiveId,
    String? executiveName,
    num? rate,
    num? freight,
    num? oAmount,
    num? subTotal,
    num? balance,
    num? tAmount,
    int? totalQty,
    num? totalVWeight,
    num? totalAWeight,
    num? totalCWeight,
    String? remarks,
    String? recStatus,
    int? ocrId,
    num? volFactor,
    String? allowPickupDeliveryPoint,
    int? cngrTelNoLen,
    int? cngeTelNoLen,
    int? cngrZipCodeLen,
    int? cngeZipCodeLen,
    int? pcs,
    String? documentType,
    String? loadTypeName,
    String? loadType,
    String? orderid,
    String? packingname,
    String? packingcode,
    String? goods,
    double? weight,
    String? invoiceimage,
    String? autosendemail,
  }) {
    return OtexPickupInfoModel(
        commandStatus: commandStatus ?? this.commandStatus,
        commandMessage: commandMessage ?? this.commandMessage,
        indentId: indentId ?? this.indentId,
        grdt: grdt ?? this.grdt,
        time: time ?? this.time,
        orgCode: orgCode ?? this.orgCode,
        orgName: orgName ?? this.orgName,
        pickDt: pickDt ?? this.pickDt,
        pickTime: pickTime ?? this.pickTime,
        invoiceCode: invoiceCode ?? this.invoiceCode,
        pickupPoint: pickupPoint ?? this.pickupPoint,
        pickupPincodeDataId: pickupPincodeDataId ?? this.pickupPincodeDataId,
        pickupPincode: pickupPincode ?? this.pickupPincode,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        destCode: destCode ?? this.destCode,
        destName: destName ?? this.destName,
        deliveryPoint: deliveryPoint ?? this.deliveryPoint,
        deliveryPincodeDataId:
            deliveryPincodeDataId ?? this.deliveryPincodeDataId,
        deliveryPincode: deliveryPincode ?? this.deliveryPincode,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        grtype: grtype ?? this.grtype,
        bookingTypeName: bookingTypeName ?? this.bookingTypeName,
        bookingTypeCode: bookingTypeCode ?? this.bookingTypeCode,
        custCode: custCode ?? this.custCode,
        custName: custName ?? this.custName,
        custGstNo: custGstNo ?? this.custGstNo,
        custDeptId: custDeptId ?? this.custDeptId,
        custDeptName: custDeptName ?? this.custDeptName,
        custDeptGstNo: custDeptGstNo ?? this.custDeptGstNo,
        referenceNo: referenceNo ?? this.referenceNo,
        cngrGstNo: cngrGstNo ?? this.cngrGstNo,
        cngrDocNoCode: cngrDocNoCode ?? this.cngrDocNoCode,
        cngrCode: cngrCode ?? this.cngrCode,
        cngr: cngr ?? this.cngr,
        cngrName: cngrName ?? this.cngrName,
        cngrAddress: cngrAddress ?? this.cngrAddress,
        cngrCity: cngrCity ?? this.cngrCity,
        cngrCityCode: cngrCityCode ?? this.cngrCityCode,
        cngrZipCode: cngrZipCode ?? this.cngrZipCode,
        cngrState: cngrState ?? this.cngrState,
        cngrCountry: cngrCountry ?? this.cngrCountry,
        cngrMobileNo: cngrMobileNo ?? this.cngrMobileNo,
        cngrEmailId: cngrEmailId ?? this.cngrEmailId,
        cngeGstNo: cngeGstNo ?? this.cngeGstNo,
        cngeDocNoCode: cngeDocNoCode ?? this.cngeDocNoCode,
        cngeCode: cngeCode ?? this.cngeCode,
        cnge: cnge ?? this.cnge,
        cngeName: cngeName ?? this.cngeName,
        cngeAddress: cngeAddress ?? this.cngeAddress,
        cngeCity: cngeCity ?? this.cngeCity,
        cngeCityCode: cngeCityCode ?? this.cngeCityCode,
        cngeZipCode: cngeZipCode ?? this.cngeZipCode,
        cngeState: cngeState ?? this.cngeState,
        cngeCountry: cngeCountry ?? this.cngeCountry,
        cngeMobileNo: cngeMobileNo ?? this.cngeMobileNo,
        cngeEmailId: cngeEmailId ?? this.cngeEmailId,
        productCode: productCode ?? this.productCode,
        productName: productName ?? this.productName,
        dlvType: dlvType ?? this.dlvType,
        deliveryTypeName: deliveryTypeName ?? this.deliveryTypeName,
        deliveryTypeCode: deliveryTypeCode ?? this.deliveryTypeCode,
        vehicleCode: vehicleCode ?? this.vehicleCode,
        modeName: modeName ?? this.modeName,
        vendCode: vendCode ?? this.vendCode,
        vendName: vendName ?? this.vendName,
        vehicleTypeCode: vehicleTypeCode ?? this.vehicleTypeCode,
        vehicleTypeName: vehicleTypeName ?? this.vehicleTypeName,
        driverCode: driverCode ?? this.driverCode,
        mainDriverName: mainDriverName ?? this.mainDriverName,
        driverMobileNo: driverMobileNo ?? this.driverMobileNo,
        mainDriverLcNo: mainDriverLcNo ?? this.mainDriverLcNo,
        mainDriverLcValidateUpto:
            mainDriverLcValidateUpto ?? this.mainDriverLcValidateUpto,
        distance: distance ?? this.distance,
        executiveId: executiveId ?? this.executiveId,
        executiveName: executiveName ?? this.executiveName,
        rate: rate ?? this.rate,
        freight: freight ?? this.freight,
        oAmount: oAmount ?? this.oAmount,
        subTotal: subTotal ?? this.subTotal,
        balance: balance ?? this.balance,
        tAmount: tAmount ?? this.tAmount,
        totalQty: totalQty ?? this.totalQty,
        totalVWeight: totalVWeight ?? this.totalVWeight,
        totalAWeight: totalAWeight ?? this.totalAWeight,
        totalCWeight: totalCWeight ?? this.totalCWeight,
        remarks: remarks ?? this.remarks,
        recStatus: recStatus ?? this.recStatus,
        ocrId: ocrId ?? this.ocrId,
        volFactor: volFactor ?? this.volFactor,
        allowPickupDeliveryPoint:
            allowPickupDeliveryPoint ?? this.allowPickupDeliveryPoint,
        cngrTelNoLen: cngrTelNoLen ?? this.cngrTelNoLen,
        cngeTelNoLen: cngeTelNoLen ?? this.cngeTelNoLen,
        cngrZipCodeLen: cngrZipCodeLen ?? this.cngrZipCodeLen,
        cngeZipCodeLen: cngeZipCodeLen ?? this.cngeZipCodeLen,
        pcs: pcs ?? this.pcs,
        documentType: documentType ?? this.documentType,
        loadTypeName: loadTypeName ?? this.loadTypeName,
        loadTypeCode: loadType ?? this.loadTypeCode,
        orderid: orderid ?? this.orderid,
        packing: packingname ?? this.packing,
        packingcode: packingcode ?? this.packingcode,
        goods: goods ?? this.goods,
        weight: weight ?? this.weight,
        invoiceimage: invoiceimage ?? this.invoiceimage,
        autoSendEmail: autoSendEmail ?? this.autoSendEmail);
  }
}

// class OtexPickupInfoModel {
//   final int? indentId;
//   final String? documentType;

//   final String? bookingBranchName;
//   final String? bookingBranchCode;
//   final String? grdt;
//   final String? picktime;

//   final String? invoiceCode;
//   final String? cnmtNo1;
//   final String? cnmtNo2;
//   final String? grNo;

//   final String? bookingTypeName;
//   final String? bookingTypeCode;

//   final String? referenceNumber;

//   final String? customerName;
//   final String? customerCode;
//   final String? customerGstNo;

//   final String? departmentName;
//   final String? departmentCode;
//   final String? departmentGstNo;

//   final String? shipperName;
//   final String? shipperCode;
//   final String? shipperAddress;
//   final String? shipperZipCode;
//   final String? shipperMobileNo;
//   final String? shipperEmail;

//   final String? cngeName;
//   final String? cngeCode;
//   final String? cngeAddress;
//   final String? cngeZipCode;
//   final String? cngeMobileNo;
//   final String? cngeEmail;

//   final String? pickupPoint;
//   final String? pickupPinCode;
//   final String? pickupPointAlias;
//   final String? pickupLatitude;
//   final String? pickupLongitude;
//   final String? pickupAddress;

//   final String? deliveryPoint;
//   final String? deliveryPinCode;
//   final String? deliveryPointAlias;
//   final String? deliveryLatitude;
//   final String? deliveryLongitude;
//   final String? deliveryAddress;

//   final String? productTypeName;
//   final String? productTypeCode;

//   final String? loadTypeName;
//   final String? loadTypeCode;

//   final String? deliveryTypeName;
//   final String? deliveryTypeCode;

//   final String? remarks;
//   final String? recstatus;
//   final int? pcs;

//   const OtexPickupInfoModel(
//       {this.indentId,
//       this.documentType,
//       this.bookingBranchName,
//       this.bookingBranchCode,
//       this.grdt,
//       this.picktime,
//       this.invoiceCode,
//       this.cnmtNo1,
//       this.cnmtNo2,
//       this.grNo,
//       this.bookingTypeName,
//       this.bookingTypeCode,
//       this.referenceNumber,
//       this.customerName,
//       this.customerCode,
//       this.customerGstNo,
//       this.departmentName,
//       this.departmentCode,
//       this.departmentGstNo,
//       this.shipperName,
//       this.shipperCode,
//       this.shipperAddress,
//       this.shipperZipCode,
//       this.shipperMobileNo,
//       this.shipperEmail,
//       this.cngeName,
//       this.cngeCode,
//       this.cngeAddress,
//       this.cngeZipCode,
//       this.cngeMobileNo,
//       this.cngeEmail,
//       this.pickupPoint,
//       this.pickupPinCode,
//       this.pickupPointAlias,
//       this.pickupLatitude,
//       this.pickupLongitude,
//       this.pickupAddress,
//       this.deliveryPoint,
//       this.deliveryPinCode,
//       this.deliveryPointAlias,
//       this.deliveryLatitude,
//       this.deliveryLongitude,
//       this.deliveryAddress,
//       this.productTypeName,
//       this.productTypeCode,
//       this.loadTypeName,
//       this.loadTypeCode,
//       this.deliveryTypeName,
//       this.deliveryTypeCode,
//       this.remarks,
//       this.recstatus,
//       this.pcs});

//   OtexPickupInfoModel copyWith(
//       {int? indentId,
//       String? documentType,
//       String? bookingBranchName,
//       String? bookingBranchCode,
//       String? bookingDate,
//       String? bookingTime,
//       String? invoiceCode,
//       String? cnmtNo1,
//       String? cnmtNo2,
//       String? grNo,
//       String? bookingTypeName,
//       String? bookingTypeCode,
//       String? referenceNumber,
//       String? customerName,
//       String? customerCode,
//       String? customerGstNo,
//       String? departmentName,
//       String? departmentCode,
//       String? departmentGstNo,
//       String? shipperName,
//       String? shipperCode,
//       String? shipperAddress,
//       String? shipperZipCode,
//       String? shipperMobileNo,
//       String? shipperEmail,
//       String? cngeName,
//       String? cngeCode,
//       String? cngeAddress,
//       String? cngeZipCode,
//       String? cngeMobileNo,
//       String? cngeEmail,
//       String? pickupPoint,
//       String? pickupPinCode,
//       String? pickupPointAlias,
//       String? pickupLatitude,
//       String? pickupLongitude,
//       String? pickupAddress,
//       String? deliveryPoint,
//       String? deliveryPinCode,
//       String? deliveryPointAlias,
//       String? deliveryLatitude,
//       String? deliveryLongitude,
//       String? deliveryAddress,
//       String? productTypeName,
//       String? productTypeCode,
//       String? loadTypeName,
//       String? loadTypeCode,
//       String? deliveryTypeName,
//       String? deliveryTypeCode,
//       String? remarks,
//       String? recstatus,
//       int? pcs,
//       String? bookingtypename}) {
//     return OtexPickupInfoModel(
//         indentId: indentId ?? this.indentId,
//         documentType: documentType ?? this.documentType,
//         bookingBranchName: bookingBranchName ?? this.bookingBranchName,
//         bookingBranchCode: bookingBranchCode ?? this.bookingBranchCode,
//         grdt: bookingDate ?? this.grdt,
//         picktime: bookingTime ?? this.picktime,
//         invoiceCode: invoiceCode ?? this.invoiceCode,
//         cnmtNo1: cnmtNo1 ?? this.cnmtNo1,
//         cnmtNo2: cnmtNo2 ?? this.cnmtNo2,
//         grNo: grNo ?? this.grNo,
//         bookingTypeName: bookingTypeName ?? this.bookingTypeName,
//         bookingTypeCode: bookingTypeCode ?? this.bookingTypeCode,
//         referenceNumber: referenceNumber ?? this.referenceNumber,
//         customerName: customerName ?? this.customerName,
//         customerCode: customerCode ?? this.customerCode,
//         customerGstNo: customerGstNo ?? this.customerGstNo,
//         departmentName: departmentName ?? this.departmentName,
//         departmentCode: departmentCode ?? this.departmentCode,
//         departmentGstNo: departmentGstNo ?? this.departmentGstNo,
//         shipperName: shipperName ?? this.shipperName,
//         shipperCode: shipperCode ?? this.shipperCode,
//         shipperAddress: shipperAddress ?? this.shipperAddress,
//         shipperZipCode: shipperZipCode ?? this.shipperZipCode,
//         shipperMobileNo: shipperMobileNo ?? this.shipperMobileNo,
//         shipperEmail: shipperEmail ?? this.shipperEmail,
//         cngeName: cngeName ?? this.cngeName,
//         cngeCode: cngeCode ?? this.cngeCode,
//         cngeAddress: cngeAddress ?? this.cngeAddress,
//         cngeZipCode: cngeZipCode ?? this.cngeZipCode,
//         cngeMobileNo: cngeMobileNo ?? this.cngeMobileNo,
//         cngeEmail: cngeEmail ?? this.cngeEmail,
//         pickupPoint: pickupPoint ?? this.pickupPoint,
//         pickupPinCode: pickupPinCode ?? this.pickupPinCode,
//         pickupPointAlias: pickupPointAlias ?? this.pickupPointAlias,
//         pickupLatitude: pickupLatitude ?? this.pickupLatitude,
//         pickupLongitude: pickupLongitude ?? this.pickupLongitude,
//         pickupAddress: pickupAddress ?? this.pickupAddress,
//         deliveryPoint: deliveryPoint ?? this.deliveryPoint,
//         deliveryPinCode: deliveryPinCode ?? this.deliveryPinCode,
//         deliveryPointAlias: deliveryPointAlias ?? this.deliveryPointAlias,
//         deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
//         deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
//         deliveryAddress: deliveryAddress ?? this.deliveryAddress,
//         productTypeName: productTypeName ?? this.productTypeName,
//         productTypeCode: productTypeCode ?? this.productTypeCode,
//         loadTypeName: loadTypeName ?? this.loadTypeName,
//         loadTypeCode: loadTypeCode ?? this.loadTypeCode,
//         deliveryTypeName: deliveryTypeName ?? this.deliveryTypeName,
//         deliveryTypeCode: deliveryTypeCode ?? this.deliveryTypeCode,
//         remarks: remarks ?? this.remarks,
//         recstatus: recstatus ?? this.recstatus,
//         pcs: pcs ?? this.pcs);
//   }

//   factory OtexPickupInfoModel.fromJson(Map<String, dynamic> json) {
//     return OtexPickupInfoModel(
//         indentId: json['indentid'] as int?,
//         documentType: json['documenttype'] as String?,
//         bookingBranchName: json['orgname'] as String?,
//         bookingBranchCode: json['orgcode'] as String?,
//         grdt: json['pickdt'] as String?,
//         picktime: json['picktime'] as String?,
//         invoiceCode: json['invoicecode'] as String?,
//         cnmtNo1: json['cnmtno1'] as String?,
//         cnmtNo2: json['cnmtno2'] as String?,
//         grNo: json['grno'] as String?,
//         bookingTypeName: json['bookingtypename'] as String?,
//         bookingTypeCode: json['grtype'] as String?,
//         referenceNumber: json['referenceno'] as String?,
//         customerName: json['custname'] as String?,
//         customerCode: json['custcode'] as String?,
//         customerGstNo: json['custgstno'] as String?,
//         departmentName: json['custdeptname'] as String?,
//         departmentCode: json['custdeptid']?.toString(),
//         departmentGstNo: json['custdeptgstno'] as String?,
//         shipperName: json['cngrname'] as String?,
//         shipperCode: json['cngrcode'] as String?,
//         shipperAddress: json['cngraddress'] as String?,
//         shipperZipCode: json['cngrzipcode'] as String?,
//         shipperMobileNo: json['cngrtelno'] as String?,
//         shipperEmail: json['cngremail'] as String?,
//         cngeName: json['cngename'] as String?,
//         cngeCode: json['cngecode'] as String?,
//         cngeAddress: json['cngeaddress'] as String?,
//         cngeZipCode: json['cngezipcode'] as String?,
//         cngeMobileNo: json['cngetelno'] as String?,
//         cngeEmail: json['cngeemail'] as String?,
//         pickupPoint: json['pickuppoint'] as String?,
//         pickupPinCode: json['pickuppincode']?.toString(),
//         pickupPointAlias: json['pickuppointalias'] as String?,
//         pickupLatitude: json['pickuplatitude']?.toString(),
//         pickupLongitude: json['pickuplongitude']?.toString(),
//         pickupAddress: json['pickupaddress'] as String?,
//         deliveryPoint: json['deliverypoint'] as String?,
//         deliveryPinCode: json['deliverypincode']?.toString(),
//         deliveryPointAlias: json['deliverypointalias'] as String?,
//         deliveryLatitude: json['deliverylatitude']?.toString(),
//         deliveryLongitude: json['deliverylongitude']?.toString(),
//         deliveryAddress: json['dlvaddress'] as String?,
//         productTypeName: json['productname'] as String?,
//         productTypeCode: json['productcode'] as String?,
//         loadTypeName: json['loadtype'] as String?,
//         loadTypeCode: json['loadtype'] as String?,
//         deliveryTypeName: json['deliverytypename'] as String?,
//         deliveryTypeCode: json['dlvtype'] as String?,
//         remarks: json['remarks'] as String?,
//         recstatus: json['recstatus'] as String?,
//         pcs: json['pcs'] as int);
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'indentid': indentId,
//       'documenttype': documentType,
//       'orgname': bookingBranchName,
//       'orgcode': bookingBranchCode,
//       'grdt': grdt,
//       'picktime': picktime,
//       'invoicecode': invoiceCode,
//       'cnmtno1': cnmtNo1,
//       'cnmtno2': cnmtNo2,
//       'grno': grNo,
//       'contracttype': bookingTypeName,
//       'grtype': bookingTypeCode,
//       'referenceno': referenceNumber,
//       'custname': customerName,
//       'custcode': customerCode,
//       'custgstno': customerGstNo,
//       'custdeptname': departmentName,
//       'custdeptid': departmentCode,
//       'custdeptgstno': departmentGstNo,
//       'cngrname': shipperName,
//       'cngrcode': shipperCode,
//       'cngraddress': shipperAddress,
//       'cngrzipcode': shipperZipCode,
//       'cngrtelno': shipperMobileNo,
//       'cngremail': shipperEmail,
//       'cngename': cngeName,
//       'cngecode': cngeCode,
//       'cngeaddress': cngeAddress,
//       'cngezipcode': cngeZipCode,
//       'cngetelno': cngeMobileNo,
//       'cngeemail': cngeEmail,
//       'pickuppoint': pickupPoint,
//       'pickuppincode': pickupPinCode,
//       'pickuppointalias': pickupPointAlias,
//       'pickuplatitude': pickupLatitude,
//       'pickuplongitude': pickupLongitude,
//       'pickupaddress': pickupAddress,
//       'deliverypoint': deliveryPoint,
//       'deliverypincode': deliveryPinCode,
//       'deliverypointalias': deliveryPointAlias,
//       'deliverylatitude': deliveryLatitude,
//       'deliverylongitude': deliveryLongitude,
//       'dlvaddress': deliveryAddress,
//       'productcode': productTypeCode,
//       'loadtype': loadTypeCode,
//       'dlvtype': deliveryTypeCode,
//       'remarks': remarks,
//       'recstatus': recstatus,
//       'pcs': pcs
//     };
//   }
// }
