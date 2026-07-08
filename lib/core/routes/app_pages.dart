import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/screens/admin_bottom_bar/admin_bottom_bar.dart';
import 'package:handmade_ecommerce_app/features/admin/ui/screens/categories/categories_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/ui/screens/forget_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/ui/screens/login_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/ui/screens/register_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/ui/screens/reset_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/ui/screens/verify_password_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/ai_chatbot/ui/screens/recommendation_chatbot_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/screens/customer_notifications_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/ui/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/screens/customer_layout.dart';
import 'package:handmade_ecommerce_app/features/customer/home/ui/widgets/customer_bloc_providers.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/ui/screens/customer_orderdetails_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/product_details/ui/screens/customer_product_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/search/ui/screens/customer_search_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/shop_details/ui/screens/customer_shop_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/ui/screens/customer_writereview_screen.dart';
import 'package:handmade_ecommerce_app/features/notifications/ui/screens/notifications_screen.dart';

import 'package:handmade_ecommerce_app/features/onboarding/ui/onboarding_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/ui/screens/seller_add_edit_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/ui/screens/seller_add_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/ui/screens/seller_bottom_nav.dart';
import 'package:handmade_ecommerce_app/features/seller/ui/screens/seller_manage_products_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/ui/screens/seller_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/ui/screens/seller_pending_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/ui/screens/seller_registration_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/data/models/seller_model.dart';

import '../../features/admin/ui/screens/dashboard/dashboard_screen.dart';
import '../../features/admin/ui/screens/orders_screen/orders_screen.dart';
import '../../features/admin/ui/screens/products/products_screen.dart';
import '../../features/admin/ui/screens/sellers/sellers_screen.dart';
import '../../features/admin/ui/screens/settings/settings_screen.dart';

class AppPages {
  static final List<GetPage<dynamic>> pages = [
    // onboarding
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),

    // auth
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.register, page: () => const RegisterScreen()),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.verifyPassword,
      page: () => const VerifyPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),

    // customer
    GetPage(name: AppRoutes.customerlayout, page: () => const CustomerLayout()),
    GetPage(
      name: AppRoutes.customerOrderDetails,
      page: () {
        final args = Get.arguments;
        final CustomerOrderModel? order = args is CustomerOrderModel
            ? args
            : args is Map
            ? args['order'] as CustomerOrderModel?
            : null;

        if (order == null) {
          return const _CustomerRouteErrorScreen(
            title: 'Order not found',
            subtitle: 'Unable to open order details from this entry point.',
          );
        }

        return CustomerBlocProviders(
          child: CustomerOrderDetailsScreen(order: order),
        );
      },
    ),
    GetPage(
      name: AppRoutes.customerCart,
      page: () => const CustomerBlocProviders(child: CustomerCartScreen()),
    ),
    GetPage(
      name: AppRoutes.customerProductDetails,
      page: () {
        final args = Get.arguments;
        final ProductModel? product = args is ProductModel
            ? args
            : args is Map
            ? args['product'] as ProductModel?
            : null;

        if (product == null) {
          return const _CustomerRouteErrorScreen(
            title: 'Product not found',
            subtitle: 'Unable to open product details from this entry point.',
          );
        }

        return CustomerBlocProviders(
          child: CustomerProductDetailsScreen(product: product),
        );
      },
    ),
    GetPage(
      name: AppRoutes.customerSearch,
      page: () => const CustomerBlocProviders(child: CustomerSearchScreen()),
    ),
    GetPage(
      name: AppRoutes.customerShopDetails,
      page: () => CustomerBlocProviders(
        child: CustomerShopDetailsScreen(sellerId: Get.arguments as String),
      ),
    ),
    GetPage(
      name: AppRoutes.customerNotifications,
      page: () =>
          const CustomerBlocProviders(child: CustomerNotificationsScreen()),
    ),
    GetPage(
      name: AppRoutes.customerWriteReview,
      page: () {
        final args = Get.arguments;
        final ProductModel? product = args is ProductModel
            ? args
            : args is Map
            ? args['product'] as ProductModel?
            : null;

        if (product == null) {
          return const _CustomerRouteErrorScreen(
            title: 'Product not found',
            subtitle: 'Unable to open review screen without product data.',
          );
        }

        return CustomerBlocProviders(
          child: CustomerWriteReviewScreen(product: product),
        );
      },
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.customerRecommendationChatbot,
      page: () {
        final args = Get.arguments;
        final ProductModel? product = args is ProductModel
            ? args
            : args is Map
            ? args['product'] as ProductModel?
            : null;

        if (product == null) {
          return const _CustomerRouteErrorScreen(
            title: 'Product not found',
            subtitle: 'Unable to open product details from this entry point.',
          );
        }
        return const RecommendationChatbotScreen();
      },
    ),
    // seller
    GetPage(
      name: AppRoutes.sellerdashboard,
      page: () => const SellerBottomNav(),
    ),
    GetPage(
      name: AppRoutes.selleraddproduct,
      page: () => const SellerAddProductScreen(),
    ),
    GetPage(
      name: AppRoutes.selleraddoreditproduct,
      page: () => SellerAddEditProductScreen(
        product: Get.arguments as SellerProductModel,
      ),
    ),
    GetPage(
      name: AppRoutes.sellerorders,
      page: () => const SellerOrdersScreen(),
    ),
    GetPage(
      name: AppRoutes.sellermanageproducts,
      page: () => const SellerManageProductsScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerregisteation,
      page: () => const SellerRegistrationScreen(),
    ),
    GetPage(
      name: AppRoutes.sellerPending,
      page: () => const SellerPendingScreen(),
    ),

    // admin
    GetPage(
      name: AppRoutes.adminBottomBar,
      page: () => const AdminBottomBarScreen(),
    ),
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
    ),
    GetPage(
      name: AppRoutes.adminSellers,
      page: () => const AdminSellersScreen(),
    ),
    GetPage(
      name: AppRoutes.adminProducts,
      page: () => const AdminProductsScreen(),
    ),
    GetPage(name: AppRoutes.adminOrders, page: () => const AdminOrdersScreen()),
    GetPage(
      name: AppRoutes.adminSettings,
      page: () => const AdminSettingsScreen(),
    ),
    GetPage(
      name: AppRoutes.adminCategories,
      page: () => const AdminCategoriesScreen(),
    ),
  ];
}

class _CustomerRouteErrorScreen extends StatelessWidget {
  const _CustomerRouteErrorScreen({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 32),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
