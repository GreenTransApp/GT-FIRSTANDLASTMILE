class EwayBillModelResponse {
  final String? ewayBill;
  final DateTime? ewayBillDate;
  final DateTime? validUpto;
  final String? invoiceNo;
  final DateTime? invoiceDate;
  final double? invoiceValue;
  final int? partId;
  final double? qty;

  EwayBillModelResponse({
    this.ewayBill,
    this.ewayBillDate,
    this.validUpto,
    this.invoiceNo,
    this.invoiceDate,
    this.invoiceValue,
    this.partId,
    this.qty,
  });

  factory EwayBillModelResponse.fromJson(Map<String, dynamic> json) {
    return EwayBillModelResponse(
      ewayBill: json['ewayBill'],
      ewayBillDate: json['ewaybillDate'] != null
          ? DateTime.tryParse(json['ewaybillDate'])
          : null,
      validUpto: json['validUpto'] != null
          ? DateTime.tryParse(json['validUpto'])
          : null,
      invoiceNo: json['invoiceNo'],
      invoiceDate: json['invoiceDate'] != null
          ? DateTime.tryParse(json['invoiceDate'])
          : null,
      invoiceValue: (json['invoiceValue'] as num?)?.toDouble(),
      partId: json['partid'],
      qty: (json['qty'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ewayBill': ewayBill,
      'ewaybillDate': ewayBillDate?.toIso8601String(),
      'validUpto': validUpto?.toIso8601String(),
      'invoiceNo': invoiceNo,
      'invoiceDate': invoiceDate?.toIso8601String(),
      'invoiceValue': invoiceValue,
      'partid': partId,
      'qty': qty,
    };
  }
}
