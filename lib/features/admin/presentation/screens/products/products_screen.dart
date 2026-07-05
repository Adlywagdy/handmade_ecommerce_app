import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../cubit/admin_cubit.dart';
import '../../../models/products_model.dart';
import 'productdetails/product_details_screen.dart';
import 'widget/product_card.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: backGroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'Approve Products',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: blackDegree,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            labelColor: commonColor,
            unselectedLabelColor: subTitleColor,
            indicatorColor: commonColor,
            overlayColor: WidgetStateProperty.all(
              Colors.grey.withValues(alpha: 0.15),
            ),
            indicatorWeight: 3,
            labelStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
            ),
            tabs: const [
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
            ],
          ),
        ),
        body: Column(
          children: [
            CustomSearchBar(
              hintText: 'Search products...',
              onChanged: (v) => context.read<AdminCubit>().setProductsQuery(v),
            ),
            Expanded(
              child: BlocBuilder<AdminCubit, AdminState>(
                builder: (context, state) {
                  final cubit = context.read<AdminCubit>();
                  if (cubit.productsList.isEmpty && state is GetProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (cubit.productsList.isEmpty && state is GetProductsError) {
                    return Center(child: Text(state.error));
                  }
                  return TabBarView(
                    children: [
                      _ProductsGrid(
                        products: cubit.productsByStatus('pending'),
                      ),
                      _ProductsGrid(
                        products: cubit.productsByStatus('approved'),
                        showActions: false,
                      ),
                      _ProductsGrid(
                        products: cubit.productsByStatus('rejected'),
                        showActions: false,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  final List<ProductsModel> products;
  final bool showActions;

  const _ProductsGrid({required this.products, this.showActions = true});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return Center(
        child: Text(
          'No products found',
          style: TextStyle(fontSize: 14.sp, color: subTitleColor),
        ),
      );
    }

    final cubit = context.read<AdminCubit>();

    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        mainAxisExtent: showActions ? 350.h : 310.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        debugPrint("product image === ${products[index].productImage}");
        return ProductCard(
          product: product,
          vendorName: cubit.vendorNameFor(product),
          showActions: showActions,
          isProcessing: cubit.isProcessing(product.id),
          onApprove: () => cubit.approveProduct(product.id),
          onReject: () => cubit.rejectProduct(product.id),
          onPreview: () => Get.to(
            () => BlocProvider.value(
              value: cubit,
              child: ProductDetailsScreen(productId: product.id),
            ),
          ),
        );
      },
    );
  }
}
