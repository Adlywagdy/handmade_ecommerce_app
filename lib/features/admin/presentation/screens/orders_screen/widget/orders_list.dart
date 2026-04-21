import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../cubit/admin_cubit.dart';
import '../../../../models/orders_model.dart';
import '../order_details_screen.dart';
import 'order_card.dart';

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          'No orders found',
          style: TextStyle(fontSize: 14.sp, color: subTitleColor),
        ),
      );
    }
    final cubit = context.read<AdminCubit>();
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      itemCount: orders.length,
      itemBuilder: (c, i) {
        final order = orders[i];
        return OrderCard(
          order: order,
          onTap: () => Get.to(() => BlocProvider.value(
            value: cubit,
            child: OrderDetailsScreen(orderId: order.id),
          )),
        );
      },
    );
  }
}
