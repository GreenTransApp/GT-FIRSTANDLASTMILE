class CustomerModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? custCode;
  final String? custName;
  final String? custType;

  CustomerModel({
    this.commandStatus,
    this.commandMessage,
    this.custCode,
    this.custName,
    this.custType,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      custCode: json['custcode'],
      custName: json['custname'],
      custType: json['custtype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'custcode': custCode,
      'custname': custName,
      'custtype': custType,
    };
  }
}
