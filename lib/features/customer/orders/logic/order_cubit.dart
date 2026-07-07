import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/services/customer_order_service.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/logic/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/orders/data/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/notifications/services/notification_generator.dart';

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
    emit(GetAllOrdersLoadingState());
    try {
      allordersList = await _orderService.getAllOrders();
      displayedordersList = allordersList;
      if (isClosed) return;
      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      if (isClosed) return;
      emit(GetAllOrdersFailedState(errorMessage: e.toString()));
    }
  }

  Future<void> getFilteredOrders({required OrderStatus status}) async {
    selectedStatus = status;
    emit(GetFilteredOrdersLoadingState());
    try {
      final fetched = await _orderService.getFilteredOrders(status);
      displayedordersList = fetched;
      if (isClosed) return;
      emit(GetFilteredOrdersSuccessState(filteredorders: fetched));
    } catch (e) {
      if (isClosed) return;
      emit(GetFilteredOrdersFailedState(errorMessage: e.toString()));
    }
  }

  Future<void> getOrderDetails(String orderId) async {
    emit(GetOrderDetailsLoadingState());
    try {
      await _orderService.getOrderDetails(orderId);
      if (isClosed) return;
      emit(GetOrderDetailsSuccessState());
    } catch (e) {
      if (isClosed) return;
      emit(GetOrderDetailsFailedState(errorMessage: e.toString()));
    }
  }

  Future<void> placeNewOrder(
    CustomerOrderModel newOrder,
    BuildContext context,
  ) async {
    emit(PlaceOrderLoadingState());
    try {
      final cartCubit = context.read<CartCubit>();
      await cartCubit.makePayment(newOrder.payment, context);
      await _orderService.placeOrder(newOrder);
      allordersList.add(newOrder);
      await _refreshByCurrentFilter();

      // Trigger notifications for the seller(s) of the ordered products
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
      showSnack(title: "Success", message: "Order placed successfully.");
      if (isClosed) return;
      emit(PlaceOrderSuccessState());
      await cartCubit.clearCart();
    } catch (e) {
      if (isClosed) return;
      emit(PlaceOrderFailedState(errorMessage: e.toString()));
    }
  }

  Future<void> cancelOrder(String orderId) async {
    emit(CancelOrderLoadingState());
    try {
      await _orderService.cancelOrder(orderId);
      await _refreshByCurrentFilter();
      if (isClosed) return;
      emit(CancelOrderSuccessState());
      final state = selectedStatus == null
          ? GetAllOrdersSuccessState(orders: displayedordersList) as OrderState
          : GetFilteredOrdersSuccessState(filteredorders: displayedordersList);
      emit(state);
    } catch (e) {
      if (isClosed) return;
      emit(CancelOrderFailedState(errorMessage: e.toString()));
    }
  }

  Future<int> getNewOrderID() => _orderService.getNextOrderID();
}
