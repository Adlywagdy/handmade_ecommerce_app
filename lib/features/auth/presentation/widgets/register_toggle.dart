import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class RegisterToggle extends StatefulWidget {
  const RegisterToggle({super.key});

  @override
  State<RegisterToggle> createState() => _RegisterToggleState();
}

int selectedIndex = 0;

class _RegisterToggleState extends State<RegisterToggle> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4).r,
      decoration: BoxDecoration(
        color: Colors.brown.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Customer
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10).r,
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Customer',
                    style: AppTextStyles.t_14w700.copyWith(
                      color: selectedIndex == 0
                          ? primaryColor
                          : primaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Seller
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10).r,
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Seller',
                    style: AppTextStyles.t_14w700.copyWith(
                      color: selectedIndex == 1
                          ? primaryColor
                          : primaryColor.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
