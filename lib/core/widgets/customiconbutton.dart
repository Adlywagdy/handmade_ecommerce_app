import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomIconButton extends StatelessWidget {
  final Color? backgroundColor;
  final IconData? icon;
  final double? iconsize;
  final Color? iconcolor;
  final void Function()? onPressed;
  const CustomIconButton({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.iconcolor,
    this.iconsize = 25,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      padding: EdgeInsets.zero,

      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        iconSize: WidgetStatePropertyAll(iconsize!.r),
      ),
      icon: Icon(icon, color: iconcolor),
    );
  }
}
