class OtexPickupInfoModel {
  final String? bookingBranchName;
  final String? bookingBranchCode;
  final String? bookingDate;
  final String? bookingTime;
  final String? bookingTypeName;
  final String? bookingTypeCode;
  final String? referenceNumber;
  final String? customerName;
  final String? customerCode;
  final String? departmentName;
  final String? departmentCode;
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
  final String? productTypeName;
  final String? productTypeCode;
  final String? loadTypeName;
  final String? loadTypeCode;
  final String? deliveryTypeName;
  final String? deliveryTypeCode;

  OtexPickupInfoModel({
    this.bookingBranchName,
    this.bookingBranchCode,
    this.bookingDate,
    this.bookingTime,
    this.bookingTypeName,
    this.bookingTypeCode,
    this.referenceNumber,
    this.customerName,
    this.customerCode,
    this.departmentName,
    this.departmentCode,
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
    this.productTypeName,
    this.productTypeCode,
    this.loadTypeName,
    this.loadTypeCode,
    this.deliveryTypeName,
    this.deliveryTypeCode,
  });

  factory OtexPickupInfoModel.empty() {
    return OtexPickupInfoModel();
  }

  OtexPickupInfoModel copyWith({
    String? bookingBranchName,
    String? bookingBranchCode,
    String? bookingDate,
    String? bookingTime,
    String? bookingTypeName,
    String? bookingTypeCode,
    String? referenceNumber,
    String? customerName,
    String? customerCode,
    String? departmentName,
    String? departmentCode,
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
    String? productTypeName,
    String? productTypeCode,
    String? loadTypeName,
    String? loadTypeCode,
    String? deliveryTypeName,
    String? deliveryTypeCode,
  }) {
    return OtexPickupInfoModel(
      bookingBranchName: bookingBranchName ?? this.bookingBranchName,
      bookingBranchCode: bookingBranchCode ?? this.bookingBranchCode,
      bookingDate: bookingDate ?? this.bookingDate,
      bookingTime: bookingTime ?? this.bookingTime,
      bookingTypeName: bookingTypeName ?? this.bookingTypeName,
      bookingTypeCode: bookingTypeCode ?? this.bookingTypeCode,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      customerName: customerName ?? this.customerName,
      customerCode: customerCode ?? this.customerCode,
      departmentName: departmentName ?? this.departmentName,
      departmentCode: departmentCode ?? this.departmentCode,
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
      productTypeName: productTypeName ?? this.productTypeName,
      productTypeCode: productTypeCode ?? this.productTypeCode,
      loadTypeName: loadTypeName ?? this.loadTypeName,
      loadTypeCode: loadTypeCode ?? this.loadTypeCode,
      deliveryTypeName: deliveryTypeName ?? this.deliveryTypeName,
      deliveryTypeCode: deliveryTypeCode ?? this.deliveryTypeCode,
    );
  }
}
