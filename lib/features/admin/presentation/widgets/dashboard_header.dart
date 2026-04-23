import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/colors.dart';
import '../../../notifications/cubit/notifications_cubit.dart';
import '../../../notifications/cubit/notifications_state.dart';
import '../../../notifications/presentation/widgets/notification_badge.dart';

class DashboardHeader extends StatelessWidget {
  final String iconPath;
  final VoidCallback? onNotificationTap;

  const DashboardHeader({
    super.key,
    this.iconPath = 'assets/images/unknown_user_icon.svg',
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 20.r,
          backgroundColor: commonColor.withValues(alpha: 0.10),
          child: SvgPicture.asset(
            iconPath,
            height: 20.h,
            width: 20.h,
          ),
        ),
        GestureDetector(
          onTap: onNotificationTap,
          child: BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              final unreadCount =
                  state is NotificationsLoaded ? state.unreadCount : 0;
              return NotificationBadge(
                unreadCount: unreadCount,
                child: Icon(
                  Icons.notifications_outlined,
                  color: commonColor,
                  size: 22.sp,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}