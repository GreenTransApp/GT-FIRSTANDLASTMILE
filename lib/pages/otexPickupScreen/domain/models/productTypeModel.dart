class ProductTypeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? productname;
  final String? productcode;

  ProductTypeModel({
    this.commandStatus,
    this.commandMessage,
    this.productname,
    this.productcode,
  });

  factory ProductTypeModel.fromJson(Map<String, dynamic> json) {
    return ProductTypeModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      productname: json['productname'],
      productcode: json['productcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'productname': productname,
      'productcode': productcode,
    };
  }

  @override
  String toString() => productname ?? '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductTypeModel &&
          runtimeType == other.runtimeType &&
          productcode == other.productcode;

  @override
  int get hashCode => productcode.hashCode;
}
