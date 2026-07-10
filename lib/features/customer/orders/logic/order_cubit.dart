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

/// Manages order state: fetch, filter, place, and cancel orders.
class OrderCubit extends Cubit<OrderState> {
  OrderCubit({CustomerOrderService? orderService})
      : _orderService = orderService ?? CustomerOrderService(),
        super(OrderInitial());

  final CustomerOrderService _orderService;
  List<CustomerOrderModel> allordersList = [];
  List<CustomerOrderModel> displayedordersList = [];
  OrderStatus? selectedStatus;
  int orderID = 1;

  /// Refreshes the displayed list based on the currently active filter.
  Future<void> _refreshByCurrentFilter() async {
    if (selectedStatus == null) {
      allordersList = await _orderService.getAllOrders();
      displayedordersList = allordersList;
    } else {
      displayedordersList =
          await _orderService.getFilteredOrders(selectedStatus!);
    }
  }

  /// Loads all orders for the current user.
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

  /// Loads orders filtered by a specific status.
  Future<void> getFilteredOrders({required OrderStatus status}) async {
    selectedStatus = status;
    emit(GetFilteredOrdersLoading());
    try {
      displayedordersList = await _orderService.getFilteredOrders(status);
      emit(GetFilteredOrdersSuccess(orders: displayedordersList));
    } catch (e) {
      emit(GetFilteredOrdersError(message: e.toString()));
    }
  }

  /// Processes payment, saves the order, notifies sellers, and clears cart.
  Future<void> placeNewOrder(
    CustomerOrderModel newOrder,
    BuildContext context,
  ) async {
    emit(PlaceOrderLoading());
    try {
      final cartCubit = context.read<CartCubit>();

      // Process payment via the selected method (Visa/PayPal/Wallet/COD).
      await cartCubit.makePayment(newOrder.payment, context);

      // Save order to Firestore and decrement stock.
      await _orderService.placeOrder(newOrder);
      allordersList.add(newOrder);
      await _refreshByCurrentFilter();

      // Notify each seller about the new order.
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

  /// Cancels an order and notifies sellers of the cancellation.
  Future<void> cancelOrder(String orderId) async {
    emit(CancelOrderLoading());
    try {
      // Find the order in local list to get seller info before cancelling.
      CustomerOrderModel? orderToCancel;
      try {
        orderToCancel = allordersList.firstWhere(
            (o) => o.orderid == orderId || o.orderid.contains(orderId));
      } catch (_) {}

      await _orderService.cancelOrder(orderId);
      await _refreshByCurrentFilter();

      // Notify sellers about cancellation.
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
      // Re-emit the current list so UI updates.
      final state = selectedStatus == null
          ? GetAllOrdersSuccess(orders: displayedordersList) as OrderState
          : GetFilteredOrdersSuccess(orders: displayedordersList);
      emit(state);
    } catch (e) {
      emit(CancelOrderError(message: e.toString()));
    }
  }

  /// Gets the next sequential order ID from the Firestore counter.
  Future<int> getNewOrderID() => _orderService.getNextOrderID();
}
