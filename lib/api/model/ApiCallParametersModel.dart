class ApiCallParametersModel {
  String? companyId;
  String? spName;
  Map<String, dynamic> parameters;
  String userCode;
  String loginBranchCode;
  String? sessionId;

  ApiCallParametersModel({
    this.companyId,
    this.spName,
    Map<String, dynamic>? parameters,
    required this.userCode,
    required this.loginBranchCode,
    this.sessionId,
  }) : parameters = parameters ?? {};

  ApiCallParametersModel.fromJson(Map<String, dynamic> json)
      : companyId = json['companyId'],
        spName = json['spName'] ?? '',
        parameters = json['parameters'] ?? {},
        userCode = json['userCode'] ?? '',
        loginBranchCode = json['loginBranchCode'] ?? '',
        sessionId = json['sessionId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['companyId'] = companyId;
    data['spName'] = spName;
    data['parameters'] = parameters;
    data['userCode'] = userCode;
    data['loginBranchCode'] = loginBranchCode;
    data['sessionId'] = sessionId;
    return data;
  }
}
