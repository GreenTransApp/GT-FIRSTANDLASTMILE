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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          overflow: TextOverflow.ellipsis,
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: CommonColors.colorPrimary!,
          ),
        ),
      ],
    );
  }
}
