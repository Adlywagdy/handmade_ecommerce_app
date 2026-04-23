import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/models/orders_model.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/orders_screen/widget/orders_status_badge.dart';
import 'formatters.dart';

// Top card of the details page Shows the order id, the total price
class StatusHeader extends StatelessWidget {
  final OrderModel order;
  const StatusHeader({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.displayId,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: blackDegree,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${formatMoney(order.totalPrice, order.currency)} • ${order.items.length} items',
                style: TextStyle(fontSize: 12.sp, color: subTitleColor),
              ),
            ],
          ),
          // Status badge
          OrderStatusBadge(status: order.status),
        ],
      ),
    );
  }
}
