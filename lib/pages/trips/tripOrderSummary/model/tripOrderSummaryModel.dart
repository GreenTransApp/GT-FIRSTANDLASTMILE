import 'package:gtlmd/pages/trips/tripOrderSummary/model/consignmentModel.dart';
import 'package:gtlmd/pages/trips/tripOrderSummary/model/manifestModel.dart';

class TripOrderSummaryModel {
  List<ConsignmentModel> consignments;
  List<ManifestModel> manifests;

  TripOrderSummaryModel({
    this.consignments = const [],
    this.manifests = const [],
  });

  factory TripOrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return TripOrderSummaryModel(
      consignments: json['Table'] != null
          ? (json['Table'] as List)
              .map((e) => ConsignmentModel.fromJson(e))
              .toList()
          : [],
      manifests: json['Table1'] != null
          ? (json['Table1'] as List)
              .map((e) => ManifestModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
