import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';
import 'package:gtlmd/common/Utils.dart';

Widget ProfileCard(BuildContext context, String imageUrl, bool isSmallDevice) {
  return Column(
    children: [
      CircleAvatar(
        radius:
            MediaQuery.sizeOf(context).height * (isSmallDevice ? 0.08 : 0.1),
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
      const SizedBox(
        height: 8,
      ),
      Text(
        textAlign: TextAlign.center,
        savedUser.displayusername.toString(),
        style: TextStyle(
            fontWeight: FontWeight.w600, fontSize: isSmallDevice ? 14 : 16),
      ),
      const SizedBox(
        height: 8,
      ),
      Text(
        textAlign: TextAlign.center,
        savedUser.compname.toString(),
        style: TextStyle(
            fontWeight: FontWeight.w400, fontSize: isSmallDevice ? 11 : 13),
      ),
    ],
  );
}
