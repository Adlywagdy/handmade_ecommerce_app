import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/addresscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/cartproductitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/orderitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/orderstatusslider.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productitemoforder.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/reviewedproduct.dart';

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
        title: Column(
          children: [
            Text(
              'Order #AY-9402',
              style: TextStyle(
                color: blackDegree,
                fontSize: 18.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            Text(
              'Placed on Oct 24, 2023',
              style: TextStyle(
                color: subTitleColor,
                fontSize: 12.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
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
                    child: OrderStatusSlider(
                      orderstatus: OrderStatus.confirmed,
                    ),
                  ),
                  Text(
                    'ORDER ITEMS (${order.products.length})',
                    style: TextStyle(
                      color: blackDegree,
                      fontSize: 16.sp,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      height: 1.43,
                      letterSpacing: 1.40,
                    ),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),

            SliverList.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0).h,
                  child: ProductItemOfOrder(order: order),
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
                            style: TextStyle(
                              color: blackDegree,
                              fontSize: 14.sp,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w700,
                              height: 1.43,
                              letterSpacing: 1.40,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        order.customer.name,
                        style: TextStyle(
                          color: blackDegree,
                          fontSize: 14.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          height: 1.43,
                        ),
                      ),
                      Text(
                        order.customer.address?.addressdescription ??
                            "123 Main St, City, Country",
                        style: TextStyle(
                          color: subTitleColor,
                          fontSize: 14.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      Text(
                        order.customer.address?.city ?? "Cairo, Egypt",
                        style: TextStyle(
                          color: subTitleColor,
                          fontSize: 14.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                      Text(
                        order.customer.phone ?? "+20 123 456 7890",
                        style: TextStyle(
                          color: subTitleColor,
                          fontSize: 14.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w400,
                          height: 1.43,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: OrderSummary(order: order)),
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
                      style: TextStyle(
                        color: redDegree,
                        fontSize: 16.sp,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                      ),
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
                style: TextStyle(
                  color: subTitleColor,
                  fontSize: 10.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 25.h)),
          ],
        ),
      ),
    );
  }
}
