import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InvoiceModel {
  String invoiceNo;
  String date = DateFormat("dd-MM-yyyy").format(DateTime.now());
  String pckgs;
  String invoiceValue;
  // ContentModel content;

  // Add controllers for UI fields
  final TextEditingController invoiceNoController;
  final TextEditingController dateController;
  final TextEditingController pckgsController;
  final TextEditingController invoiceValueController;

  InvoiceModel({
    required this.invoiceNo,
    required this.date,
    required this.pckgs,
    required this.invoiceValue,
    // required this.content
    // required this.contentModel,
  })  : invoiceNoController = TextEditingController(text: invoiceNo),
        dateController = TextEditingController(text: date),
        pckgsController = TextEditingController(text: pckgs),
        invoiceValueController = TextEditingController(text: invoiceValue);

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      invoiceNo: json['invoiceNo']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      pckgs: json['pckgs']?.toString() ?? '',
      invoiceValue: json['invoiceValue']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'invoiceNo': invoiceNo,
      'date': date,
      'pckgs': pckgs,
      'invoiceValue': invoiceValue,
    };
  }

  void disposeControllers() {
    invoiceNoController.dispose();
    dateController.dispose();
    pckgsController.dispose();
    invoiceValueController.dispose();
  }
}
