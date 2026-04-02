import 'package:flutter/material.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';

class RegisterToggle extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const RegisterToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Customer
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedIndex == 0 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Customer',
                    style: TextStyle(
                      color: selectedIndex == 0 ? primaryColor : SecodaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Seller
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(1),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selectedIndex == 1 ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Seller',
                    style: TextStyle(
                      color: selectedIndex == 1 ? primaryColor : SecodaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
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
