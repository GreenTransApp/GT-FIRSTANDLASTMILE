class LoadTypeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? name;
  final String? code;

  LoadTypeModel({
    this.commandStatus,
    this.commandMessage,
    this.name,
    this.code,
  });

  factory LoadTypeModel.fromJson(Map<String, dynamic> json) {
    return LoadTypeModel(
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

  static List<LoadTypeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LoadTypeModel.fromJson(json)).toList();
  }
}
