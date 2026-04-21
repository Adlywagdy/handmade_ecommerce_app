import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/colors.dart';
import '../../../cubit/admin_cubit.dart';
import '../../../models/orders_model.dart';
import 'widget/orders_status_badge.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final cubit = context.read<AdminCubit>();
        final order = cubit.orderById(orderId);
        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Order')),
            body: const Center(child: Text('Order not found')),
          );
        }
        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              order.displayId.isNotEmpty ? order.displayId : 'Order',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: blackDegree,
              ),
            ),
            centerTitle: true,
          ),
          body: _Body(order: order, cubit: cubit),
        );
      },
    );
  }
}

class _Body extends StatelessWidget {
  final OrderModel order;
  final AdminCubit cubit;

  const _Body({required this.order, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final busy = cubit.isProcessing(order.id);
    final sellerName = cubit.sellerById(order.sellerId)?.name ??
        order.sellerName ??
        '—';
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        _StatusHeader(order: order),
        SizedBox(height: 16.h),
        _Section(title: 'Parties', rows: [
          ('Customer', order.customerName ?? order.customerId),
          ('Seller', sellerName),
          ('Created', _fmtDate(order.createdAt)),
          ('Last update', _fmtDate(order.updatedAt)),
        ]),
        SizedBox(height: 12.h),
        _ItemsCard(order: order),
        SizedBox(height: 12.h),
        _Section(title: 'Totals', rows: [
          ('Subtotal', _money(order.subtotal, order.currency)),
          ('Delivery fee', _money(order.deliveryFee, order.currency)),
          ('Commission',
              '${_money(order.commission, order.currency)} (${(order.commissionRate * 100).toStringAsFixed(1)}%)'),
          ('Seller earning', _money(order.sellerEarning, order.currency)),
          ('Total', _money(order.totalPrice, order.currency)),
        ]),
        SizedBox(height: 12.h),
        _Section(title: 'Payment', rows: [
          ('Method', order.paymentMethod),
          ('Status', order.paymentStatus),
        ]),
        SizedBox(height: 12.h),
        _Section(title: 'Shipping', rows: [
          ('Street', order.shippingAddress.street),
          ('City', order.shippingAddress.city),
          ('Governorate', order.shippingAddress.governorate),
          ('Country', order.shippingAddress.country),
          ('Zip', order.shippingAddress.zipCode),
        ]),
        SizedBox(height: 20.h),
        _StatusActions(order: order, cubit: cubit, busy: busy),
      ],
    );
  }
}

class _StatusHeader extends StatelessWidget {
  final OrderModel order;

  const _StatusHeader({required this.order});

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
                '${_money(order.totalPrice, order.currency)} • ${order.items.length} items',
                style: TextStyle(fontSize: 12.sp, color: subTitleColor),
              ),
            ],
          ),
          OrderStatusBadge(status: order.status),
        ],
      ),
    );
  }
}

class _ItemsCard extends StatelessWidget {
  final OrderModel order;

  const _ItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Items (${order.items.length})',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 10.h),
          if (order.items.isEmpty)
            Text(
              'No line items',
              style: TextStyle(fontSize: 13.sp, color: subTitleColor),
            )
          else
            for (final item in order.items)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.productName,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: blackDegree,
                            ),
                          ),
                          Text(
                            '${item.quantity} × ${_money(item.price, order.currency)}',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: subTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      _money(item.subtotal, order.currency),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: blackDegree,
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

class _StatusActions extends StatelessWidget {
  final OrderModel order;
  final AdminCubit cubit;
  final bool busy;

  const _StatusActions({
    required this.order,
    required this.cubit,
    required this.busy,
  });

  @override
  Widget build(BuildContext context) {
    final actions = cubit.nextOrderActions(order.status);
    if (actions.isEmpty) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Icon(Icons.lock_outline, size: 16.sp, color: subTitleColor),
            SizedBox(width: 8.w),
            Text(
              'No further actions — ${order.status.name}',
              style: TextStyle(fontSize: 12.sp, color: subTitleColor),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Update status',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: blackDegree,
          ),
        ),
        SizedBox(height: 10.h),
        for (final action in actions)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: action.$1 == OrderStatus.cancelled
                      ? redDegree
                      : commonColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                onPressed: busy
                    ? null
                    : () => cubit.updateOrderStatus(order, action.$1),
                child: busy
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(action.$2),
              ),
            ),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<(String, String)> rows;

  const _Section({required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: commonColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 10.h),
          for (final row in rows)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                children: [
                  Text('${row.$1}:',
                      style:
                          TextStyle(fontSize: 12.sp, color: subTitleColor)),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      row.$2.isEmpty ? '—' : row.$2,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: blackDegree,
                      ),
                      textAlign: TextAlign.end,
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

String _money(double v, String currency) =>
    '$currency ${v.toStringAsFixed(2)}';

String _fmtDate(DateTime? d) {
  if (d == null) return '—';
  return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
