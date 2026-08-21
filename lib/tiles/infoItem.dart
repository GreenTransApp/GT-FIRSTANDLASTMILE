import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/design_system/size_config.dart';

class InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final Color colors;
  final Icon icon;

  InfoItem({
    Key? key,
    required this.label,
    required this.value,
    required this.colors, required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: SizeConfig.extraSmallVerticalPadding,
          horizontal: SizeConfig.extraSmallHorizontalPadding),
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.extraSmallHorizontalSpacing,
          vertical: SizeConfig.extraSmallVerticalSpacing),
      decoration: BoxDecoration(
        border: Border.all(color: colors.withAlpha((255 * 0.1).toInt())),
        borderRadius: BorderRadius.all(Radius.circular(SizeConfig.largeRadius)),
        color: colors.withAlpha((255 * 0.1).toInt()),
      ),
      child: Row(
        children: [
          CircleAvatar(child: icon,backgroundColor: CommonColors.white,),
          SizedBox(width: SizeConfig.extraSmallHorizontalSpacing,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                label,
                style: TextStyle(
                  fontSize: SizeConfig.smallTextSize,
                  color: CommonColors.appBarColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                overflow: TextOverflow.ellipsis,
                value,
                style: TextStyle(
                  fontSize: SizeConfig.mediumTextSize,
                  fontWeight: FontWeight.bold,
                  color: CommonColors.appBarColor!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
