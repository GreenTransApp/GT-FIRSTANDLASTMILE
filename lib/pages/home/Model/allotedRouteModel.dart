class AllotedRouteModel {
  int? commandstatus;
  String? commandmessage;
  int? planningid;
  String? planningdt;
  int? noofconsign;
  String? routename;
  String? displayconsignmenttype;
  String? totdistance;
  String? totweight;
  String? acceptedStatus; // ✅ New field

  AllotedRouteModel(
      {this.commandstatus,
      this.commandmessage,
      this.planningid,
      this.planningdt,
      this.noofconsign,
      this.routename,
      this.displayconsignmenttype,
      this.totdistance,
      this.totweight,
      this.acceptedStatus // ✅ Added to constructor

      });

  AllotedRouteModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    commandmessage = json['commandmessage'];
    planningid = json['planningid'];
    planningdt = json['planningdt'];
    noofconsign = json['noofconsign'];
    routename = json['routename'];
    displayconsignmenttype = json['displayconsignmenttype'];
    totdistance = json['totdistance']?.toString();
    totweight = json['totweight']?.toString();
    acceptedStatus = json['acceptedStatus']?.toString(); // ✅ Added here
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['commandstatus'] = commandstatus;
    data['commandmessage'] = commandmessage;
    data['planningid'] = planningid;
    data['planningdt'] = planningdt;
    data['noofconsign'] = noofconsign;
    data['routename'] = routename;
    data['displayconsignmenttype'] = displayconsignmenttype;
    data['totdistance'] = totdistance;
    data['totweight'] = totweight;
    data['acceptedStatus'] = acceptedStatus; // ✅ Added here
    return data;
  }
}
