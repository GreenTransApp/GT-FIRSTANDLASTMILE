import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onTap;
  const CommonButton({
    Key? key,
    required this.title,
    required this.onTap,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Center(
            child: Text(
          title.toUpperCase(),
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
