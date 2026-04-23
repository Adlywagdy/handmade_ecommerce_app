import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/orders_model.dart';
import 'orders_status_badge.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback? onTap;

  const OrderCard({super.key, required this.order, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _StatusIcon(status: order.status),
            SizedBox(width: 12.w),
            Expanded(child: _OrderInfo(order: order)),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 20.sp),
          ],
        ),
      ),
    );
  }
}

//////////////////////////////  Helpers ////////////////////////////
IconData _iconForStatus(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Icons.access_time;
    case OrderStatus.confirmed:
      return Icons.task_alt;
    case OrderStatus.preparing:
      return Icons.inventory_2_outlined;
    case OrderStatus.shipped:
      return Icons.local_shipping_outlined;
    case OrderStatus.delivered:
      return Icons.check_circle_outline;
    case OrderStatus.cancelled:
      return Icons.cancel_outlined;
  }
}

Color _colorForStatus(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return const Color(0xFFD97706);
    case OrderStatus.confirmed:
      return const Color(0xFF2563EB);
    case OrderStatus.preparing:
      return const Color(0xFFB45309);
    case OrderStatus.shipped:
      return const Color(0xFF7C3AED);
    case OrderStatus.delivered:
      return const Color(0xFF07880E);
    case OrderStatus.cancelled:
      return const Color(0xFFD32F2F);
  }
}

Color _bgColorForStatus(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return const Color(0xFFFEF3C7);
    case OrderStatus.confirmed:
      return const Color(0xFFDBEAFE);
    case OrderStatus.preparing:
      return const Color(0xFFFEF3C7);
    case OrderStatus.shipped:
      return const Color(0xFFEDE9FE);
    case OrderStatus.delivered:
      return const Color(0xFFDCFCE7);
    case OrderStatus.cancelled:
      return const Color(0xFFFEE2E2);
  }
}

//////////////////////////// Status icon on the left ////////////////////////////
class _StatusIcon extends StatelessWidget {
  final OrderStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: _bgColorForStatus(status),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Icon(_iconForStatus(status), color: _colorForStatus(status), size: 22.sp),
    );
  }
}

////////////////////////////// Middle info section ////////////////////////////
class _OrderInfo extends StatelessWidget {
  final OrderModel order;
  const _OrderInfo({required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Text(
                  order.displayId,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            OrderStatusBadge(status: order.status),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          '${order.date} • ${order.customerName ?? ''}',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade500),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${order.currency}${order.price.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFC07D3A),
              ),
            ),
            Text(
              'Seller: ${order.sellerName ?? ''}',
              style: TextStyle(fontSize: 11.sp, color: Colors.grey.shade500),
            ),
          ],
        ),
      ],
    );
  }
}
