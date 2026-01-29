class DivisionModel {
  final int? accdivisionid;
  final String? accdivisionname;
  final int? commandstatus;
  final String? commandmessage;

  DivisionModel({
    this.accdivisionid,
    this.accdivisionname,
    this.commandstatus,
    this.commandmessage,
  });

  factory DivisionModel.fromJson(Map<String, dynamic> json) {
    return DivisionModel(
      accdivisionid: json['accdivisionid'] as int?,
      accdivisionname: json['accdivisionname'] as String?,
      commandstatus: json['commandstatus'] as int?,
      commandmessage: json['commandmessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accdivisionid': accdivisionid,
      'accdivisionname': accdivisionname,
      'commandstatus': commandstatus,
      'commandmessage': commandmessage,
    };
  }

  DivisionModel copyWith({
    int? accdivisionid,
    String? accdivisionname,
    int? commandstatus,
    String? commandmessage,
  }) {
    return DivisionModel(
      accdivisionid: accdivisionid ?? this.accdivisionid,
      accdivisionname: accdivisionname ?? this.accdivisionname,
      commandstatus: commandstatus ?? this.commandstatus,
      commandmessage: commandmessage ?? this.commandmessage,
    );
  }
}
