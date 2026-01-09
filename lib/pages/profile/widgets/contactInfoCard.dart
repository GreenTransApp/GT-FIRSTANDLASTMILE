import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';
import 'package:gtlmd/design_system/size_config.dart';
import 'package:gtlmd/pages/profile/widgets/profileInfoCard.dart';

Widget ContactInfoCard(BuildContext context, bool isSmallDevice) {
  return Container(
    width: MediaQuery.sizeOf(context).width,
    padding: EdgeInsets.symmetric(
        horizontal: SizeConfig.mediumHorizontalSpacing,
        vertical: SizeConfig.mediumVerticalSpacing),
    margin: EdgeInsets.symmetric(
        horizontal: SizeConfig.mediumHorizontalSpacing,
        vertical: SizeConfig.mediumVerticalSpacing),
    decoration: BoxDecoration(
        // shape: BoxShape.circle,
        border: Border.all(color: CommonColors.appBarColor),
        borderRadius: BorderRadius.circular(SizeConfig.extraLargeRadius)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONTACT INFORMATION',
          style: TextStyle(
              fontWeight: FontWeight.w500, fontSize: SizeConfig.mediumTextSize),
        ),
        SizedBox(
          height: SizeConfig.mediumVerticalSpacing,
          width: 12,
        ),
        Container(
          height: 1,
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.smallHorizontalPadding,
              vertical: SizeConfig.smallVerticalPadding),
          color: CommonColors.grey200,
        ),
        ProfileInfoCard(
            "USERNAME",
            savedLogin.displayname.toString(),
            CommonColors.colorPrimary,
            CommonColors.colorPrimary!.withAlpha((0.2 * 255).round()),
            Icons.person_outline_outlined,
            context,
            isSmallDevice),
        Container(
          height: 1,
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.smallHorizontalPadding,
              vertical: SizeConfig.smallVerticalPadding),
          color: CommonColors.grey200,
        ),
        ProfileInfoCard(
            "MOBILE",
            savedLogin.mobileno.toString(),
            CommonColors.green500,
            CommonColors.green50,
            Icons.phone_android_outlined,
            context,
            isSmallDevice),
        Container(
          height: 1,
          width: MediaQuery.sizeOf(context).width,
          padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.smallHorizontalPadding,
              vertical: SizeConfig.smallVerticalPadding),
          color: CommonColors.grey200,
        ),
        ProfileInfoCard(
            "EMAIL",
            savedUser.emailid.toString(),
            CommonColors.amber500,
            CommonColors.amber50,
            Icons.email_outlined,
            context,
            isSmallDevice),
      ],
    ),
  );
}
