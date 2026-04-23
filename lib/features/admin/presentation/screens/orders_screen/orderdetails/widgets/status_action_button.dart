import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/models/orders_model.dart';

class StatusActionButton extends StatelessWidget {
  final OrderStatus nextStatus;
  final String label;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onPressed;

  const StatusActionButton({
    super.key,
    required this.nextStatus,
    required this.label,
    required this.isLoading,
    required this.isEnabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isCancelButton = nextStatus == OrderStatus.cancelled;
    final Color backgroundColor = isCancelButton ? redDegree : commonColor;

    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: Colors.white,
            disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
            disabledForegroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h),
          ),
          onPressed: isEnabled ? onPressed : null,
          child: isLoading
              ? SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(label),
        ),
      ),
    );
  }
}
