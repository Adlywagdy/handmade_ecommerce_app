import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/functions/filter_sheet_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/models/category_model.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/custom_icon_button.dart';
import 'package:handmade_ecommerce_app/core/widgets/search_field.dart';
import 'package:handmade_ecommerce_app/features/customer/search/logic/search_cubit.dart';
import 'package:handmade_ecommerce_app/core/widgets/product_item.dart';
import 'package:handmade_ecommerce_app/features/customer/search/ui/widgets/searched_product_item_lower_column.dart';

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
    final args = Get.arguments;
    if (args is CategoryModel) {
      final cubit = _searchCubit;
      cubit.selectedCategory = args;
      controller.text = args.categorytitle;
      cubit.filterproducts(categoryname: args.categorytitle);
    } else if (args is Map && args['rating'] != null) {
      _searchCubit.filterproducts(rating: (args['rating'] as num).toDouble());
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
                    openFilterSheet(
                      context,
                      searchCubit: _searchCubit,
                      selectedCategory:
                          _searchCubit.selectedCategory?.categorytitle,
                    );
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
              if (state is SearchProductsSuccessedstate ||
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
                        cardclipBehavior: Clip.antiAlias,
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
              } else if (state is SearchProductsLoadingstate ||
                  state is FilterProductsLoadingstate) {
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
              } else {
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
              }
            },
          ),
          SliverToBoxAdapter(child: SizedBox(height: 50.h)),
        ],
      ),
    );
  }
}
