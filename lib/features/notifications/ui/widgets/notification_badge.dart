import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';

/// A badge widget that shows the unread notification count
/// Wraps around any child widget (typically a bell icon)
class NotificationBadge extends StatelessWidget {
  final int unreadCount;
  final Widget child;

  const NotificationBadge({
    super.key,
    required this.unreadCount,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (unreadCount > 0)
          Positioned(
            top: -4,
            right: -4,
            child: AnimatedScale(
              scale: unreadCount > 0 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: unreadCount > 9 ? 4.w : 0,
                ),
                constraints: BoxConstraints(
                  minWidth: 16.w,
                  minHeight: 16.w,
                ),
                decoration: BoxDecoration(
                  color: redDegree,
                  shape: unreadCount > 9
                      ? BoxShape.rectangle
                      : BoxShape.circle,
                  borderRadius: unreadCount > 9
                      ? BorderRadius.circular(8.r)
                      : null,
                  border: Border.all(
                    color: Colors.white,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: redDegree.withValues(alpha: 0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  unreadCount > 99 ? '99+' : '$unreadCount',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
