import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/addresscolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/cartproductitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/copounrow.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/paymentcolumn.dart';

class CustomerCartScreen extends StatelessWidget {
  // before get into this page it should trigger cubit to get the cubit to get the order products and calculate total & deleviryfee
  final OrderModel order;
  const CustomerCartScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: customerbackGroundColor,
              scrolledUnderElevation: 0,
              centerTitle: true,

              title: Text(
                'Your Cart',

                style: TextStyle(
                  color: blackDegree,
                  fontSize: 18.sp,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.56,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0).h,
                child: Divider(color: commonColor.withValues(alpha: .05)),
              ),
            ),
            SliverList.builder(
              itemBuilder: (context, index) {
                return CartProductItem(product: order.products[index]);
              },
              itemCount: order.products.length,
            ),
            SliverToBoxAdapter(child: OrderSummary(order: order)),

            SliverToBoxAdapter(child: CopounRow()),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0).h,
                child: AddressColumn(order: order),
              ),
            ),
            SliverToBoxAdapter(child: PaymentColumn()),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.only(top: 80, bottom: 30).h,
                child: Column(
                  children: [
                    Divider(color: commonColor.withValues(alpha: .05)),

                    CustomElevatedButton(
                      buttoncolor: commonColor,
                      onPressed: () {},
                      child: Text(
                        'Proceed to Checkout',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Plus Jakarta Sans',
                          fontWeight: FontWeight.w700,
                          height: 1.50,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
