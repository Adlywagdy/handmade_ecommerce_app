import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/functions/get_initial_route.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
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

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.login);
  await Hive.openBox(HiveHelper.email);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await RemoteConfigService.instance.init();

  final initialRoute = await getInitialRoute();

  runApp(HandcraftedEcommerceApp(initialRoute: initialRoute));
}

class HandcraftedEcommerceApp extends StatelessWidget {
  final String initialRoute;

  const HandcraftedEcommerceApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit(AuthService())),
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
            initialRoute: initialRoute,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
