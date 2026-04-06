import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/forget_password3.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/forget_password_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/login_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/register_screen.dart';
import 'package:handmade_ecommerce_app/features/auth/presentation/screens/verify_password.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_home_screen.dart';
import 'package:handmade_ecommerce_app/features/onboarding/presentation/screens/onboarding_screen.dart';
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
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            getPages: [
              GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
              GetPage(
                name: AppRoutes.onboarding,
                page: () => const OnboardingScreen(),
              ),
              GetPage(
                name: AppRoutes.customerHome,
                page: () => const CustomerHomeScreen(),
              ),
            ],

            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}


/*
  return MultiBlocProvider(
          providers: [
            BlocProvider(create: (BuildContext context) => AuthCubit()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/login',
            getPages: [
              GetPage(name: '/login', page: () => LoginScreen()),
              GetPage(name: '/register', page: () => RegisterScreen()),
              GetPage(name: '/forgot', page: () => ForgotPasswordScreen()),
              GetPage(name: '/verify', page: () => VerifytPassword()),
              GetPage(name: '/password', page: () => Password()),
            ],
          ),

          // home: RegisterScreen(),
          // home: ForgotPasswordScreen(),
          // home: VerifytPassword(),
          //  home: Password(),
        );
      },
    );
  }
}
 */