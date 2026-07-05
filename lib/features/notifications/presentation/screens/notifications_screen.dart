import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/services/notification_service.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/utils/time_formatter.dart';
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_state.dart';
import 'package:handmade_ecommerce_app/features/notifications/models/notifications_model.dart';
import 'package:handmade_ecommerce_app/features/notifications/presentation/widgets/notification_card.dart';
import 'package:handmade_ecommerce_app/features/notifications/presentation/widgets/notification_empty.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: _buildAppBar(context),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoaded) {
            return Column(
              children: [
                // ── Filter Tabs ──
                _buildFilterTabs(context, state),

                // ── Content ──
                Expanded(
                  child: state.filteredNotifications.isEmpty
                      ? const NotificationEmpty()
                      : _buildNotificationsList(context, state),
                ),
              ],
            );
          }
          return const Center(
            child: CupertinoActivityIndicator(color: commonColor),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      scrolledUnderElevation: 0,
      elevation: 0,
      leading: IconButton(
        onPressed: () => Get.back(),
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: const Color(0xFF0F172A),
          size: 20.w,
        ),
      ),
      centerTitle: true,
      title: Text(
        'Notifications',
        style: TextStyle(
          color: const Color(0xFF0F172A),
          fontSize: 18.sp,
          fontFamily: 'Plus Jakarta Sans',
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state is NotificationsLoaded && state.notifications.isNotEmpty) {
              return PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert_rounded,
                  color: const Color(0xFF334155),
                  size: 22.w,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                color: Colors.white,
                elevation: 6,
                offset: Offset(0, 40.h),
                onSelected: (value) {
                  if (value == 'mark_all') {
                    context.read<NotificationsCubit>().markAllAsRead();
                  } else if (value == 'clear_all') {
                    _showClearAllDialog(context);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'mark_all',
                    child: Row(
                      children: [
                        Icon(Icons.done_all, color: commonColor, size: 18.w),
                        SizedBox(width: 10.w),
                        Text(
                          'Mark all as read',
                          style: TextStyle(
                            color: const Color(0xFF334155),
                            fontSize: 14.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'clear_all',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: redDegree, size: 18.w),
                        SizedBox(width: 10.w),
                        Text(
                          'Clear all',
                          style: TextStyle(
                            color: redDegree,
                            fontSize: 14.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  /// Build the filter tabs bar
  Widget _buildFilterTabs(BuildContext context, NotificationsLoaded state) {
    final filters = [
      _FilterTabData(
        filter: NotificationFilter.all,
        label: 'All',
        icon: Icons.all_inbox_outlined,
      ),
      _FilterTabData(
        filter: NotificationFilter.unread,
        label: 'Unread',
        icon: Icons.mark_email_unread_outlined,
      ),
      _FilterTabData(
        filter: NotificationFilter.orders,
        label: 'Orders',
        icon: Icons.shopping_bag_outlined,
      ),
      _FilterTabData(
        filter: NotificationFilter.messages,
        label: 'Messages',
        icon: Icons.chat_bubble_outline,
      ),
      _FilterTabData(
        filter: NotificationFilter.offers,
        label: 'Offers',
        icon: Icons.local_offer_outlined,
      ),
    ];

    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(bottom: 8.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 14.w),
        child: Row(
          children: filters.map((tab) {
            final isActive = state.activeFilter == tab.filter;
            return Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: GestureDetector(
                onTap: () {
                  context.read<NotificationsCubit>().setFilter(tab.filter);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? commonColor
                        : commonColor.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: isActive
                          ? commonColor
                          : commonColor.withValues(alpha: 0.15),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 15.w,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        tab.label,
                        style: TextStyle(
                          color: isActive
                              ? Colors.white
                              : const Color(0xFF64748B),
                          fontSize: 12.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight:
                              isActive ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationsList(
    BuildContext context,
    NotificationsLoaded state,
  ) {
    // Use filtered notifications
    final notifications = state.filteredNotifications;

    // Group notifications by date
    final grouped = _groupNotificationsByDate(notifications);

    return CupertinoScrollbar(
      child: RefreshIndicator(
        color: commonColor,
        onRefresh: () async {
          context.read<NotificationsCubit>().loadNotifications();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: grouped.length,
          itemBuilder: (context, index) {
            final group = grouped[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header (Today, Yesterday, Earlier)
                Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 8.h : 16.h,
                    bottom: 10.h,
                    left: 4.w,
                  ),
                  child: Text(
                    group.label,
                    style: TextStyle(
                      color: const Color(0xFF94A3B8),
                      fontSize: 12.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                // Notification cards
                ...group.notifications.map((notification) {
                  return NotificationCard(
                    notification: notification,
                    onTap: () {
                      context
                          .read<NotificationsCubit>()
                          .markAsRead(notification.id);
                      // Smart navigation based on notification type
                      NotificationService.handleNotificationTap(notification);
                    },
                    onDismissed: () {
                      context
                          .read<NotificationsCubit>()
                          .deleteNotification(notification.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notification deleted',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 13.sp,
                            ),
                          ),
                          backgroundColor: const Color(0xFF334155),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          margin: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 12.h,
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                }),
              ],
            );
          },
        ),
      ),
    );
  }

  /// Group notifications into Today, Yesterday, and Earlier
  List<_NotificationGroup> _groupNotificationsByDate(
    List<NotificationModel> notifications,
  ) {
    final todayList = <NotificationModel>[];
    final yesterdayList = <NotificationModel>[];
    final earlierList = <NotificationModel>[];

    for (final n in notifications) {
      if (TimeFormatter.isToday(n.createdAt)) {
        todayList.add(n);
      } else if (TimeFormatter.isYesterday(n.createdAt)) {
        yesterdayList.add(n);
      } else {
        earlierList.add(n);
      }
    }

    final groups = <_NotificationGroup>[];
    if (todayList.isNotEmpty) {
      groups.add(_NotificationGroup(label: 'TODAY', notifications: todayList));
    }
    if (yesterdayList.isNotEmpty) {
      groups.add(
        _NotificationGroup(label: 'YESTERDAY', notifications: yesterdayList),
      );
    }
    if (earlierList.isNotEmpty) {
      groups.add(
        _NotificationGroup(label: 'EARLIER', notifications: earlierList),
      );
    }

    return groups;
  }

  /// Show confirmation dialog before clearing all notifications
  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          'Clear All Notifications',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 17.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all notifications? This action cannot be undone.',
          style: TextStyle(
            color: const Color(0xFF64748B),
            fontSize: 14.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w400,
            height: 1.4,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 14.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<NotificationsCubit>().clearAll();
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              'Clear All',
              style: TextStyle(
                color: redDegree,
                fontSize: 14.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal model for grouped notifications
class _NotificationGroup {
  final String label;
  final List<NotificationModel> notifications;

  const _NotificationGroup({
    required this.label,
    required this.notifications,
  });
}

/// Internal model for filter tab data
class _FilterTabData {
  final NotificationFilter filter;
  final String label;
  final IconData icon;

  const _FilterTabData({
    required this.filter,
    required this.label,
    required this.icon,
  });
}
