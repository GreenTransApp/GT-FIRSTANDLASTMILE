import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String title;
  final Widget leadingIcon;
  final Function() press;
  final bool isSmallDevice;

  const SideMenuItem({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.press,
    this.isSmallDevice = false,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isSmallDevice ? 12 : 16,
        vertical: isSmallDevice ? 4 : 8,
      ),
      leading: IconTheme(
        data: IconThemeData(size: isSmallDevice ? 20 : 24),
        child: leadingIcon,
      ),
      title: Text(
        title,
        style: TextStyle(fontSize: isSmallDevice ? 14 : 16),
      ),
      onTap: press,
    );
  }
}
