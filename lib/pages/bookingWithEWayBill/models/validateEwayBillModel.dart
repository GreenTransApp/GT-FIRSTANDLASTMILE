class ValidateEwayBillModel {
  int? commandstatus;
  String? commandmessage;
  String? companyId;
  String? userCode;
  String? loginBranchCode;
  String? bookingBranchCode;
  String? menuCode;
  String? sessionId;

  ValidateEwayBillModel({
    this.commandstatus,
    this.commandmessage,
    required this.companyId,
    this.userCode,
    this.loginBranchCode,
    this.bookingBranchCode,
    this.menuCode,
    this.sessionId,
  });

  /// FROM JSON
  factory ValidateEwayBillModel.fromJson(Map<String, dynamic> json) {
    return ValidateEwayBillModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      companyId: json['companyId'],
      userCode: json['userCode'],
      loginBranchCode: json['loginBranchCode'],
      bookingBranchCode: json['bookingBranchCode'],
      menuCode: json['menuCode'],
      sessionId: json['sessionId'],
    );
  }

  /// TO JSON
  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'companyId': companyId,
      'userCode': userCode,
      'loginBranchCode': loginBranchCode,
      'bookingBranchCode': bookingBranchCode,
      'menuCode': menuCode,
      'sessionId': sessionId,
    };
  }
}
