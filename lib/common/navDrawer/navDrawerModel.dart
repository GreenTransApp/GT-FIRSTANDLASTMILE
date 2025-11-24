import 'package:flutter/material.dart';

class SideMenuItem extends StatelessWidget {
  final String title;
  final Widget leadingIcon;
  final Function() press;

  const SideMenuItem({
    super.key,
    required this.title,
    required this.leadingIcon,
    required this.press,
  });
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leadingIcon,
      title: Text(title),
      onTap: press,
    );
  }
}
