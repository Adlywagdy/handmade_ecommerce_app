import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/customtextcontainer.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class OrderItem extends StatelessWidget {
  final OrderModel order;
  const OrderItem({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 10.0.w,
          vertical: 12.0.h,
        ),
        leading: Card(
          elevation: 0,
          color: _getStatusColor(order.status!).withValues(alpha: .1),

          shape: ContinuousRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(24.r),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0).w,
            child: Icon(
              getStatusIcon(order.status!),
              color: _getStatusColor(order.status!),
              size: 26.r,
            ),
          ),
        ),
        title: Row(
          spacing: 8.w,
          children: [
            Text(
              '${order.orderid}',
              style: TextStyle(
                color: blackDegree,
                fontSize: 16.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.50,
              ),
            ),
            CustomTextContainer(
              text: order.status.toString().split('.').last.toUpperCase(),
              textcolor: _getStatusColor(order.status!),
              horizontalpadding: 8.w,
              verticalpadding: 2.h,
              fontSize: 10.sp,
              backGroundColor: _getStatusColor(
                order.status!,
              ).withValues(alpha: .1),
              borderRadius: 200,
            ),
          ],
        ),
        trailing: CustomIconButton(
          backgroundColor: Colors.white,
          iconsize: 20.sp,
          icon: Icons.arrow_forward_ios,
          iconcolor: subTitleColor.withValues(alpha: 0.5),
        ),
        subtitle: Column(
          spacing: 5.h,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${order.orderDate!.toLocal().toString().split(' ')[0]} • ${order.products.length} Items',
              style: TextStyle(
                color: subTitleColor,
                fontSize: 12.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
            ),
            Text(
              '\$${order.payment!.totalPrice!.toStringAsFixed(2)}',
              style: TextStyle(
                color: commonColor,
                fontSize: 14.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
                height: 1.43,
              ),
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
