import 'package:flutter/widgets.dart';
import 'package:gtlmd/design_system/size_config.dart';

Widget ProfileInfoCard(
    String title,
    String value,
    Color? iconColor,
    Color? iconBackground,
    IconData icon,
    BuildContext context,
    bool isSmallDevice) {
  return Padding(
    padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.03),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: isSmallDevice ? 30 : 40,
          height: isSmallDevice ? 30 : 40,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.smallHorizontalPadding,
              vertical: SizeConfig.smallVerticalPadding),
          decoration: BoxDecoration(
              color: iconBackground,
              // border: Border.all(),
              shape: BoxShape.circle),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        SizedBox(
          width: SizeConfig.smallHorizontalSpacing,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: SizeConfig.smallTextSize),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.smallTextSize),
            ),
          ],
        )
      ],
    ),
  );
}
