import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                style: TextStyle(
                  color: commonColor,
                  fontSize: 20,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                CustomIconButton(
                  backgroundColor: customerbackGroundColor,
                  icon: Icons.notifications_none,
                  iconcolor: darkblue,
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0).w,
                child: SearchField(hintText: "Search unique handmade crafts"),
              ),
            ),
            SliverToBoxAdapter(
              child: CustomFeatureRow(
                title: "Categories",
                buttontext: "See All",
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 100.h, child: HomeCategoriesList()),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 32.h),
                  Text(
                    'Featured Products',
                    style: TextStyle(
                      color: blackDegree,
                      fontSize: 20,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Handpicked for your style',
                    style: TextStyle(
                      color: darkblue,
                      fontSize: 14,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 16.h),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 330.h,
                constraints: BoxConstraints(minHeight: 315.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsListData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0).w,
                      child: AspectRatio(
                        aspectRatio: .84,
                        child: ProductItem(
                          cardmargin: 5,
                          cardclipBehavior: .antiAlias,
                          imageflex: 3,
                          lowercolumnflex: 2,
                          lowercolumntoppadding: 16.h,
                          lowercolumnbottompadding: 16.h,
                          lowercolumnleftpadding: 16.w,
                          lowercolumnrightpadding: 16.w,
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
              child: CustomFeatureRow(
                title: "Top Rated",
                buttontext: 'Explore All',
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                height: 320.h,

                constraints: BoxConstraints(minHeight: 300.h),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productsListData.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16.0).w,
                      child: AspectRatio(
                        aspectRatio: .64,
                        child: ProductItem(
                          cardmargin: 5,
                          cardclipBehavior: .antiAlias,
                          imageflex: 3,
                          lowercolumnflex: 2,
                          lowercolumnleftpadding: 12.w,
                          lowercolumnrightpadding: 12.w,
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

            // SliverFillRemaining(
            //   hasScrollBody: false,
            //   child: CustomBottomBar(items: customerBottomBarItems),
            // ),
          ],
        ),
      ),
    );
  }
}
