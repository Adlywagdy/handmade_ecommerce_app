import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/customer_button_navbar.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/orderitem.dart';

class CustomerOrdersScreen extends StatelessWidget {
  final List<OrderModel> customerorderslist;
  const CustomerOrdersScreen({super.key, required this.customerorderslist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customerbackGroundColor,
      appBar: AppBar(
        backgroundColor: customerbackGroundColor,
        scrolledUnderElevation: 0,
        centerTitle: true,
        actions: [
          CustomIconButton(
            backgroundColor: customerbackGroundColor,
            icon: Icons.search,
            iconcolor: commonColor,
          ),
        ],

        title: Text(
          'My Orders',
          style: TextStyle(
            color: blackDegree,
            fontSize: 18.sp,
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            height: 1.56,
            letterSpacing: -0.45,
          ),
        ),
      ),
      // tab bar should be here to filter orders by status (all, delivered, canceled, etc.)
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: customerorderslist.length,
              padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
              itemBuilder: (context, index) {
                return OrderItem(order: customerorderslist[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomerButtonNavBar(),
    );
  }
}
