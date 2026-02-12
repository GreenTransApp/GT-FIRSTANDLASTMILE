class DeliveryPerformanceModel {
  String? sNo;
  String? title;
  String? executiveId;
  String? executiveName;
  String? noOfConsignments;
  String? within4Hours;
  String? within4HoursPercent;
  String? within6Hours;
  String? within6HoursPercent;
  String? within24Hours;
  String? within24HoursPercent;
  String? post24Hours;
  String? post24HoursPercent;
  String? pendingPercent;

  DeliveryPerformanceModel({
    this.sNo,
    this.title,
    this.executiveId,
    this.executiveName,
    this.noOfConsignments,
    this.within4Hours,
    this.within4HoursPercent,
    this.within6Hours,
    this.within6HoursPercent,
    this.within24Hours,
    this.within24HoursPercent,
    this.post24Hours,
    this.post24HoursPercent,
    this.pendingPercent,
  });

  factory DeliveryPerformanceModel.fromJson(Map<String, dynamic> json) {
    return DeliveryPerformanceModel(
      sNo: json['S#']?.toString(),
      title: json['Title']?.toString(),
      executiveId: json['executiveid']?.toString(),
      executiveName: json['executivename']?.toString(),
      noOfConsignments: json['No Of Consignemts']?.toString(),
      within4Hours: json['WithIn 4 hours']?.toString(),
      within4HoursPercent: json['WithIn 4 hours %']?.toString(),
      within6Hours: json['WithIn 6 hours']?.toString(),
      within6HoursPercent: json['WithIn 6 hours %']?.toString(),
      within24Hours: json['WithIn 24 hours']?.toString(),
      within24HoursPercent: json['WithIn 24 hours %']?.toString(),
      post24Hours: json['Post 24 hours']?.toString(),
      post24HoursPercent: json['Post 24 hours %']?.toString(),
      pendingPercent: json['Pending %']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'S#': sNo,
      'Title': title,
      'executiveid': executiveId,
      'executivename': executiveName,
      'No Of Consignments': noOfConsignments,
      'WithIn 4 hours': within4Hours,
      'WithIn 4 hours %': within4HoursPercent,
      'WithIn 6 hours': within6Hours,
      'WithIn 6 hours %': within6HoursPercent,
      'WithIn 24 hours': within24Hours,
      'WithIn 24 hours %': within24HoursPercent,
      'Post 24 hours': post24Hours,
      'Post 24 hours %': post24HoursPercent,
      'Pending %': pendingPercent,
    };
  }
}
