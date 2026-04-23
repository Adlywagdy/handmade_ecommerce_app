import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/order_cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/orderstatusslider.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/ordersummary.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productitemoforder.dart';

class CustomerOrderDetailsScreen extends StatelessWidget {
  final CustomerOrderModel order;
  const CustomerOrderDetailsScreen({super.key, required this.order});

  String get _currencyLabel => order.payment.currency ?? 'EGP';

  String get _customerName {
    final authUser = FirebaseAuth.instance.currentUser;
    final orderName = order.customer.name.trim();
    final profileName = authUser?.displayName?.trim() ?? '';

    if (orderName.isNotEmpty) return orderName;
    if (profileName.isNotEmpty) return profileName;
    return _customerEmail;
  }

  String get _customerEmail {
    final authUser = FirebaseAuth.instance.currentUser;
    final orderEmail = order.customer.email.trim();
    final profileEmail = authUser?.email?.trim() ?? '';

    if (orderEmail.isNotEmpty) return orderEmail;
    if (profileEmail.isNotEmpty) return profileEmail;
    return 'Unknown Customer';
  }

  Future<void> _cancelOrder(BuildContext context) async {
    if (order.status != OrderStatus.pending) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Only pending orders can be cancelled.')),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: customerbackGroundColor,

          title: const Text('Cancel order?'),
          content: const Text(
            'This order will be cancelled and cannot be restored.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('No', style: TextStyle(color: subTitleColor)),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Yes', style: TextStyle(color: redDegree)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await context.read<OrderCubit>().cancelOrder(order.orderid);
  }

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
                  child: ProductItemOfOrder(
                    product: order.products[index],
                    order: order,
                  ),
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
                      Text(_customerName, style: AppTextStyles.t_14w700),
                      if (_customerEmail != _customerName)
                        Text(
                          _customerEmail,
                          style: AppTextStyles.t_14w400.copyWith(
                            color: subTitleColor,
                          ),
                        ),
                      Text(
                        order.address.addressdescription,
                        style: AppTextStyles.t_14w400.copyWith(
                          color: subTitleColor,
                        ),
                      ),
                      order.address.city != null
                          ? Text(
                              "${order.address.city}, ${order.address.country}",
                              style: AppTextStyles.t_14w400.copyWith(
                                color: subTitleColor,
                              ),
                            )
                          : SizedBox(),
                      Text(
                        "zipCode:${order.address.zipCode.toString()}",
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
                currency: _currencyLabel,
                subtotalPrice: order.payment.subtotalPrice,
                totalPrice: order.payment.totalPrice,
                deliveryFee: order.payment.deliveryFee,
                discount: order.payment.discount,
              ),
            ),
            if (order.status == OrderStatus.pending)
              SliverToBoxAdapter(
                child: CustomElevatedButton(
                  onPressed: () => _cancelOrder(context),
                  buttoncolor: Colors.white,
                  bordercolor: redDegree,
                  child: Row(
                    spacing: 8.w,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined, color: redDegree, size: 24.r),
                      Text(
                        'Cancel Order',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.t_16w700.copyWith(
                          color: redDegree,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
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
