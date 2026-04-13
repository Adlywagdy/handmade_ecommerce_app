import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/orderdetailsrow.dart';

class OrderSummary extends StatelessWidget {
  final PaymentDetailsModel orderPaymentDetails;
  const OrderSummary({super.key, required this.orderPaymentDetails});

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
          Text('Order Summary', style: AppTextStyles.t_18w700),

          OrderDetailsRow(
            title: 'Subtotal',
            valuestyle: AppTextStyles.t_14w500,
            titlestyle: AppTextStyles.t_14w400.copyWith(
              color: darkblue.withValues(alpha: .9),
            ),
            value: '\$${orderPaymentDetails.subtotalPrice?.toStringAsFixed(2)}',
          ),
          OrderDetailsRow(
            title: 'Delivery Fee',
            valuestyle: AppTextStyles.t_14w500,
            titlestyle: AppTextStyles.t_14w400.copyWith(
              color: darkblue.withValues(alpha: .9),
            ),
            value: '\$${orderPaymentDetails.deliveryFee?.toStringAsFixed(2)}',
          ),
          OrderDetailsRow(
            title: 'Discount',
            valuestyle: AppTextStyles.t_14w500.copyWith(color: greenDegree),
            titlestyle: AppTextStyles.t_14w400.copyWith(
              color: darkblue.withValues(alpha: .9),
            ),
            value: '- \$${orderPaymentDetails.discount?.toStringAsFixed(2)}',
          ),
          Divider(color: commonColor.withValues(alpha: .1)),
          OrderDetailsRow(
            title: 'Total Amount',
            titlestyle: AppTextStyles.t_18w700,
            valuestyle: AppTextStyles.t_20w700.copyWith(color: commonColor),
            value: '\$${orderPaymentDetails.totalPrice?.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}
