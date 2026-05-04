import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/functions/get_initial_route.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/home/cubit/home_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/search/cubit/search_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/cubit/customer_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/wishlist/cubit/wishlist_cubit.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/reviews/cubit/reviews_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/services/seller_firestore_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/app_pages.dart';
import 'core/services/remote_config_services.dart';
import 'firebase_options.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox('notifications');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.login);
  await Hive.openBox(HiveHelper.email);

  // ─── TEST FIREBASE CONNECTION ───
  try {
    final db = FirebaseFirestore.instance;
    await db.collection('test_connection').add({
      'message': 'Firebase is connected successfully!',
      'timestamp': FieldValue.serverTimestamp(),
    });
    debugPrint('FIREBASE CONNECTION SUCCESSFUL! Document written.');
  } catch (e) {
    debugPrint('FIREBASE CONNECTION FAILED: $e');
  }

  //////////////////////////// Crashlytics ///////////////////////////////////
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
            BlocProvider(create: (context) => ReviewsCubit()),
          ],
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: initialRoute,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback: (locale, supportedLocales) {
              if (locale == null) return supportedLocales.first;
              for (final supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale.languageCode) {
                  return supportedLocale;
                }
              }
              return supportedLocales.first;
            },

            getPages: AppPages.pages,
          ),
        );
      },
    );
  }
}
