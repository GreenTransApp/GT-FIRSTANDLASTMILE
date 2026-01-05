import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/pages/pickup/model/contentSelectionBS.dart';
import 'package:gtlmd/pages/pickup/model/invoiceModel.dart';

import 'package:intl/intl.dart';

class Invoice extends StatefulWidget {
  const Invoice({super.key});

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  String todayDate = "";
  InvoiceModel firstInvoiceModel =
      InvoiceModel(invoiceNo: '', date: '', pckgs: '', invoiceValue: '');
  List<InvoiceModel> invoiceList = List.empty(growable: true);
  TextEditingController invoiceNoController = TextEditingController();
  TextEditingController invoiceDateController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // DateTime d = DateTime.now();
    // todayDate = DateFormat('dd-MM-yyyy', d.toString()).toString();
    // invoiceList.add(InvoiceModel(
    //     invoiceNo: '', date: todayDate, pckgs: '', invoiceValue: ''));
  }

  Widget _buildFormField({
    required String label,
    required bool isRequired,
    required IconData icon,
    required Widget child,
    Color labelColor = const Color(0xFF334155),
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                  if (isRequired)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: CommonColors.red!,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  addNewInvoice() {
    setState(() {
      invoiceList.add(
          InvoiceModel(invoiceNo: '', date: '', pckgs: '', invoiceValue: ''));
    });

    // Wait for UI to rebuild, then scroll
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     duration: const Duration(milliseconds: 400),
    //     curve: Curves.easeOut,
    //   );
    // });
  }

  deleteInvoice(int index) {
    setState(() {
      invoiceList.removeAt(index);
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
      );
    });
  }

  Widget defaultInvoiceCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // heading
            const Text(
              "Invoice #: 1",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            SizedBox(
              height: 8,
            ),
            // first row
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice No.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                        firstInvoiceModel.invoiceNo =
                            firstInvoiceModel.invoiceNoController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: invoiceNoController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice No"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter SKU';
                      }
                      return null;
                    },
                  ),
                )),
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice Date.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        firstInvoiceModel.date =
                            firstInvoiceModel.dateController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: firstInvoiceModel.dateController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice Date"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice date';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            // second row
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Packages.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        firstInvoiceModel.pckgs =
                            firstInvoiceModel.pckgsController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: firstInvoiceModel.pckgsController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice No"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter SKU';
                      }
                      return null;
                    },
                  ),
                )),
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice Value.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        firstInvoiceModel.invoiceValue =
                            firstInvoiceModel.invoiceValueController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: firstInvoiceModel.invoiceValueController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice Date"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice date';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Content',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTap: () {
                      showContentSelectionBs(context, "Select Content", (data) {
                        debugPrint(data);
                      });
                    },
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    // textInputAction: TextInputAction.done,
                    // controller: model.invoiceValueController,
                    // keyboardType: TextInputType.text,
                    enabled: true,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration(" Content"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select content';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Packing',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    onTap: () {},
                    enabled: false,
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                        // model.invoiceValue = model.invoiceValueController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    // textInputAction: TextInputAction.done,
                    // controller: model.invoiceValueController,
                    // keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Packing"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select packing';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CommonButton(
                  color: CommonColors.colorPrimary!,
                  onTap: () {
                    addNewInvoice();
                  },
                  title: "Add More",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget invoiceCard(InvoiceModel model, int index) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // heading
            Text(
              "Invoice #: $index",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(
              height: 8,
            ),
            // first row
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice No.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        model.invoiceNo = model.invoiceNoController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: model.invoiceNoController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice No"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice no';
                      }
                      return null;
                    },
                  ),
                )),
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice Date.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        model.date = model.dateController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: model.dateController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice Date"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice date';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            // second row
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Packages.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();

                        model.pckgs = model.pckgsController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: model.pckgsController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice No"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter packages';
                      }
                      return null;
                    },
                  ),
                )),
                Expanded(
                    child: _buildFormField(
                  label: 'Invoice Value.',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                        model.invoiceValue = model.invoiceValueController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    textInputAction: TextInputAction.done,
                    controller: model.invoiceValueController,
                    keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Invoice Date"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter invoice value';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Content',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    // focusNode: skuFocus,
                    onTap: () {},
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    // textInputAction: TextInputAction.done,
                    // controller: model.invoiceValueController,
                    // keyboardType: TextInputType.text,
                    enabled: false,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration(" Content"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select content';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                    child: _buildFormField(
                  label: 'Packing',
                  isRequired: true,
                  icon: Icons.numbers,
                  child: TextFormField(
                    onTap: () {},
                    enabled: false,
                    // focusNode: skuFocus,
                    onTapOutside: (event) {
                      // skuFocus.unfocus();
                    },
                    autofocus: true,
                    onEditingComplete: () {
                      setState(() {
                        // _skuController.text =
                        //     _skuController.text.trim();
                        // model.invoiceValue = model.invoiceValueController.text;
                      });
                      // skuFocus.unfocus();
                      // verifySku();
                    },
                    // textInputAction: TextInputAction.done,
                    // controller: model.invoiceValueController,
                    // keyboardType: TextInputType.text,
                    style: const TextStyle(color: CommonColors.appBarColor),
                    decoration: _inputDecoration("Packing"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select packing';
                      }
                      return null;
                    },
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CommonButton(
                        color: CommonColors.colorPrimary!,
                        onTap: () {
                          addNewInvoice();
                        },
                        title: "Add More",
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: CommonButton(
                        color: CommonColors.colorPrimary!,
                        onTap: () {
                          deleteInvoice(index - 2);
                        },
                        title: "Delete",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: CommonColors.grey400!),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide:
            BorderSide(color: CommonColors.primaryColorShade!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.red!, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: CommonColors.red!, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                defaultInvoiceCard(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invoiceList.length,
                  itemBuilder: (context, index) {
                    return invoiceCard(invoiceList[index], index + 2);
                  },
                )
              ],
            )),
      ),
    );
  }
}
