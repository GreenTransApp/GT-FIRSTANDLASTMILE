import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/dialogs/model/MailDialogResult.dart';
import 'package:gtlmd/pages/otexPickupScreen/models/mailDetails.dart';

class MailDialog extends StatefulWidget {
  MailDetails mailDetails;
  MailDialog({super.key, required this.mailDetails});

  @override
  State<MailDialog> createState() => _MailDialogState();
}

class _MailDialogState extends State<MailDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController mailController = TextEditingController();
  TextEditingController ccController = TextEditingController();
  TextEditingController subjectController = TextEditingController();
  TextEditingController rdlcController = TextEditingController();

  bool sendLabel = true;

  @override
  void initState() {
    mailController.text = isNullOrEmpty(widget.mailDetails.toemailid.toString())
        ? ''
        : widget.mailDetails.toemailid.toString();
    subjectController.text = widget.mailDetails.emailsubject.toString();
    super.initState();
  }

  @override
  void dispose() {
    mailController.dispose();
    ccController.dispose();
    subjectController.dispose();
    rdlcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      child: SingleChildScrollView(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            CommonColors.colorPrimary!.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        color: CommonColors.colorPrimary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Send Mail',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    )
                  ],
                ),

                const SizedBox(height: 24),

                _buildTextField(
                    controller: mailController,
                    label: 'Mail To',
                    icon: Icons.alternate_email,
                    hint: 'example@company.com',
                    enabled: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Enter a valid email id';
                      }
                      return null;
                    }),

                const SizedBox(height: 16),

                _buildTextField(
                    controller: ccController,
                    label: 'CC Mails',
                    icon: Icons.people_outline,
                    hint: 'cc1@company.com, cc2@company.com',
                    enabled: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return null;
                      final emails = value.split(',');
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      for (var email in emails) {
                        if (!emailRegex.hasMatch(email.trim())) {
                          return 'Invalid email: ${email.trim()}';
                        }
                      }
                      return null;
                    }),

                const SizedBox(height: 16),

                _buildTextField(
                    controller: subjectController,
                    label: 'Subject',
                    icon: Icons.subject,
                    hint: 'Enter subject',
                    enabled: false),

                const SizedBox(height: 16),

                _buildTextField(
                    controller: rdlcController,
                    label: 'RDLC Name',
                    icon: Icons.description_outlined,
                    hint: 'Report Name',
                    enabled: false),

                const SizedBox(height: 20),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CheckboxListTile(
                    value: sendLabel,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: const Text(
                      'Send Label',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        sendLabel = value ?? false;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 24),

                //----------------------------------
                // Buttons
                //----------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        label: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.pop(
                              context,
                              MailDialogResult(
                                email: mailController.text,
                                ccemails: ccController.text,
                                sendLabel: sendLabel,
                              ),
                            );
                          }
                        },
                        label: const Text('Send'),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      required IconData icon,
      String? hint,
      required bool enabled,
      String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        enabled: enabled,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
