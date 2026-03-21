import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final void Function()? onPressed;

  final Color? buttoncolor;

  final Widget? child;
  const CustomElevatedButton({
    super.key,

    required this.onPressed,
    required this.buttoncolor,

    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(buttoncolor),

        fixedSize: WidgetStateProperty.all(Size(double.maxFinite, 50)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      onPressed: onPressed,
      child: child,
    );
  }
}
