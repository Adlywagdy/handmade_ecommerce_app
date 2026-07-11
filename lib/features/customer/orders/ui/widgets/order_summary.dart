import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/ui/widgets/order_details_row.dart';

class OrderSummary extends StatelessWidget {
  final String currency;
  final double? subtotalPrice;
  final double? totalPrice;
  final double? deliveryFee;
  final double? discount;

  const OrderSummary({
    super.key,
    this.currency = 'EGP',
    required this.subtotalPrice,
    required this.totalPrice,
    required this.deliveryFee,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: commonColor.withValues(alpha: .05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        spacing: 12.h,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.orderSummary, style: AppTextStyles.t_18w700),

          OrderDetailsRow(
            title: context.l10n.subtotal,
            valuestyle: AppTextStyles.t_14w500,
            titlestyle: AppTextStyles.t_14w400.copyWith(
              color: darkblue.withValues(alpha: .9),
            ),
            value: '$currency ${subtotalPrice?.toStringAsFixed(2) ?? '0.00'}',
          ),
          OrderDetailsRow(
            title: context.l10n.deliveryFee,
            valuestyle: AppTextStyles.t_14w500,
            titlestyle: AppTextStyles.t_14w400.copyWith(
              color: darkblue.withValues(alpha: .9),
            ),
            value: '$currency ${deliveryFee?.toStringAsFixed(2) ?? '0.00'}',
          ),
          OrderDetailsRow(
            title: context.l10n.discount,
            valuestyle: AppTextStyles.t_14w500.copyWith(color: greenDegree),
            titlestyle: AppTextStyles.t_14w400.copyWith(
              color: darkblue.withValues(alpha: .9),
            ),
            value: '- $currency ${discount?.toStringAsFixed(2) ?? '0.00'}',
          ),
          Divider(color: commonColor.withValues(alpha: .1)),
          OrderDetailsRow(
            title: context.l10n.totalAmount,
            titlestyle: AppTextStyles.t_18w700,
            valuestyle: AppTextStyles.t_20w700.copyWith(color: commonColor),
            value: '$currency ${totalPrice?.toStringAsFixed(2) ?? '0.00'}',
          ),
        ],
      ),
    );
  }
}
