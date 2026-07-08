import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/features/l10n/generated/app_localizations.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/service/customer_order_service.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/logic/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/notifications/data/services/notification_generator.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({CustomerOrderService? orderService})
    : _orderService = orderService ?? CustomerOrderService(),
      super(OrderInitial());

  final CustomerOrderService _orderService;
  List<CustomerOrderModel> allordersList = [];
  List<CustomerOrderModel> displayedordersList = [];
  OrderStatus? selectedStatus;
  int orderID = 1;

  Future<void> _refreshByCurrentFilter() async {
    displayedordersList = selectedStatus == null
        ? allordersList = await _orderService.getAllOrders()
        : await _orderService.getFilteredOrders(selectedStatus!);
  }

  Future<void> getAllOrders() async {
    selectedStatus = null;
    emit(GetAllOrdersLoading());
    try {
      allordersList = await _orderService.getAllOrders();
      displayedordersList = allordersList;
      emit(GetAllOrdersSuccess(orders: allordersList));
    } catch (e) {
      emit(GetAllOrdersError(message: e.toString()));
    }
  }

  Future<void> getFilteredOrders({required OrderStatus status}) async {
    selectedStatus = status;
    emit(GetFilteredOrdersLoading());
    try {
      final fetched = await _orderService.getFilteredOrders(status);
      displayedordersList = fetched;
      emit(GetFilteredOrdersSuccess(orders: fetched));
    } catch (e) {
      emit(GetFilteredOrdersError(message: e.toString()));
    }
  }

  Future<void> placeNewOrder(
    CustomerOrderModel newOrder,
    BuildContext context,
  ) async {
    emit(PlaceOrderLoading());
    try {
      final cartCubit = context.read<CartCubit>();
      await cartCubit.makePayment(newOrder.payment, context);
      await _orderService.placeOrder(newOrder);
      allordersList.add(newOrder);
      await _refreshByCurrentFilter();

      for (final product in newOrder.products) {
        final sellerEmail = product.seller.email;
        if (sellerEmail.isNotEmpty) {
          NotificationGenerator.onOrderCreated(
            sellerId: sellerEmail,
            orderId: newOrder.orderid,
            customerName: newOrder.customer.name,
            productName: product.name,
          );
        }
      }
      showSnack(
        title: AppLocalizations.of(Get.context!)!.success,
        message: AppLocalizations.of(Get.context!)!.orderPlacedSuccessfully,
      );
      emit(PlaceOrderSuccess());
      await cartCubit.clearCart();
    } catch (e) {
      emit(PlaceOrderError(message: e.toString()));
    }
  }

  Future<void> cancelOrder(String orderId) async {
    emit(CancelOrderLoading());
    try {
      // Find the order before cancelling it to extract sellers
      CustomerOrderModel? orderToCancel;
      try {
        orderToCancel = allordersList.firstWhere(
            (o) => o.orderid == orderId || o.orderid.contains(orderId));
      } catch (_) {}

      await _orderService.cancelOrder(orderId);
      await _refreshByCurrentFilter();
      // Trigger notification to sellers if we found the order
      if (orderToCancel != null) {
        for (final product in orderToCancel.products) {
          final sellerEmail = product.seller.email;
          if (sellerEmail.isNotEmpty) {
            NotificationGenerator.onOrderCancelledByCustomer(
              sellerId: sellerEmail,
              orderId: orderToCancel.orderid,
              customerName: orderToCancel.customer.name,
              productName: product.name,
            );
          }
        }
      }
      emit(CancelOrderSuccess());
      final state = selectedStatus == null
          ? GetAllOrdersSuccess(orders: displayedordersList) as OrderState
          : GetFilteredOrdersSuccess(orders: displayedordersList);
      emit(state);
    } catch (e) {
      emit(CancelOrderError(message: e.toString()));
    }
  }

  Future<int> getNewOrderID() => _orderService.getNextOrderID();
}
