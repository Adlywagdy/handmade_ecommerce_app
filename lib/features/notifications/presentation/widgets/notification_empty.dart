import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';

/// Empty state widget shown when there are no notifications
class NotificationEmpty extends StatelessWidget {
  const NotificationEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bell icon with decorative circle
            Container(
              width: 90.w,
              height: 90.w,
              decoration: BoxDecoration(
                color: commonColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: commonColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.notifications_off_outlined,
                    color: commonColor.withValues(alpha: 0.6),
                    size: 30.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Title
            Text(
              'No Notifications Yet',
              style: TextStyle(
                color: const Color(0xFF0F172A),
                fontSize: 18.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),

            // Subtitle
            Text(
              'When you receive notifications, they\'ll appear here. Stay tuned!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 14.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
