import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/products/widgets/product_card.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widgets/custom_searc_bar.dart';
import '../../../models/products_model.dart';

class ApproveProductsScreen extends StatelessWidget {
  const ApproveProductsScreen({super.key});

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
            labelStyle: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700),
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
              onChanged: (value) {},
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ProductsGrid(products: _pendingProducts),
                  ProductsGrid(products: _approvedProducts, showActions: false),
                  ProductsGrid(products: _rejectedProducts, showActions: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductsGrid extends StatelessWidget {
  final List<ProductsModel> products;
  final bool showActions;

  const ProductsGrid({
    super.key,
    required this.products,
    this.showActions = true,
  });

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
        return ProductCard(
          product: product,
          showActions: showActions,
          onApprove: () {},
          onReject: () {},
        );
      },
    );
  }
}

final _pendingProducts = [
  const ProductsModel(
    productId: 3,
    name: 'Silver Filigree Ring',
    price: 850,
    currency: 'EGP',
    vendorName: 'Laila Jewelry',
    productImage:
        'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400',
    status: 'pending',
  ),
  const ProductsModel(
    productId: 4,
    name: 'Genuine Leather Bag',
    price: 1200,
    currency: 'EGP',
    vendorName: 'Omar Leather Goods',
    productImage:
        'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400',
    status: 'pending',
  ),
  const ProductsModel(
    productId: 5,
    name: 'Handwoven Wool Rug',
    price: 2400,
    currency: 'EGP',
    vendorName: 'Sinai Weaves',
    productImage:
        'https://images.unsplash.com/photo-1600166898405-da9535204843?w=400',
    status: 'pending',
  ),
  const ProductsModel(
    productId: 6,
    name: 'Carved Wall Mirror',
    price: 1150,
    currency: 'EGP',
    vendorName: 'Artisan Woodworks',
    productImage:
        'https://images.unsplash.com/photo-1618220179428-22790b461013?w=400',
    status: 'pending',
  ),
  const ProductsModel(
    productId: 1,
    name: 'Ceramic Turquoise Vase',
    price: 450,
    currency: 'EGP',
    vendorName: 'Fatima Handcrafts',
    productImage:
    'https://images.unsplash.com/photo-1612196808214-b7e239e5f6b7?w=400',
    status: 'pending',
  ),
  const ProductsModel(
    productId: 2,
    name: 'Woven Wicker Basket',
    price: 300,
    currency: 'EGP',
    vendorName: 'Ahmed Reed Works',
    productImage:
    'https://images.unsplash.com/photo-1595351475754-8a9d45a97ea5?w=400',
    status: 'pending',
  ),
];

final _approvedProducts = [
  const ProductsModel(
    productId: 7,
    name: 'Hand-painted Tajine',
    price: 680,
    currency: 'EGP',
    vendorName: 'Nour Ceramics',
    productImage:
        'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400',
    status: 'approved',
  ),
  const ProductsModel(
    productId: 8,
    name: 'Macramé Wall Hanging',
    price: 520,
    currency: 'EGP',
    vendorName: 'Dina Fiber Arts',
    productImage:
        'https://images.unsplash.com/photo-1622398925373-3f91b1e275f5?w=400',
    status: 'approved',
  ),
  const ProductsModel(
    productId: 9,
    name: 'Copper Coffee Set',
    price: 1800,
    currency: 'EGP',
    vendorName: 'Al-Qahira Metalworks',
    productImage:
        'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=400',
    status: 'approved',
  ),
  const ProductsModel(
    productId: 10,
    name: 'Embroidered Silk Scarf',
    price: 390,
    currency: 'EGP',
    vendorName: 'Hana Textiles',
    productImage:
        'https://images.unsplash.com/photo-1601924994987-69e26d50dc26?w=400',
    status: 'approved',
  ),
];

final _rejectedProducts = [
  const ProductsModel(
    productId: 11,
    name: 'Plastic Souvenir Set',
    price: 150,
    currency: 'EGP',
    vendorName: 'QuickMade Co.',
    productImage:
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=400',
    status: 'rejected',
  ),
  const ProductsModel(
    productId: 12,
    name: 'Machine-print Carpet',
    price: 900,
    currency: 'EGP',
    vendorName: 'Factory Floors',
    productImage:
        'https://images.unsplash.com/photo-1575377222312-dd1a63a51638?w=400',
    status: 'rejected',
  ),
];
