import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class OrderSummary extends StatelessWidget {
  final OrderModel order;
  const OrderSummary({super.key, required this.order});

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
          Text(
            'Order Summary',
            style: TextStyle(
              color: blackDegree,
              fontSize: 18.sp,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.56,
            ),
          ),

          OrderDetailsRow(
            title: 'Subtotal',
            value: '\$${order.payment?.subtotalPrice?.toStringAsFixed(2)}',
          ),
          OrderDetailsRow(
            title: 'Delivery Fee',
            value: '\$${order.payment?.deliveryFee?.toStringAsFixed(2)}',
          ),
          OrderDetailsRow(
            title: 'Discount',
            value: '\$${order.payment?.discount?.toStringAsFixed(2)}',
          ),
          Divider(color: commonColor.withValues(alpha: .05)),
          OrderDetailsRow(
            title: 'Total Amount',
            titlefontSize: 16,
            titlecolor: blackDegree,
            valuecolor: commonColor,
            titlefontWeight: FontWeight.w700,
            valuefontWeight: FontWeight.w800,
            valuefontSize: 20,
            value: '\$${order.payment?.totalPrice?.toStringAsFixed(2)}',
          ),
        ],
      ),
    );
  }
}

class OrderDetailsRow extends StatelessWidget {
  final String title;
  final String value;
  final Color? titlecolor;
  final Color? valuecolor;
  final double? titlefontSize;
  final FontWeight? titlefontWeight;
  final FontWeight? valuefontWeight;
  final double? valuefontSize;
  const OrderDetailsRow({
    super.key,
    required this.title,
    required this.value,
    this.titlecolor = darkblue,
    this.valuecolor = blackDegree,
    this.titlefontSize = 14,
    this.titlefontWeight = FontWeight.w400,
    this.valuefontWeight = FontWeight.w500,
    this.valuefontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: titlecolor,
            fontSize: titlefontSize!.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: titlefontWeight,
            height: 1.43,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valuecolor,
            fontSize: valuefontSize!.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: valuefontWeight,
            height: 1.43,
          ),
        ),
      ],
    );
  }
}
