class ManifestModel {
  final String manifestNo;
  final String rider;
  final String vehicleNo;
  final String vehicleType;
  final String manifestDateTime;
  final String dispatchDateTime;
  final int noOfConsignment;
  final double totalWeight;
  final String remarks;
  final String distance;
  final String delivered;
  final String unDelivered;
  final String pending;
  final int startReadingKm;
  final int endReadingKm;
  final int distanceTravelledKm;
  final String imgStartReading;
  final String imgEndReading;

  ManifestModel({
    required this.manifestNo,
    required this.rider,
    required this.vehicleNo,
    required this.vehicleType,
    required this.manifestDateTime,
    required this.dispatchDateTime,
    required this.noOfConsignment,
    required this.totalWeight,
    required this.remarks,
    required this.distance,
    required this.delivered,
    required this.unDelivered,
    required this.pending,
    required this.startReadingKm,
    required this.endReadingKm,
    required this.distanceTravelledKm,
    required this.imgStartReading,
    required this.imgEndReading,
  });

  factory ManifestModel.fromJson(Map<String, dynamic> json) {
    return ManifestModel(
      manifestNo: json['Manifest No'] ?? '',
      rider: json['Rider'] ?? '',
      vehicleNo: json['Vehicle No'] ?? '',
      vehicleType: json['Vehicle Type'] ?? '',
      manifestDateTime: json['Manifest Date Time'] ?? '',
      dispatchDateTime: json['Dispatch Date Time'] ?? '',
      noOfConsignment: json['No Of Consignment'] ?? 0,
      totalWeight: (json['Total Weight'] ?? 0).toDouble(),
      remarks: json['Remarks'] ?? '',
      distance: json['Distance'] ?? '',
      delivered: json['Delivered'] ?? '',
      unDelivered: json['UnDelivered'] ?? '',
      pending: json['Pending'] ?? '',
      startReadingKm: json['Start Reading km'] ?? 0,
      endReadingKm: json['End Reading km'] ?? 0,
      distanceTravelledKm: json['Distance Travelled km'] ?? 0,
      imgStartReading: json['img_Start Reading Image'] ?? '',
      imgEndReading: json['img_End Reading Image'] ?? '',
    );
  }
}
