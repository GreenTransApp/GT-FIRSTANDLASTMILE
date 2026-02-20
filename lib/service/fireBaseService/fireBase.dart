class FireBase {
  String timeStamp;
  String latitude;
  String longitude;
  String headingNorth;

  FireBase({
    required this.timeStamp,
    required this.latitude,
    required this.longitude,
    required this.headingNorth,
  });

  // Convert JSON to model
  factory FireBase.fromJson(Map<String, dynamic> json) {
    return FireBase(
      timeStamp: json['timeStamp'] ?? '',
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',
      headingNorth: json['headingNorth'] ?? '',
    );
  }

  // Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'timeStamp': timeStamp,
      'latitude': latitude,
      'longitude': longitude,
      'headingNorth': headingNorth,
    };
  }
}
