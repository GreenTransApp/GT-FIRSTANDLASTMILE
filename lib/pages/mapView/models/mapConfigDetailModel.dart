import 'dart:convert';

import 'package:gtlmd/pages/mapView/models/mapConfigJsonModel.dart';

class MapConfigDetailModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? planningDraftCode;
  final int? planningId;
  final MapConfigJsonModel? mapConfigData;

  MapConfigDetailModel({
    this.commandStatus,
    this.commandMessage,
    this.planningDraftCode,
    this.planningId,
    this.mapConfigData,
  });

  factory MapConfigDetailModel.fromJson(Map<String, dynamic> json) {
    return MapConfigDetailModel(
      commandStatus: json['commandstatus'] as int?,
      commandMessage: json['commandmessage'] as String?,
      planningDraftCode: json['planningdraftcode'] as String?,
      planningId: json['planningid'] as int?,
      mapConfigData:
          json.containsKey('mapconfigdata') && json['mapconfigdata'] != null
              ? MapConfigJsonModel.fromJson(jsonDecode(json['mapconfigdata']))
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'planningdraftcode': planningDraftCode,
      'planningid': planningId,
      'mapconfigdata': mapConfigData != null ? jsonEncode(mapConfigData) : null,
    };
  }
}
