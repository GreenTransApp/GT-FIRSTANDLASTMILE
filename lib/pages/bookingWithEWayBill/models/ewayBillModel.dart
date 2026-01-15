import 'package:flutter/material.dart';

class EwayBillModel {
  /// DATA FIELDS
  String? ewaybillno;
  String? ewaybilldate;
  String? validupto;
  String? invoiceno;
  String? invoicevalue;
  String? invoicedate;
  bool isValidated = false;

  /// CONTROLLERS
  final TextEditingController ewaybillnoCtrl;
  final TextEditingController ewaybilldateCtrl;
  final TextEditingController validuptoCtrl;
  final TextEditingController invoicenoCtrl;
  final TextEditingController invoicevalueCtrl;
  final TextEditingController invoicedateCtrl;

  /// FOCUS NODES
  final FocusNode ewaybillnoFocus;
  final FocusNode ewaybilldateFocus;
  final FocusNode validuptoFocus;
  final FocusNode invoicenoFocus;
  final FocusNode invoicevalueFocus;
  final FocusNode invoicedateFocus;

  EwayBillModel({
    this.ewaybillno,
    this.ewaybilldate,
    this.validupto,
    this.invoiceno,
    this.invoicevalue,
    this.invoicedate,
  })  : ewaybillnoCtrl = TextEditingController(text: ewaybillno ?? ''),
        ewaybilldateCtrl = TextEditingController(text: ewaybilldate ?? ''),
        validuptoCtrl = TextEditingController(text: validupto ?? ''),
        invoicenoCtrl = TextEditingController(text: invoiceno ?? ''),
        invoicevalueCtrl = TextEditingController(text: invoicevalue ?? ''),
        invoicedateCtrl = TextEditingController(text: invoicedate ?? ''),
        ewaybillnoFocus = FocusNode(),
        ewaybilldateFocus = FocusNode(),
        validuptoFocus = FocusNode(),
        invoicenoFocus = FocusNode(),
        invoicevalueFocus = FocusNode(),
        invoicedateFocus = FocusNode();

  /// SYNC CONTROLLER VALUES BACK TO MODEL
  void syncFromControllers() {
    ewaybillno = ewaybillnoCtrl.text.trim();
    ewaybilldate = ewaybilldateCtrl.text.trim();
    validupto = validuptoCtrl.text.trim();
    invoiceno = invoicenoCtrl.text.trim();
    invoicevalue = invoicevalueCtrl.text.trim();
    invoicedate = invoicedateCtrl.text.trim();
  }

  /// CLEAR ALL FIELDS
  void clear() {
    ewaybillnoCtrl.clear();
    ewaybilldateCtrl.clear();
    validuptoCtrl.clear();
    invoicenoCtrl.clear();
    invoicevalueCtrl.clear();
    invoicedateCtrl.clear();
  }

  /// DISPOSE (VERY IMPORTANT)
  void dispose() {
    ewaybillnoCtrl.dispose();
    ewaybilldateCtrl.dispose();
    validuptoCtrl.dispose();
    invoicenoCtrl.dispose();
    invoicevalueCtrl.dispose();
    invoicedateCtrl.dispose();

    ewaybillnoFocus.dispose();
    ewaybilldateFocus.dispose();
    validuptoFocus.dispose();
    invoicenoFocus.dispose();
    invoicevalueFocus.dispose();
    invoicedateFocus.dispose();
  }
}
