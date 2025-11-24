class ContentModel {
  int? commandstatus;
  String? commandmessage;
  String? itemCode;
  String? itemName;
  String? active;
  String? groupCode;

  ContentModel({
    required this.commandstatus,
    required this.commandmessage,
    required this.itemCode,
    required this.itemName,
    required this.active,
    required this.groupCode,
  });

  ContentModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage']?.toString() ?? '';
    itemCode = json['ItemCode']?.toString() ?? '';
    itemName = json['ItemName']?.toString() ?? '';
    active = json['Active']?.toString() ?? '';
    groupCode = json['GroupCode']?.toString() ?? '';
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
      'ItemCode': itemCode,
      'ItemName': itemName,
      'Active': active,
      'GroupCode': groupCode,
    };
  }
}
