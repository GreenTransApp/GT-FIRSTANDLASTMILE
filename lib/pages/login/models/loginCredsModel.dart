class LoginCredsModel {
  String? username;
  String? password;
  String? executivefaceid;
  String? faceid;

  LoginCredsModel(
      {this.username, this.password, this.executivefaceid, this.faceid});

  LoginCredsModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    executivefaceid = json['executivefaceid'];
    faceid = json['faceid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    data['executivefaceid'] = executivefaceid;
    data['faceid'] = faceid;
    return data;
  }
}
