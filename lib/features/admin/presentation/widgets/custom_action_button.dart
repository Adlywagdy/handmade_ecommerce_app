import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Two visual styles for the button
enum ActionButtonStyle { filled, outlined }

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final ActionButtonStyle style;

  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    this.onTap,
    this.style = ActionButtonStyle.filled,
  });

  @override
  Widget build(BuildContext context) {
    // Is the button filled or outlined?
    final isFilled = style == ActionButtonStyle.filled;
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isFilled ? color : Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: isFilled ? Colors.transparent : color,
              width: 1.5,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isFilled ? Colors.white : color,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}