import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/reset_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/login_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/register_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/verify_password_screen.dart';
import 'package:handmade_ecommerce_app/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_add_edit_product_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_dashboard_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_manage_products_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/seller/presentation/screens/seller_registration_screen.dart';
import 'package:handmade_ecommerce_app/features/splash/presentation/screens/splash_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
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
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
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
              // seller
              GetPage(
                name: AppRoutes.sellerdashboard,
                page: () => const SellerDashboardScreen(),
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

            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
