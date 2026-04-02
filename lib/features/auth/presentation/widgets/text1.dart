import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class Text1 extends StatelessWidget {
  final String text1;
  const Text1({super.key, required this.text1});

  @override
  Widget build(BuildContext context) {
    return Text(
      text1,
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primaryColor,
      ),
    );
  }
}
