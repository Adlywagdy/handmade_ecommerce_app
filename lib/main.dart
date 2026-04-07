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
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_cart_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_home_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_orderdetails_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_orders_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_product_details_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_profile_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_search_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_wishlist_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_writereview_screen.dart';
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
            initialRoute: AppRoutes.customerHome, // AppRoutes.splash,
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
                name: AppRoutes.customerHome,
                page: () => const CustomerHomeScreen(),
              ),
              GetPage(
                name: AppRoutes.customerCart,
                page: () => CustomerCartScreen(
                  order: OrderModel(
                    customer: CustomerModel(name: "adly"),
                    products: productsListData,
                    orderid: '#AY-9402',
                  ),
                ),
              ),
              GetPage(
                name: AppRoutes.customerOrderDetails,
                page: () => CustomerOrderDetailsScreen(
                  order: OrderModel(
                    customer: CustomerModel(name: "adly"),
                    products: productsListData,
                    orderid: '#AY-9402',
                  ),
                ),
              ),
              GetPage(
                name: AppRoutes.customerOrders,
                page: () => CustomerOrdersScreen(
                  customerorderslist: [
                    OrderModel(
                      customer: CustomerModel(name: "adly"),
                      orderid: '#AY-84920',
                      products: productsListData,

                      payment: PaymentDetailsModel(
                        paymentMethod: 'Credit Card',
                        totalPrice: 500.00,
                        discount: 50.00,
                      ),
                      orderDate: DateTime.now().subtract(
                        const Duration(days: 2),
                      ),
                      status: .delivered,
                    ),
                    OrderModel(
                      customer: CustomerModel(name: "adly"),
                      orderid: '#AY-84920',
                      products: productsListData,

                      payment: PaymentDetailsModel(
                        paymentMethod: 'Credit Card',
                        totalPrice: 500.00,
                        discount: 50.00,
                      ),
                      orderDate: DateTime.now().subtract(
                        const Duration(days: 2),
                      ),
                      status: .confirmed,
                    ),
                  ],
                ),
              ),
              GetPage(
                name: AppRoutes.customerProductDetails,
                page: () =>
                    CustomerProductDetailsScreen(product: productsListData[0]),
              ),
              GetPage(
                name: AppRoutes.customerProfile,
                page: () => CustomerProfilesScreen(
                  customer: CustomerModel(
                    name: "Adly Wagdy",
                    email: "adly.wagdy@ayady.com",
                    image: "assets/images/splash.jpeg",
                  ),
                ),
              ),
              GetPage(
                name: AppRoutes.customerSearch,
                page: () => const CustomerSearchScreen(),
              ),
              GetPage(
                name: AppRoutes.customerWriteReview,
                page: () =>
                    CustomerWriteReviewScreen(product: productsListData[0]),
              ),
              GetPage(
                name: AppRoutes.customerwishlist,
                page: () => const CustomerWishlistScreen(),
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
          ),
        );
      },
    );
  }
}
