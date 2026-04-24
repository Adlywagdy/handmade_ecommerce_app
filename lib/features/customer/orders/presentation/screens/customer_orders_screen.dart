import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';
import 'package:handmade_ecommerce_app/core/theme/app_theme.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/cubit/order_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/presentation/widgets/orderitem.dart';

class CustomerOrdersScreen extends StatelessWidget {
  const CustomerOrdersScreen({super.key});

  static const List<String> _tabs = [
    'All',
    'Pending',
    'Confirmed',
    'Preparing',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  OrderStatus _statusFromTab(int tabIndex) {
    switch (tabIndex) {
      case 1:
        return OrderStatus.pending;
      case 2:
        return OrderStatus.confirmed;
      case 3:
        return OrderStatus.preparing;
      case 4:
        return OrderStatus.shipped;
      case 5:
        return OrderStatus.delivered;
      case 6:
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  Future<void> _loadByTab(BuildContext context, int tabIndex) {
    if (tabIndex == 0) {
      return context.read<OrderCubit>().getAllOrders();
    }

    return context.read<OrderCubit>().getFilteredOrders(
      status: _statusFromTab(tabIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        backgroundColor: customerbackGroundColor,
        appBar: AppBar(
          backgroundColor: customerbackGroundColor,
          scrolledUnderElevation: 0,
          centerTitle: true,
          title: Text('My Orders', style: AppTextStyles.t_18w700),
          bottom: TabBar(
            isScrollable: true,

            onTap: (tabIndex) => _loadByTab(context, tabIndex),
            labelColor: commonColor,
            unselectedLabelColor: subTitleColor,
            indicatorColor: commonColor,
            indicatorWeight: 3,
            indicatorSize: TabBarIndicatorSize.tab,
            tabAlignment: TabAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            labelStyle: AppTextStyles.t_14w700,
            unselectedLabelStyle: AppTextStyles.t_14w500,
            tabs: _tabs.map((title) => Tab(text: title)).toList(),
          ),
        ),
        body: BlocBuilder<OrderCubit, OrderState>(
          buildWhen: (previous, current) {
            return current is GetAllOrdersLoadingState ||
                current is GetAllOrdersSuccessState ||
                current is GetAllOrdersFailedState ||
                current is GetFilteredOrdersLoadingState ||
                current is GetFilteredOrdersSuccessState ||
                current is GetFilteredOrdersFailedState ||
                current is SearchOrdersSuccessState ||
                current is CancelOrderSuccessState ||
                current is PlaceOrderSuccessState;
          },
          builder: (context, state) {
            final orderCubit = context.read<OrderCubit>();
            final orders = orderCubit.displayedordersList;

            if ((state is GetAllOrdersLoadingState ||
                    state is GetFilteredOrdersLoadingState) &&
                orders.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(color: commonColor),
              );
            }

            if ((state is GetAllOrdersFailedState ||
                    state is GetFilteredOrdersFailedState) &&
                orders.isEmpty) {
              return Center(
                child: Text(
                  'Failed to load orders. Pull to refresh.',
                  style: AppTextStyles.t_14w500.copyWith(color: redDegree),
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: orders.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 140.h),
                            Center(
                              child: Text(
                                'No orders found in this tab.',
                                style: AppTextStyles.t_14w500.copyWith(
                                  color: subTitleColor,
                                ),
                              ),
                            ),
                          ],
                        )
                      : RefreshIndicator(
                          color: commonColor,
                          backgroundColor: Colors.white,
                          onRefresh: () {
                            final tabIndex = DefaultTabController.of(
                              context,
                            ).index;
                            return _loadByTab(context, tabIndex);
                          },
                          child: ListView.builder(
                            itemCount: orders.length,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ).w,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    AppRoutes.customerOrderDetails,
                                    arguments: orders[index],
                                  );
                                },
                                child: OrderItem(order: orders[index]),
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
