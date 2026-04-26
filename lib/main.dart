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
import 'package:handmade_ecommerce_app/features/notifications/cubit/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/cubit/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/services/seller_firestore_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/routes/app_pages.dart';
import 'core/services/remote_config_services.dart';
import 'firebase_options.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notifications');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  ////////////////////////
  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.login);
  await Hive.openBox(HiveHelper.email);
  await Hive.openBox(HiveHelper.role);
  await Hive.openBox(HiveHelper.status);

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
                  NotificationsCubit()..loadNotifications(),
            ),
            // seller
            BlocProvider(
              create: (BuildContext context) =>
                  SellerCubit(SellerFirestoreService())..loadDashboard(),
            ),
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
