class DeliveryPerformanceSummaryModel {
  String? title;
  String? bookingDate;
  String? branchName;
  String? consignmentNo;
  String? cneeName;
  String? deliveredTo;
  String? grNo;
  String? imagePath;
  String? manifestNo;
  String? markerAddress;
  String? planningId;
  String? status;
  String? receivedOn;
  String? signImagePath;
  String? tripId;
  String? undelReason;
  String? undelImg;

  DeliveryPerformanceSummaryModel({
    this.title,
    this.bookingDate,
    this.branchName,
    this.consignmentNo,
    this.cneeName,
    this.deliveredTo,
    this.grNo,
    this.imagePath,
    this.manifestNo,
    this.markerAddress,
    this.planningId,
    this.status,
    this.receivedOn,
    this.signImagePath,
    this.tripId,
    this.undelReason,
    this.undelImg,
  });

  factory DeliveryPerformanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPerformanceSummaryModel(
      title: json['title']?.toString(),
      bookingDate: json['bookingdt']?.toString(),
      branchName: json['branchname']?.toString(),
      consignmentNo: json['Consignment #']?.toString(),
      cneeName: json['cngename']?.toString(),
      deliveredTo: json['deliverdto']?.toString(),
      grNo: json['grno']?.toString(),
      imagePath: json['imagepath']?.toString(),
      manifestNo: json['manifestno']?.toString(),
      markerAddress: json['markerAddress']?.toString(),
      planningId: json['planningid']?.toString(),
      status: json['status']?.toString(),
      receivedOn: json['Received On']?.toString(),
      signImagePath: json['signimagepath']?.toString(),
      tripId: json['tripid']?.toString(),
      undelReason: json['undelreason']?.toString(),
      undelImg: json['undelimg']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'bookingdt': bookingDate,
      'branchname': branchName,
      'Consignment #': consignmentNo,
      'cngename': cneeName,
      'deliverdto': deliveredTo,
      'grno': grNo,
      'imagepath': imagePath,
      'manifestno': manifestNo,
      'markerAddress': markerAddress,
      'planningid': planningId,
      'status': status,
      'Received On': receivedOn,
      'signimagepath': signImagePath,
      'tripid': tripId,
      'undelreason': undelReason,
      'undelimg': undelImg,
    };
  }
}
