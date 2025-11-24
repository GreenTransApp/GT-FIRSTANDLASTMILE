
class ModulesModel {
  int? commandstatus;
  String? modulename;
  String? modulecode;

  ModulesModel({this.commandstatus, this.modulename, this.modulecode});

  ModulesModel.fromJson(Map<String, dynamic> json) {
    commandstatus = json['commandstatus'];
    modulename = json['modulename'];
    modulecode = json['modulecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commandstatus'] = this.commandstatus;
    data['modulename'] = this.modulename;
    data['modulecode'] = this.modulecode;
    return data;
  }
}
