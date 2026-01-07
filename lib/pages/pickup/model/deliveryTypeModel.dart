class DeliveryTypeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? deliveryTypeName;
  final String? deliveryType;

  DeliveryTypeModel({
    this.commandStatus,
    this.commandMessage,
    this.deliveryTypeName,
    this.deliveryType,
  });

  factory DeliveryTypeModel.fromJson(Map<String, dynamic> json) {
    return DeliveryTypeModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      deliveryTypeName: json['deliverytypename'],
      deliveryType: json['deliverytype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'deliverytypename': deliveryTypeName,
      'deliverytype': deliveryType,
    };
  }

  static List<DeliveryTypeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DeliveryTypeModel.fromJson(json)).toList();
  }
}
