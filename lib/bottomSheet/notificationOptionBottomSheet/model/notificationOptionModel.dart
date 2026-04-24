class NotificationOptionModel {
  String? title;
  String? key;
  String? pageName;
  int? count;

  NotificationOptionModel({
    this.title,
    this.key,
    this.pageName,
    this.count,
  });

  NotificationOptionModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    key = json['key'];
    pageName = json['pageName'];
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['title'] = title;
    data['key'] = key;
    data['count'] = count;

    return data;
  }
}
