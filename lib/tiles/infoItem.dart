import 'package:flutter/material.dart';
import 'package:gtlmd/common/Colors.dart';

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  InfoItem({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    bool isSmallDevice = screenWidth <= 360;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          label,
          style: TextStyle(
            fontSize: isSmallDevice ? 10 : 12,
            color: CommonColors.appBarColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          overflow: TextOverflow.ellipsis,
          value,
          style: TextStyle(
            fontSize: isSmallDevice ? 14 : 18,
            fontWeight: FontWeight.w500,
            color: CommonColors.colorPrimary!,
          ),
        ),
      ],
    );
  }
}
