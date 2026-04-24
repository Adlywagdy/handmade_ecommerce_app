import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/functions/filter_sheet_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/core/widgets/searchfield.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/search_cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/core/widgets/productitem.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/searchcategorieslist.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/searchedproductitemlowercolumn.dart';

class CustomerSearchScreen extends StatefulWidget {
  const CustomerSearchScreen({super.key});

  @override
  State<CustomerSearchScreen> createState() => _CustomerSearchScreenState();
}

class _CustomerSearchScreenState extends State<CustomerSearchScreen> {
  late final TextEditingController controller;

  SearchCubit get _searchCubit => context.read<SearchCubit>();

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
    final selectedCategory = _searchCubit.selectedCategory;
    if (selectedCategory != null) {
      controller.text = selectedCategory.categorytitle;
      _searchCubit.filterproducts(categoryname: selectedCategory.categorytitle);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
              controller: controller,
              autofocus: true,
              hintText: 'Search for products',
              textstyle: AppTextStyles.t_14w500.copyWith(
                color: commonColor.withValues(alpha: .6),
              ),

              onChanged: (value) {
                _searchCubit.searchproducts(productname: value);
              },
            ),
            actions: [
              CustomIconButton(
                backgroundColor: commonColor.withValues(alpha: .03),
                icon: Icons.tune_outlined,
                iconcolor: commonColor,
                onPressed: () {
                  if (controller.text.trim().isNotEmpty ||
                      _searchCubit.selectedCategory != null) {
                    openFilterSheet(context);
                  } else {
                    showSnack(
                      title: "No filters",
                      message:
                          "Please enter a search query or select a category to filter.",
                    );
                  }
                },
              ),
            ],
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await Future.delayed(Duration(seconds: 2));
              final selectedCategory = _searchCubit.selectedCategory;
              if (selectedCategory != null) {
                _searchCubit.filterproducts(
                  categoryname: selectedCategory.categorytitle,
                );
              } else if (controller.text.isNotEmpty) {
                _searchCubit.searchproducts(productname: controller.text);
              }
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
          BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (previous, current) {
              return current is SearchInitial ||
                  current is SearchProductsSuccessedstate ||
                  current is FilterProductsSuccessedstate ||
                  current is SearchProductsLoadingstate ||
                  current is FilterProductsLoadingstate ||
                  current is SearchProductsFailedstate ||
                  current is FilterProductsFailedstate;
            },
            builder: (context, state) {
              if (state is SearchProductsSuccessedstate ||
                  state is FilterProductsSuccessedstate) {
                final resultsCount = state is SearchProductsSuccessedstate
                    ? _searchCubit.searchedproductsList.length
                    : _searchCubit.filteredproductsList.length;

                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
                    child: Text(
                      '$resultsCount RESULTS FOUND',
                      style: AppTextStyles.t_14w500.copyWith(
                        color: commonColor.withValues(alpha: .6),
                      ),
                    ),
                  ),
                );
              } else {
                return SliverToBoxAdapter(child: SizedBox());
              }
            },
          ),

          SliverToBoxAdapter(child: SizedBox(height: 16.h)),

          BlocBuilder<SearchCubit, SearchState>(
            buildWhen: (previous, current) {
              return current is SearchInitial ||
                  current is SearchProductsSuccessedstate ||
                  current is FilterProductsSuccessedstate ||
                  current is SearchProductsLoadingstate ||
                  current is FilterProductsLoadingstate ||
                  current is SearchProductsFailedstate ||
                  current is FilterProductsFailedstate;
            },
            builder: (context, state) {
              if (state is SearchInitial) {
                return SliverToBoxAdapter(
                  child: SizedBox(
                    height: 220.h,
                    child: Center(
                      child: Text(
                        'Start typing to see matching products',
                        style: AppTextStyles.t_14w500.copyWith(
                          color: commonColor.withValues(alpha: .6),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is SearchProductsSuccessedstate ||
                  state is FilterProductsSuccessedstate) {
                final List<ProductModel> products =
                    state is SearchProductsSuccessedstate
                    ? _searchCubit.searchedproductsList
                    : _searchCubit.filteredproductsList;

                return SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1 / 1.8,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0).w,
                      child: ProductItem(
                        cardclipBehavior: .antiAlias,
                        product: products[index],
                        imageflex: 2,
                        lowercolumnflex: 1,
                        elevation: 0,
                        imageclipBehavior: Clip.antiAlias,
                        lowercolumnbottompadding: 8.h,
                        lowercolumntoppadding: 8.h,
                        lowercolumnleftpadding: 8,
                        lowercolumnrightpadding: 8,
                        lowercolumn: SearchedProductItemLowerColumn(
                          product: products[index],
                        ),
                      ),
                    );
                  },
                );
              } else if (state is SearchProductsFailedstate ||
                  state is FilterProductsFailedstate) {
                String errorMessage = state is SearchProductsFailedstate
                    ? state.errorMessage
                    : (state as FilterProductsFailedstate).errorMessage;
                showSnack(title: "Error", message: errorMessage);
                return SliverToBoxAdapter(child: SizedBox(height: 200.h));
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
                      child: SvgPicture.asset("assets/images/loadingCard.svg"),
                    ),
                  ),
                );
              }
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 50.h)),
        ],
      ),
    );
  }
}
