import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class Text2 extends StatelessWidget {
  final String text2;
  const Text2({super.key, required this.text2});

  @override
  Widget build(BuildContext context) {
    return Text(
      text2,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}
