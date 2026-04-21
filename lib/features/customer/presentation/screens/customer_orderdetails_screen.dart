import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/orderstatusslider.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productitemoforder.dart';

class CustomerOrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  const CustomerOrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: blackDegree),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.orderid, style: AppTextStyles.t_18w700),
            Text(
              'Placed on ${order.orderDate.toLocal().toString().split(' ').first}',
              style: AppTextStyles.t_12w400.copyWith(color: subTitleColor),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                    color: commonColor.withValues(alpha: .1),
                    height: 1.h,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32.0).h,
                    child: OrderStatusSlider(orderstatus: order.status),
                  ),
                  Text(
                    'ORDER ITEMS (${order.products.length})',
                    style: AppTextStyles.t_16w700,
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),

            SliverList.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0).h,
                  child: ProductItemOfOrder(product: order.products[index]),
                );
              },
              itemCount: order.products.length,
            ),
            SliverToBoxAdapter(
              child: Card(
                color: commonColor.withValues(alpha: .02),
                elevation: 0,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                  side: BorderSide(
                    color: commonColor.withValues(alpha: .1),
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0).h,
                  child: Column(
                    spacing: 4.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8.w,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: commonColor,
                            size: 26.r,
                          ),
                          Text(
                            'DELIVERY ADDRESS',
                            style: AppTextStyles.t_14w700,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(order.customer.name, style: AppTextStyles.t_14w700),
                      Text(
                        order.customer.address?.addressdescription ?? '',
                        style: AppTextStyles.t_14w400.copyWith(
                          color: subTitleColor,
                        ),
                      ),
                      Text(
                        order.customer.address?.city ?? '',
                        style: AppTextStyles.t_14w400.copyWith(
                          color: subTitleColor,
                        ),
                      ),
                      Text(
                        order.customer.phone,
                        style: AppTextStyles.t_14w400.copyWith(
                          color: subTitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: OrderSummary(
                subtotalPrice: order.payment.subtotalPrice,
                totalPrice: order.payment.totalPrice,
                deliveryFee: order.payment.deliveryFee,
                discount: order.payment.discount,
              ),
            ),
            SliverToBoxAdapter(
              child: CustomElevatedButton(
                onPressed: () {},
                buttoncolor: Colors.white,
                bordercolor: redDegree,
                child: Row(
                  spacing: 8.w,
                  mainAxisAlignment: .center,
                  children: [
                    Icon(Icons.cancel_outlined, color: redDegree, size: 24.r),
                    Text(
                      'Cancel Order',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.t_16w700.copyWith(color: redDegree),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(
              child: Text(
                "Orders can only be cancelled while in 'Pending' status.",
                textAlign: TextAlign.center,
                style: AppTextStyles.t_10w400.copyWith(color: subTitleColor),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 25.h)),
          ],
        ),
      ),
    );
  }
}
