class MidMileTripListModel {
  final int? tripid;
  final int? tripdetailid;
  final String? startdt;
  final String? starttime;
  final double? vehiclestartkm;
  final String? vehiclestartlocation;
  final double? pickuplatposition;
  final double? pickuplongposition;
  final String? startreadingimageid;
  final String? tripstart;
  final int? placementid;
  final String? origin;
  final String? destination;
  final String? vehiclecode;
  final String? vehicleno;
  final String? drivername;
  final String? mobileno;
  final double? rating;
  final String? startdatetime;

  MidMileTripListModel({
    this.tripid,
    this.tripdetailid,
    this.startdt,
    this.starttime,
    this.vehiclestartkm,
    this.vehiclestartlocation,
    this.pickuplatposition,
    this.pickuplongposition,
    this.startreadingimageid,
    this.tripstart,
    this.placementid,
    this.origin,
    this.destination,
    this.vehiclecode,
    this.vehicleno,
    this.drivername,
    this.mobileno,
    this.rating,
    this.startdatetime,
  });

  factory MidMileTripListModel.fromJson(Map<String, dynamic> json) {
    return MidMileTripListModel(
      tripid: json['tripid'] as int?,
      tripdetailid: json['tripdetailid'] as int?,
      startdt: json['startdt'] as String?,
      starttime: json['starttime'] as String?,
      vehiclestartkm: (json['vehiclestartkm'] as num?)?.toDouble(),
      vehiclestartlocation: json['vehiclestartlocation'] as String?,
      pickuplatposition: (json['pickuplatposition'] as num?)?.toDouble(),
      pickuplongposition: (json['pickuplongposition'] as num?)?.toDouble(),
      startreadingimageid: json['startreadingimageid'] as String?,
      tripstart: json['tripstart'],
      placementid: json['placementid'] as int?,
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      vehiclecode: json['vehiclecode'] as String?,
      vehicleno: json['vehicleno'] as String?,
      drivername: json['drivername'] as String?,
      mobileno: json['mobileno'] as String?,
      rating: json['rating'] as double?,
        startdatetime: json['startdatetime'] as String?
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripid': tripid,
      'tripdetailid': tripdetailid,
      'startdt': startdt,
      'starttime': starttime,
      'vehiclestartkm': vehiclestartkm,
      'vehiclestartlocation': vehiclestartlocation,
      'pickuplatposition': pickuplatposition,
      'pickuplongposition': pickuplongposition,
      'startreadingimageid': startreadingimageid,
      'tripstart': tripstart,
      'placementid': placementid,
      'origin': origin,
      'destination': destination,
      'vehiclecode': vehiclecode,
      'vehicleno': vehicleno,
      'drivername': drivername,
      'mobileno': mobileno,
      'rating': rating,
      'startdatetime': startdatetime,
    };
  }

  MidMileTripListModel copyWith({
    int? tripid,
    int? tripdetailid,
    String? startdt,
    String? starttime,
    double? vehiclestartkm,
    String? vehiclestartlocation,
    double? pickuplatposition,
    double? pickuplongposition,
    String? startreadingimageid,
    String? tripstart,
    int? placementid,
    String? origin,
    String? destination,
    String? vehiclecode,
    String? vehicleno,
    String? drivername,
    String? mobileno,
    double? rating,
    String? startdatetime,
  }) {
    return MidMileTripListModel(
      tripid: tripid ?? this.tripid,
      tripdetailid: tripdetailid ?? this.tripdetailid,
      startdt: startdt ?? this.startdt,
      starttime: starttime ?? this.starttime,
      vehiclestartkm: vehiclestartkm ?? this.vehiclestartkm,
      vehiclestartlocation: vehiclestartlocation ?? this.vehiclestartlocation,
      pickuplatposition: pickuplatposition ?? this.pickuplatposition,
      pickuplongposition: pickuplongposition ?? this.pickuplongposition,
      startreadingimageid: startreadingimageid ?? this.startreadingimageid,
      tripstart: tripstart ?? this.tripstart,
      placementid: placementid ?? this.placementid,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      vehiclecode: vehiclecode ?? this.vehiclecode,
      vehicleno: vehicleno ?? this.vehicleno,
      drivername: drivername ?? this.drivername,
      mobileno: mobileno ?? this.mobileno,
      rating: rating ?? this.rating,
      startdatetime: startdatetime ?? this.startdatetime,
    );
  }
}
