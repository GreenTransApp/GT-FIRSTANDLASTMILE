class LmdMenuModel {
  int? commandStatus;
  String? commandMessage;
  int? outputId;
  String? moduleName;
  String? menuName;
  String? menuCode;
  String? fileName;
  String? displayName;
  String? tag;

  LmdMenuModel({
    this.commandStatus,
    this.commandMessage,
    this.outputId,
    this.moduleName,
    this.menuName,
    this.menuCode,
    this.fileName,
    this.displayName,
    this.tag,
  });

  factory LmdMenuModel.fromJson(Map<String, dynamic> json) {
    return LmdMenuModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      outputId: json['outputid'],
      moduleName: json['modulename'],
      menuName: json['menuname'],
      menuCode: json['menucode'],
      fileName: json['filename'],
      displayName: json['displayname'],
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'outputid': outputId,
      'modulename': moduleName,
      'menuname': menuName,
      'menucode': menuCode,
      'filename': fileName,
      'displayname': displayName,
      'tag': tag,
    };
  }
}
