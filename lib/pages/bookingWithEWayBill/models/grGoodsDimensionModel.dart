class GrGoodsDimensionModel {
  final String? compCode;
  final String? grNo;
  final int? rowNo;
  final String? goods;
  final String? packing;
  final double? pieces;
  final double? length;
  final double? breadth;
  final double? height;
  final String? createId;
  final DateTime? createdOn;
  final DateTime? loginDate;
  final String? sessionId;
  final double? volumetricWeight;
  final double? actualWeight;
  final String? unitType;

  GrGoodsDimensionModel({
    this.compCode,
    this.grNo,
    this.rowNo,
    this.goods,
    this.packing,
    this.pieces,
    this.length,
    this.breadth,
    this.height,
    this.createId,
    this.createdOn,
    this.loginDate,
    this.sessionId,
    this.volumetricWeight,
    this.actualWeight,
    this.unitType,
  });

  factory GrGoodsDimensionModel.fromJson(Map<String, dynamic> json) {
    return GrGoodsDimensionModel(
      compCode: json['compcode'],
      grNo: json['grno'],
      rowNo: json['rowno'],
      goods: json['goods'],
      packing: json['packing'],
      pieces: (json['pieces'] as num?)?.toDouble(),
      length: (json['length'] as num?)?.toDouble(),
      breadth: (json['breadth'] as num?)?.toDouble(),
      height: (json['height'] as num?)?.toDouble(),
      createId: json['createid'],
      createdOn: json['createdon'] != null
          ? DateTime.tryParse(json['createdon'])
          : null,
      loginDate: json['logindate'] != null
          ? DateTime.tryParse(json['logindate'])
          : null,
      sessionId: json['sessionid'],
      volumetricWeight: (json['vweight'] as num?)?.toDouble(),
      actualWeight: (json['aweight'] as num?)?.toDouble(),
      unitType: json['unittype'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'compcode': compCode,
      'grno': grNo,
      'rowno': rowNo,
      'goods': goods,
      'packing': packing,
      'pieces': pieces,
      'length': length,
      'breadth': breadth,
      'height': height,
      'createid': createId,
      'createdon': createdOn?.toIso8601String(),
      'logindate': loginDate?.toIso8601String(),
      'sessionid': sessionId,
      'vweight': volumetricWeight,
      'aweight': actualWeight,
      'unittype': unitType,
    };
  }
}
