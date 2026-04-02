
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

class ProductItemOfOrder extends StatelessWidget {
  const ProductItemOfOrder({super.key, required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: commonColor.withValues(alpha: .02),

        border: Border.all(color: commonColor.withValues(alpha: .05)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.all(12.w),
      child: Row(
        spacing: 16.w,

        children: [
          Expanded(
            flex: 1,
            child: Card(
              elevation: 0,
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                order.products[0].images[0],
                height: 100.h,
                width: 100.w,
                fit: BoxFit.fill,
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.products[0].name,
                  style: TextStyle(
                    color: blackDegree,
                    fontSize: 16.sp,

                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  'Indigo Blue • Large',
                  style: TextStyle(
                    color: subTitleColor,
                    fontSize: 12.sp,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${order.products[0].price.toString()}',
                      style: TextStyle(
                        color: const Color(0xFF8B4513),
                        fontSize: 16.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
                    ),
                    Card(
                      color: Colors.white.withValues(alpha: .5),
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0).r,
                        child: Text(
                          'Qty: ${order.products[0].quantity}',
                          style: TextStyle(
                            color: blackDegree,
                            fontSize: 12.sp,
                            fontFamily: 'Plus Jakarta Sans',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
