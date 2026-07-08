import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/cubit/locale_cubit.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customelevatedbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/logic/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/product_details/ui/widgets/productdetailslowercolumn.dart';
import 'package:share_plus/share_plus.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

class CustomerProductDetailsScreen extends StatelessWidget {
  final ProductModel product;
  const CustomerProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<LocaleCubit>().state?.languageCode == 'ar';

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
                      text: context.l10n.checkOutThisProduct(
                        product.localizedName(isArabic),
                        'EGP ${product.price}',
                      ),
                    ),
                  );
                },
              ),
            ],
            title: Text(
              context.l10n.productDetails,
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
              height: 450.h,
              constraints: BoxConstraints(maxHeight: 500.h, minHeight: 300.h),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      product.localizedName(isArabic),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.t_24w700.copyWith(
                        color: blackDegree,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'EGP ${product.price}',
                      style: AppTextStyles.t_20w700.copyWith(
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
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: ProductDetailsLowerColumn(product: product),
            ),
          ),

          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Row(
                spacing: 5.w,
                children: [
                  Expanded(
                    flex: 1,
                    child: CustomElevatedButton(
                      onPressed: () async {
                        await context.read<CartCubit>().addCartProducts(
                          product,
                        );
                        if (context.mounted) {
                          Get.toNamed(AppRoutes.customerCart);
                        }
                      },
                      buttoncolor: commonColor,
                      child: Text(
                        context.l10n.buyNow,
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
                      onPressed: () async {
                        await context.read<CartCubit>().addCartProducts(
                          product,
                        );
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
                                  context.l10n.added,
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
                                context.l10n.addToCart,
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
          ),
        ],
      ),
    );
  }
}
