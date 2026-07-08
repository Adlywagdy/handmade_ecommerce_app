import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../logic/admin_cubit.dart';
import '../../../../data/models/orders_model.dart';
import '../orderdetails/order_details_screen.dart';
import 'order_card.dart';

class OrdersList extends StatelessWidget {
  final List<OrderModel> orders;

  const OrdersList({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Text(
          AppLocalizations.of(context)!.admNoOrdersFound,
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
          onTap: () => Get.to(
            () => BlocProvider.value(
              value: cubit,
              child: OrderDetailsScreen(orderId: order.id),
            ),
          ),
        );
      },
    );
  }
}
