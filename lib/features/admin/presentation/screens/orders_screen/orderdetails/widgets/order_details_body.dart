import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
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

  const OrderDetailsBody({super.key, required this.order, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final bool isBusy = cubit.isProcessing(order.id);
    final String sellerName =
        cubit.sellerById(order.sellerId)?.name ?? order.sellerName ?? '—';
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        StatusHeader(order: order),
        SizedBox(height: 16.h),
        SectionWidget(
          title: context.l10n.parties,
          rows: [
            InfoRow(
              label: context.l10n.customer,
              value: order.customerName ?? order.customerId,
            ),
            InfoRow(label: context.l10n.seller, value: sellerName),
            InfoRow(
              label: context.l10n.created,
              value: formatDate(order.createdAt),
            ),
            InfoRow(
              label: context.l10n.lastUpdate,
              value: formatDate(order.updatedAt),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ItemsCard(order: order),
        SizedBox(height: 12.h),
        SectionWidget(
          title: context.l10n.totals,
          rows: [
            InfoRow(
              label: context.l10n.subtotal,
              value: formatMoney(order.subtotal, order.currency),
            ),
            InfoRow(
              label: context.l10n.deliveryFeeLower,
              value: formatMoney(order.deliveryFee, order.currency),
            ),
            InfoRow(
              label: context.l10n.commission,
              value:
                  '${formatMoney(order.commission, order.currency)} '
                  '(${(order.commissionRate * 100).toStringAsFixed(1)}%)',
            ),
            InfoRow(
              label: context.l10n.sellerEarning,
              value: formatMoney(order.sellerEarning, order.currency),
            ),
            InfoRow(
              label: context.l10n.total,
              value: formatMoney(order.totalPrice, order.currency),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: context.l10n.payment,
          rows: [
            InfoRow(label: context.l10n.method, value: order.paymentMethod),
            InfoRow(label: context.l10n.status, value: order.paymentStatus),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: context.l10n.shipping,
          rows: [
            InfoRow(
              label: context.l10n.street,
              value: order.shippingAddress.street,
            ),
            InfoRow(
              label: context.l10n.city,
              value: order.shippingAddress.city,
            ),
            InfoRow(
              label: context.l10n.governorate,
              value: order.shippingAddress.governorate,
            ),
            InfoRow(
              label: context.l10n.country,
              value: order.shippingAddress.country,
            ),
            InfoRow(
              label: context.l10n.zip,
              value: order.shippingAddress.zipCode,
            ),
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
