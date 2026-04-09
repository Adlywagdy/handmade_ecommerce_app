import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/models/seller_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/review_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/searchedproductitemlowercolumn.dart';

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
                          Text(
                            '${wishlistProducts.length} saved items',
                            style: AppTextStyles.t_16w700.copyWith(
                              color: blackDegree,
                            ),
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

            SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1 / 1.8,
              ),
              itemCount: wishlistProducts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0).w,
                  child: ProductItem(
                    cardclipBehavior: .antiAlias,
                    product: wishlistProducts[index],
                    imageflex: 2,
                    lowercolumnflex: 1,
                    elevation: 0,
                    imageclipBehavior: Clip.antiAlias,
                    lowercolumnbottompadding: 7.h,
                    lowercolumntoppadding: 7.h,
                    lowercolumnleftpadding: 8,
                    lowercolumnrightpadding: 8,
                    lowercolumn: SearchedProductItemLowerColumn(
                      product: wishlistProducts[index],
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 50.h)),
          ],
        ),
      ),
    );
  }
}

List<ProductModel> wishlistProducts = [
  ProductModel(
    name: 'Handmade Ceramic Vase',
    description:
        'This exquisite Terra Vase is hand-thrown by master artisans using traditional Mediterranean techniques.\nEach piece is unique, featuring a natural matte finish and subtle variations in texture that celebrate the organic beauty of locally sourced clay. \nPerfect for dried botanicals or as a standalone sculptural piece.',
    price: 49.99,
    totalrate: 4.5,
    quantity: 50,
    reviews: [
      ReviewModel(
        reviewer: CustomerModel(
          name: "Alice Smith",
          email: "alice.smith@example.com",
        ),
        rating: 3,
        reviewText:
            "Absolutely stunning quality. You can feel the craftsmanship in the texture of the clay.",
        reviewDate: DateTime.now(),
      ),
    ],
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Artisan ",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Verified",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Ceramic", "Decorative"],
  ),
  ProductModel(
    name: 'Woven Basket',
    description:
        'A sturdy and stylish woven basket, ideal for storage or as a decorative piece.',
    price: 29.99,
    totalrate: 4.0,
    quantity: 30,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Ceramics",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Top Seller",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Wooden", "Decorative"],
  ),
  ProductModel(
    name: 'Hand-Painted Wooden Sign',
    description:
        'A charming hand-painted wooden sign that adds a rustic touch to any space.',
    price: 19.99,
    totalrate: 4.8,
    quantity: 20,
    images: [
      "assets/images/splash.jpeg",
      "assets/images/test.png",
      "assets/images/test2.png",
    ],
    category: CategoryModel(categorytitle: "WOODWORK"),
    seller: SellerModel(
      name: "John Doe",
      email: "john.doe@example.com",
      specialty: "Ceramics",
      submittedDate: "2023-01-01",
      image: "assets/images/profile.svg",
      badge: "Top Seller",
      location: "Tunisia",
    ),
    tags: ["Handmade", "Wooden", "Decorative"],
  ),
];
