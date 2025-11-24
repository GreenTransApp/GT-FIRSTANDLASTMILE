class CommonResponse {
  int? commandStatus;
  String? commandMessage;
  String? dataSet;
  bool? succeed;
  String? message;
  String? firstParameter;
  String? secondParameter;
  String? thirdParameter;
  String? fourthParameter;

  CommonResponse(
      {this.commandStatus,
      this.commandMessage,
      this.dataSet,
      this.succeed,
      this.message,
      this.firstParameter,
      this.secondParameter,
      this.thirdParameter,
      this.fourthParameter});

  CommonResponse.fromJson(Map<String, dynamic> json) {
    commandStatus = json['CommandStatus'];
    commandMessage = json['CommandMessage'];
    dataSet = json['DataSet'];
    succeed = json['Succeed'];
    message = json['Message'];
    firstParameter = json['FirstParameter'];
    secondParameter = json['SecondParameter'];
    thirdParameter = json['ThirdParameter'];
    fourthParameter = json['FourthParameter'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CommandStatus'] = this.commandStatus;
    data['CommandMessage'] = this.commandMessage;
    data['DataSet'] = this.dataSet;
    data['Succeed'] = this.succeed;
    data['Message'] = this.message;
    data['FirstParameter'] = this.firstParameter;
    data['SecondParameter'] = this.secondParameter;
    data['ThirdParameter'] = this.thirdParameter;
    data['FourthParameter'] = this.fourthParameter;
    return data;
  }
}
