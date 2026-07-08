import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/logic/admin_cubit.dart';
import 'package:handmade_ecommerce_app/features/admin/data/models/orders_model.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
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
          title: AppLocalizations.of(context)!.admSectionParties,
          rows: [
            InfoRow(
              label: AppLocalizations.of(context)!.admCustomerLabel,
              value: order.customerName ?? order.customerId,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admSellerLabelDetails,
              value: sellerName,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admCreatedLabel,
              value: formatDate(order.createdAt),
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admLastUpdateLabel,
              value: formatDate(order.updatedAt),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        ItemsCard(order: order),
        SizedBox(height: 12.h),
        SectionWidget(
          title: AppLocalizations.of(context)!.admSectionTotals,
          rows: [
            InfoRow(
              label: AppLocalizations.of(context)!.admSubtotalLabel,
              value: formatMoney(order.subtotal, order.currency),
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admDeliveryFeeLabel,
              value: formatMoney(order.deliveryFee, order.currency),
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admCommissionLabel,
              value:
                  '${formatMoney(order.commission, order.currency)} '
                  '(${(order.commissionRate * 100).toStringAsFixed(1)}%)',
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admSellerEarningLabel,
              value: formatMoney(order.sellerEarning, order.currency),
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admTotalLabel,
              value: formatMoney(order.totalPrice, order.currency),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: AppLocalizations.of(context)!.admSectionPayment,
          rows: [
            InfoRow(
              label: AppLocalizations.of(context)!.admPaymentMethodLabel,
              value: order.paymentMethod,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admPaymentStatusLabel,
              value: order.paymentStatus,
            ),
          ],
        ),
        SizedBox(height: 12.h),
        SectionWidget(
          title: AppLocalizations.of(context)!.admSectionShipping,
          rows: [
            InfoRow(
              label: AppLocalizations.of(context)!.admStreetLabel,
              value: order.shippingAddress.street,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admCityLabel,
              value: order.shippingAddress.city,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admGovernorateLabel,
              value: order.shippingAddress.governorate,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admCountryLabel,
              value: order.shippingAddress.country,
            ),
            InfoRow(
              label: AppLocalizations.of(context)!.admZipLabel,
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
