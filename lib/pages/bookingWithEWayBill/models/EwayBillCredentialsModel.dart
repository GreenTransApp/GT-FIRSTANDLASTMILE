class EwayBillCredentialsModel {
  int? commandStatus;
  String? commandMessage;
  String? ewayEnabled;
  String? stateGst;
  String? compGst;
  String? ewayUserId;
  String? ewayPassword;

  EwayBillCredentialsModel({
    this.commandStatus,
    this.commandMessage,
    this.ewayEnabled,
    this.stateGst,
    this.compGst,
    this.ewayUserId,
    this.ewayPassword,
  });

  factory EwayBillCredentialsModel.fromJson(Map<String, dynamic> json) {
    return EwayBillCredentialsModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      ewayEnabled: json['ewayEnabled'],
      stateGst: json['stateGst'],
      compGst: json['compGst'],
      ewayUserId: json['ewayUserId'],
      ewayPassword: json['ewayPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'ewayEnabled': ewayEnabled,
      'stateGst': stateGst,
      'compGst': compGst,
      'ewayUserId': ewayUserId,
      'ewayPassword': ewayPassword,
    };
  }
}
