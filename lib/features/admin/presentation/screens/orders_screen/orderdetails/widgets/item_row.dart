import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/models/orders_model.dart';
import 'formatters.dart';

class ItemRow extends StatelessWidget {
  final OrderItemModel item;
  final String currency;
  const ItemRow({super.key, required this.item, required this.currency});
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  '${item.quantity} × ${formatMoney(item.price, currency)}',
                  style: TextStyle(fontSize: 11.sp, color: subTitleColor),
                ),
              ],
            ),
          ),
          Text(
            formatMoney(item.subtotal, currency),
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
        ],
      ),
    );
  }
}
