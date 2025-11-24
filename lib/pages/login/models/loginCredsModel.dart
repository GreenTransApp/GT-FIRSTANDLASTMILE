class LoginCredsModel {
  String? username;
  String? password;

  LoginCredsModel({this.username, this.password});

  LoginCredsModel.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    return data;
  }
}