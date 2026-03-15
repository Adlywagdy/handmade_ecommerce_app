import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/errors/no_internet_connection.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  runApp(const HandcraftedEcommerceApp());
}

class HandcraftedEcommerceApp extends StatelessWidget {
  const HandcraftedEcommerceApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: NoInternetConnection(),
    );
  }
}
