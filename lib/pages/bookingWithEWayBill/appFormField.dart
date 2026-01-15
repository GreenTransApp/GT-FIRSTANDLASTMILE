import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';

class AppFormField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final bool isInput;
  final VoidCallback? onTap;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;
  final bool isRequired;
  final IconData icon;
  final IconData? endIcon;
  final VoidCallback? endIconOnTap;
  final Color? endIconColor;
  final String? Function(String?)? validator;

  const AppFormField(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.label,
      this.isInput = true,
      this.onTap,
      required this.keyboardType,
      this.textInputAction = TextInputAction.next,
      this.onSubmitted,
      required this.isRequired,
      required this.icon,
      this.endIcon,
      this.endIconOnTap,
      this.endIconColor,
      this.validator});

  InputDecoration _inputDecoration(
    String label,
  ) {
    return InputDecoration(
      hintText: label,
      suffixIcon: IconButton(
        icon: Icon(endIcon),
        onPressed: endIconOnTap,
      ),
      suffixIconColor: endIconColor ?? CommonColors.primaryColorShade,
      hintStyle: TextStyle(
          color: CommonColors.grey400!, fontSize: SizeConfig.mediumTextSize),
      contentPadding: EdgeInsets.symmetric(
          horizontal: SizeConfig.horizontalPadding,
          vertical: SizeConfig.verticalPadding),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.grey300!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide:
            BorderSide(color: CommonColors.primaryColorShade!, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
        borderSide: BorderSide(color: CommonColors.red!, width: 1.5),
      ),
    );
  }

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
                size: SizeConfig.mediumIconSize,
                color: const Color(0xFF64748B)),
            SizedBox(width: SizeConfig.smallHorizontalSpacing),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: TextStyle(
                      fontSize: SizeConfig.smallTextSize,
                      fontWeight: FontWeight.w500,
                      color: CommonColors.darkCyanBlue!,
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
        SizedBox(height: SizeConfig.smallVerticalSpacing),
        child,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFormField(
        label: label,
        isRequired: isRequired,
        icon: icon,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          readOnly: !isInput,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          onTap: isInput ? null : onTap,
          onFieldSubmitted: (_) => onSubmitted?.call(),
          decoration: _inputDecoration(label),
          validator: validator,
        ));
  }
}
