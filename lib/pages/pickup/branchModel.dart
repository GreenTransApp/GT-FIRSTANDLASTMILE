class BranchModel {
  final int? commandStatus;
  final String? stnCode;
  final String? country;
  final String? stnName;
  final String? stnGst;
  final String? address;
  final String? allowBidding;
  final String? stateName;
  final String? isDelivered;
  final String? zipCode;

  BranchModel({
    this.commandStatus,
    this.stnCode,
    this.country,
    this.stnName,
    this.stnGst,
    this.address,
    this.allowBidding,
    this.stateName,
    this.isDelivered,
    this.zipCode,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      commandStatus: json['commandstatus'],
      stnCode: json['stncode'],
      country: json['country'],
      stnName: json['stnname'],
      stnGst: json['stngst'],
      address: json['address'],
      allowBidding: json['allowbidding'],
      stateName: json['statename'],
      isDelivered: json['isdelivered'],
      zipCode: json['zipcode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'stncode': stnCode,
      'country': country,
      'stnname': stnName,
      'stngst': stnGst,
      'address': address,
      'allowbidding': allowBidding,
      'statename': stateName,
      'isdelivered': isDelivered,
      'zipcode': zipCode,
    };
  }
}
