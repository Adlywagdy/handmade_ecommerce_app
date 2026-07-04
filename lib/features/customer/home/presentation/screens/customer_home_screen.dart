import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/searchfield.dart';
import 'package:handmade_ecommerce_app/features/customer/home/cubit/home_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/home/presentation/widgets/categorieslist.dart';
import 'package:handmade_ecommerce_app/features/customer/home/presentation/widgets/customfeaturerow.dart';
import 'package:handmade_ecommerce_app/features/customer/home/presentation/widgets/featuredproductitemlowercolumn.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/home/presentation/widgets/topratedproductitemlowercolumn.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/cubit/wishlist_cubit.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  void _openAllCategoriesSheet(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final wishListCubit = context.read<WishListCubit>();
    final categories = searchCubit.categoriesList;

    showModalBottomSheet(
      context: context,
      backgroundColor: customerbackGroundColor,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16.h),
                Center(
                  child: Container(
                    width: 44.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: commonColor.withValues(alpha: .2),
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'All Categories',
                  style: AppTextStyles.t_18w700.copyWith(color: commonColor),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 10.w,
                  runSpacing: 10.h,
                  children: List.generate(categories.length, (index) {
                    final category = categories[index];
                    return GestureDetector(
                      onTap: () {
                        searchCubit.selectedCategory = category;
                        searchCubit.filterproducts(
                          categoryname: category.categorytitle,
                        );
                        Get.back();
                        Get.toNamed(
                          AppRoutes.customerSearch,
                          arguments: {
                            'searchCubit': searchCubit,
                            'wishListCubit': wishListCubit,
                          },
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ).w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.r),
                          color: commonColor.withValues(alpha: 0.1),
                        ),
                        child: Text(
                          category.categorytitle,
                          style: AppTextStyles.t_14w600.copyWith(
                            color: commonColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0).w,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          primary: true,
          slivers: [
            SliverAppBar(
              actionsPadding: const EdgeInsets.only(right: 8.0).w,
              backgroundColor: customerbackGroundColor,
              pinned: true,
              scrolledUnderElevation: 0,
              centerTitle: true,
              title: Text(
                'Ayady',
                style: AppTextStyles.t_20w700.copyWith(color: commonColor),
              ),
              actions: [
                CustomIconButton(
                  backgroundColor: customerbackGroundColor,
                  icon: Icons.notifications_none,
                  iconcolor: darkblue,
                  onPressed: () {
                    final customerCubit = BlocProvider.of<CustomerCubit>(
                      context,
                    );
                    customerCubit.getNotifications();
                    Get.toNamed(
                      AppRoutes.customerNotifications,
                      arguments: customerCubit,
                    );
                  },
                ),
              ],
            ),
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                BlocProvider.of<HomeCubit>(context).getTopRatedProducts();
                BlocProvider.of<SearchCubit>(context).getCategories();
                BlocProvider.of<HomeCubit>(context).getFeaturedProducts();
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
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0).w,
                child: SearchField(
                  autofocus: false,
                  hintText: "Search unique handmade crafts",
                  textstyle: AppTextStyles.t_12w500.copyWith(
                    color: commonColor.withValues(alpha: .6),
                  ),
                  readOnly: true,
                  onTap: () {
                    final searchCubit = BlocProvider.of<SearchCubit>(context);
                    final wishListCubit = BlocProvider.of<WishListCubit>(
                      context,
                    );
                    searchCubit.resetSearchState();
                    Get.toNamed(
                      AppRoutes.customerSearch,
                      arguments: {
                        'searchCubit': searchCubit,
                        'wishListCubit': wishListCubit,
                      },
                    );
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(right: 16.w, bottom: 12.h),
                child: CustomFeatureRow(
                  title: "Categories",
                  buttontext: "See All",
                  onTap: () => _openAllCategoriesSheet(context),
                  buttontextstyle: AppTextStyles.t_14w600.copyWith(
                    color: commonColor,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 107.h,
                constraints: BoxConstraints(minHeight: 105.h, maxHeight: 110.h),
                child: BlocBuilder<SearchCubit, SearchState>(
                  buildWhen: (previous, current) {
                    return current is GetCategoriesLoadingstate ||
                        current is GetCategoriesSuccessedstate ||
                        current is GetCategoriesFailedstate;
                  },
                  builder: (context, state) {
                    if (state is GetCategoriesSuccessedstate) {
                      return HomeCategoriesList();
                    } else if (state is GetCategoriesFailedstate) {
                      showSnack(title: "Error", message: state.errorMessage);
                      return SizedBox(height: 100.h);
                    } else {
                      return Center(
                        child: CircularProgressIndicator(color: commonColor),
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 14.h),
                  Text(
                    'Featured Products',
                    style: AppTextStyles.t_20w700.copyWith(color: blackDegree),
                  ),
                  Text(
                    'Handpicked for your style',
                    style: AppTextStyles.t_14w400.copyWith(
                      color: darkblue.withValues(alpha: .75),
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 397.h,
                constraints: BoxConstraints(minHeight: 395.h, maxHeight: 400.h),
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) {
                    return current is GetFeaturedLoadingstate ||
                        current is GetFeaturedSuccessedstate ||
                        current is GetFeaturedFailedstate;
                  },
                  builder: (context, state) {
                    if (state is GetFeaturedSuccessedstate) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: AspectRatio(
                              aspectRatio: .83,
                              child: ProductItem(
                                cardmargin: 5,
                                cardclipBehavior: .antiAlias,
                                imageflex: 3,
                                lowercolumnflex: 2,
                                lowercolumntoppadding: 16.h,
                                lowercolumnbottompadding: 16.h,
                                lowercolumnleftpadding: 16,
                                lowercolumnrightpadding: 16,
                                product: state.products[index],
                                lowercolumn: FeaturedProductItemLowerColumn(
                                  product: state.products[index],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is GetFeaturedFailedstate) {
                      showSnack(title: "Error", message: state.errorMessage);

                      return SizedBox(height: 300.h);
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SvgPicture.asset("assets/images/loadingCard.svg"),
                          SizedBox(width: 16.w),
                          SvgPicture.asset("assets/images/loadingCard.svg"),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 24.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0).w,
                child: CustomFeatureRow(
                  title: "Top Rated",
                  buttontext: 'Explore All',
                  onTap: () {
                    final searchCubit = BlocProvider.of<SearchCubit>(context);
                    final wishListCubit = BlocProvider.of<WishListCubit>(
                      context,
                    );
                    searchCubit.filterproducts(rating: 4);
                    Get.toNamed(
                      AppRoutes.customerSearch,
                      arguments: {
                        'searchCubit': searchCubit,
                        'wishListCubit': wishListCubit,
                      },
                    );
                  },
                  buttontextstyle: AppTextStyles.t_14w600.copyWith(
                    color: commonColor,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 340.h,
                constraints: BoxConstraints(minHeight: 337.h, maxHeight: 343.h),
                child: BlocBuilder<HomeCubit, HomeState>(
                  buildWhen: (previous, current) {
                    return current is GetTopRatedLoadingstate ||
                        current is GetTopRatedSuccessedstate ||
                        current is GetTopRatedFailedstate;
                  },
                  builder: (context, state) {
                    if (state is GetTopRatedSuccessedstate) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.products.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: AspectRatio(
                              aspectRatio: .64,
                              child: ProductItem(
                                cardmargin: 5,
                                cardclipBehavior: .antiAlias,
                                imageflex: 3,
                                lowercolumnflex: 2,
                                lowercolumnleftpadding: 12,
                                lowercolumnrightpadding: 12,
                                lowercolumntoppadding: 12.h,
                                lowercolumnbottompadding: 12.h,
                                product: state.products[index],
                                lowercolumn: TopRatedProductItemLowerColumn(
                                  product: state.products[index],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is GetTopRatedFailedstate) {
                      showSnack(title: "Error", message: state.errorMessage);
                      return SizedBox(height: 200.h);
                    } else {
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          SvgPicture.asset(
                            "assets/images/loadingCard.svg",
                            width: 200.w,
                          ),
                          SizedBox(width: 16.w),
                          SvgPicture.asset(
                            "assets/images/loadingCard.svg",
                            width: 200.w,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50.h)),
          ],
        ),
      ),
    );
  }
}
