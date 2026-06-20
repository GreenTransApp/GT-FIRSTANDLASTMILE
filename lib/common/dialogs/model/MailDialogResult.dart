class MailDialogResult {
  final String email;
  final String ccemails;
  final bool sendLabel;

  const MailDialogResult(
      {required this.email, required this.ccemails, required this.sendLabel});
}
