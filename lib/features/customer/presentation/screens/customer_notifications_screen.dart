import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/customer_cubit/customer_cubit.dart';

class CustomerNotificationsScreen extends StatelessWidget {
  const CustomerNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            scrolledUnderElevation: 0,
            backgroundColor: customerbackGroundColor,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: commonColor),
            ),
            centerTitle: true,
            title: Text(
              'Notifications',
              style: AppTextStyles.t_20w700.copyWith(color: commonColor),
            ),
          ),

          BlocBuilder<CustomerCubit, CustomerState>(
            buildWhen: (previous, current) {
              return current is NotificationsLoadingstate ||
                  current is NotificationsSuccessedstate ||
                  current is NotificationsFailedstate;
            },
            builder: (context, state) {
              if (state is NotificationsSuccessedstate) {
                if (state.notifications.isEmpty) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0).w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14.0).w,
                              decoration: BoxDecoration(
                                color: commonColor.withValues(alpha: .1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.notifications_none,
                                color: commonColor,
                                size: 32.r,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              'No notifications yet',
                              style: AppTextStyles.t_16w600.copyWith(
                                color: blackDegree,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            Text(
                              'We will notify you about orders, offers and updates.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.t_12w400.copyWith(
                                color: darkblue.withValues(alpha: .75),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else {
                  return SliverList.builder(
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      return NotificationItem(
                        notification: state.notifications[index],
                      );
                    },
                  );
                }
              } else if (state is NotificationsFailedstate) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0).w,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: redDegree,
                            size: 34.r,
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'Failed to load notifications',
                            style: AppTextStyles.t_16w600.copyWith(
                              color: blackDegree,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            state.errorMessage,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.t_12w400.copyWith(
                              color: darkblue.withValues(alpha: .75),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                return SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: commonColor),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String notification;
  const NotificationItem({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 12.w),
      padding: const EdgeInsets.all(12).w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14).r,
        border: Border.all(color: commonColor.withValues(alpha: .12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            padding: const EdgeInsets.all(8).w,
            decoration: BoxDecoration(
              color: commonColor.withValues(alpha: .1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.notifications, color: commonColor, size: 18.r),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification,
                  style: AppTextStyles.t_14w500.copyWith(
                    color: blackDegree,
                    height: 1.3,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  'Just now', //  replace this with actual timestamp
                  style: AppTextStyles.t_12w400.copyWith(
                    color: darkblue.withValues(alpha: .6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
