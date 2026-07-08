import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:handmade_ecommerce_app/features/admin/presentation/screens/orders_screen/orderdetails/widgets/order_details_body.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import '../../../../../../core/theme/colors.dart';
import '../../../../cubit/admin_cubit.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminCubit, AdminState>(
      builder: (context, state) {
        final cubit = context.read<AdminCubit>();
        final order = cubit.orderById(orderId);
        if (order == null) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.admOrderTitle)),
            body: Center(child: Text(AppLocalizations.of(context)!.admOrderNotFound)),
          );
        }
        return Scaffold(
          backgroundColor: backGroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              order.displayId.isNotEmpty ? order.displayId : AppLocalizations.of(context)!.admOrderTitle,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: blackDegree,
              ),
            ),
            centerTitle: true,
          ),
          body: OrderDetailsBody(order: order, cubit: cubit),
        );
      },
    );
  }
}
