import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class SocialButton extends StatelessWidget {
  final String text;

  final IconData icon;
  const SocialButton({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          print("$text");
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12).h,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.black),
              Text(
                text,
                style: AppTextStyles.t_14w600.copyWith(color: darkblue),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
