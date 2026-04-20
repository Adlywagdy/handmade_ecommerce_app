import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/widgets/seller_product_card.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_product_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';

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

  // Mock product data
  final List<Map<String, dynamic>> _allProducts = [
    {
      'name': 'Handmade Terracotta V...',
      'price': 'EGP 450.00',
      'stock': 'Stock: 12 units',
      'status': 'Active',
      'isActive': true,
      'image':
          'https://images.unsplash.com/photo-1565193566173-7a0ee3dbe261?w=200&h=200&fit=crop',
    },
    {
      'name': 'Woven Palm Leaf Basket',
      'price': 'EGP 250.00',
      'stock': 'Stock: 5 units',
      'status': 'Active',
      'isActive': true,
      'image':
          'https://images.unsplash.com/photo-1622205313162-be1d5712a43f?w=200&h=200&fit=crop',
    },
    {
      'name': 'Embroidered Linen Cush...',
      'price': 'EGP 380.00',
      'stock': 'Stock: 0 units',
      'status': 'Pending Review',
      'isActive': false,
      'image':
          'https://images.unsplash.com/photo-1629949009765-40fc74c9ec21?w=200&h=200&fit=crop',
    },
    {
      'name': 'Ceramic Decorative Plate',
      'price': 'EGP 600.00',
      'stock': 'Stock: 8 units',
      'status': 'Active',
      'isActive': true,
      'image':
          'https://images.unsplash.com/photo-1610701596007-11502861dcfa?w=200&h=200&fit=crop',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredProducts(int tabIndex) {
    switch (tabIndex) {
      case 1: // Active
        return _allProducts.where((p) => p['status'] == 'Active').toList();
      case 2: // Pending
        return _allProducts
            .where((p) => p['status'] == 'Pending Review')
            .toList();
      default: // All
        return _allProducts;
    }
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
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList(0),
          _buildProductList(1),
          _buildProductList(2),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AppRoutes.selleraddproduct);
        },
        backgroundColor: commonColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: Icon(Icons.add, color: Colors.white, size: 28.w),
      ),
    );
  }

  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      labelColor: const Color(0xFF0F172A),
      unselectedLabelColor: const Color(0xFF94A3B8),
      labelStyle: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Plus Jakarta Sans',
        fontWeight: FontWeight.w500,
      ),
      indicatorColor: commonColor,
      indicatorWeight: 2.5,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: const Color(0xFFE2E8F0),
      tabs: [
        Tab(text: 'All (${_allProducts.length})'),
        Tab(text: 'Active'),
        Tab(text: 'Pending'),
      ],
    );
  }

  Widget _buildProductList(int tabIndex) {
    final products = _getFilteredProducts(tabIndex);

    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              color: const Color(0xFF94A3B8),
              size: 48.w,
            ),
            SizedBox(height: 12.h),
            Text(
              'No products found',
              style: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: 16.sp,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.only(top: 4.h),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return SellerProductCard(
          productName: product['name'],
          price: product['price'],
          stock: product['stock'],
          status: product['status'],
          imageUrl: product['image'],
          isActive: product['isActive'],
          onToggle: (value) {
            setState(() {
              final originalIndex = _allProducts.indexOf(product);
              if (originalIndex != -1) {
                _allProducts[originalIndex]['isActive'] = value;
              }
            });
          },
          onMenuTap: () {
            _showProductMenu(context, product);
          },
        );
      },
    );
  }

  void _showProductMenu(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 16.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.edit_outlined, color: commonColor),
                  title: Text(
                    'Edit Product',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.selleraddproduct);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.visibility_outlined,
                    color: const Color(0xFF334155),
                  ),
                  title: Text(
                    'View Details',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    Get.to(
                      () => CustomerProductDetailsScreen(
                        product: productsListData[0], // Using mock data
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.delete_outlined,
                    color: const Color(0xFFD32F2F),
                  ),
                  title: Text(
                    'Delete Product',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFFD32F2F),
                    ),
                  ),
                  onTap: () {
                    Get.back();
                    // TODO: Delete product
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
