import 'package:flutter/widgets.dart';

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
          width: isSmallDevice ? 32 : 40,
          height: isSmallDevice ? 32 : 40,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: iconBackground,
              // border: Border.all(),
              shape: BoxShape.circle),
          child: Icon(
            icon,
            color: iconColor,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: isSmallDevice ? 10 : 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: isSmallDevice ? 11 : 13),
            ),
          ],
        )
      ],
    ),
  );
}
