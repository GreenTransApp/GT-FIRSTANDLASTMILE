class OtexPickupSplitInfo {
  final String? wayBillNo;
  final String? destName;
  final String? destCode;
  final String? cngeName;
  final String? cngeCode;
  final int? palletQty;
  final String? packingMethod;
  final String? saidToContain;
  final double? weight;
  final double? freightAmt;

  OtexPickupSplitInfo({
    this.wayBillNo,
    this.destName,
    this.destCode,
    this.cngeName,
    this.cngeCode,
    this.palletQty,
    this.packingMethod,
    this.saidToContain,
    this.weight,
    this.freightAmt,
  });

  OtexPickupSplitInfo copyWith({
    String? wayBillNo,
    String? destName,
    String? destCode,
    String? cngeName,
    String? cngeCode,
    int? palletQty,
    String? packingMethod,
    String? saidToContain,
    double? weight,
    double? freightAmt,
  }) {
    return OtexPickupSplitInfo(
      wayBillNo: wayBillNo ?? this.wayBillNo,
      destName: destName ?? this.destName,
      destCode: destCode ?? this.destCode,
      cngeName: cngeName ?? this.cngeName,
      cngeCode: cngeCode ?? this.cngeCode,
      palletQty: palletQty ?? this.palletQty,
      packingMethod: packingMethod ?? this.packingMethod,
      saidToContain: saidToContain ?? this.saidToContain,
      weight: weight ?? this.weight,
      freightAmt: freightAmt ?? this.freightAmt,
    );
  }
}
