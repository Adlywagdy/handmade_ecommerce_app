import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/admin_bottom_bar/admin_bottom_bar.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/login_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/register_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/verify_password_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/presentation/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/layout/presentation/screens/customer_layout.dart';
import 'package:handmade_ecommerce_app/features/customer/notifications/presentation/screens/customer_notifications_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/presentation/screens/customer_orderdetails_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/product_details/presentation/screens/customer_product_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/search/presentation/screens/customer_search_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/shop_details/presentation/screens/customer_shop_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/presentation/screens/customer_writereview_screen.dart';
import 'package:handmade_ecommerce_app/features/notifications/presentation/screens/notifications_screen.dart';

import 'package:handmade_ecommerce_app/features/home/presentation/screens/Decider_screen.dart';
import 'package:handmade_ecommerce_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_edit_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_bottom_nav.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_manage_products_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_registration_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/models/seller_model.dart';

import '../../features/admin/presentation/screens/dashboard/dashboard_screen.dart';
import '../../features/admin/presentation/screens/orders_screen/orders_screen.dart';
import '../../features/admin/presentation/screens/products/products_screen.dart';
import '../../features/admin/presentation/screens/sellers/sellers_screen.dart';
import '../../features/admin/presentation/screens/settings/settings_screen.dart';

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
      page: () => const VerifytPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.resetPassword,
      page: () => const ResetPasswordScreen(),
    ),

    // decider
    GetPage(name: AppRoutes.decider, page: () => const DeciderScreen()),

    // customer
    GetPage(name: AppRoutes.customerlayout, page: () => const CustomerLayout()),
    GetPage(
      name: AppRoutes.customerOrderDetails,
      page: () => CustomerOrderDetailsScreen(
        order: Get.arguments as CustomerOrderModel,
      ),
    ),
    GetPage(name: AppRoutes.customerCart, page: () => CustomerCartScreen()),
    GetPage(
      name: AppRoutes.customerProductDetails,
      page: () =>
          CustomerProductDetailsScreen(product: Get.arguments as ProductModel),
    ),
    GetPage(
      name: AppRoutes.customerShopDetails,
      page: () => CustomerShopDetailsScreen(sellerId: Get.arguments as String),
    ),
    GetPage(name: AppRoutes.customerSearch, page: () => CustomerSearchScreen()),
    GetPage(
      name: AppRoutes.customerNotifications,
      page: () => const CustomerNotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.customerWriteReview,
      page: () =>
          CustomerWriteReviewScreen(product: Get.arguments as ProductModel),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () => const NotificationsScreen(),
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
  ];
}
