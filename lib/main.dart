import 'dart:ui';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/cubit/locale_cubit.dart';
import 'package:handmade_ecommerce_app/core/debugging/bloc_observer.dart';
import 'package:handmade_ecommerce_app/core/functions/get_initial_route.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/features/auth/logic/auth_cubit.dart';
import 'package:handmade_ecommerce_app/features/notifications/logic/notifications_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/logic/seller_cubit.dart';
import 'package:handmade_ecommerce_app/features/seller/data/services/seller_firestore_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:handmade_ecommerce_app/features/auth/data/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:handmade_ecommerce_app/features/notifications/data/services/fcm_service.dart';
import 'core/routes/app_pages.dart';
import 'core/services/remote_config_services.dart';
import 'firebase_options.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('notifications');
  await Hive.openBox(HiveHelper.onboardingBox);
  await Hive.openBox(HiveHelper.login);
  await Hive.openBox(HiveHelper.email);
  await Hive.openBox(HiveHelper.role);
  await Hive.openBox(HiveHelper.status);
  await Hive.openBox(HiveHelper.language);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize FCM Services
  await FCMService.init();
  final token = await FCMService.getToken();
  debugPrint("==============");
  debugPrint("FCM TOKEN: $token");
  debugPrint("==============");
  // Sync token if user is already logged in
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser != null) {
    try {
      final token = await FCMService.getToken();
      if (token != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .set({'fcmToken': token}, SetOptions(merge: true));
        debugPrint('✅ FCM Token synced on app startup for: ${currentUser.uid}');
      }
    } catch (e) {
      debugPrint('❌ Failed to sync FCM Token on app startup: $e');
    }
  }

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

  await RemoteConfigService.instance.init();
  final initialRoute = await getInitialRoute();
  Bloc.observer = MyCubitObserver();
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
            BlocProvider(
              create: (BuildContext context) =>
                  SellerCubit(SellerFirestoreService())..loadDashboard(),
            ),
            BlocProvider(
              create: (BuildContext context) =>
                  LocaleCubit()..loadSavedLocale(),
            ),
          ],
          child: BlocBuilder<LocaleCubit, Locale?>(
            builder: (context, locale) {
              return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                initialRoute: initialRoute,
                locale: locale,
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
              );
            },
          ),
        );
      },
    );
  }
}
