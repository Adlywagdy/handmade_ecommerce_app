import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;

  final Color? buttoncolor;
  final Color? bordercolor;
  final Widget? child;
  final double buttonheight;
  const CustomElevatedButton({
    super.key,

    required this.onPressed,
    required this.buttoncolor,
    this.bordercolor,
    required this.child,
    this.buttonheight = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(buttoncolor),
        elevation: WidgetStateProperty.all(0),
        fixedSize: WidgetStateProperty.all(
          Size(double.maxFinite, buttonheight.h),
        ),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12).r,
            side: BorderSide(color: bordercolor ?? buttoncolor!),
          ),
        ),
      ),

      onPressed: onPressed,
      child: child,
    );
  }
}
