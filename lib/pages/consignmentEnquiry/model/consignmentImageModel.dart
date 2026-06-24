class ConsignmentImageModel {
  String? grNo;
  String? transactionId;
  String? filePath;

  ConsignmentImageModel({
    this.grNo,
    this.transactionId,
    this.filePath,
  });

  factory ConsignmentImageModel.fromJson(Map<String, dynamic> json) {
    return ConsignmentImageModel(
      grNo: json['grno']?.toString(),
      transactionId: json['transactionid']?.toString(),
      filePath: json['filepath']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grno': grNo,
      'transactionid': transactionId,
      'filepath': filePath,
    };
  }
}