class OtexPickupInfoModel {
  final int? indentId;
  final String? documentType;

  final String? bookingBranchName;
  final String? bookingBranchCode;
  final String? grdt;
  final String? picktime;

  final String? invoiceCode;
  final String? cnmtNo1;
  final String? cnmtNo2;
  final String? grNo;

  final String? bookingTypeName;
  final String? bookingTypeCode;

  final String? referenceNumber;

  final String? customerName;
  final String? customerCode;
  final String? customerGstNo;

  final String? departmentName;
  final String? departmentCode;
  final String? departmentGstNo;

  final String? shipperName;
  final String? shipperCode;
  final String? shipperAddress;
  final String? shipperZipCode;
  final String? shipperMobileNo;
  final String? shipperEmail;

  final String? cngeName;
  final String? cngeCode;
  final String? cngeAddress;
  final String? cngeZipCode;
  final String? cngeMobileNo;
  final String? cngeEmail;

  final String? pickupPoint;
  final String? pickupPinCode;
  final String? pickupPointAlias;
  final String? pickupLatitude;
  final String? pickupLongitude;
  final String? pickupAddress;

  final String? deliveryPoint;
  final String? deliveryPinCode;
  final String? deliveryPointAlias;
  final String? deliveryLatitude;
  final String? deliveryLongitude;
  final String? deliveryAddress;

  final String? productTypeName;
  final String? productTypeCode;

  final String? loadTypeName;
  final String? loadTypeCode;

  final String? deliveryTypeName;
  final String? deliveryTypeCode;

  final String? remarks;
  final String? recstatus;
  final int? pcs;

  const OtexPickupInfoModel(
      {this.indentId,
      this.documentType,
      this.bookingBranchName,
      this.bookingBranchCode,
      this.grdt,
      this.picktime,
      this.invoiceCode,
      this.cnmtNo1,
      this.cnmtNo2,
      this.grNo,
      this.bookingTypeName,
      this.bookingTypeCode,
      this.referenceNumber,
      this.customerName,
      this.customerCode,
      this.customerGstNo,
      this.departmentName,
      this.departmentCode,
      this.departmentGstNo,
      this.shipperName,
      this.shipperCode,
      this.shipperAddress,
      this.shipperZipCode,
      this.shipperMobileNo,
      this.shipperEmail,
      this.cngeName,
      this.cngeCode,
      this.cngeAddress,
      this.cngeZipCode,
      this.cngeMobileNo,
      this.cngeEmail,
      this.pickupPoint,
      this.pickupPinCode,
      this.pickupPointAlias,
      this.pickupLatitude,
      this.pickupLongitude,
      this.pickupAddress,
      this.deliveryPoint,
      this.deliveryPinCode,
      this.deliveryPointAlias,
      this.deliveryLatitude,
      this.deliveryLongitude,
      this.deliveryAddress,
      this.productTypeName,
      this.productTypeCode,
      this.loadTypeName,
      this.loadTypeCode,
      this.deliveryTypeName,
      this.deliveryTypeCode,
      this.remarks,
      this.recstatus,
      this.pcs});

  OtexPickupInfoModel copyWith(
      {int? indentId,
      String? documentType,
      String? bookingBranchName,
      String? bookingBranchCode,
      String? bookingDate,
      String? bookingTime,
      String? invoiceCode,
      String? cnmtNo1,
      String? cnmtNo2,
      String? grNo,
      String? bookingTypeName,
      String? bookingTypeCode,
      String? referenceNumber,
      String? customerName,
      String? customerCode,
      String? customerGstNo,
      String? departmentName,
      String? departmentCode,
      String? departmentGstNo,
      String? shipperName,
      String? shipperCode,
      String? shipperAddress,
      String? shipperZipCode,
      String? shipperMobileNo,
      String? shipperEmail,
      String? cngeName,
      String? cngeCode,
      String? cngeAddress,
      String? cngeZipCode,
      String? cngeMobileNo,
      String? cngeEmail,
      String? pickupPoint,
      String? pickupPinCode,
      String? pickupPointAlias,
      String? pickupLatitude,
      String? pickupLongitude,
      String? pickupAddress,
      String? deliveryPoint,
      String? deliveryPinCode,
      String? deliveryPointAlias,
      String? deliveryLatitude,
      String? deliveryLongitude,
      String? deliveryAddress,
      String? productTypeName,
      String? productTypeCode,
      String? loadTypeName,
      String? loadTypeCode,
      String? deliveryTypeName,
      String? deliveryTypeCode,
      String? remarks,
      String? recstatus,
      int? pcs,
      String? bookingtypename}) {
    return OtexPickupInfoModel(
        indentId: indentId ?? this.indentId,
        documentType: documentType ?? this.documentType,
        bookingBranchName: bookingBranchName ?? this.bookingBranchName,
        bookingBranchCode: bookingBranchCode ?? this.bookingBranchCode,
        grdt: bookingDate ?? this.grdt,
        picktime: bookingTime ?? this.picktime,
        invoiceCode: invoiceCode ?? this.invoiceCode,
        cnmtNo1: cnmtNo1 ?? this.cnmtNo1,
        cnmtNo2: cnmtNo2 ?? this.cnmtNo2,
        grNo: grNo ?? this.grNo,
        bookingTypeName: bookingTypeName ?? this.bookingTypeName,
        bookingTypeCode: bookingTypeCode ?? this.bookingTypeCode,
        referenceNumber: referenceNumber ?? this.referenceNumber,
        customerName: customerName ?? this.customerName,
        customerCode: customerCode ?? this.customerCode,
        customerGstNo: customerGstNo ?? this.customerGstNo,
        departmentName: departmentName ?? this.departmentName,
        departmentCode: departmentCode ?? this.departmentCode,
        departmentGstNo: departmentGstNo ?? this.departmentGstNo,
        shipperName: shipperName ?? this.shipperName,
        shipperCode: shipperCode ?? this.shipperCode,
        shipperAddress: shipperAddress ?? this.shipperAddress,
        shipperZipCode: shipperZipCode ?? this.shipperZipCode,
        shipperMobileNo: shipperMobileNo ?? this.shipperMobileNo,
        shipperEmail: shipperEmail ?? this.shipperEmail,
        cngeName: cngeName ?? this.cngeName,
        cngeCode: cngeCode ?? this.cngeCode,
        cngeAddress: cngeAddress ?? this.cngeAddress,
        cngeZipCode: cngeZipCode ?? this.cngeZipCode,
        cngeMobileNo: cngeMobileNo ?? this.cngeMobileNo,
        cngeEmail: cngeEmail ?? this.cngeEmail,
        pickupPoint: pickupPoint ?? this.pickupPoint,
        pickupPinCode: pickupPinCode ?? this.pickupPinCode,
        pickupPointAlias: pickupPointAlias ?? this.pickupPointAlias,
        pickupLatitude: pickupLatitude ?? this.pickupLatitude,
        pickupLongitude: pickupLongitude ?? this.pickupLongitude,
        pickupAddress: pickupAddress ?? this.pickupAddress,
        deliveryPoint: deliveryPoint ?? this.deliveryPoint,
        deliveryPinCode: deliveryPinCode ?? this.deliveryPinCode,
        deliveryPointAlias: deliveryPointAlias ?? this.deliveryPointAlias,
        deliveryLatitude: deliveryLatitude ?? this.deliveryLatitude,
        deliveryLongitude: deliveryLongitude ?? this.deliveryLongitude,
        deliveryAddress: deliveryAddress ?? this.deliveryAddress,
        productTypeName: productTypeName ?? this.productTypeName,
        productTypeCode: productTypeCode ?? this.productTypeCode,
        loadTypeName: loadTypeName ?? this.loadTypeName,
        loadTypeCode: loadTypeCode ?? this.loadTypeCode,
        deliveryTypeName: deliveryTypeName ?? this.deliveryTypeName,
        deliveryTypeCode: deliveryTypeCode ?? this.deliveryTypeCode,
        remarks: remarks ?? this.remarks,
        recstatus: recstatus ?? this.recstatus,
        pcs: pcs ?? this.pcs);
  }

  factory OtexPickupInfoModel.fromJson(Map<String, dynamic> json) {
    return OtexPickupInfoModel(
        indentId: json['indentid'] as int?,
        documentType: json['documenttype'] as String?,
        bookingBranchName: json['orgname'] as String?,
        bookingBranchCode: json['orgcode'] as String?,
        grdt: json['pickdt'] as String?,
        picktime: json['picktime'] as String?,
        invoiceCode: json['invoicecode'] as String?,
        cnmtNo1: json['cnmtno1'] as String?,
        cnmtNo2: json['cnmtno2'] as String?,
        grNo: json['grno'] as String?,
        bookingTypeName: json['bookingtypename'] as String?,
        bookingTypeCode: json['grtype'] as String?,
        referenceNumber: json['referenceno'] as String?,
        customerName: json['custname'] as String?,
        customerCode: json['custcode'] as String?,
        customerGstNo: json['custgstno'] as String?,
        departmentName: json['custdeptname'] as String?,
        departmentCode: json['custdeptid']?.toString(),
        departmentGstNo: json['custdeptgstno'] as String?,
        shipperName: json['cngrname'] as String?,
        shipperCode: json['cngrcode'] as String?,
        shipperAddress: json['cngraddress'] as String?,
        shipperZipCode: json['cngrzipcode'] as String?,
        shipperMobileNo: json['cngrtelno'] as String?,
        shipperEmail: json['cngremail'] as String?,
        cngeName: json['cngename'] as String?,
        cngeCode: json['cngecode'] as String?,
        cngeAddress: json['cngeaddress'] as String?,
        cngeZipCode: json['cngezipcode'] as String?,
        cngeMobileNo: json['cngetelno'] as String?,
        cngeEmail: json['cngeemail'] as String?,
        pickupPoint: json['pickuppoint'] as String?,
        pickupPinCode: json['pickuppincode']?.toString(),
        pickupPointAlias: json['pickuppointalias'] as String?,
        pickupLatitude: json['pickuplatitude']?.toString(),
        pickupLongitude: json['pickuplongitude']?.toString(),
        pickupAddress: json['pickupaddress'] as String?,
        deliveryPoint: json['deliverypoint'] as String?,
        deliveryPinCode: json['deliverypincode']?.toString(),
        deliveryPointAlias: json['deliverypointalias'] as String?,
        deliveryLatitude: json['deliverylatitude']?.toString(),
        deliveryLongitude: json['deliverylongitude']?.toString(),
        deliveryAddress: json['dlvaddress'] as String?,
        productTypeName: json['productname'] as String?,
        productTypeCode: json['productcode'] as String?,
        loadTypeName: json['loadtype'] as String?,
        loadTypeCode: json['loadtype'] as String?,
        deliveryTypeName: json['deliverytypename'] as String?,
        deliveryTypeCode: json['dlvtype'] as String?,
        remarks: json['remarks'] as String?,
        recstatus: json['recstatus'] as String?,
        pcs: json['pcs'] as int);
  }

  Map<String, dynamic> toJson() {
    return {
      'indentid': indentId,
      'documenttype': documentType,
      'orgname': bookingBranchName,
      'orgcode': bookingBranchCode,
      'grdt': grdt,
      'picktime': picktime,
      'invoicecode': invoiceCode,
      'cnmtno1': cnmtNo1,
      'cnmtno2': cnmtNo2,
      'grno': grNo,
      'contracttype': bookingTypeName,
      'grtype': bookingTypeCode,
      'referenceno': referenceNumber,
      'custname': customerName,
      'custcode': customerCode,
      'custgstno': customerGstNo,
      'custdeptname': departmentName,
      'custdeptid': departmentCode,
      'custdeptgstno': departmentGstNo,
      'cngrname': shipperName,
      'cngrcode': shipperCode,
      'cngraddress': shipperAddress,
      'cngrzipcode': shipperZipCode,
      'cngrtelno': shipperMobileNo,
      'cngremail': shipperEmail,
      'cngename': cngeName,
      'cngecode': cngeCode,
      'cngeaddress': cngeAddress,
      'cngezipcode': cngeZipCode,
      'cngetelno': cngeMobileNo,
      'cngeemail': cngeEmail,
      'pickuppoint': pickupPoint,
      'pickuppincode': pickupPinCode,
      'pickuppointalias': pickupPointAlias,
      'pickuplatitude': pickupLatitude,
      'pickuplongitude': pickupLongitude,
      'pickupaddress': pickupAddress,
      'deliverypoint': deliveryPoint,
      'deliverypincode': deliveryPinCode,
      'deliverypointalias': deliveryPointAlias,
      'deliverylatitude': deliveryLatitude,
      'deliverylongitude': deliveryLongitude,
      'dlvaddress': deliveryAddress,
      'productcode': productTypeCode,
      'loadtype': loadTypeCode,
      'dlvtype': deliveryTypeCode,
      'remarks': remarks,
      'recstatus': recstatus,
      'pcs': pcs
    };
  }
}
