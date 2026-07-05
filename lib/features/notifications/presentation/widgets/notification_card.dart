import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../models/notifications_model.dart';

/// A single notification card widget with swipe-to-delete
class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onTap,
    this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed?.call(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20.w),
        decoration: BoxDecoration(
          color: redDegree.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Icon(
          Icons.delete_outline,
          color: redDegree,
          size: 24.w,
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 8.h),
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: notification.isRead
                ? Colors.white
                : commonColor.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: notification.isRead
                  ? const Color(0xFFE2E8F0)
                  : commonColor.withValues(alpha: 0.15),
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Leading: Type Icon ──
              _buildTypeIcon(),
              SizedBox(width: 12.w),

              // ── Content ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row with unread dot
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: TextStyle(
                              color: const Color(0xFF0F172A),
                              fontSize: 14.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: notification.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (!notification.isRead) ...[
                          SizedBox(width: 6.w),
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: const BoxDecoration(
                              color: commonColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 4.h),

                    // Body text
                    Text(
                      notification.body,
                      style: TextStyle(
                        color: const Color(0xFF64748B),
                        fontSize: 12.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),

                    // Time ago
                    Text(
                      TimeFormatter.format(notification.createdAt),
                      style: TextStyle(
                        color: const Color(0xFF94A3B8),
                        fontSize: 11.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the leading icon based on notification type
  Widget _buildTypeIcon() {
    final config = _getTypeConfig(notification.type);

    return Container(
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        color: config.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Icon(
        config.icon,
        color: config.color,
        size: 20.w,
      ),
    );
  }


  /// Get icon and color configuration for each notification type
  _NotificationTypeConfig _getTypeConfig(NotificationType type) {
    switch (type) {
      case NotificationType.orderConfirmed:
        return const _NotificationTypeConfig(
          icon: Icons.check_circle_outline,
          color: greenDegree,
        );
      case NotificationType.orderShipped:
        return const _NotificationTypeConfig(
          icon: Icons.local_shipping_outlined,
          color: commonColor,
        );
      case NotificationType.orderDelivered:
        return const _NotificationTypeConfig(
          icon: Icons.done_all,
          color: darkgreen,
        );
      case NotificationType.orderCancelled:
        return const _NotificationTypeConfig(
          icon: Icons.cancel_outlined,
          color: redDegree,
        );
      case NotificationType.priceDropAlert:
        return const _NotificationTypeConfig(
          icon: Icons.trending_down,
          color: goldColor,
        );
      case NotificationType.newCoupon:
        return const _NotificationTypeConfig(
          icon: Icons.discount_outlined,
          color: orangedegree,
        );
      case NotificationType.newMessage:
        return const _NotificationTypeConfig(
          icon: Icons.chat_bubble_outline,
          color: darkblue,
        );
      case NotificationType.newOrder:
        return const _NotificationTypeConfig(
          icon: Icons.shopping_bag_outlined,
          color: primaryColor,
        );
      case NotificationType.orderStatusUpdate:
        return const _NotificationTypeConfig(
          icon: Icons.update_outlined,
          color: commonColor,
        );
      case NotificationType.productReview:
        return const _NotificationTypeConfig(
          icon: Icons.star_outline,
          color: yellowIconColor,
        );
      case NotificationType.lowStock:
        return const _NotificationTypeConfig(
          icon: Icons.warning_amber_outlined,
          color: redDegree,
        );
      case NotificationType.paymentReceived:
        return const _NotificationTypeConfig(
          icon: Icons.payments_outlined,
          color: darkgreen,
        );
      case NotificationType.newCustomerMessage:
        return const _NotificationTypeConfig(
          icon: Icons.chat_bubble_outline,
          color: darkblue,
        );
      case NotificationType.newSellerRegistration:
        return const _NotificationTypeConfig(
          icon: Icons.person_add_outlined,
          color: commonColor,
        );
      case NotificationType.reportedProduct:
        return const _NotificationTypeConfig(
          icon: Icons.flag_outlined,
          color: redDegree,
        );
      case NotificationType.systemAlert:
        return const _NotificationTypeConfig(
          icon: Icons.info_outline,
          color: greyTextColor,
        );
    }
  }
}

/// Internal config class for notification type icon & color
class _NotificationTypeConfig {
  final IconData icon;
  final Color color;

  const _NotificationTypeConfig({
    required this.icon,
    required this.color,
  });
}
