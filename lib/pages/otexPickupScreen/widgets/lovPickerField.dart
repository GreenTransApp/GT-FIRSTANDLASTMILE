import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';

/// A tappable field that looks like a TextFormField but is read-only.
/// Used for all LOV (List of Values) selections.
/// Pass [onTap] as null to disable it — styling updates automatically.
class LovPickerField extends StatelessWidget {
  final String? value;
  final String placeholder;
  final VoidCallback? onTap; // null = disabled
  final bool isError;

  const LovPickerField({
    super.key,
    this.value,
    required this.placeholder,
    this.onTap,
    this.isError = false,
  });

  bool get _hasValue => value != null && value!.isNotEmpty;
  bool get _isDisabled => onTap == null;

  @override
  Widget build(BuildContext context) {
    final borderColor = isError ? CommonColors.red! : CommonColors.appBarColor;

    final bgColor = _isDisabled ? Colors.grey.shade100 : Colors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.mediumHorizontalSpacing,
          vertical: SizeConfig.mediumVerticalSpacing,
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(
            color: borderColor!,
            width: isError ? 1.5 : 1.0,
          ),
          borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _hasValue ? value! : placeholder,
                style: TextStyle(
                  fontSize: _hasValue
                      ? SizeConfig.mediumTextSize
                      : SizeConfig.smallTextSize,
                  color: _hasValue
                      ? (_isDisabled
                          ? Colors.grey.shade600
                          : _hasValue
                              ? CommonColors.appBarColor
                              : Colors.black87)
                      : CommonColors.grey400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(
              _isDisabled ? Icons.lock_outline : Icons.arrow_drop_down,
              color: _isDisabled ? Colors.grey.shade400 : Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
