import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/searchfield.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/categorieslist.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customfeaturerow.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/featuredproductitemlowercolumn.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/topratedproductitemlowercolumn.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});
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
                ),
              ],
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
                    Get.toNamed(AppRoutes.customerSearch);
                  },
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 16.h)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: 16).w,
                child: CustomFeatureRow(
                  title: "Categories",
                  buttontext: "See All",
                  buttontextstyle: AppTextStyles.t_14w600.copyWith(
                    color: commonColor,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: 12.h)),
            SliverToBoxAdapter(
              child: Container(
                height: 107.h,
                constraints: BoxConstraints(minHeight: 105.h, maxHeight: 110.h),
                child: HomeCategoriesList(),
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsListData.length,
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
                          product: productsListData[index],
                          lowercolumn: FeaturedProductItemLowerColumn(
                            product: productsListData[index],
                          ),
                        ),
                      ),
                    );
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
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsListData.length,
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
                          product: productsListData[index],
                          lowercolumn: TopRatedProductItemLowerColumn(
                            product: productsListData[index],
                          ),
                        ),
                      ),
                    );
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
