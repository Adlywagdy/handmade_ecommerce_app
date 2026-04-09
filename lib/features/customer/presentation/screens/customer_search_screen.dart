import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
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
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            backgroundColor: customerbackGroundColor,
            actionsPadding: const EdgeInsets.only(right: 8.0).w,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back, color: commonColor),
            ),
            scrolledUnderElevation: 0,
            centerTitle: true,
            title: SearchField(
              autofocus: true,
              readOnly: false,
              hintText: 'Handmade ceramics',
              textstyle: AppTextStyles.t_14w500.copyWith(color: blackDegree),
            ),
            actions: [
              CustomIconButton(
                backgroundColor: commonColor.withValues(alpha: .03),
                icon: Icons.tune_outlined,
                iconcolor: commonColor,
                onPressed: () {
                  // filter & sort actions
                },
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
            child: Container(
              height: 67.h,
              constraints: BoxConstraints(minHeight: 65.h, maxHeight: 68.h),
              child: Searchcategorieslist(),
            ),
          ),

          SliverToBoxAdapter(
            child: Divider(color: commonColor.withValues(alpha: .1)),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                '124 RESULTS FOUND',
                style: AppTextStyles.t_14w500.copyWith(
                  color: commonColor.withValues(alpha: .6),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.8,
            ),
            itemCount: productsListData.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0).w,
                child: ProductItem(
                  cardclipBehavior: .antiAlias,
                  product: productsListData[index],
                  imageflex: 2,
                  lowercolumnflex: 1,
                  elevation: 0,
                  imageclipBehavior: Clip.antiAlias,
                  lowercolumnbottompadding: 8.h,
                  lowercolumntoppadding: 8.h,
                  lowercolumnleftpadding: 8,
                  lowercolumnrightpadding: 8,
                  lowercolumn: SearchedProductItemLowerColumn(
                    product: productsListData[index],
                  ),
                ),
              );
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 50.h)),
        ],
      ),
    );
  }
}
