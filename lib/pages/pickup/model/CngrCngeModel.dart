class CngrCngeModel {
  final int? commandStatus;
  final String? commandMessage;
  final String? code;
  final String? name;
  final String? gstNo;
  final String? address;
  final String? city;
  final String? zipCode;
  final String? state;
  final String? telNo;
  final String? email;
  final String? country;

  CngrCngeModel({
    this.commandStatus,
    this.commandMessage,
    this.code,
    this.name,
    this.gstNo,
    this.address,
    this.city,
    this.zipCode,
    this.state,
    this.telNo,
    this.email,
    this.country,
  });

  factory CngrCngeModel.fromJson(Map<String, dynamic> json) {
    return CngrCngeModel(
      commandStatus: json['commandstatus'],
      commandMessage: json['commandmessage'],
      code: json['code'],
      name: json['name'],
      gstNo: json['gstno'],
      address: json['address'],
      city: json['city'],
      zipCode: json['zipcode'],
      state: json['state'],
      telNo: json['telno'],
      email: json['email'],
      country: json['country'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'code': code,
      'name': name,
      'gstno': gstNo,
      'address': address,
      'city': city,
      'zipcode': zipCode,
      'state': state,
      'telno': telNo,
      'email': email,
      'country': country,
    };
  }
}
