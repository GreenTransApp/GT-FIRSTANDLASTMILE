import 'package:flutter/material.dart';
import 'package:gtlmd/common/colors.dart';
import 'package:gtlmd/design_system/size_config.dart';

class SideMenuItem extends StatelessWidget {
  final String title;
  final Widget leadingIcon;
  final Function() press;
  final bool isSelected;
  final bool isSmallDevice;

  const SideMenuItem({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.press,
    this.isSelected = false,
    this.isSmallDevice = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.smallHorizontalPadding,
        vertical: 4,
      ),
      child: Stack(
        children: [
          Material(
            color: Colors.transparent,
            elevation: isSelected ? 1 : 0,
            shadowColor: CommonColors.shadow,
            borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
            child: ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(SizeConfig.mediumRadius),
              ),
              tileColor: isSelected
                  ? (CommonColors.colorPrimary ?? Colors.blue)
                      .withAlpha((0.08 * 255).toInt())
                  : Colors.transparent,
              contentPadding: EdgeInsets.only(
                left: SizeConfig.horizontalPadding,
                right: SizeConfig.smallHorizontalPadding,
                top: 4,
                bottom: 4,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? CommonColors.colorPrimary!
                          .withAlpha((0.12 * 255).toInt())
                      : CommonColors.green600!.withAlpha((0.05 * 255).toInt()),
                  borderRadius: BorderRadius.circular(SizeConfig.largeRadius),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    size: SizeConfig.extraLargeIconSize,
                    color: isSelected
                        ? CommonColors.colorPrimary
                        : CommonColors.appBarColor,
                  ),
                  child: leadingIcon,
                ),
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  letterSpacing: 0.3,
                  color: isSelected
                      ? CommonColors.colorPrimary
                      : CommonColors.textPrimary,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: isSelected
                    ? CommonColors.colorPrimary!.withAlpha((0.5 * 255).toInt())
                    : CommonColors.textSecondary!
                        .withAlpha((0.3 * 255).toInt()),
              ),
              onTap: press,
            ),
          ),
          if (isSelected)
            Positioned(
              left: 4,
              top: 12,
              bottom: 12,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: CommonColors.colorPrimary,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
