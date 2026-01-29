class MenuModel {
  int? commandstatus;
  String? modulename;
  String? menutype;
  String? page;
  String? menucode;
  String? menuname;
  String? displayname;
  String? rights;
  String? addrec;
  String? updaterec;
  String? cancelrec;
  String? deleterec;
  String? printrec;
  String? exestr;
  String? parentcode;
  String? sequenceid;

  MenuModel(
      {this.commandstatus,
      this.modulename,
      this.menutype,
      this.page,
      this.menucode,
      this.menuname,
      this.displayname,
      this.rights,
      this.addrec,
      this.updaterec,
      this.cancelrec,
      this.deleterec,
      this.printrec,
      this.exestr,
      this.parentcode,
      this.sequenceid});

  MenuModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    modulename = json['modulename'];
    menutype = json['menutype'];
    page = json['page'];
    menucode = json['menucode'];
    menuname = json['menuname'];
    displayname = json['displayname'];
    rights = json['rights'];
    addrec = json['addrec'].toString();
    updaterec = json['updaterec'].toString();
    cancelrec = json['cancelrec'].toString();
    deleterec = json['deleterec'].toString();
    printrec = json['printrec'].toString();
    exestr = json['exestr'];
    parentcode = json['parentcode'];
    sequenceid = json['sequenceid'];
  }

  MenuModel copyWith({
    String? page,
  }) {
    return MenuModel(
      commandstatus: commandstatus,
      modulename: modulename,
      menutype: menutype,
      page: page ?? this.page,
      menucode: menucode,
      menuname: menuname,
      displayname: displayname,
      rights: rights,
      addrec: addrec,
      updaterec: updaterec,
      cancelrec: cancelrec,
      deleterec: deleterec,
      printrec: printrec,
      exestr: exestr,
      sequenceid: sequenceid,
      parentcode: parentcode,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['modulename'] = this.modulename;
    data['menutype'] = this.menutype;
    data['page'] = this.page;
    data['menucode'] = this.menucode;
    data['menuname'] = this.menuname;
    data['displayname'] = this.displayname;
    data['rights'] = this.rights;
    data['addrec'] = this.addrec;
    data['updaterec'] = this.updaterec;
    data['cancelrec'] = this.cancelrec;
    data['deleterec'] = this.deleterec;
    data['printrec'] = this.printrec;
    data['exestr'] = this.exestr;
    data['parentcode'] = this.parentcode;
    data['sequenceid'] = this.sequenceid;
    return data;
  }
}
