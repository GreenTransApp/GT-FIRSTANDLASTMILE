import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/otexPickupScreen/domain/models/OtexPickupInfoModel.dart';
import 'package:intl/intl.dart';
import 'package:gtlmd/pages/otexPickupScreen/presentation/controller/OtexPickupProvider.dart';
import 'package:gtlmd/common/genericBottomSheet.dart';

// Import necessary models for search UI
import 'package:gtlmd/pages/pickup/model/branchModel.dart';
import 'package:gtlmd/pages/pickup/model/customerModel.dart';
import 'package:gtlmd/pages/pickup/model/departmentModel.dart';
import 'package:gtlmd/pages/pickup/model/CngrCngeModel.dart';

// Helper method for form decoration to match existing UI styling in pickup.dart
InputDecoration otexInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: CommonColors.grey400,
      fontSize: SizeConfig.smallTextSize,
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: SizeConfig.mediumHorizontalSpacing,
      vertical: SizeConfig.mediumVerticalSpacing,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      borderSide: const BorderSide(color: CommonColors.appBarColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      borderSide: const BorderSide(color: CommonColors.appBarColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      borderSide: BorderSide(
          color: CommonColors.primaryColorShade ?? CommonColors.colorPrimary!,
          width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      borderSide: BorderSide(color: CommonColors.red!, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      borderSide: BorderSide(color: CommonColors.red!, width: 1.5),
    ),
  );
}

// Reusable Form Field Wrapper matching pickup.dart styling
Widget otexBuildFormField({
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
          Icon(icon,
              size: SizeConfig.largeIconSize, color: const Color(0xFF64748B)),
          SizedBox(width: SizeConfig.extraSmallHorizontalSpacing),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: label,
                  style: TextStyle(
                    fontSize: SizeConfig.smallTextSize,
                    fontWeight: FontWeight.w500,
                    color: labelColor,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isRequired)
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: CommonColors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      SizedBox(height: SizeConfig.smallVerticalSpacing),
      child,
    ],
  );
}

class CollapsibleHeaderSection extends StatefulWidget {
  final OtexPickupProvider controller;

  const CollapsibleHeaderSection({
    super.key,
    required this.controller,
  });

  @override
  State<CollapsibleHeaderSection> createState() =>
      _CollapsibleHeaderSectionState();
}

class _CollapsibleHeaderSectionState extends State<CollapsibleHeaderSection> {
  bool _isExpanded = true;

  // Controllers for date, time, and reference fields
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _refController = TextEditingController();

  // Selected LOV text variables
  String _selectedBranch = "Select Booking Branch";
  String _selectedCustomer = "Select Customer";
  String _selectedDept = "Select Department";
  String _selectedShipper = "Select Shipper";

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat("dd-MM-yyyy").format(DateTime.now());
    _timeController.text = DateFormat("HH:mm").format(DateTime.now());
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _refController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      String formattedDate = DateFormat("dd-MM-yyyy").format(picked);
      setState(() {
        _dateController.text = formattedDate;
      });
      final currentInfo =
          widget.controller.state.info ?? OtexPickupInfoModel.empty();
      widget.controller
          .updateGlobalInfo(currentInfo.copyWith(bookingDate: formattedDate));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      String formattedTime = DateFormat("HH:mm").format(dt);
      setState(() {
        _timeController.text = formattedTime;
      });
      final currentInfo =
          widget.controller.state.info ?? OtexPickupInfoModel.empty();
      widget.controller
          .updateGlobalInfo(currentInfo.copyWith(bookingTime: formattedTime));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // Header Toggle Bar
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(SizeConfig.mediumHorizontalSpacing),
              decoration: const BoxDecoration(
                color: Color(0xFFF1F5F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: CommonColors.colorPrimary),
                  const SizedBox(width: 8),
                  Text(
                    'Global Booking Details',
                    style: TextStyle(
                      fontSize: SizeConfig.mediumTextSize,
                      fontWeight: FontWeight.w600,
                      color: CommonColors.colorPrimary,
                    ),
                  ),
                  const Spacer(),
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

          // Collapsible Panel body
          AnimatedCrossFade(
            firstChild: Padding(
              padding: EdgeInsets.all(SizeConfig.mediumHorizontalSpacing),
              child: Column(
                children: [
                  // 1. Booking Branch (LOV Selection)
                  otexBuildFormField(
                    label: "Booking Branch",
                    isRequired: true,
                    icon: Icons.location_city_outlined,
                    child: InkWell(
                      onTap: () {
                        showGenericApiBottomSheet<BranchModel>(
                          context: context,
                          title: "Search Booking Branch",
                          fetchItems: (query) =>
                              widget.controller.searchBranches(query),
                          itemTitle: (branch) => branch.stnName ?? 'Unknown',
                          itemSubtitle: (branch) =>
                              "Code: ${branch.stnCode ?? ''} | Zip: ${branch.zipCode ?? ''}",
                          onSelected: (branch) {
                            setState(() =>
                                _selectedBranch = branch.stnName ?? 'Unknown');
                            final currentInfo = widget.controller.state.info ??
                                OtexPickupInfoModel.empty();
                            widget.controller.updateGlobalInfo(
                              currentInfo.copyWith(
                                bookingBranchName: branch.stnName,
                                bookingBranchCode: branch.stnCode,
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
                                _selectedBranch,
                                style: TextStyle(
                                  color: _selectedBranch.startsWith("Select")
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

                  // 2. Booking Date & 3. Booking Time
                  Row(
                    children: [
                      Expanded(
                        child: otexBuildFormField(
                          label: "Booking Date",
                          isRequired: true,
                          icon: Icons.calendar_today_outlined,
                          child: InkWell(
                            onTap: () => _selectDate(context),
                            child: IgnorePointer(
                              child: TextFormField(
                                controller: _dateController,
                                decoration: otexInputDecoration("Date"),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                      Expanded(
                        child: otexBuildFormField(
                          label: "Booking Time",
                          isRequired: true,
                          icon: Icons.access_time_outlined,
                          child: InkWell(
                            onTap: () => _selectTime(context),
                            child: IgnorePointer(
                              child: TextFormField(
                                controller: _timeController,
                                decoration: otexInputDecoration("Time"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),

                  // 4. Booking Type (LOV Dropdown)
                  otexBuildFormField(
                    label: "Booking Type",
                    isRequired: true,
                    icon: Icons.assignment_outlined,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: otexInputDecoration("Select Booking Type"),
                      items: ["Paid (C)", "To Pay (T)", "TBB (R)", "PP"]
                          .map((type) {
                        return DropdownMenuItem<String>(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final currentInfo = widget.controller.state.info ??
                            OtexPickupInfoModel.empty();
                        widget.controller.updateGlobalInfo(
                          currentInfo.copyWith(
                            bookingTypeName: val,
                            bookingTypeCode: val,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),

                  // 5. Reference No (Text Field)
                  otexBuildFormField(
                    label: "Reference No",
                    isRequired: false,
                    icon: Icons.tag_outlined,
                    child: TextFormField(
                      controller: _refController,
                      decoration: otexInputDecoration("Enter Reference Number"),
                      onChanged: (val) {
                        final currentInfo = widget.controller.state.info ??
                            OtexPickupInfoModel.empty();
                        widget.controller.updateGlobalInfo(
                            currentInfo.copyWith(referenceNumber: val));
                      },
                    ),
                  ),
                  SizedBox(height: SizeConfig.mediumVerticalSpacing),

                  // 6. Customer (LOV Selection UI)
                  otexBuildFormField(
                    label: "Customer",
                    isRequired: true,
                    icon: Icons.person_search_outlined,
                    child: InkWell(
                      onTap: () {
                        showGenericApiBottomSheet<CustomerModel>(
                          context: context,
                          title: "Search Customer",
                          fetchItems: (query) =>
                              widget.controller.searchCustomers(query),
                          itemTitle: (customer) =>
                              customer.custName ?? 'Unknown',
                          itemSubtitle: (customer) =>
                              "Code: ${customer.custCode ?? ''}",
                          onSelected: (customer) {
                            setState(() => _selectedCustomer =
                                customer.custName ?? 'Unknown');
                            final currentInfo = widget.controller.state.info ??
                                OtexPickupInfoModel.empty();
                            widget.controller.updateGlobalInfo(
                              currentInfo.copyWith(
                                customerName: customer.custName,
                                customerCode: customer.custCode,
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
                                _selectedCustomer,
                                style: TextStyle(
                                  color: _selectedCustomer.startsWith("Select")
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

                  // 7. Department (LOV Selection UI)
                  otexBuildFormField(
                    label: "Department",
                    isRequired: false,
                    icon: Icons.corporate_fare_outlined,
                    child: InkWell(
                      onTap: () {
                        showGenericApiBottomSheet<DepartmentModel>(
                          context: context,
                          title: "Search Department",
                          fetchItems: (query) =>
                              widget.controller.searchDepartments(query),
                          itemTitle: (dept) => dept.custDeptName ?? 'Unknown',
                          itemSubtitle: (dept) =>
                              "Code: ${dept.custDeptId ?? ''}",
                          onSelected: (dept) {
                            setState(() =>
                                _selectedDept = dept.custDeptName ?? 'Unknown');
                            final currentInfo = widget.controller.state.info ??
                                OtexPickupInfoModel.empty();
                            widget.controller.updateGlobalInfo(
                              currentInfo.copyWith(
                                departmentName: dept.custDeptName,
                                departmentCode: dept.custDeptId.toString(),
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
                                _selectedDept,
                                style: TextStyle(
                                  color: _selectedDept.startsWith("Select")
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

                  // 8. Shipper (LOV Selection UI)
                  otexBuildFormField(
                    label: "Shipper",
                    isRequired: true,
                    icon: Icons.local_shipping_outlined,
                    child: InkWell(
                      onTap: () {
                        showGenericApiBottomSheet<CngrCngeModel>(
                          context: context,
                          title: "Search Shipper",
                          fetchItems: (query) =>
                              widget.controller.searchShippers(query),
                          itemTitle: (shipper) => shipper.name ?? 'Unknown',
                          itemSubtitle: (shipper) =>
                              "Code: ${shipper.code ?? ''} | Mobile: ${shipper.telNo ?? ''}",
                          onSelected: (shipper) {
                            setState(() =>
                                _selectedShipper = shipper.name ?? 'Unknown');
                            final currentInfo = widget.controller.state.info ??
                                OtexPickupInfoModel.empty();
                            widget.controller.updateGlobalInfo(
                              currentInfo.copyWith(
                                shipperName: shipper.name,
                                shipperCode: shipper.code,
                                shipperAddress: shipper.address,
                                shipperZipCode: shipper.zipCode,
                                shipperMobileNo: shipper.telNo,
                                shipperEmail: shipper.email,
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
                                _selectedShipper,
                                style: TextStyle(
                                  color: _selectedShipper.startsWith("Select")
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

                  // 9. Product Type & 10. Delivery Type (Standard Dropdowns)
                  Row(
                    children: [
                      Expanded(
                        child: otexBuildFormField(
                          label: "Product Type",
                          isRequired: true,
                          icon: Icons.inventory_2_outlined,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: otexInputDecoration("Select"),
                            items: ["OTEX", "Standard", "Express"].map((prod) {
                              return DropdownMenuItem<String>(
                                value: prod,
                                child: Text(prod),
                              );
                            }).toList(),
                            onChanged: (val) {
                              final currentInfo =
                                  widget.controller.state.info ??
                                      OtexPickupInfoModel.empty();
                              widget.controller.updateGlobalInfo(
                                currentInfo.copyWith(
                                  productTypeName: val,
                                  productTypeCode: val,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: SizeConfig.mediumHorizontalSpacing),
                      Expanded(
                        child: otexBuildFormField(
                          label: "Delivery Type",
                          isRequired: true,
                          icon: Icons.hail_outlined,
                          child: DropdownButtonFormField<String>(
                            isExpanded: true,
                            decoration: otexInputDecoration("Select"),
                            items: ["DOOR TO DOOR", "HUB TO HUB", "DOOR TO HUB"]
                                .map((deliv) {
                              return DropdownMenuItem<String>(
                                value: deliv,
                                child: Text(deliv),
                              );
                            }).toList(),
                            onChanged: (val) {
                              final currentInfo =
                                  widget.controller.state.info ??
                                      OtexPickupInfoModel.empty();
                              widget.controller.updateGlobalInfo(
                                currentInfo.copyWith(
                                  deliveryTypeName: val,
                                  deliveryTypeCode: val,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
            crossFadeState: _isExpanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
