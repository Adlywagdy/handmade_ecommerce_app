import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/cubit/wishlist_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/presentation/widgets/searchedproductitemlowercolumn.dart';

class CustomerWishlistScreen extends StatelessWidget {
  const CustomerWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              pinned: true,
              backgroundColor: customerbackGroundColor,
              scrolledUnderElevation: 0,
              centerTitle: true,

              title: Text(
                'Your Wishlist',
                style: AppTextStyles.t_18w700.copyWith(color: blackDegree),
              ),
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                await BlocProvider.of<WishListCubit>(
                  context,
                ).getWishlistProducts();
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
                margin: EdgeInsets.only(bottom: 14.h),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  gradient: LinearGradient(
                    colors: [
                      commonColor.withValues(alpha: .12),
                      commonColor.withValues(alpha: .05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: commonColor.withValues(alpha: .14)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42.w,
                      height: 42.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: .8),
                      ),
                      child: Icon(
                        Icons.favorite_rounded,
                        color: commonColor,
                        size: 22.r,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<WishListCubit, WishListState>(
                            buildWhen: (previous, current) {
                              return current is GetWishlistLoadingstate ||
                                  current is GetWishlistFailedstate ||
                                  current is GetWishlistSuccessedstate;
                            },
                            builder: (context, state) {
                              final productsCount =
                                  state is GetWishlistSuccessedstate
                                  ? state.wishlistproducts.length
                                  : BlocProvider.of<WishListCubit>(
                                      context,
                                    ).wishlistProductsList.length;

                              return Text(
                                '$productsCount saved items',
                                style: AppTextStyles.t_16w700.copyWith(
                                  color: blackDegree,
                                ),
                              );
                            },
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Your favorite products are ready anytime.',
                            style: AppTextStyles.t_12w500.copyWith(
                              color: subTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            BlocBuilder<WishListCubit, WishListState>(
              buildWhen: (previous, current) {
                return current is GetWishlistLoadingstate ||
                    current is GetWishlistFailedstate ||
                    current is GetWishlistSuccessedstate ||
                    current is AddOrDeleteWishlistSuccessedstate;
              },
              builder: (context, state) {
                if (state is GetWishlistFailedstate) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Failed to load wishlist. Please try again.',
                        style: AppTextStyles.t_14w500.copyWith(
                          color: redDegree,
                        ),
                      ),
                    ),
                  );
                } else if (state is GetWishlistSuccessedstate &&
                    state.wishlistproducts.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Text(
                        'Your wishlist is empty. \nStart adding your favorite products!',
                        textAlign: .center,
                        style: AppTextStyles.t_14w500.copyWith(
                          color: subTitleColor,
                        ),
                      ),
                    ),
                  );
                } else if (state is GetWishlistSuccessedstate) {
                  return SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.8,
                    ),
                    itemCount: state.wishlistproducts.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8.0).w,
                        child: ProductItem(
                          cardclipBehavior: .antiAlias,
                          product: state.wishlistproducts[index],
                          imageflex: 2,
                          lowercolumnflex: 1,
                          elevation: 0,
                          imageclipBehavior: Clip.antiAlias,
                          lowercolumnbottompadding: 7.h,
                          lowercolumntoppadding: 7.h,
                          lowercolumnleftpadding: 8,
                          lowercolumnrightpadding: 8,
                          lowercolumn: SearchedProductItemLowerColumn(
                            product: state.wishlistproducts[index],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      childCount: 4,
                      (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0).w,
                        child: SvgPicture.asset(
                          "assets/images/loadingCard.svg",
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50.h)),
          ],
        ),
      ),
    );
  }
}
