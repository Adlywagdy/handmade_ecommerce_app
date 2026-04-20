import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;
  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(top: 12.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.0.w,
          vertical: 12.0.h,
        ),
        leading: Card(
          color: _getStatusColor(order.status).withValues(alpha: .1),
          elevation: 0,
          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24.r),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 12.h,
              right: 12,
              left: 12,
              top: 12.h,
            ),
            child: Icon(
              getStatusIcon(order.status),
              color: _getStatusColor(order.status),
              size: 26.r,
            ),
          ),
        ),
        title: Row(
          spacing: 8.w,
          children: [
            Text(order.orderid, style: AppTextStyles.t_16w700),
            CustomTextContainer(
              text: order.status.toString().split('.').last.toUpperCase(),

              horizontalpadding: 8.w,
              verticalpadding: 2.h,
              textstyle: AppTextStyles.t_12w400.copyWith(
                color: _getStatusColor(order.status),
              ),
              backGroundColor: _getStatusColor(
                order.status,
              ).withValues(alpha: .1),
              borderRadius: 200.r,
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20.r,
          color: subTitleColor.withValues(alpha: 0.5),
        ),
        subtitle: Column(
          spacing: 5.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${order.orderDate.toLocal().toString().split(' ')[0]} • ${order.products.length} Items',
              style: AppTextStyles.t_12w400.copyWith(color: subTitleColor),
            ),
            Text(
              '\$${order.payment.totalPrice!.toStringAsFixed(2)}',
              style: AppTextStyles.t_14w600.copyWith(color: commonColor),
            ),
          ],
        ),
      ),
    );
  }
}

Color _getStatusColor(OrderStatus status) {
  switch (status) {
    case .confirmed:
      return Colors.blue;
    case .pending:
      return Colors.yellow;
    case .preparing:
      return Colors.orange;
    case .shipped:
      return Colors.purple;
    case .delivered:
      return Colors.green;
    case .cancelled:
      return Colors.red;
  }
}

IconData getStatusIcon(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Icons.access_time_outlined;
    case OrderStatus.confirmed:
      return Icons.check_circle_outline_outlined;
    case OrderStatus.preparing:
      return Icons.handyman_outlined;
    case OrderStatus.shipped:
      return Icons.local_shipping_outlined;
    case OrderStatus.delivered:
      return Icons.inventory_2_outlined;
    case OrderStatus.cancelled:
      return Icons.cancel_outlined;
  }
}
