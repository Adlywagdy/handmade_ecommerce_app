import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/searchfield.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/searchcategorieslist.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/searchedproductitemlowercolumn.dart';

class CustomerSearchScreen extends StatelessWidget {
  const CustomerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: customerbackGroundColor,
            actionsPadding: const EdgeInsets.only(right: 8.0).w,
            pinned: true,
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: SearchField(
              hintText: 'Handmade ceramics',
              fontSize: 16,
              hintColor: blackDegree,
            ),
            actions: [
              CustomIconButton(
                backgroundColor: commonColor.withValues(alpha: .03),
                icon: Icons.tune_outlined,
                iconcolor: commonColor,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 60.h,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0).w,
                child: Searchcategorieslist(),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Divider(color: commonColor.withValues(alpha: .1)),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, bottom: 8, top: 8).w,
              child: Text(
                '124 RESULTS FOUND',
                style: TextStyle(
                  color: const Color(0x998B4513),
                  fontSize: 14,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                  letterSpacing: 0.70,
                ),
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.8,
            ),
            itemCount: productsListData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0).w,
                child: ProductItem(
                  cardclipBehavior: .antiAlias,
                  product: productsListData[index],
                  imageflex: 2,
                  lowercolumnflex: 1,
                  elevation: 0,
                  imageclipBehavior: Clip.antiAlias,
                  lowercolumnpadding: 8,
                  lowercolumn: SearchedProductItemLowerColumn(
                    product: productsListData[index],
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 50.h)),

          // SliverFillRemaining(
          //   hasScrollBody: false,
          //   child: CustomBottomBar(items: customerBottomBarItems),
          // ),
        ],
      ),
    );
  }
}
