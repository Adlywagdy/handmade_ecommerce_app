import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_state.dart';
import 'package:handmade_ecommerce_app/features/seller/models/seller_model.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_product_card.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_edit_product_screen.dart';

class SellerManageProductsScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const SellerManageProductsScreen({super.key, this.onBackPressed});

  @override
  State<SellerManageProductsScreen> createState() =>
      _SellerManageProductsScreenState();
}

class _SellerManageProductsScreenState extends State<SellerManageProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Trigger load of dashboard if not loaded yet
    context.read<SellerCubit>().loadDashboard();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        backgroundColor: customerbackGroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: () {
            if (widget.onBackPressed != null) {
              widget.onBackPressed!();
              return;
            }
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: commonColor, size: 24.w),
        ),
        title: Text(
          'Manage Products',
          style: TextStyle(
            color: const Color(0xFF0F172A),
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Search functionality
            },
            icon: Icon(
              Icons.search,
              color: const Color(0xFF334155),
              size: 24.w,
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Filter functionality
            },
            icon: Icon(
              Icons.filter_list,
              color: const Color(0xFF334155),
              size: 24.w,
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.h),
          child: _buildTabBar(),
        ),
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SellerError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          } else if (state is SellerLoaded) {
            final allProducts = state.products;
            
            final activeProducts = allProducts.where((p) => p.status == 'Active' || p.status == 'In Stock' || p.isActive).toList();
            final pendingProducts = allProducts.where((p) => p.status == 'Pending Review').toList();

            return TabBarView(
              controller: _tabController,
              children: [
                _buildProductList(allProducts),
                _buildProductList(activeProducts),
                _buildProductList(pendingProducts),
              ],
            );
          }
          return const Center(child: Text('No products found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.selleraddproduct);
        },
        backgroundColor: commonColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Icon(Icons.add, color: Colors.white, size: 28.w),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFE2E8F0),
            width: 1.0,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: commonColor,
        unselectedLabelColor: const Color(0xFF64748B),
        indicatorColor: commonColor,
        indicatorWeight: 3,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Plus Jakarta Sans',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Plus Jakarta Sans',
        ),
        tabs: const [
          Tab(text: 'All'),
          Tab(text: 'Active'),
          Tab(text: 'Pending'),
        ],
      ),
    );
  }

  Widget _buildProductList(List<SellerProductModel> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64.w, color: const Color(0xFFCBD5E1)),
            SizedBox(height: 16.h),
            Text(
              'No products found',
              style: TextStyle(
                color: const Color(0xFF64748B),
                fontSize: 16.sp,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _buildRealProductCard(product),
        );
      },
    );
  }

  Widget _buildRealProductCard(SellerProductModel product) {
    return InkWell(
      onTap: () {
        Get.to(() => SellerAddEditProductScreen(product: product));
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: const Color(0xFFF8FAFC),
                image: DecorationImage(
                  image: NetworkImage(product.images.isNotEmpty ? product.images.first : 'https://via.placeholder.com/150'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12.w),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'EGP ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: commonColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Plus Jakarta Sans',
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Stock: ${product.stock} units',
                        style: TextStyle(
                          color: const Color(0xFF64748B),
                          fontSize: 12.sp,
                          fontFamily: 'Plus Jakarta Sans',
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: product.isActive
                              ? const Color(0xFFECFDF5)
                              : const Color(0xFFFFFBEB),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          product.status,
                          style: TextStyle(
                            color: product.isActive
                                ? const Color(0xFF10B981) // Green
                                : const Color(0xFFF59E0B), // Amber/Orange
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Plus Jakarta Sans',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions Menu
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: const Color(0xFF94A3B8), size: 20.w),
              onSelected: (value) {
                if (value == 'edit') {
                  Get.to(() => SellerAddEditProductScreen(product: product));
                } else if (value == 'delete') {
                  context.read<SellerCubit>().deleteProduct(product.id);
                }
              },
              itemBuilder: (BuildContext context) => [
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit Product'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
