class FireBase {
  String timeStamp;
  String latitude;
  String longitude;

  FireBase({
    required this.timeStamp,
    required this.latitude,
    required this.longitude,
  });

  // Convert JSON to model
  factory FireBase.fromJson(Map<String, dynamic> json) {
    return FireBase(
      timeStamp: json['timeStamp'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'timeStamp': timeStamp,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
