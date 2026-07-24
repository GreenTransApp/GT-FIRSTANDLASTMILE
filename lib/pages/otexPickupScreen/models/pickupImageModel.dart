class PickupImageModel {
  final String? menuCode;
  final String? scanDocumentTitle;
  final String? imagePath;
  final int? jobId;
  final String? grNo;
  final int? batchId;
  final int? transactionId;

  const PickupImageModel({
    this.menuCode,
    this.scanDocumentTitle,
    this.imagePath,
    this.jobId,
    this.grNo,
    this.batchId,
    this.transactionId,
  });

  factory PickupImageModel.fromJson(Map<String, dynamic> json) {
    return PickupImageModel(
      menuCode: json['menucode'],
      scanDocumentTitle: json['scandocumenttitle'],
      imagePath: json['imagepath'],
      jobId: json['jobid'],
      grNo: json['grno'],
      batchId: json['batchid'],
      transactionId: json['transactionid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menucode': menuCode ?? '',
      'scandocumenttitle': scanDocumentTitle ?? '',
      'imagepath': imagePath ?? '',
      'jobid': jobId ?? 0,
      'grno': grNo ?? '',
      'batchid': batchId ?? 0,
      'transactionid': transactionId ?? 0,
    };
  }

  PickupImageModel copyWith({
    String? menuCode,
    String? scanDocumentTitle,
    String? imagePath,
    int? jobId,
    String? grNo,
    int? batchId,
    int? transactionId,
  }) {
    return PickupImageModel(
      menuCode: menuCode ?? this.menuCode,
      scanDocumentTitle:
          scanDocumentTitle ?? this.scanDocumentTitle,
      imagePath: imagePath ?? this.imagePath,
      jobId: jobId ?? this.jobId,
      grNo: grNo ?? this.grNo,
      batchId: batchId ?? this.batchId,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}