import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/cubit/locale_cubit.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/searchfield.dart';
import 'package:handmade_ecommerce_app/features/notifications/logic/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/logic/notifications_state.dart';
import 'package:handmade_ecommerce_app/features/notifications/ui/widgets/notification_badge.dart';
import 'package:handmade_ecommerce_app/features/customer/ai_chatbot/ui/screens/recommendation_chatbot_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/home/logic/home_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/logic/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/logic/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/logic/notifications_state.dart';
import 'package:handmade_ecommerce_app/features/notifications/ui/widgets/notification_badge.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/widgets/categorieslist.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/widgets/customfeaturerow.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/widgets/featuredproductitemlowercolumn.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/widgets/topratedproductitemlowercolumn.dart';
import 'package:handmade_ecommerce_app/core/extension/localization_extension.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  void _openAllCategoriesSheet(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final categories = searchCubit.categoriesList;
    final isArabic = context.read<LocaleCubit>().state?.languageCode == 'ar';

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
                  context.l10n.allCategories,
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
                        Get.back();
                        Get.toNamed(
                          AppRoutes.customerSearch,
                          arguments: category,
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
                          category.localizedTitle(isArabic),
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
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: commonColor,
        elevation: 6,
        onPressed: () {
          Get.to(() => const RecommendationChatbotScreen());
        },
        icon: const Icon(Icons.auto_awesome, color: Colors.white),
        label: Text(
          context.l10n.aiHelp,
          style: AppTextStyles.t_14w600.copyWith(color: Colors.white),
        ),
      ),
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
                context.l10n.ayady,
                style: AppTextStyles.t_20w700.copyWith(color: commonColor),
              ),
              actions: [
                BlocBuilder<NotificationsCubit, NotificationsState>(
                  builder: (context, state) {
                    final unreadCount =
                        state is NotificationsLoaded ? state.unreadCount : 0;
                    return NotificationBadge(
                      unreadCount: unreadCount,
                      child: CustomIconButton(
                        backgroundColor: customerbackGroundColor,
                        icon: Icons.notifications_none,
                        iconcolor: darkblue,
                        onPressed: () {
                          Get.toNamed(AppRoutes.notifications);
                        },
                      ),
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
                  hintText: context.l10n.searchUniqueHandmadeCrafts,
                  textstyle: AppTextStyles.t_12w500.copyWith(
                    color: commonColor.withValues(alpha: .6),
                  ),
                  readOnly: true,
                  onTap: () {
                    Get.toNamed(AppRoutes.customerSearch);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(right: 16.w, bottom: 12.h),
                child: CustomFeatureRow(
                  title: context.l10n.categories,
                  buttontext: context.l10n.seeAll,
                  onTap: () => _openAllCategoriesSheet(context),
                  buttontextstyle: AppTextStyles.t_14w600.copyWith(
                    color: commonColor,
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 108.h,
                constraints: BoxConstraints(minHeight: 107.h, maxHeight: 110.h),
                child: BlocBuilder<SearchCubit, SearchState>(
                  buildWhen: (previous, current) {
                    return current is CategoriesLoading ||
                        current is CategoriesSuccess ||
                        current is CategoriesError;
                  },
                  builder: (context, state) {
                    if (state is CategoriesSuccess) {
                      return HomeCategoriesList();
                    } else if (state is CategoriesError) {
                      showSnack(
                        title: context.l10n.error,
                        message: state.message,
                      );
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
                    context.l10n.featuredProducts,
                    style: AppTextStyles.t_20w700.copyWith(color: blackDegree),
                  ),
                  Text(
                    context.l10n.handpickedForYourStyle,
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
                    return current is FeaturedLoading ||
                        current is FeaturedSuccess ||
                        current is FeaturedError;
                  },
                  builder: (context, state) {
                    if (state is FeaturedSuccess) {
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
                                cardclipBehavior: Clip.antiAlias,
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
                    } else if (state is FeaturedError) {
                      showSnack(
                        title: context.l10n.error,
                        message: state.message,
                      );

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
                  title: context.l10n.topRated,
                  buttontext: context.l10n.exploreAll,
                  onTap: () {
                    Get.toNamed(
                      AppRoutes.customerSearch,
                      arguments: {'rating': 4},
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
                    return current is TopRatedLoading ||
                        current is TopRatedSuccess ||
                        current is TopRatedError;
                  },
                  builder: (context, state) {
                    if (state is TopRatedSuccess) {
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
                                cardclipBehavior: Clip.antiAlias,
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
                    } else if (state is TopRatedError) {
                      showSnack(
                        title: context.l10n.error,
                        message: state.message,
                      );
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
