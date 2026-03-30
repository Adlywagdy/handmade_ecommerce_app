import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_orderdetails_screen.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_writereview_screen.dart';
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
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,

          home:
              //CustomerWriteReviewScreen(product: productsListData[0]),
              CustomerOrderDetailsScreen(
                order: OrderModel(
                  customer: CustomerModel(name: "adly"),
                  products: productsListData,
                  orderid: '#AY-9402',
                ),
              ),

          // CustomerProfilesScreen(
          //   customer: CustomerModel(
          //     name: "Adly Wagdy",
          //     email: "adly.wagdy@ayady.com",
          //     image: "assets/images/splash.jpeg",
          //   ),
          // ),
          //  CustomerOrdersScreen(
          //   customerorderslist: [
          //     OrderModel(
          //       customer: CustomerModel(name: "adly"),
          //       orderid: '#AY-84920',
          //       products: productsListData,

          //       payment: PaymentDetailsModel(
          //         paymentMethod: 'Credit Card',
          //         totalPrice: 500.00,
          //         discount: 50.00,
          //       ),
          //       orderDate: DateTime.now().subtract(const Duration(days: 2)),
          //       status: .delivered,
          //     ),
          //     OrderModel(
          //       customer: CustomerModel(name: "adly"),
          //       orderid: '#AY-84920',
          //       products: productsListData,

          //       payment: PaymentDetailsModel(
          //         paymentMethod: 'Credit Card',
          //         totalPrice: 500.00,
          //         discount: 50.00,
          //       ),
          //       orderDate: DateTime.now().subtract(const Duration(days: 2)),
          //       status: .confirmed,
          //     ),
          //     OrderModel(
          //       customer: CustomerModel(name: "adly"),
          //       orderid: '#AY-84920',
          //       products: productsListData,

          //       payment: PaymentDetailsModel(
          //         paymentMethod: 'Credit Card',
          //         totalPrice: 500.00,
          //         discount: 50.00,
          //       ),
          //       orderDate: DateTime.now().subtract(const Duration(days: 2)),
          //       status: .pending,
          //     ),
          //     OrderModel(
          //       customer: CustomerModel(name: "adly"),
          //       orderid: '#AY-84920',
          //       products: productsListData,

          //       payment: PaymentDetailsModel(
          //         paymentMethod: 'Credit Card',
          //         totalPrice: 500.00,
          //         discount: 50.00,
          //       ),
          //       orderDate: DateTime.now().subtract(const Duration(days: 2)),
          //       status: .shipped,
          //     ),
          //     OrderModel(
          //       customer: CustomerModel(name: "adly"),
          //       orderid: '#AY-84920',
          //       products: productsListData,
          //       payment: PaymentDetailsModel(
          //         paymentMethod: 'PayPal',
          //         totalPrice: 124.00,
          //         discount: 20.00,
          //       ),
          //       orderDate: DateTime.now().subtract(const Duration(days: 1)),
          //       status: .cancelled,
          //     ),
          //     OrderModel(
          //       customer: CustomerModel(name: "adly"),
          //       orderid: '#AY-84920',
          //       products: productsListData,
          //       payment: PaymentDetailsModel(
          //         paymentMethod: 'PayPal',
          //         totalPrice: 124.00,
          //         discount: 20.00,
          //       ),
          //       orderDate: DateTime.now().subtract(const Duration(days: 1)),
          //       status: .returned,
          //     ),
          //     OrderModel(
          //       customer: CustomerModel(name: "adly"),
          //       orderid: '#AY-84920',
          //       products: productsListData,
          //       payment: PaymentDetailsModel(
          //         paymentMethod: 'PayPal',
          //         totalPrice: 124.00,
          //         discount: 20.00,
          //       ),
          //       orderDate: DateTime.now().subtract(const Duration(days: 1)),
          //       status: .preparing,
          //     ),
          //   ],
          // ),
        );
      },
    );
  }
}
