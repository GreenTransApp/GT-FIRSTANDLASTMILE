class BookingTypeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? name;
  final String? code;

  BookingTypeModel({
    this.commandStatus,
    this.commandMessage,
    this.name,
    this.code,
  });

  factory BookingTypeModel.fromJson(Map<String, dynamic> json) {
    return BookingTypeModel(
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
      other is BookingTypeModel &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}
