import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/size_config.dart';

Widget ProfileCard(BuildContext context, String imageUrl, bool isSmallDevice) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      CircleAvatar(
        radius:
            MediaQuery.sizeOf(context).height * (isSmallDevice ? 0.05 : 0.08),
        backgroundColor: CommonColors.White,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset("assets/images/defaultimage.png",
                fit: BoxFit.cover);
          },
        ),
      ),
      SizedBox(
        width: SizeConfig.mediumHorizontalSpacing,
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            savedUser.displayusername.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: SizeConfig.mediumTextSize),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            textAlign: TextAlign.center,
            savedUser.compname.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: SizeConfig.mediumTextSize),
          ),
        ],
      )
    ],
  );
}
