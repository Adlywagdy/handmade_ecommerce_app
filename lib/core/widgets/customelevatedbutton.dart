import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;

  final Color? buttoncolor;
  final double height;
  final Widget? child;
  const CustomElevatedButton({
    super.key,

    required this.onPressed,
    required this.buttoncolor,

    required this.child,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(buttoncolor),

        fixedSize: WidgetStateProperty.all(Size(double.maxFinite, height.h)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        ),
      ),

      onPressed: onPressed,
      child: child,
    );
  }
}
