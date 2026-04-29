class AllFormLoadModel {
  int? CommandStatus;
  String? CommandMessage;
  String? Table_Name;
  String? Column_Name;
  String? LabelName;
  String? FieldInfo;
  String? PlaceHolder;

  bool? DisableColumn;
  bool? IsRequired;
  bool? IsDefaultDisable;
  bool? DisableInEditMode;

  AllFormLoadModel({
    this.CommandStatus,
    this.CommandMessage,
    this.Table_Name,
    this.Column_Name,
    this.LabelName,
    this.FieldInfo,
    this.PlaceHolder,
    this.DisableColumn,
    this.IsRequired,
    this.IsDefaultDisable,
    this.DisableInEditMode,
  });

  AllFormLoadModel.fromJson(Map<String, dynamic> json) {
    CommandStatus = json['CommandStatus'];
    CommandMessage = json['CommandMessage'];
    Table_Name = json['Table_Name'];
    Column_Name = json['Column_Name'];
    LabelName = json['LabelName'];
    FieldInfo = json['FieldInfo'];
    PlaceHolder = json['PlaceHolder'];

    DisableColumn = _toBool(json['DisableColumn']);
    IsRequired = _toBool(json['IsRequired']);
    IsDefaultDisable = _toBool(json['IsDefaultDisable']);
    DisableInEditMode = _toBool(json['DisableInEditMode']);
  }

  Map<String, dynamic> toJson() {
    return {
      'CommandStatus': CommandStatus,
      'CommandMessage': CommandMessage,
      'Table_Name': Table_Name,
      'Column_Name': Column_Name,
      'LabelName': LabelName,
      'FieldInfo': FieldInfo,
      'PlaceHolder': PlaceHolder,
      'DisableColumn': DisableColumn == true ? 1 : 0,
      'IsRequired': IsRequired == true ? 1 : 0,
      'IsDefaultDisable': IsDefaultDisable == true ? 1 : 0,
      'DisableInEditMode': DisableInEditMode == true ? 1 : 0,
    };
  }

  bool? _toBool(dynamic value) {
    if (value == null) return null;
    if (value is int) return value == 1;
    if (value is String) return value == "1";
    return value as bool?;
  }
}
