class SavePickupRespModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? grno;
  final String? smsstring;

  SavePickupRespModel({
    this.commandStatus,
    this.commandMessage,
    this.grno,
    this.smsstring,
  });

  factory SavePickupRespModel.fromJson(Map<String, dynamic> json) {
    return SavePickupRespModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      grno: json['grno'],
      smsstring: json['smsstring'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'grno': grno,
      'smsstring': smsstring,
    };
  }
}
