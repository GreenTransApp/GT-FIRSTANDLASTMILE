import 'package:gtlmd/common/jsonConverters.dart';

class ServiceTypeModel extends JsonConverters<ServiceTypeModel> {
  final int? commandStatus;
  final String? commandMessage;
  final bool? isCft;
  final String? deliveryType;
  final String? prodCode;
  final String? prodName;
  final String? active;
  final String? displayName;
  final int? volFactor;
  final String? modeType;

  ServiceTypeModel({
    this.commandStatus,
    this.commandMessage,
    this.isCft,
    this.deliveryType,
    this.prodCode,
    this.prodName,
    this.active,
    this.displayName,
    this.volFactor,
    this.modeType,
  });

  @override
  factory ServiceTypeModel.fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      isCft: json['iscft'] == 'Y' ? true : false,
      deliveryType: json['deliverytype'],
      prodCode: json['ProdCode'],
      prodName: json['ProdName'],
      active: json['Active'],
      displayName: json['DisplayName'],
      volFactor: json['volfactor'],
      modeType: json['modetype'],
    );
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return ServiceTypeModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      isCft: json['iscft'] == 'Y' ? true : false,
      deliveryType: json['deliverytype'],
      prodCode: json['ProdCode'],
      prodName: json['ProdName'],
      active: json['Active'],
      displayName: json['DisplayName'],
      volFactor: json['volfactor'],
      modeType: json['modetype'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'iscft': isCft,
      'deliverytype': deliveryType,
      'ProdCode': prodCode,
      'ProdName': prodName,
      'Active': active,
      'DisplayName': displayName,
      'volfactor': volFactor,
      'modetype': modeType,
    };
  }

  static List<ServiceTypeModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ServiceTypeModel.fromJson(json)).toList();
  }
}
