import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/login_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/register_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/verify_password_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/home_cubit/home_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/order_cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/search_cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/customer_cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_layout.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_notifications_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_orderdetails_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_product_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_search_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_writereview_screen.dart';
import 'package:handmade_ecommerce_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_edit_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_bottom_nav.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_manage_products_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_registration_screen.dart';
import 'package:handmade_ecommerce_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const HandcraftedEcommerceApp());
}

class HandcraftedEcommerceApp extends StatelessWidget {
  const HandcraftedEcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (BuildContext context) => AuthCubit()),
            BlocProvider(
              create: (BuildContext context) => SellerCubit()..loadDashboard(),
            ),

            BlocProvider(create: (BuildContext context) => CustomerCubit()),
            BlocProvider(
              create: (BuildContext context) => HomeCubit()
                ..getFeaturedProducts()
                ..getTopRatedProducts(),
            ),
            BlocProvider(
              create: (BuildContext context) => SearchCubit()..getCategories(),
            ),
            BlocProvider(
              create: (context) => WishListCubit()..getWishlistProducts(),
            ),
            BlocProvider(create: (context) => CartCubit()..getcartProducts()),
            BlocProvider(create: (context) => OrderCubit()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.customerlayout, // AppRoutes.splash,
            getPages: [
              // splash and onboarding
              GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
              GetPage(
                name: AppRoutes.onboarding,
                page: () => const OnboardingScreen(),
              ),

              // auth
              GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
              GetPage(
                name: AppRoutes.register,
                page: () => const RegisterScreen(),
              ),
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

              // customer
              GetPage(
                name: AppRoutes.customerlayout,
                page: () => const CustomerLayout(),
              ),
              GetPage(
                name: AppRoutes.customerOrderDetails,
                page: () => CustomerOrderDetailsScreen(
                  order: Get.arguments as OrderModel,
                ),
              ),
              GetPage(
                name: AppRoutes.customerCart,
                page: () => CustomerCartScreen(),
              ),
              GetPage(
                name: AppRoutes.customerProductDetails,
                page: () => CustomerProductDetailsScreen(
                  product: Get.arguments as ProductModel,
                ),
              ),
              GetPage(
                name: AppRoutes.customerSearch,
                page: () => CustomerSearchScreen(),
              ),
              GetPage(
                name: AppRoutes.customerNotifications,
                page: () => const CustomerNotificationsScreen(),
              ),
              GetPage(
                name: AppRoutes.customerWriteReview,
                page: () => CustomerWriteReviewScreen(
                  product: Get.arguments as ProductModel,
                ),
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
                page: () => const SellerAddEditProductScreen(),
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
            ],
          ),
        );
      },
    );
  }
}
