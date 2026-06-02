import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/widgets/collapsible_header_section.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/controller/OtexPickupProvider.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupSplitInfo.dart';
import 'package:gtlmd/common/genericBottomSheet.dart';

// Import necessary models for search sheets
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';

class OtexPickupCard extends StatefulWidget {
  final OtexPickupProvider controller;
  final int index;
  final bool
      isFreightVisible; // Determines conditional visibility of freight (based on Booking Type PP)
  final VoidCallback? onDelete; // Allows card removal if allowed

  const OtexPickupCard({
    super.key,
    required this.controller,
    required this.index,
    required this.isFreightVisible,
    this.onDelete,
  });

  @override
  State<OtexPickupCard> createState() => _OtexPickupCardState();
}

class _OtexPickupCardState extends State<OtexPickupCard> {
  bool _isCardExpanded = true;

  // Controllers for dynamic text fields
  final TextEditingController _ewayBillController = TextEditingController();
  final TextEditingController _palletQtyController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _freightController = TextEditingController();

  // Selected LOV text variables
  String _selectedDestination = "Select Destination";
  String _selectedConsignee = "Select Consignee";
  String _selectedPackaging = "Select Packaging Method";
  String _selectedSaidToContain = "Select Said to Contain";

  @override
  void initState() {
    super.initState();
    _palletQtyController.text = "1";

    // Bind from provider if state contains pre-filled data
    final splitList = widget.controller.state.splitInfo;
    if (widget.index < splitList.length) {
      final cardData = splitList[widget.index];
      _ewayBillController.text = cardData.wayBillNo ?? "";
      if (cardData.palletQty != null) {
        _palletQtyController.text = cardData.palletQty.toString();
      }
      if (cardData.weight != null) {
        _weightController.text = cardData.weight.toString();
      }
      if (cardData.freightAmt != null) {
        _freightController.text = cardData.freightAmt.toString();
      }
      if (cardData.destName != null) {
        _selectedDestination = cardData.destName!;
      }
      if (cardData.cngeName != null) {
        _selectedConsignee = cardData.cngeName!;
      }
      if (cardData.packingMethod != null) {
        _selectedPackaging = cardData.packingMethod!;
      }
      if (cardData.saidToContain != null) {
        _selectedSaidToContain = cardData.saidToContain!;
      }
    }
  }

  @override
  void dispose() {
    _ewayBillController.dispose();
    _palletQtyController.dispose();
    _weightController.dispose();
    _freightController.dispose();
    super.dispose();
  }

  void _clearCardData() {
    setState(() {
      _ewayBillController.clear();
      _palletQtyController.text = "1";
      _weightController.clear();
      _freightController.clear();
      _selectedDestination = "Select Destination";
      _selectedConsignee = "Select Consignee";
      _selectedPackaging = "Select Packaging Method";
      _selectedSaidToContain = "Select Said to Contain";
    });

    // Reset provider record
    widget.controller.updateCardData(widget.index, OtexPickupSplitInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            BorderSide(color: CommonColors.grey400 ?? Colors.grey, width: 0.5),
      ),
      child: Column(
        children: [
          // Collapsible Header Row
          InkWell(
            onTap: () {
              setState(() {
                _isCardExpanded = !_isCardExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: SizeConfig.smallVerticalPadding,
                horizontal: SizeConfig.mediumHorizontalSpacing,
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: Radius.circular(_isCardExpanded ? 0 : 12),
                  bottomRight: Radius.circular(_isCardExpanded ? 0 : 12),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: CommonColors.colorPrimary,
                    child: Text(
                      "${widget.index + 1}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Consignment Entry Card",
                    style: TextStyle(
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey.shade800,
                    ),
                  ),
                  const Spacer(),
                  if (widget.onDelete != null) ...[
                    IconButton(
                      icon: Icon(Icons.delete_outline,
                          color: CommonColors.red, size: 20),
                      onPressed: widget.onDelete,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Icon(
                    _isCardExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.blueGrey,
                  ),
                ],
              ),
            ),
          ),

          // Card Body
          AnimatedCrossFade(
            firstChild: Padding(
              padding: EdgeInsets.all(SizeConfig.mediumHorizontalSpacing),
              child: Column(
                children: [
                  // 1. EwayBill Number (Disabled by default)
                  otexBuildFormField(
                    label: "EwayBill Number",
                    isRequired: false,
                    icon: Icons.receipt_long_outlined,
                    child: TextFormField(
                      controller: _ewayBillController,
                      enabled: false,
                      decoration: otexInputDecoration("Generated on Server"),
                    ),
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),

                  // 2. Destination (LOV Selection UI)
                  otexBuildFormField(
                    label: "Destination",
                    isRequired: true,
                    icon: Icons.pin_drop_outlined,
                    child: InkWell(
                      onTap: () {
                        showGenericApiBottomSheet<BranchModel>(
                          context: context,
                          title: "Search Destination",
                          fetchItems: (query) =>
                              widget.controller.searchBranches(query),
                          itemTitle: (branch) => branch.stnName ?? 'Unknown',
                          itemSubtitle: (branch) =>
                              "Code: ${branch.stnCode ?? ''} | Zip: ${branch.zipCode ?? ''}",
                          onSelected: (branch) {
                            setState(() => _selectedDestination =
                                branch.stnName ?? 'Unknown');
                            final currentCard =
                                widget.controller.state.splitInfo[widget.index];
                            widget.controller.updateCardData(
                              widget.index,
                              currentCard.copyWith(
                                destName: branch.stnName,
                                destCode: branch.stnCode,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.mediumHorizontalSpacing,
                          vertical: SizeConfig.mediumVerticalSpacing,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: CommonColors.appBarColor),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.largeRadius),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedDestination,
                                style: TextStyle(
                                  color:
                                      _selectedDestination.startsWith("Select")
                                          ? CommonColors.grey400
                                          : Colors.black,
                                  fontSize: SizeConfig.smallTextSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),

                  // 3. Consignee (LOV Selection UI)
                  otexBuildFormField(
                    label: "Consignee",
                    isRequired: true,
                    icon: Icons.person_pin_outlined,
                    child: InkWell(
                      onTap: () {
                        showGenericApiBottomSheet<CngrCngeModel>(
                          context: context,
                          title: "Search Consignee",
                          fetchItems: (query) =>
                              widget.controller.searchCngrCnge(query, 'E'),
                          itemTitle: (consignee) => consignee.name ?? 'Unknown',
                          itemSubtitle: (consignee) =>
                              "Code: ${consignee.code ?? ''}",
                          onSelected: (consignee) {
                            setState(() => _selectedConsignee =
                                consignee.name ?? 'Unknown');
                            final currentCard =
                                widget.controller.state.splitInfo[widget.index];
                            widget.controller.updateCardData(
                              widget.index,
                              currentCard.copyWith(
                                cngeName: consignee.name,
                                cngeCode: consignee.code,
                              ),
                            );
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.mediumHorizontalSpacing,
                          vertical: SizeConfig.mediumVerticalSpacing,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: CommonColors.appBarColor),
                          borderRadius:
                              BorderRadius.circular(SizeConfig.largeRadius),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                _selectedConsignee,
                                style: TextStyle(
                                  color: _selectedConsignee.startsWith("Select")
                                      ? CommonColors.grey400
                                      : Colors.black,
                                  fontSize: SizeConfig.smallTextSize,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),

                  // 4. Pallet Quantity & 7. Weight (Combined in one row)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: otexBuildFormField(
                          label: "Pallet Quantity",
                          isRequired: true,
                          icon: Icons.grid_view_outlined,
                          child: TextFormField(
                            controller: _palletQtyController,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: otexInputDecoration("Quantity"),
                            onChanged: (val) {
                              final parsed = int.tryParse(val) ?? 1;
                              final currentCard = widget
                                  .controller.state.splitInfo[widget.index];
                              widget.controller.updateCardData(
                                widget.index,
                                currentCard.copyWith(palletQty: parsed),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                      Expanded(
                        child: otexBuildFormField(
                          label: "Weight",
                          isRequired: true,
                          icon: Icons.monitor_weight_outlined,
                          child: TextFormField(
                            controller: _weightController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}$')),
                            ],
                            decoration: otexInputDecoration("Weight (KG)"),
                            onChanged: (val) {
                              final parsed = double.tryParse(val) ?? 0.0;
                              final currentCard = widget
                                  .controller.state.splitInfo[widget.index];
                              widget.controller.updateCardData(
                                widget.index,
                                currentCard.copyWith(weight: parsed),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),

                  // 5. Packaging Method & 6. Said to Contain (Combined in one row)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: otexBuildFormField(
                          label: "Packaging",
                          isRequired: true,
                          icon: Icons.workspaces_outline,
                          child: InkWell(
                            onTap: () {
                              showGenericApiBottomSheet<String>(
                                context: context,
                                title: "Select Packaging Method",
                                fetchItems: (query) async => [
                                  "BOX",
                                  "WOODEN CASE",
                                  "CARTON",
                                  "PALLET",
                                  "BAG"
                                ]
                                    .where(
                                        (e) => e.contains(query.toUpperCase()))
                                    .toList(),
                                itemTitle: (item) => item,
                                onSelected: (item) {
                                  setState(() => _selectedPackaging = item);
                                  final currentCard = widget
                                      .controller.state.splitInfo[widget.index];
                                  widget.controller.updateCardData(
                                    widget.index,
                                    currentCard.copyWith(packingMethod: item),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.mediumHorizontalSpacing,
                                vertical: SizeConfig.mediumVerticalSpacing,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: CommonColors.appBarColor),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.largeRadius),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedPackaging,
                                      style: TextStyle(
                                        color: _selectedPackaging
                                                .startsWith("Select")
                                            ? CommonColors.grey400
                                            : Colors.black,
                                        fontSize: SizeConfig.smallTextSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                      Expanded(
                        child: otexBuildFormField(
                          label: "Said To Contain",
                          isRequired: true,
                          icon: Icons.inventory_outlined,
                          child: InkWell(
                            onTap: () {
                              showGenericApiBottomSheet<String>(
                                context: context,
                                title: "Select Said to Contain",
                                fetchItems: (query) async => [
                                  "DOCUMENTS",
                                  "ELECTRONICS",
                                  "SPARE PARTS",
                                  "CLOTHES",
                                  "MEDICINES",
                                  "OTHERS"
                                ]
                                    .where(
                                        (e) => e.contains(query.toUpperCase()))
                                    .toList(),
                                itemTitle: (item) => item,
                                onSelected: (item) {
                                  setState(() => _selectedSaidToContain = item);
                                  final currentCard = widget
                                      .controller.state.splitInfo[widget.index];
                                  widget.controller.updateCardData(
                                    widget.index,
                                    currentCard.copyWith(saidToContain: item),
                                  );
                                },
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: SizeConfig.mediumHorizontalSpacing,
                                vertical: SizeConfig.mediumVerticalSpacing,
                              ),
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: CommonColors.appBarColor),
                                borderRadius: BorderRadius.circular(
                                    SizeConfig.largeRadius),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _selectedSaidToContain,
                                      style: TextStyle(
                                        color: _selectedSaidToContain
                                                .startsWith("Select")
                                            ? CommonColors.grey400
                                            : Colors.black,
                                        fontSize: SizeConfig.smallTextSize,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 8. Freight (Conditional Visibility - PP Only)
                  if (widget.isFreightVisible) ...[
                    SizedBox(height: SizeConfig.mediumVerticalSpacing),
                    otexBuildFormField(
                      label: "Freight",
                      isRequired: true,
                      icon: Icons.currency_rupee_outlined,
                      child: TextFormField(
                        controller: _freightController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+\.?\d{0,2}$')),
                        ],
                        decoration: otexInputDecoration("Enter Freight Amount"),
                        onChanged: (val) {
                          final parsed = double.tryParse(val) ?? 0.0;
                          final currentCard =
                              widget.controller.state.splitInfo[widget.index];
                          widget.controller.updateCardData(
                            widget.index,
                            currentCard.copyWith(freightAmt: parsed),
                          );
                        },
                      ),
                    ),
                  ],

                  // 9. Card-level Buttons (Save, Print Label, Clear, Print Waybill)
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              widget.controller.printLabel(widget.index),
                          icon: const Icon(Icons.print_outlined, size: 14),
                          label: const Text("Print Label",
                              style: TextStyle(fontSize: 10)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            foregroundColor: CommonColors.colorPrimary,
                            side: const BorderSide(
                                color: CommonColors.appBarColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              widget.controller.printWaybill(widget.index),
                          icon:
                              const Icon(Icons.description_outlined, size: 14),
                          label: const Text("Print Waybill",
                              style: TextStyle(fontSize: 10)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            foregroundColor: CommonColors.colorPrimary,
                            side: const BorderSide(
                                color: CommonColors.appBarColor),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _clearCardData,
                          icon: const Icon(Icons.refresh, size: 14),
                          label: const Text("Clear",
                              style: TextStyle(fontSize: 10)),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            foregroundColor: Colors.grey.shade700,
                            side: BorderSide(color: Colors.grey.shade400),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          widget.controller.saveCardEntry(widget.index),
                      icon: const Icon(Icons.check_circle_outline, size: 16),
                      label: const Text("Save Entry",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: CommonColors.colorPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isCardExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
