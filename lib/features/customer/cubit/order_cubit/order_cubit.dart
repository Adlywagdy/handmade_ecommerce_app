import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_order_service.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';
import 'package:handmade_ecommerce_app/features/notifications/services/notification_generator.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit({FirebaseOrderService? orderService})
    : _orderService = orderService ?? FirebaseOrderService(),
      super(OrderInitial());

  final FirebaseOrderService _orderService;
  List<OrderModel> allordersList = [];
  List<OrderModel> filteredordersList = [];
  List<OrderModel> displayedordersList = [];
  OrderStatus? selectedStatus;
  String searchQuery = '';
  int orderID = 10050;


  void _syncDisplayedOrders(List<OrderModel> orders) {
    displayedordersList = orders;
  }

  /*------------------------------------------- */
  Future<void> getAllOrders() async {
    selectedStatus = null;
    emit(GetAllOrdersLoadingState());
    try {
      allordersList = await _orderService.getAllOrders();

      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(GetAllOrdersFailedState(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */

  Future<void> getFilteredOrders({required OrderStatus status}) async {
    selectedStatus = status;
    emit(GetFilteredOrdersLoadingState());
    try {
      filteredordersList = await _orderService.getFilteredOrders(status);

      _syncDisplayedOrders(filteredordersList);
      emit(GetFilteredOrdersSuccessState(filteredorders: filteredordersList));
    } catch (e) {
      emit(GetFilteredOrdersFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> getOrderDetails(String orderId) async {
    emit(GetOrderDetailsLoadingState());
    try {
      await _orderService.getOrderDetails(orderId);
      emit(GetOrderDetailsSuccessState());
    } catch (e) {
      emit(GetOrderDetailsFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> placeNewOrder(OrderModel newOrder, BuildContext context) async {
    emit(PlaceOrderLoadingState());
    try {
      final cartCubit = context.read<CartCubit>();
      await cartCubit.makePayment(newOrder.payment, context);
      await _orderService.placeOrder(newOrder);
      allordersList.add(newOrder);

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
      emit(PlaceOrderSuccessState());
      cartCubit.clearCart();
    } catch (e) {
      emit(PlaceOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> cancelOrder(String orderId) async {
    emit(CancelOrderLoadingState());
    try {
      await _orderService.cancelOrder(orderId);
      allordersList = await _orderService.getAllOrders();

      emit(CancelOrderSuccessState());
      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(CancelOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
}
