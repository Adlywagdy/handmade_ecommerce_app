import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class ButtomText extends StatelessWidget {
  final String text;
  final String value;
  final VoidCallback? onTap;
  final bool? isLoading;
  const ButtomText({
    super.key,
    required this.text,
    required this.value,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap:
              onTap ??
              () {
                print("$value");
              },
          child: Text(
            text,
            style: TextStyle(fontWeight: FontWeight.w600, color: primaryColor),
          ),
        ),
      ],
    );
  }
}
