import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Color? backgroundColor;
  final IconData? icon;
  final Color? iconcolor;
  const CustomIconButton({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.iconcolor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: () {},
      padding: EdgeInsets.zero,

      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
      ),
      icon: Icon(icon, color: iconcolor),
    );
  }
}
