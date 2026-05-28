class DocumentApprovalModel {
  int? commandstatus;
  String? commandmessage;
  int? approvalId;
  String? logDt;
  String? approvalTitle;
  String? approvalText;
  String? approvalCode;
  String? approvalType;
  String? actionspname;
  String? actionjsondatastr;
  String? seenOnDt;
  String? approvalRemarks;
  bool? approvedActionTaken;
  String? approvedStatus;
  String? speechText;
  String? approvalFor;
  String? createdByUserCode;
  String? createdByUserName;
  String? createdOn;
  bool? isExcel;
  bool? isUrl;
  String? excelJson;
  String? urlToOpen;
  String? menuCode;

  DocumentApprovalModel({
    this.commandstatus,
    this.commandmessage,
    this.approvalId,
    this.logDt,
    this.approvalTitle,
    this.approvalText,
    this.approvalCode,
    this.approvalType,
    this.actionspname,
    this.actionjsondatastr,
    this.seenOnDt,
    this.approvalRemarks,
    this.approvedActionTaken,
    this.approvedStatus,
    this.speechText,
    this.approvalFor,
    this.createdByUserCode,
    this.createdByUserName,
    this.createdOn,
    this.isExcel,
    this.isUrl,
    this.excelJson,
    this.urlToOpen,
    this.menuCode,
  });

  DocumentApprovalModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage']?.toString();
    approvalId = json['approvalId'];

    logDt = json['logDt']?.toString();
    approvalTitle = json['approvalTitle']?.toString();
    approvalText = json['approvalText']?.toString();
    approvalCode = json['approvalCode']?.toString();

    approvalType = json['approvalType']?.toString();
    actionspname = json['actionspname']?.toString();
    actionjsondatastr = json['actionjsondatastr']?.toString();

    seenOnDt = json['seenOnDt']?.toString();
    approvalRemarks = json['approvalRemarks']?.toString();

    approvedActionTaken = json['approvedActionTaken'];
    approvedStatus = json['approvedStatus']?.toString();

    speechText = json['speechText']?.toString();
    approvalFor = json['approvalFor']?.toString();

    createdByUserCode = json['createdByUserCode']?.toString();
    createdByUserName = json['createdByUserName']?.toString();

    createdOn = json['createdOn']?.toString();

    isExcel = json['isExcel'];
    isUrl = json['isUrl'];

    excelJson = json['excelJson']?.toString();
    urlToOpen = json['urlToOpen']?.toString();

    menuCode = json['menuCode']?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['approvalId'] = approvalId;

    data['logDt'] = logDt;
    data['approvalTitle'] = approvalTitle;
    data['approvalText'] = approvalText;
    data['approvalCode'] = approvalCode;

    data['approvalType'] = approvalType;
    data['actionspname'] = actionspname;
    data['actionjsondatastr'] = actionjsondatastr;

    data['seenOnDt'] = seenOnDt;
    data['approvalRemarks'] = approvalRemarks;

    data['approvedActionTaken'] = approvedActionTaken;
    data['approvedStatus'] = approvedStatus;

    data['speechText'] = speechText;
    data['approvalFor'] = approvalFor;

    data['createdByUserCode'] = createdByUserCode;
    data['createdByUserName'] = createdByUserName;

    data['createdOn'] = createdOn;

    data['isExcel'] = isExcel;
    data['isUrl'] = isUrl;

    data['excelJson'] = excelJson;
    data['urlToOpen'] = urlToOpen;

    data['menuCode'] = menuCode;

    return data;
  }
}
