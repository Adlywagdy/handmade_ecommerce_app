import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:handmade_ecommerce_app/features/customer/cart/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/presentation/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/layout/presentation/screens/customer_layout.dart';
import 'package:handmade_ecommerce_app/features/customer/notifications/presentation/screens/customer_notifications_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/presentation/screens/customer_orderdetails_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/product_details/presentation/screens/customer_product_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/cubit/reviews_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/presentation/screens/customer_search_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/shop_details/presentation/screens/customer_shop_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/presentation/screens/customer_writereview_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/cubit/wishlist_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/presentation/screens/notifications_screen.dart';

import 'package:handmade_ecommerce_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_edit_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_bottom_nav.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_manage_products_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_pending_screen.dart';
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

        final orderCubit = args is Map ? args['orderCubit'] : null;
        if (orderCubit is OrderCubit) {
          return BlocProvider<OrderCubit>.value(
            value: orderCubit,
            child: CustomerOrderDetailsScreen(order: order),
          );
        }

        return BlocProvider<OrderCubit>(
          create: (context) => OrderCubit()..getAllOrders(),
          child: CustomerOrderDetailsScreen(order: order),
        );
      },
    ),
    GetPage(
      name: AppRoutes.customerCart,
      page: () {
        final args = Get.arguments;
        final cartCubit = args is Map ? args['cartCubit'] : null;
        final orderCubit = args is Map ? args['orderCubit'] : null;
        final customerCubit = args is Map ? args['customerCubit'] : null;

        return MultiBlocProvider(
          providers: [
            if (cartCubit is CartCubit)
              BlocProvider<CartCubit>.value(value: cartCubit)
            else
              BlocProvider<CartCubit>(
                create: (context) => CartCubit()..getcartProducts(),
              ),
            if (orderCubit is OrderCubit)
              BlocProvider<OrderCubit>.value(value: orderCubit)
            else
              BlocProvider<OrderCubit>(
                create: (context) => OrderCubit()..getAllOrders(),
              ),
            if (customerCubit is CustomerCubit)
              BlocProvider<CustomerCubit>.value(value: customerCubit)
            else
              BlocProvider<CustomerCubit>(
                create: (context) => CustomerCubit()..getCustomerdata(),
              ),
          ],
          child: CustomerCartScreen(),
        );
      },
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

        final cartCubit = args is Map ? args['cartCubit'] : null;
        final wishlistCubit = args is Map ? args['wishListCubit'] : null;
        final reviewsCubit = args is Map ? args['reviewsCubit'] : null;

        return MultiBlocProvider(
          providers: [
            if (cartCubit is CartCubit)
              BlocProvider<CartCubit>.value(value: cartCubit)
            else
              BlocProvider<CartCubit>(
                create: (context) => CartCubit()..getcartProducts(),
              ),
            if (wishlistCubit is WishListCubit)
              BlocProvider<WishListCubit>.value(value: wishlistCubit)
            else
              BlocProvider<WishListCubit>(
                create: (context) => WishListCubit()..getWishlistProducts(),
              ),
            if (reviewsCubit is ReviewsCubit)
              BlocProvider<ReviewsCubit>.value(value: reviewsCubit)
            else
              BlocProvider<ReviewsCubit>(create: (context) => ReviewsCubit()),
          ],
          child: CustomerProductDetailsScreen(product: product),
        );
      },
    ),
    GetPage(
      name: AppRoutes.customerShopDetails,
      page: () => CustomerShopDetailsScreen(sellerId: Get.arguments as String),
    ),
    GetPage(
      name: AppRoutes.customerSearch,
      page: () {
        final args = Get.arguments;
        final searchCubit = args is SearchCubit
            ? args
            : args is Map
            ? args['searchCubit']
            : null;
        final wishListCubit = args is Map ? args['wishListCubit'] : null;

        return MultiBlocProvider(
          providers: [
            if (searchCubit is SearchCubit)
              BlocProvider<SearchCubit>.value(value: searchCubit)
            else
              BlocProvider<SearchCubit>(
                create: (context) => SearchCubit()..getCategories(),
              ),
            if (wishListCubit is WishListCubit)
              BlocProvider<WishListCubit>.value(value: wishListCubit)
            else
              BlocProvider<WishListCubit>(
                create: (context) => WishListCubit()..getWishlistProducts(),
              ),
          ],
          child: const CustomerSearchScreen(),
        );
      },
    ),
    GetPage(
      name: AppRoutes.customerNotifications,
      page: () {
        final cubit = Get.arguments;

        if (cubit is CustomerCubit) {
          return BlocProvider<CustomerCubit>.value(
            value: cubit,
            child: const CustomerNotificationsScreen(),
          );
        }

        return BlocProvider<CustomerCubit>(
          create: (context) => CustomerCubit()..getNotifications(),
          child: const CustomerNotificationsScreen(),
        );
      },
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

        final cubit = args is Map ? args['reviewsCubit'] : null;
        if (cubit is ReviewsCubit) {
          return BlocProvider<ReviewsCubit>.value(
            value: cubit,
            child: CustomerWriteReviewScreen(product: product),
          );
        }

        return BlocProvider<ReviewsCubit>(
          create: (context) => ReviewsCubit(),
          child: CustomerWriteReviewScreen(product: product),
        );
      },
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
