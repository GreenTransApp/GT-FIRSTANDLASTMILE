class PinCodeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? code;
  final String? text;
  final String? flagTwo;
  final String? flagThree;
  final String? flagFour;
  final String? stnCode;
  final String? stnName;
  final String? name;
  final double? value;
  final int? intValue;
  final String? amount;
  final String? flagFive;
  final String? flagSix;
  final String? flagSeven;
  final String? flagEight;
  final String? flagOne;

  PinCodeModel({
    this.commandStatus,
    this.commandMessage,
    this.code,
    this.text,
    this.flagTwo,
    this.flagThree,
    this.flagFour,
    this.stnCode,
    this.stnName,
    this.name,
    this.value,
    this.intValue,
    this.amount,
    this.flagFive,
    this.flagSix,
    this.flagSeven,
    this.flagEight,
    this.flagOne,
  });

  factory PinCodeModel.fromJson(Map<String, dynamic> json) {
    return PinCodeModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      code: json['code'],
      text: json['text'],
      flagTwo: json['flagtwo'],
      flagThree: json['flagthree'],
      flagFour: json['flagfour'],
      stnCode: json['stncode'],
      stnName: json['stnname'],
      name: json['name'],
      value: (json['value'] as num?)?.toDouble(),
      intValue: json['intvalue'],
      amount: json['amount'],
      flagFive: json['flagfive'],
      flagSix: json['flagsix'],
      flagSeven: json['flagseven'],
      flagEight: json['flageight'],
      flagOne: json['flagone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'code': code,
      'text': text,
      'flagtwo': flagTwo,
      'flagthree': flagThree,
      'flagfour': flagFour,
      'stncode': stnCode,
      'stnname': stnName,
      'name': name,
      'value': value,
      'intvalue': intValue,
      'amount': amount,
      'flagfive': flagFive,
      'flagsix': flagSix,
      'flagseven': flagSeven,
      'flageight': flagEight,
      'flagone': flagOne,
    };
  }
}
