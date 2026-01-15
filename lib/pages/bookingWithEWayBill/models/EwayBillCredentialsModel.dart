class EwayBillCredentialsModel {
  int? commandstatus;
  String? commandmessage;
  String? ewayEnabled;
  String? stateGst;
  String? compGst;
  String? ewayUserId;
  String? ewayPassword;

  EwayBillCredentialsModel({
    this.commandstatus,
    this.commandmessage,
    this.ewayEnabled,
    this.stateGst,
    this.compGst,
    this.ewayUserId,
    this.ewayPassword,
  });

  factory EwayBillCredentialsModel.fromJson(Map<String, dynamic> json) {
    return EwayBillCredentialsModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      ewayEnabled: json['ewayEnabled'],
      stateGst: json['stateGst'],
      compGst: json['compGst'],
      ewayUserId: json['ewayUserId'],
      ewayPassword: json['ewayPassword'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'ewayEnabled': ewayEnabled,
      'stateGst': stateGst,
      'compGst': compGst,
      'ewayUserId': ewayUserId,
      'ewayPassword': ewayPassword,
    };
  }
}
