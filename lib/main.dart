import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';

import 'package:handmade_ecommerce_app/features/customer/models/data/test_productslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/screens/customer_cart_screen.dart';

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

          home: CustomerCartScreen(
            order: OrderModel(
              customer: CustomerModel(name: "Adly"),
              products: productsListData,
              orderid: "123",
              payment: PaymentDetailsModel(
                subtotalPrice: 500,
                totalPrice: 520,
                deliveryFee: 20,
                discount: 0,
              ),
            ),
          ),
        );
      },
    );
  }
}
