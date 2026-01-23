import 'package:flutter/material.dart';
import 'package:gtlmd/design_system/device_type.dart';
import 'package:gtlmd/design_system/size_config.dart';

class DimensionCard extends StatelessWidget {
  final int index;
  final VoidCallback onAdd;
  final VoidCallback? onRemove;

  const DimensionCard({
    super.key,
    required this.index,
    required this.onAdd,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SizeConfig.largeRadius)),
      margin: EdgeInsets.symmetric(
          vertical: SizeConfig.verticalPadding,
          horizontal: SizeConfig.horizontalPadding),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: SizeConfig.horizontalPadding,
            vertical: SizeConfig.verticalPadding),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // final isSmall = constraints.maxWidth < 380;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ---------- HEADER ----------
                Center(
                  child: Text(
                    "DIMENSION : $index",
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.mediumVerticalSpacing),

                /// ---------- UNIT TYPE ----------
                _label("Unit Type"),
                SizedBox(height: SizeConfig.smallVerticalSpacing),
                _unitTypeDropdown(),

                SizedBox(height: SizeConfig.mediumVerticalSpacing),

                /// ---------- PIECES + LENGTH ----------
                _responsiveRow(
                  children: [
                    _field("Pieces"),
                    _field("Length (C)"),
                  ],
                ),

                const SizedBox(height: 12),

                /// ---------- BREADTH + HEIGHT ----------
                _responsiveRow(
                  children: [
                    _field("Breadth (C)"),
                    _field("Height (C)"),
                  ],
                ),

                const SizedBox(height: 12),

                /// ---------- CFT + VOLUMETRIC WEIGHT ----------
                _responsiveRow(
                  children: [
                    _field("CFT", initialValue: "10"),
                    _field("Volumetric Weight"),
                  ],
                ),

                const SizedBox(height: 16),

                /// ---------- BUTTONS ----------
                _buttonsRow(),
              ],
            );
          },
        ),
      ),
    );
  }

  // ===================== WIDGET HELPERS =====================

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _unitTypeDropdown() {
    return DropdownButtonFormField<String>(
      value: "CM",
      decoration: _inputDecoration(),
      items: const [
        DropdownMenuItem(value: "CM", child: Text("CM")),
        DropdownMenuItem(value: "INCH", child: Text("INCH")),
      ],
      onChanged: (v) {},
    );
  }

  Widget _field(String label, {String? initialValue}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(label),
        SizedBox(height: SizeConfig.smallVerticalSpacing),
        TextFormField(
          initialValue: initialValue ?? "0",
          keyboardType: TextInputType.number,
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      ),
    );
  }

  Widget _responsiveRow({required List<Widget> children}) {
    if (SizeConfig.deviceType == DeviceType.smallPhone) {
      return Column(
        children: [
          children[0],
          SizedBox(height: SizeConfig.mediumVerticalSpacing),
          children[1],
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 12),
        Expanded(child: children[1]),
      ],
    );
  }

  Widget _buttonsRow() {
    final addBtn = Expanded(
      child: ElevatedButton(
        onPressed: onAdd,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: SizeConfig.verticalPadding),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.largeRadius)),
        ),
        child: const Text("Add More"),
      ),
    );

    final removeBtn = onRemove == null
        ? const SizedBox()
        : Expanded(
            child: ElevatedButton(
              onPressed: onRemove,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding:
                    EdgeInsets.symmetric(vertical: SizeConfig.verticalPadding),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(SizeConfig.largeRadius)),
              ),
              child: const Text("Remove"),
            ),
          );

    if (SizeConfig.deviceType == DeviceType.smallPhone) {
      return Column(
        children: [
          addBtn,
          if (onRemove != null) ...[
            SizedBox(height: SizeConfig.mediumVerticalSpacing),
            removeBtn,
          ]
        ],
      );
    }

    return Row(
      children: [
        addBtn,
        if (onRemove != null) ...[
          SizedBox(width: SizeConfig.mediumVerticalSpacing),
          removeBtn,
        ]
      ],
    );
  }
}
