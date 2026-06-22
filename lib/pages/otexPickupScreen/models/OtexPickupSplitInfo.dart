class OtexPickupSplitInfo {
  // Existing Fields
  final String? wayBillNo;
  final String? destName;
  final String? destCode;
  final String? cngeName;
  final String? cngeCode;
  final int? palletQty;
  final String? packingMethodName;
  final String? packingMethodCode;
  final String? saidToContainName;
  final String? saidToContainCode;
  final double? weight;
  final double? freightAmt;
  final bool isSaved;

  // Missing Fields From API
  final String? invGuid;
  final String? partGuid;
  final int? transactionId;
  final String? grNo;

  final int? innerQty;
  final int? noOfBox;

  final String? itemCode;
  final String? itemName;

  final double? actualWeight;
  final double? volumetricWeight;
  final double? chargeableWeight;

  final String? dimensionUnitType;
  final double? cft;

  final double? length;
  final double? width;
  final double? height;

  final int? invoicePackages;
  final double? invoiceActualWeight;
  final double? invoiceVolumetricWeight;
  final double? invoiceChargeableWeight;
  final int? invoiceQty;
  final String? grtype;

  const OtexPickupSplitInfo({
    this.wayBillNo,
    this.destName,
    this.destCode,
    this.cngeName,
    this.cngeCode,
    this.palletQty = 0,
    this.packingMethodName,
    this.packingMethodCode,
    this.saidToContainName,
    this.saidToContainCode,
    this.weight,
    this.freightAmt,
    this.isSaved = false,
    this.invGuid,
    this.partGuid,
    this.transactionId,
    this.grNo,
    this.innerQty,
    this.noOfBox,
    this.itemCode,
    this.itemName,
    this.actualWeight,
    this.volumetricWeight,
    this.chargeableWeight,
    this.dimensionUnitType,
    this.cft,
    this.length,
    this.width,
    this.height,
    this.invoicePackages,
    this.invoiceActualWeight,
    this.invoiceVolumetricWeight,
    this.invoiceChargeableWeight,
    this.invoiceQty,
    this.grtype,
  });

  factory OtexPickupSplitInfo.fromJson(Map<String, dynamic> json) {
    return OtexPickupSplitInfo(
        invGuid: json['invguid'],
        partGuid: json['partguid'],
        transactionId: json['transactionid'],
        grNo: json['grno'],
        wayBillNo: json['grno'],
        innerQty: json['innerqty'],
        noOfBox: json['noofbox'],
        itemCode: json['itemcode'],
        itemName: json['itemname'],
        packingMethodCode: json['packingcode'],
        packingMethodName: json['packingname'],
        actualWeight: (json['aweight'] as num?)?.toDouble(),
        volumetricWeight: (json['vweight'] as num?)?.toDouble(),
        chargeableWeight: (json['cweight'] as num?)?.toDouble(),
        dimensionUnitType: json['dimensionunittype'],
        cft: (json['cft'] as num?)?.toDouble(),
        length: (json['length'] as num?)?.toDouble(),
        width: (json['width'] as num?)?.toDouble(),
        height: (json['height'] as num?)?.toDouble(),
        invoicePackages: json['invpckgs'],
        invoiceActualWeight: (json['invaweight'] as num?)?.toDouble(),
        invoiceVolumetricWeight: (json['invvweight'] as num?)?.toDouble(),
        invoiceChargeableWeight: (json['invcweight'] as num?)?.toDouble(),
        invoiceQty: json['invqty'],
        grtype: json['grtype']);
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'invguid': invGuid,
  //     'partguid': partGuid,
  //     'transactionid': transactionId,
  //     'grno': grNo,
  //     'innerqty': innerQty,
  //     'noofbox': noOfBox,
  //     'itemcode': itemCode,
  //     'itemname': itemName,
  //     'packingcode': packingMethodCode,
  //     'packingname': packingMethodName,
  //     'aweight': actualWeight,
  //     'vweight': volumetricWeight,
  //     'cweight': chargeableWeight,
  //     'dimensionunittype': dimensionUnitType,
  //     'cft': cft,
  //     'length': length,
  //     'width': width,
  //     'height': height,
  //     'invpckgs': invoicePackages,
  //     'invaweight': invoiceActualWeight,
  //     'invvweight': invoiceVolumetricWeight,
  //     'invcweight': invoiceChargeableWeight,
  //     'invqty': invoiceQty,
  //   };
  // }

  Map<String, dynamic> toJson() {
    return {
      'transactionid': transactionId ?? 0,
      'grno': grNo ?? '',
      'itemcode': saidToContainCode ?? '',
      'itemname': saidToContainName ?? '',
      'packingcode': packingMethodCode ?? '',
      'packingname': packingMethodName ?? '',
      'noofbox': noOfBox ?? 0,
      'unittype': dimensionUnitType ?? '',
      'cft': cft ?? 0.00,
      'length': length ?? 0.00,
      'width': width ?? 0.00,
      'height': height ?? 0.00,
      'aweight': actualWeight ?? 0.00,
      'vweight': volumetricWeight ?? 0.00,
      'cweight': chargeableWeight ?? 0.00,
    };
  }

  OtexPickupSplitInfo copyWith({
    String? wayBillNo,
    String? destName,
    String? destCode,
    String? cngeName,
    String? cngeCode,
    int? palletQty,
    String? packingMethodName,
    String? packingMethodCode,
    String? saidToContainName,
    String? saidToContainCode,
    double? weight,
    double? freightAmt,
    bool? isSaved,
    String? invGuid,
    String? partGuid,
    int? transactionId,
    String? grNo,
    int? innerQty,
    int? noOfBox,
    String? itemCode,
    String? itemName,
    double? actualWeight,
    double? volumetricWeight,
    double? chargeableWeight,
    String? dimensionUnitType,
    double? cft,
    double? length,
    double? width,
    double? height,
    int? invoicePackages,
    double? invoiceActualWeight,
    double? invoiceVolumetricWeight,
    double? invoiceChargeableWeight,
    int? invoiceQty,
    String? grtype,
    String? signImagePath,
    String? docImagePath,
  }) {
    return OtexPickupSplitInfo(
      wayBillNo: wayBillNo ?? this.wayBillNo,
      destName: destName ?? this.destName,
      destCode: destCode ?? this.destCode,
      cngeName: cngeName ?? this.cngeName,
      cngeCode: cngeCode ?? this.cngeCode,
      palletQty: palletQty ?? this.palletQty,
      packingMethodName: packingMethodName ?? this.packingMethodName,
      packingMethodCode: packingMethodCode ?? this.packingMethodCode,
      saidToContainName: saidToContainName ?? this.saidToContainName,
      saidToContainCode: saidToContainCode ?? this.saidToContainCode,
      weight: weight ?? this.weight,
      freightAmt: freightAmt ?? this.freightAmt,
      isSaved: isSaved ?? this.isSaved,
      invGuid: invGuid ?? this.invGuid,
      partGuid: partGuid ?? this.partGuid,
      transactionId: transactionId ?? this.transactionId,
      grNo: grNo ?? this.grNo,
      innerQty: innerQty ?? this.innerQty,
      noOfBox: noOfBox ?? this.noOfBox,
      itemCode: itemCode ?? this.itemCode,
      itemName: itemName ?? this.itemName,
      actualWeight: actualWeight ?? this.actualWeight,
      volumetricWeight: volumetricWeight ?? this.volumetricWeight,
      chargeableWeight: chargeableWeight ?? this.chargeableWeight,
      dimensionUnitType: dimensionUnitType ?? this.dimensionUnitType,
      cft: cft ?? this.cft,
      length: length ?? this.length,
      width: width ?? this.width,
      height: height ?? this.height,
      invoicePackages: invoicePackages ?? this.invoicePackages,
      invoiceActualWeight: invoiceActualWeight ?? this.invoiceActualWeight,
      invoiceVolumetricWeight:
          invoiceVolumetricWeight ?? this.invoiceVolumetricWeight,
      invoiceChargeableWeight:
          invoiceChargeableWeight ?? this.invoiceChargeableWeight,
      invoiceQty: invoiceQty ?? this.invoiceQty,
      grtype: grtype ?? this.grtype,
    );
  }
}
