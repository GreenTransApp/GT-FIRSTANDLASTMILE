import 'package:gtlmd/common/jsonConverters.dart';

class OperationsModel extends JsonConverters<OperationsModel> {
  final int? commandstatus;
  final String? commandmessage;
  final String? menuname;
  final String? menucode;
  final String? pageLink;

  OperationsModel({
    this.commandstatus,
     this.commandmessage,
    this.menuname,
    this.menucode,
    this.pageLink, 
  });

  OperationsModel copyWith({
    int? commandstatus,
    String? commandmessage,
    String? menuname,
    String? menucode,
    String? pageLink,
  }) {
    return OperationsModel(
      commandstatus: commandstatus ?? this.commandstatus,
      commandmessage: commandmessage ?? this.commandmessage,
      menuname: menuname ?? this.menuname,
      menucode: menucode ?? this.menucode,
      pageLink: pageLink ?? this.pageLink,
    );
  }

  @override
  factory OperationsModel.fromJson(Map<String, dynamic> json) {
    return OperationsModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      menuname: json['menuname'],
      menucode: json['menucode'],
      pageLink: json['pagelink'],
    );
  }

  @override
  OperationsModel fromJson(Map<String, dynamic> json) {
    return OperationsModel(
      commandstatus: json['commandstatus'],
      commandmessage: json['commandmessage'],
      menuname: json['menuname'],
      menucode: json['menucode'],
      pageLink: json['pagelink'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'menuname': menuname,
      'menucode': menucode,
      'pagelink': pageLink,
    };
  }

  static List<OperationsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => OperationsModel.fromJson(json)).toList();
  }
}
