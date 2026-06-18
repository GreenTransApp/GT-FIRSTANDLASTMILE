import 'package:flutter/material.dart';
import 'package:gtlmd/common/Toast.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/common/commonButton.dart';
import 'package:gtlmd/pages/otexPickupScreen/models/productTypeModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/widgets/lovPickerField.dart';
import 'package:gtlmd/pages/pickup/model/bookingTypeModel.dart';
import 'package:gtlmd/pages/pickup/model/deliveryTypeModel.dart';
import 'package:provider/provider.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/otexPickupScreen/models/OtexPickupInfoModel.dart';
import 'package:gtlmd/pages/otexPickupScreen/OtexPickupProvider.dart';
import 'package:gtlmd/pages/otexPickupScreen/OtexPickupState.dart';
import 'package:gtlmd/common/genericBottomSheet.dart';
import 'package:intl/intl.dart';

import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';

class CollapsibleHeaderSection extends StatefulWidget {
  const CollapsibleHeaderSection({super.key});

  @override
  State<CollapsibleHeaderSection> createState() =>
      _CollapsibleHeaderSectionState();
}

class _CollapsibleHeaderSectionState extends State<CollapsibleHeaderSection> {
  bool _isExpanded = false;

  // Only one controller left — for reference number, which is a real text input
  final TextEditingController _refController = TextEditingController();
  bool _refControllerSynced = false;

  final TextEditingController _pcsController = TextEditingController();
  bool _pcsControllerSynced = false;

  @override
  void dispose() {
    _refController.dispose();
    _pcsController.dispose();
    super.dispose();
  }

  /// Sync ref controller once when prefill data arrives
  void _syncRefController(String? value) {
    if (!_refControllerSynced && value != null && value.isNotEmpty) {
      _refController.text = value;
      _refControllerSynced = true;
    }
  }

  void _syncPcsController(int? value) {
    if (!_pcsControllerSynced && value != null) {
      _pcsController.text = value.toString();
      _pcsControllerSynced = true;
    }
  }

  void _openBranchSheet(BuildContext context, OtexPickupProvider provider) {
    showGenericApiBottomSheet<BranchModel>(
      context: context,
      title: "Search Booking Branch",
      fetchItems: (query) => provider.searchBranches(query),
      itemTitle: (b) => b.stnName ?? 'Unknown',
      itemSubtitle: (b) => "Code: ${b.stnCode ?? ''} | Zip: ${b.zipCode ?? ''}",
      onSelected: (b) {
        provider.updateInfo(
          provider.state.info.copyWith(
            orgName: b.stnName,
            orgCode: b.stnCode,
          ),
        );
      },
    );
  }

  void _openCustomerSheet(BuildContext context, OtexPickupProvider provider) {
    showGenericApiBottomSheet<CustomerModel>(
      context: context,
      title: "Search Customer",
      fetchItems: (query) => provider.searchCustomers(query),
      itemTitle: (c) => c.custName ?? 'Unknown',
      itemSubtitle: (c) => "Code: ${c.custCode ?? ''}",
      onSelected: (c) {
        provider.updateInfo(
          provider.state.info.copyWith(
            custName: c.custName,
            custCode: c.custCode,
            // Clear department when customer changes
            custDeptId: null,
            custDeptName: null,
          ),
        );
      },
    );
  }

  void _openDepartmentSheet(BuildContext context, OtexPickupProvider provider) {
    final info = provider.state.info;
    // Validation lives here — blocks the sheet before any API call
    if (info.orgCode == null || info.orgCode!.isEmpty) {
      _showValidationSnack(context, "Please select a Booking Branch first");
      return;
    }
    if (info.custCode == null || info.custCode!.isEmpty) {
      _showValidationSnack(context, "Please select a Customer first");
      return;
    }
    showGenericApiBottomSheet<DepartmentModel>(
      context: context,
      title: "Search Department",
      fetchItems: (query) => provider.searchDepartments(query),
      itemTitle: (d) => d.custDeptName ?? 'Unknown',
      itemSubtitle: (d) => "Code: ${d.custDeptId ?? ''}",
      onSelected: (d) {
        provider.updateInfo(
          provider.state.info.copyWith(
            custDeptName: d.custDeptName,
            custDeptId: d.custDeptId,
          ),
        );
      },
    );
  }

  void _openShipperSheet(BuildContext context, OtexPickupProvider provider) {
    showGenericApiBottomSheet<CngrCngeModel>(
      context: context,
      title: "Search Shipper",
      fetchItems: (query) => provider.searchShippers(query),
      itemTitle: (s) => s.name ?? 'Unknown',
      itemSubtitle: (s) => "Code: ${s.code ?? ''} | Mobile: ${s.telNo ?? ''}",
      onSelected: (s) {
        provider.updateInfo(
          provider.state.info.copyWith(
            cngrName: s.name,
            cngrCode: s.code,
            cngrAddress: s.address,
            cngrZipCode: s.zipCode,
            cngrMobileNo: s.telNo,
            cngrEmailId: s.email,
          ),
        );
      },
    );
  }

  void _openBookingTypeSheet(
      BuildContext context, OtexPickupProvider provider) {
    showGenericApiBottomSheet<BookingTypeModel>(
      context: context,
      title: "Select Booking Type",
      fetchItems: (query) async => provider.searchBookingType(query),
      itemTitle: (o) => o.name ?? '',
      itemSubtitle: (o) => "Code: ${o.code}",
      onSelected: (o) {
        provider.updateInfo(
          provider.state.info.copyWith(
            bookingTypeName: o.name,
            bookingTypeCode: o.code,
          ),
        );
      },
    );
  }

  void _openProductTypeSheet(
      BuildContext context, OtexPickupProvider provider) {
    showGenericApiBottomSheet<ProductTypeModel>(
      context: context,
      title: "Select Product Type",
      fetchItems: (query) async => provider.searchProductType(query),
      itemTitle: (o) => o.productname!,
      itemSubtitle: (o) => "Code: ${o.productcode}",
      onSelected: (o) {
        provider.updateInfo(
          provider.state.info.copyWith(
            productName: o.productname,
            productCode: o.productcode,
          ),
        );
      },
    );
  }

  void _openLoadTypeSheet(BuildContext context, OtexPickupProvider provider) {
    showGenericApiBottomSheet<_SimpleOption>(
      context: context,
      title: "Select Load Type",
      fetchItems: (_) async => [
        const _SimpleOption("FTL", "F"),
        const _SimpleOption("LTL", "P"),
        const _SimpleOption("Container", "C"),
      ],
      itemTitle: (o) => o.name,
      itemSubtitle: (o) => "Code: ${o.code}",
      onSelected: (o) {
        provider.updateInfo(
          provider.state.info.copyWith(
            loadTypeName: o.name,
            loadType: o.code,
          ),
        );
      },
    );
  }

  void _openDeliveryTypeSheet(
      BuildContext context, OtexPickupProvider provider) {
    showGenericApiBottomSheet<DeliveryTypeModel>(
      context: context,
      title: "Select Delivery Type",
      fetchItems: (query) async => provider.searchDeliveryType(query),
      itemTitle: (o) => o.deliveryTypeName!,
      itemSubtitle: (o) => "Code: ${o.deliveryType}",
      onSelected: (o) {
        provider.updateInfo(
          provider.state.info.copyWith(
            deliveryTypeName: o.deliveryTypeName,
            deliveryTypeCode: o.deliveryType,
          ),
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, OtexPickupProvider provider) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      provider.updateInfo(
        provider.state.info.copyWith(
          grdt: DateFormat("dd-MM-yyyy").format(picked),
        ),
      );
    }
  }

  Future<void> _selectTime(
      BuildContext context, OtexPickupProvider provider) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      provider.updateInfo(
        provider.state.info.copyWith(
          time: DateFormat("HH:mm").format(dt),
        ),
      );
    }
  }

  void _showValidationSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(
                child: Text(message, style: const TextStyle(fontSize: 13))),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // We use Selector here — this widget only rebuilds when info or headerStatus changes
    // _isExpanded changes trigger local setState, not provider rebuilds
    return Selector<OtexPickupProvider, (OtexPickupInfoModel, SectionStatus)>(
      selector: (_, p) => (p.state.info, p.state.headerStatus),
      builder: (context, data, _) {
        final info = data.$1;
        final headerStatus = data.$2;
        final provider = context.read<OtexPickupProvider>();
        final isLocked = provider.state.isHeaderLocked;

        // Sync ref controller once when prefill arrives
        _syncRefController(info.referenceNo);
        _syncPcsController(info.pcs);

        return Card(
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          surfaceTintColor: CommonColors.White,
          child: Column(
            children: [
              // ── Toggle Bar ──
              InkWell(
                onTap: () => setState(() => _isExpanded = !_isExpanded),
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  padding: EdgeInsets.all(SizeConfig.mediumHorizontalSpacing),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF1F5F9),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline,
                          color: CommonColors.colorPrimary),
                      const SizedBox(width: 8),
                      Text(
                        'Booking Details',
                        style: TextStyle(
                          fontSize: SizeConfig.mediumTextSize,
                          fontWeight: FontWeight.w600,
                          color: CommonColors.colorPrimary,
                        ),
                      ),
                      if (isLocked) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.lock_outline,
                            size: 14, color: Colors.grey.shade500),
                      ],
                      const Spacer(),
                      // Header section status indicator
                      if (headerStatus == SectionStatus.loading)
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      if (headerStatus == SectionStatus.failure)
                        Icon(Icons.error_outline,
                            size: 16, color: CommonColors.red),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: CommonColors.colorPrimary,
                      ),
                    ],
                  ),
                ),
              ),

              // ── Collapsible Body ──
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                secondChild: const SizedBox.shrink(),
                firstChild: _buildBody(context, info, provider, isLocked),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    OtexPickupInfoModel info,
    OtexPickupProvider provider,
    bool isLocked,
  ) {
    return Container(
      color: CommonColors.White,
      padding: EdgeInsets.all(SizeConfig.mediumHorizontalSpacing),
      child: Column(
        children: [
          // 1. Booking Branch
          _buildFormField(
            label: "Booking Branch",
            isRequired: true,
            icon: Icons.location_city_outlined,
            child: LovPickerField(
              value: info.orgName,
              placeholder: "Select Booking Branch",
              onTap:
                  isLocked ? null : () => _openBranchSheet(context, provider),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 2 & 3. Date + Time
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: "Booking Date",
                  isRequired: true,
                  icon: Icons.calendar_today_outlined,
                  child: LovPickerField(
                    value: info.grdt,
                    placeholder:
                        DateFormat("dd-MM-yyyy").format(DateTime.now()),
                    onTap:
                        isLocked ? null : () => _selectDate(context, provider),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.mediumHorizontalSpacing),
              Expanded(
                child: _buildFormField(
                  label: "Booking Time",
                  isRequired: true,
                  icon: Icons.access_time_outlined,
                  child: LovPickerField(
                    value: info.time,
                    placeholder: DateFormat("HH:mm").format(DateTime.now()),
                    onTap:
                        isLocked ? null : () => _selectTime(context, provider),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 4. Booking Type
          _buildFormField(
            label: "Booking Type",
            isRequired: true,
            icon: Icons.assignment_outlined,
            child: LovPickerField(
              value: info.bookingTypeName,
              placeholder: "Select Booking Type",
              onTap: isLocked
                  ? null
                  : () => _openBookingTypeSheet(context, provider),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 5. Reference Number — only real text input in header
          _buildFormField(
            label: "Reference No",
            isRequired: false,
            icon: Icons.tag_outlined,
            child: TextFormField(
              controller: _refController,
              enabled: !isLocked,
              decoration: _inputDecoration("Enter Reference Number"),
              onChanged: (val) => provider.updateInfo(
                info.copyWith(referenceNo: val),
              ),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 6. Customer
          _buildFormField(
            label: "Customer",
            isRequired: true,
            icon: Icons.person_search_outlined,
            child: LovPickerField(
              value: info.custName,
              placeholder: "Select Customer",
              onTap:
                  isLocked ? null : () => _openCustomerSheet(context, provider),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 7. Department — conditional enable
          _buildFormField(
            label: "Department",
            isRequired: false,
            icon: Icons.corporate_fare_outlined,
            child: LovPickerField(
              value: info.custDeptName,
              placeholder: "Select Department",
              // Enabled only when: not locked AND branch+customer filled
              // Validation message shown inside _openDepartmentSheet
              onTap: isLocked
                  ? null
                  : () => _openDepartmentSheet(context, provider),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 8. Shipper
          _buildFormField(
            label: "Shipper",
            isRequired: true,
            icon: Icons.local_shipping_outlined,
            child: LovPickerField(
              value: info.cngrName,
              placeholder: "Select Shipper",
              onTap:
                  isLocked ? null : () => _openShipperSheet(context, provider),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 9. Product Type + 10. Load Type
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: "Product Type",
                  isRequired: true,
                  icon: Icons.inventory_2_outlined,
                  child: LovPickerField(
                    value: info.productName,
                    placeholder: "Select",
                    onTap: isLocked
                        ? null
                        : () => _openProductTypeSheet(context, provider),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.mediumHorizontalSpacing),
              Expanded(
                child: _buildFormField(
                  label: "Load Type",
                  isRequired: true,
                  icon: Icons.local_shipping_outlined,
                  child: LovPickerField(
                    value: info.loadTypeName,
                    placeholder: "Select",
                    onTap: isLocked
                        ? null
                        : () => _openLoadTypeSheet(context, provider),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 11. Delivery Type
          _buildFormField(
            label: "Delivery Type",
            isRequired: true,
            icon: Icons.hail_outlined,
            child: LovPickerField(
              value: info.deliveryTypeName,
              placeholder: "Select Delivery Type",
              onTap: isLocked
                  ? null
                  : () => _openDeliveryTypeSheet(context, provider),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),

          // 12. Pieces
          _buildFormField(
            label: "Pieces",
            isRequired: false,
            icon: Icons.numbers_outlined,
            child: TextFormField(
              controller: _pcsController,
              enabled: !isLocked,
              keyboardType: TextInputType.number,
              decoration: _inputDecoration("Enter Number of Pieces"),
              onChanged: (val) => provider.updateInfo(
                info.copyWith(pcs: int.tryParse(val)),
              ),
            ),
          ),

          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.mediumVerticalSpacing),
              child: CommonButton(
                color: CommonColors.colorPrimary!,
                onTap: () {
                  if (!isNullOrEmpty(info.invoiceimage)) {
                    showDialogWithImage(context, info.invoiceimage!,
                        isLocal: false);
                  } else {
                    failToast("No Invoice Available");
                  }
                },
                title: "View Invoice",
              ),
            ),
          ),
          SizedBox(height: SizeConfig.mediumVerticalSpacing),
        ],
      ),
    );
  }

  // Kept as a private method — not a global helper, belongs to this widget
  Widget _buildFormField({
    required String label,
    required bool isRequired,
    required IconData icon,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon,
                size: SizeConfig.largeIconSize, color: const Color(0xFF64748B)),
            SizedBox(width: SizeConfig.extraSmallHorizontalSpacing),
            Text.rich(TextSpan(children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  fontSize: SizeConfig.smallTextSize,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF334155),
                ),
              ),
              if (isRequired)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                      color: CommonColors.red, fontWeight: FontWeight.bold),
                ),
            ])),
          ],
        ),
        SizedBox(height: SizeConfig.smallVerticalSpacing),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          color: CommonColors.grey400, fontSize: SizeConfig.smallTextSize),
      contentPadding: EdgeInsets.symmetric(
        horizontal: SizeConfig.mediumHorizontalSpacing,
        vertical: SizeConfig.mediumVerticalSpacing,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
          borderSide: const BorderSide(color: CommonColors.appBarColor)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
          borderSide: const BorderSide(color: CommonColors.appBarColor)),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
          borderSide: BorderSide(
              color:
                  CommonColors.primaryColorShade ?? CommonColors.colorPrimary!,
              width: 1.5)),
    );
  }
}

// Private stub model for hardcoded LOV options
// Replace with real API models tomorrow
class _SimpleOption {
  final String name;
  final String code;
  const _SimpleOption(this.name, this.code);
}
