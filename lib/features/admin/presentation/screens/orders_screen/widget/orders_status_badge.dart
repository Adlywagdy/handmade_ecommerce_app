import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../models/orders_model.dart';

class OrderStatusBadge extends StatelessWidget {
  final OrderStatus status;


  const OrderStatusBadge({super.key, required this.status});

  String _label(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return 'PENDING';
      case OrderStatus.active:
        return 'ACTIVE';
      case OrderStatus.delivered:
        return 'DELIVERED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
    }
  }

  Color _color(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return const Color(0xFFD97706);
      case OrderStatus.active:
        return const Color(0xFF2563EB);
      case OrderStatus.delivered:
        return const Color(0xFF07880E);
      case OrderStatus.cancelled:
        return const Color(0xFFD32F2F);
    }
  }

  Color _bgColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending:
        return const Color(0xFFFEF3C7);
      case OrderStatus.active:
        return const Color(0xFFDBEAFE);
      case OrderStatus.delivered:
        return const Color(0xFFDCFCE7);
      case OrderStatus.cancelled:
        return const Color(0xFFFEE2E2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: _bgColor(status),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        _label(status),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: _color(status),
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}