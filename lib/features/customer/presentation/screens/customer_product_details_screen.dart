import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/cart/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/productdetailslowercolumn.dart';
import 'package:share_plus/share_plus.dart';

class CustomerProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const CustomerProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,

      body: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: customerbackGroundColor,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: commonColor),
            ),
            centerTitle: true,
            actions: [
              CustomIconButton(
                backgroundColor: customerbackGroundColor,
                icon: Icons.share_outlined,
                iconcolor: commonColor,
                onPressed: () {
                  SharePlus.instance.share(
                    ShareParams(
                      text:
                          'check out this product: ${product.name} for \$${product.price} at our store!',
                    ),
                  );
                },
              ),
            ],
            title: Text(
              'Product Details',
              textAlign: TextAlign.center,
              style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
            },
            builder:
                (
                  context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                ) {
                  return CupertinoSliverRefreshControl.buildRefreshIndicator(
                    context,
                    refreshState,
                    pulledExtent,
                    refreshTriggerPullDistance,
                    refreshIndicatorExtent,
                  );
                },
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 490.h,
              constraints: BoxConstraints(maxHeight: 550.h, minHeight: 350.h),
              child: ProductItem(
                product: product,
                imageflex: 3.h.toInt(),
                lowercolumnflex: 1.h.toInt(),
                elevation: 0,
                lowercolumnbottompadding: 0.h,
                lowercolumnleftpadding: 16.w,
                lowercolumnrightpadding: 16.w,
                cardclipBehavior: Clip.none,
                lowercolumn: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,

                      style: AppTextStyles.t_30w700.copyWith(
                        color: blackDegree,
                      ),
                    ),
                    Text(
                      '\$${product.price}',
                      style: AppTextStyles.t_24w700.copyWith(
                        color: commonColor,
                      ),
                    ),
                    Divider(
                      color: commonColor.withValues(alpha: .1),
                      height: 24.h,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ProductDetailsLowerColumn(product: product),
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 16.w,
                  ),
                  child: Row(
                    spacing: 5.w,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomElevatedButton(
                          onPressed: () {
                            BlocProvider.of<CartCubit>(
                              context,
                            ).addCartProducts(product);
                            Get.toNamed(AppRoutes.customerCart);
                          },
                          buttoncolor: commonColor,
                          child: Text(
                            'Buy Now',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.t_16w600.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: CustomElevatedButton(
                          buttoncolor: Colors.white,
                          bordercolor: commonColor.withValues(alpha: .35),
                          onPressed: () {
                            BlocProvider.of<CartCubit>(
                              context,
                            ).addCartProducts(product);
                          },
                          child: BlocBuilder<CartCubit, CartState>(
                            buildWhen: (previous, current) {
                              return current is AddcartproductSuccessedstate ||
                                  current is AddcartproductFailedstate ||
                                  current is AddcartproductLoadingstate;
                            },
                            builder: (context, state) {
                              if (state is AddcartproductLoadingstate) {
                                return CircularProgressIndicator(
                                  color: commonColor,
                                  strokeWidth: 1.5,
                                );
                              }
                              if (state is AddcartproductSuccessedstate) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check,
                                      color: commonColor,
                                      size: 16.r,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      'Added',
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.t_16w600.copyWith(
                                        color: commonColor,
                                      ),
                                    ),
                                  ],
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_bag_outlined,
                                    color: commonColor,
                                    size: 16.r,
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Add to Cart',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.t_16w600.copyWith(
                                      color: commonColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
