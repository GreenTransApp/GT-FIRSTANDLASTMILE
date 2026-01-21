// class EwayBillData {
//   final int ewbId;
//   final String ewbNo;
//   final String supplyType;
//   final String docNo;
//   final String docDate;
//   final String fromTrdName;
//   final String toTrdName;
//   final double totalValue;
//   final double igstValue;
//   final String vehicleNo;
//   final List<EwayBillItem> itemList;
//   final List<VehicleDetail> vehicleDetails;
//   final String status;
//   final String validUpto;

//   EwayBillData({
//     required this.ewbId,
//     required this.ewbNo,
//     required this.supplyType,
//     required this.docNo,
//     required this.docDate,
//     required this.fromTrdName,
//     required this.toTrdName,
//     required this.totalValue,
//     required this.igstValue,
//     required this.vehicleNo,
//     required this.itemList,
//     required this.vehicleDetails,
//     required this.status,
//     required this.validUpto,
//   });

//   factory EwayBillData.fromJson(Map<String, dynamic> json) {
//     return EwayBillData(
//       ewbId: json['ewbId'] ?? 0,
//       ewbNo: json['ewbNo'] ?? '',
//       supplyType: json['supplyType'] ?? '',
//       docNo: json['docNo'] ?? '',
//       docDate: json['docDate'] ?? '',
//       fromTrdName: json['fromTrdName'] ?? '',
//       toTrdName: json['toTrdName'] ?? '',
//       totalValue: (json['totalValue'] ?? 0).toDouble(),
//       igstValue: (json['igstValue'] ?? 0).toDouble(),
//       vehicleNo: json['vehicleNo'] ?? '',
//       status: json['status'] ?? '',
//       validUpto: json['validUpto'] ?? '',
//       itemList: (json['itemList'] as List? ?? [])
//           .map((e) => EwayBillItem.fromJson(e))
//           .toList(),
//       vehicleDetails: (json['vehicleDetails'] as List? ?? [])
//           .map((e) => VehicleDetail.fromJson(e))
//           .toList(),
//     );
//   }
// }
