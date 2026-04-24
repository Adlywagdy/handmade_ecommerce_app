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
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/services/seller_firestore_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'core/routes/app_pages.dart';
import 'core/services/remote_config_services.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('notifications');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ─── TEST FIREBASE CONNECTION ───
  try {
    final db = FirebaseFirestore.instance;
    await db.collection('test_connection').add({
      'message': 'Firebase is connected successfully!',
      'timestamp': FieldValue.serverTimestamp(),
    });
    debugPrint('✅ FIREBASE CONNECTION SUCCESSFUL! Document written.');
  } catch (e) {
    debugPrint('❌ FIREBASE CONNECTION FAILED: $e');
  }
  // ────────────────────────────────

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
              create: (BuildContext context) =>
                  SellerCubit(SellerFirestoreService())..loadDashboard(),
            ),
            BlocProvider(
              create: (BuildContext context) =>
                  NotificationsCubit()..loadNotifications(),
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
            BlocProvider(create: (context) => OrderCubit()..getAllOrders()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoutes.onboarding,
            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
