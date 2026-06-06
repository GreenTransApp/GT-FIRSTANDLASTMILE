class GoodsTypeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? name;
  final String? code;

  GoodsTypeModel({
    this.commandStatus,
    this.commandMessage,
    this.name,
    this.code,
  });

  factory GoodsTypeModel.fromJson(Map<String, dynamic> json) {
    return GoodsTypeModel(
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
      other is GoodsTypeModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
