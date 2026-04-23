import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/cubit/admin_cubit.dart';
import 'package:handmade_ecommerce_app/features/admin/models/orders_model.dart';
import 'formatters.dart';
import 'items_card.dart';
import 'section_widget.dart';
import 'status_actions.dart';
import 'status_header.dart';

class OrderDetailsBody extends StatelessWidget {
  final OrderModel order;
  final AdminCubit cubit;

  const OrderDetailsBody({
    super.key,
    required this.order,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBusy = cubit.isProcessing(order.id);
    final String sellerName = cubit.sellerById(order.sellerId)?.name ?? order.sellerName ?? '—';
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        StatusHeader(order: order),
        SizedBox(height: 16.h),
        SectionWidget(
          title: 'Parties',
          rows: [
            InfoRow(label: 'Customer', value: order.customerName ?? order.customerId),
            InfoRow(label: 'Seller', value: sellerName),
            InfoRow(label: 'Created', value: formatDate(order.createdAt)),
            InfoRow(label: 'Last update', value: formatDate(order.updatedAt)),
          ],
        ),
        SizedBox(height: 12.h),
        ItemsCard(order: order),
        SizedBox(height: 12.h),
        SectionWidget(
          title: 'Totals',
          rows: [
            InfoRow(label: 'Subtotal', value: formatMoney(order.subtotal, order.currency)),
            InfoRow(label: 'Delivery fee', value: formatMoney(order.deliveryFee, order.currency)),
            InfoRow(label: 'Commission', value: '${formatMoney(order.commission, order.currency)} ''(${(order.commissionRate * 100).toStringAsFixed(1)}%)'),
            InfoRow(label: 'Seller earning', value: formatMoney(order.sellerEarning, order.currency)),
            InfoRow(label: 'Total', value: formatMoney(order.totalPrice, order.currency)),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: 'Payment',
          rows: [
            InfoRow(label: 'Method', value: order.paymentMethod),
            InfoRow(label: 'Status', value: order.paymentStatus),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: 'Shipping',
          rows: [
            InfoRow(label: 'Street', value: order.shippingAddress.street),
            InfoRow(label: 'City', value: order.shippingAddress.city),
            InfoRow(label: 'Governorate', value: order.shippingAddress.governorate),
            InfoRow(label: 'Country', value: order.shippingAddress.country),
            InfoRow(label: 'Zip', value: order.shippingAddress.zipCode),
          ],
        ),
        SizedBox(height: 20.h),
        StatusActionsButtons(order: order, cubit: cubit, isBusy: isBusy),
        SizedBox(height: 50.h),
      ],
    );
  }
}

class InfoRow {
  final String label;
  final String value;

  const InfoRow({required this.label, required this.value});
}
