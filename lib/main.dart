import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/home_cubit/home_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/order_cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/search_cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/customer_cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/wishlist_cubit/wishlist_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/routes/app_pages.dart';
import 'core/services/remote_config_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //////////////////////////// Crashlytics ///////////////////////////////////
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  ///////////////////////////// RemoteConfig //////////////////////////////////
  await RemoteConfigService.instance.init();
  /////////////////////////////////////////////////////////////////////////
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
            BlocProvider(
              create: (BuildContext context) => AuthCubit(AuthService()),
            ),
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

            BlocProvider(create: (context) => SellerCubit()..loadDashboard()),
            BlocProvider(create: (context) => CustomerCubit()),
            BlocProvider(
              create: (context) => HomeCubit()
                ..getFeaturedProducts()
                ..getTopRatedProducts(),
            ),
            BlocProvider(create: (context) => SearchCubit()..getCategories()),
            BlocProvider(
              create: (context) => WishListCubit()..getWishlistProducts(),
            ),
            BlocProvider(create: (context) => CartCubit()..getcartProducts()),
            BlocProvider(create: (context) => OrderCubit()..getAllOrders()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.splash,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
