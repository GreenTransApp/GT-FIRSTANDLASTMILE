class PackingTypeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? name;
  final String? code;

  PackingTypeModel({
    this.commandStatus,
    this.commandMessage,
    this.name,
    this.code,
  });

  factory PackingTypeModel.fromJson(Map<String, dynamic> json) {
    return PackingTypeModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      name: json['name'],
      code: json['code'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'name': name,
      'code': code,
    };
  }

  @override
  String toString() => name ?? '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PackingTypeModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
