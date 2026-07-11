import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/custom_elevated_button.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/logic/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/ui/widgets/order_status_slider.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/ui/widgets/order_summary.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/ui/widgets/product_item_of_order.dart';

class CustomerOrderDetailsScreen extends StatelessWidget {
  final CustomerOrderModel order;
  const CustomerOrderDetailsScreen({super.key, required this.order});

  String _currencyLabel(BuildContext context) => order.payment.currency ?? context.l10n.egp;

  String _customerName(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;
    final orderName = order.customer.name.trim();
    final profileName = authUser?.displayName?.trim() ?? '';

    if (orderName.isNotEmpty) return orderName;
    if (profileName.isNotEmpty) return profileName;
    return _customerEmail(context);
  }

  String _customerEmail(BuildContext context) {
    final authUser = FirebaseAuth.instance.currentUser;
    final orderEmail = order.customer.email.trim();
    final profileEmail = authUser?.email?.trim() ?? '';

    if (orderEmail.isNotEmpty) return orderEmail;
    if (profileEmail.isNotEmpty) return profileEmail;
    return context.l10n.unknownCustomer;
  }

  Future<void> _cancelOrder(BuildContext context) async {
    if (order.status != OrderStatus.pending) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.onlyPendingOrdersCanBeCancelled)),
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: customerbackGroundColor,

          title: Text(context.l10n.cancelOrderQuestion),
          content: Text(
            context.l10n.cancelOrderWarning,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(context.l10n.no, style: TextStyle(color: subTitleColor)),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(context.l10n.yes, style: TextStyle(color: redDegree)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

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
              context.l10n.placedOn(order.orderDate.toLocal().toString().split(' ').first),
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
                    context.l10n.orderItems(order.products.length),
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
                            context.l10n.deliveryAddressSection,
                            style: AppTextStyles.t_14w700,
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(_customerName(context), maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.t_14w700),
                      if (_customerEmail(context) != _customerName(context))
                        Text(
                          _customerEmail(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.t_14w400.copyWith(
                            color: subTitleColor,
                          ),
                        ),
                      Text(
                        order.address.addressdescription,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
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
                        "${context.l10n.zip}:${order.address.zipCode.toString()}",
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
                currency: _currencyLabel(context),
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
                        context.l10n.cancelOrder,
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
                  context.l10n.ordersCanOnlyBeCancelledWhenPending,
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
