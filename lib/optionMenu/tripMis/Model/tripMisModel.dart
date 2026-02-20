class TripMisModel {
  String? sNo;
  String? title;
  String? branchName;
  String? rider;
  String? riderCode;
  String? tripNo;
  String? startDate;
  String? startReading;
  double? noOfConsignments;
  String? delivered;
  String? undelivered;
  double? pending;
  String? closeDate;
  String? closeReading;
  String? mapDistance;
  String? kmRun;
  String? removeColumns;
  String? vehicleNo;
  String? driverName;
  String? driverMobileNo;
  String? tripId;
  String? startReadingKm;
  String? startDateRaw;
  double? totGr;
  double? tripKm;
  double? lat;
  double? lng;
  String? executiveName;
  String? timestamp;
  String? planningid;
  String? manifestno;

  TripMisModel(
      {this.sNo,
      this.title,
      this.branchName,
      this.rider,
      this.riderCode,
      this.tripNo,
      this.startDate,
      this.startReading,
      this.noOfConsignments,
      this.delivered,
      this.undelivered,
      this.pending,
      this.closeDate,
      this.closeReading,
      this.mapDistance,
      this.kmRun,
      this.removeColumns,
      this.vehicleNo,
      this.driverName,
      this.driverMobileNo,
      this.tripId,
      this.startReadingKm,
      this.startDateRaw,
      this.totGr,
      this.tripKm,
      this.lat,
      this.lng,
      this.executiveName,
      this.timestamp,
      this.planningid,
      this.manifestno});

  factory TripMisModel.fromJson(Map<String, dynamic> json) {
    return TripMisModel(
      sNo: json['S#']?.toString(),
      title: json['Title'],
      branchName: json['Branch Name'],
      rider: json['Rider'],
      riderCode: json['ridercode']?.toString(),
      tripNo: json['Trip #']?.toString(),
      startDate: json['Start Date'],
      startReading: json['Start Reading']?.toString(),
      noOfConsignments:
          double.tryParse(json['No Of Consignments']?.toString() ?? ''),
      delivered: json['Delivered']?.toString(),
      undelivered: json['Undelivered']?.toString(),
      pending: double.tryParse(json['Pending']?.toString() ?? ''),
      closeDate: json['Close Date'],
      closeReading: json['Close Reading']?.toString(),
      mapDistance: json['Map Distance']?.toString(),
      kmRun: json['Km Run']?.toString(),
      removeColumns: json['removeColumns'],
      vehicleNo: json['vehicleno'],
      driverName: json['drivername'],
      driverMobileNo: json['drivermobileno'],
      tripId: json['tripid']?.toString(),
      startReadingKm: json['startreadingkm']?.toString(),
      startDateRaw: json['startdate'],
      totGr: double.tryParse(json['totgr']?.toString() ?? ''),
      tripKm: double.tryParse(json['tripkm']?.toString() ?? ''),
      lat: double.tryParse(json['lat']?.toString() ?? ''),
      lng: double.tryParse(json['lng']?.toString() ?? ''),
      executiveName: json['executivename'],
      timestamp: json['timestamp'],
      planningid: json['planningid']?.toString(),
      manifestno: json['manifestno']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'S#': sNo,
      'Title': title,
      'Branch Name': branchName,
      'Rider': rider,
      'ridercode': riderCode,
      'Trip #': tripNo,
      'Start Date': startDate,
      'Start Reading': startReading,
      'No Of Consignments': noOfConsignments,
      'Delivered': delivered,
      'Undelivered': undelivered,
      'Pending': pending,
      'Close Date': closeDate,
      'Close Reading': closeReading,
      'Map Distance': mapDistance,
      'Km Run': kmRun,
      'removeColumns': removeColumns,
      'vehicleno': vehicleNo,
      'drivername': driverName,
      'drivermobileno': driverMobileNo,
      'tripid': tripId,
      'startreadingkm': startReadingKm,
      'startdate': startDateRaw,
      'totgr': totGr,
      'tripkm': tripKm,
      'lat': lat,
      'lng': lng,
      'executivename': executiveName,
      'timestamp': timestamp,
      'planningid': planningid,
      'manifestno': manifestno,
    };
  }
}
