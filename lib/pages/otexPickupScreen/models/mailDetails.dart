class MailDetails {
  int? commandstatus;
  String? commandmessage;
  String? emailsubject;
  String? emailbody;
  String? toemailid;
  String? ccemailids;
  String? issendattachment;
  String? emailtemplateid;

  MailDetails({
    this.commandstatus,
    this.commandmessage,
    this.emailsubject,
    this.emailbody,
    this.toemailid,
    this.ccemailids,
    this.issendattachment,
    this.emailtemplateid,
  });

  factory MailDetails.fromJson(Map<String, dynamic> json) => MailDetails(
        commandstatus: json["commandstatus"],
        commandmessage: json["commandmessage"],
        emailsubject: json["emailsubject"],
        emailbody: json["emailbody"],
        toemailid: json["toemailid"],
        ccemailids: json["ccemailids"],
        issendattachment: json["issendattachment"],
        emailtemplateid: json["emailtemplateid"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "commandstatus": commandstatus,
        "commandmessage": commandmessage,
        "emailsubject": emailsubject,
        "emailbody": emailbody,
        "toemailid": toemailid,
        "ccemailids": ccemailids,
        "issendattachment": issendattachment,
        "emailtemplateid": emailtemplateid,
      };
}
