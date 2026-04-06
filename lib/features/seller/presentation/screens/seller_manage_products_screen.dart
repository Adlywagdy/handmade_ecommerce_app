import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../cubit/seller_cubit.dart';
import '../../cubit/seller_state.dart';
import '../widgets/seller_product_card.dart';
import 'seller_add_edit_product_screen.dart';

class SellerManageProductsScreen extends StatelessWidget {
  const SellerManageProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<SellerCubit>(),
                child: const SellerAddEditProductScreen(),
              ),
            ),
          );
        },
        backgroundColor: const Color(0xff8B4513),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: BlocBuilder<SellerCubit, SellerState>(
          builder: (context, state) {
            if (state is! SellerLoaded) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xff8B4513),
                ),
              );
            }

            final cubit = context.read<SellerCubit>();
            final products = cubit.filteredProducts;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Text(
                    'Manage Products',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),

                // Search bar + Filter
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSearchBar(context, state),
                      ),
                      SizedBox(width: 10.w),
                      _buildFilterButton(),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),

                // Results count
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    '${products.length} product${products.length != 1 ? 's' : ''} found',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withValues(alpha: 0.4),
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                ),
                SizedBox(height: 12.h),

                // Product list
                Expanded(
                  child: products.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return SellerProductCard(
                              product: product,
                              onEdit: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: cubit,
                                      child: SellerAddEditProductScreen(
                                        product: product,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onDelete: () {
                                _showDeleteConfirmation(
                                    context, cubit, product.id);
                              },
                              onToggleActive: (_) {
                                cubit.toggleProductActive(product.id);
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context, SellerLoaded state) {
    return Container(
      height: 46.h,
      decoration: BoxDecoration(
        color: const Color(0xFF16213E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: TextField(
        onChanged: (value) {
          context.read<SellerCubit>().searchProducts(value);
        },
        onTapOutside: (event) {
          FocusScope.of(context).unfocus();
        },
        cursorColor: const Color(0xff8B4513),
        style: TextStyle(
          fontSize: 13.sp,
          color: Colors.white,
          fontFamily: 'Plus Jakarta Sans',
        ),
        decoration: InputDecoration(
          hintText: 'Search products...',
          hintStyle: TextStyle(
            fontSize: 13.sp,
            color: Colors.white.withValues(alpha: 0.3),
            fontFamily: 'Plus Jakarta Sans',
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white.withValues(alpha: 0.4),
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }

  Widget _buildFilterButton() {
    return Container(
      width: 46.w,
      height: 46.h,
      decoration: BoxDecoration(
        color: const Color(0xff8B4513).withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xff8B4513).withValues(alpha: 0.3),
        ),
      ),
      child: Icon(
        Icons.tune,
        color: const Color(0xff8B4513),
        size: 20.sp,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 56.sp,
            color: Colors.white.withValues(alpha: 0.2),
          ),
          SizedBox(height: 16.h),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.4),
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Try adjusting your search or add a new product',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white.withValues(alpha: 0.3),
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, SellerCubit cubit, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text(
          'Delete Product',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this product? This action cannot be undone.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 13.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              cubit.deleteProduct(productId);
              Navigator.of(ctx).pop();
            },
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Color(0xffD32F2F),
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
