import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/features/auth/cubit/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/app_pages.dart';
import 'core/services/remote_config_services.dart';
import 'features/customer/cart/cart_cubit/cart_cubit.dart';
import 'features/customer/home/cubit/home_cubit.dart';
import 'features/customer/orders/cubit/order_cubit.dart';
import 'features/customer/profile/cubit/customer_cubit.dart';
import 'features/customer/search/cubit/search_cubit.dart';
import 'features/customer/wishlist/cubit/wishlist_cubit.dart';
import 'firebase_options.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notifications');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ////////////////////////
  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.login);
  await Hive.openBox(HiveHelper.email);

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
                  NotificationsCubit()..loadNotifications(),
            ),
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
