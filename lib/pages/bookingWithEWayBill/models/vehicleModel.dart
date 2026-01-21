class VehicleModel {
  final int commandStatus;
  final String? commandMessage;
  final String vehicleCode;
  final String modeType;
  final String regNo;
  final String typeName;
  final double capacity;

  VehicleModel({
    required this.commandStatus,
    this.commandMessage,
    required this.vehicleCode,
    required this.modeType,
    required this.regNo,
    required this.typeName,
    required this.capacity,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      commandStatus: json['commandstatus'] ?? 0,
      commandMessage: json['commandmessage'],
      vehicleCode: json['vehiclecode'] ?? '',
      modeType: json['modetype'] ?? '',
      regNo: json['regno'] ?? '',
      typeName: json['typename'] ?? '',
      capacity: (json['capacity'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'commandstatus': commandStatus,
      'commandmessage': commandMessage,
      'vehiclecode': vehicleCode,
      'modetype': modeType,
      'regno': regNo,
      'typename': typeName,
      'capacity': capacity,
    };
  }
}
