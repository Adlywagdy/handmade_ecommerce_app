import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/core/widgets/customiconbutton.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/presentation/widgets/orderitem.dart';

class CustomerOrdersScreen extends StatelessWidget {
  final List<OrderModel> customerorderslist;
  const CustomerOrdersScreen({super.key, required this.customerorderslist});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
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
          title: Text('My Orders', style: AppTextStyles.t_18w700),
          bottom: TabBar(
            isScrollable: true,
            labelColor: commonColor,
            unselectedLabelColor: subTitleColor,
            indicatorColor: commonColor,
            indicatorWeight: 3,
            indicatorSize: .tab,
            tabAlignment: .start,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            labelStyle: AppTextStyles.t_14w700,
            unselectedLabelStyle: AppTextStyles.t_14w500,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Pending'),
              Tab(text: 'Confirmed'),
              Tab(text: 'Shipped'),
              Tab(text: 'Delivered'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrderList(customerorderslist: customerorderslist),
            OrderList(customerorderslist: customerorderslist),
            OrderList(customerorderslist: customerorderslist),
            OrderList(customerorderslist: customerorderslist),
            OrderList(customerorderslist: customerorderslist),
          ],
        ),
      ),
    );
  }
}

class OrderList extends StatelessWidget {
  final List<OrderModel> customerorderslist;
  const OrderList({super.key, required this.customerorderslist});
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: commonColor,
      backgroundColor: Colors.white,

      onRefresh: () {
        return Future.delayed(const Duration(seconds: 1));
      },
      child: ListView.builder(
        itemCount: customerorderslist.length,
        padding: const EdgeInsets.symmetric(horizontal: 16.0).w,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.customerOrderDetails,
                arguments: customerorderslist[index],
              );
            },
            child: OrderItem(order: customerorderslist[index]),
          );
        },
      ),
    );
  }
}
