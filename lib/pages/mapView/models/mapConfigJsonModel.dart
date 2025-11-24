class MapConfigJsonModel {
  String? travelmode;
  String? trafficmode;
  String? alternativeroutes;
  String? avoidtolls;
  String? avoidhighways;
  String? avoidferries;

  MapConfigJsonModel(
      {this.travelmode,
      this.trafficmode,
      this.alternativeroutes,
      this.avoidtolls,
      this.avoidhighways,
      this.avoidferries});

  MapConfigJsonModel.fromJson(Map<String, dynamic> json) {
    travelmode = json['travelmode'];
    trafficmode = json['trafficmode'];
    alternativeroutes = json['alternativeroutes'];
    avoidtolls = json['avoidtolls'];
    avoidhighways = json['avoidhighways'];
    avoidferries = json['avoidferries'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['travelmode'] = this.travelmode;
    data['trafficmode'] = this.trafficmode;
    data['alternativeroutes'] = this.alternativeroutes;
    data['avoidtolls'] = this.avoidtolls;
    data['avoidhighways'] = this.avoidhighways;
    data['avoidferries'] = this.avoidferries;
    return data;
  }
}
