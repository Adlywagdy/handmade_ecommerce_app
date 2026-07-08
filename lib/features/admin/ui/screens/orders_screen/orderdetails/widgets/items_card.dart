import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/admin/data/models/orders_model.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import 'item_row.dart';

class ItemsCard extends StatelessWidget {
  final OrderModel order;
  const ItemsCard({super.key, required this.order});
  @override
  Widget build(BuildContext context) {
    final bool hasNoItems = order.items.isEmpty;
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
            AppLocalizations.of(context)!.admItemsLabel(order.items.length),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: blackDegree,
            ),
          ),
          SizedBox(height: 10.h),

          if (hasNoItems)
            Text(
              AppLocalizations.of(context)!.admNoLineItems,
              style: TextStyle(fontSize: 13.sp, color: subTitleColor),
            )
          else
            ...order.items.map(
              (item) => ItemRow(item: item, currency: order.currency),
            ),
        ],
      ),
    );
  }
}
