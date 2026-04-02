import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final String value;
  final bool isLoading;
  final void Function()? onTap;
  const CustomButton({
    super.key,
    required this.text,
    required this.value,
    this.isLoading = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      // () {
      //    print("$value");
      //  },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
