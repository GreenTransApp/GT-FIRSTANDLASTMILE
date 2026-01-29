import 'package:gtlmd/common/jsonConverters.dart';

class OperationsModel extends JsonConverters<OperationsModel> {
  final String? menuname;
  final String? menucode;
  final String? pageLink;

  OperationsModel({
    this.menuname,
    this.menucode,
    this.pageLink,
  });

  OperationsModel copyWith({
    String? menuname,
    String? menucode,
    String? pageLink,
  }) {
    return OperationsModel(
      menuname: menuname ?? this.menuname,
      menucode: menucode ?? this.menucode,
      pageLink: pageLink ?? this.pageLink,
    );
  }

  @override
  factory OperationsModel.fromJson(Map<String, dynamic> json) {
    return OperationsModel(
      menuname: json['menuname'],
      menucode: json['menucode'],
      pageLink: json['pagelink'],
    );
  }

  @override
  OperationsModel fromJson(Map<String, dynamic> json) {
    return OperationsModel(
      menuname: json['menuname'],
      menucode: json['menucode'],
      pageLink: json['pagelink'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'menuname': menuname,
      'menucode': menucode,
      'pagelink': pageLink,
    };
  }

  static List<OperationsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OperationsModel.fromJson(json)).toList();
  }
}
