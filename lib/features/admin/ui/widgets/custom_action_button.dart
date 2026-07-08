import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Two visual styles for the button
enum ActionButtonStyle { filled, outlined }

class ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final ActionButtonStyle style;
  final bool isLoading;

  const ActionButton({
    super.key,
    required this.label,
    required this.color,
    this.onTap,
    this.style = ActionButtonStyle.filled,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFilled = style == ActionButtonStyle.filled;
    final disabled = isLoading || onTap == null;
    return Expanded(
      child: GestureDetector(
        onTap: disabled ? null : onTap,
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
          child: isLoading
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isFilled ? Colors.white : color,
                    ),
                  ),
                )
              : Text(
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
