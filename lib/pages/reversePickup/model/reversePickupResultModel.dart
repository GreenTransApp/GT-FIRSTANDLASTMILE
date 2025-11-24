class ReversePickupResultModel {
  int? commandstatus;
  String? commandmessage;
  String? generatedgrno;
  int? transactionid;

  ReversePickupResultModel(
      {this.commandstatus,
      this.commandmessage,
      this.generatedgrno,
      this.transactionid});

  ReversePickupResultModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    generatedgrno = json['generatedgrno'];
    transactionid = json['transactionid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['commandmessage'] = this.commandmessage;
    data['generatedgrno'] = this.generatedgrno;
    data['transactionid'] = this.transactionid;
    return data;
  }
}
