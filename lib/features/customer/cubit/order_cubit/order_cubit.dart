import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_order_service.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

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
  int orderID = 10007;
  Timer? _searchDebounce;

  List<OrderModel> _applySearch(List<OrderModel> source, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return source;
    }

    return source.where((order) {
      return order.orderid.toLowerCase().contains(normalizedQuery) ||
          order.customer.name.toLowerCase().contains(normalizedQuery) ||
          order.customer.email.toLowerCase().contains(normalizedQuery) ||
          order.customer.phone.toLowerCase().contains(normalizedQuery);
    }).toList();
  }

  List<OrderModel> _ordersForActiveTab() {
    if (selectedStatus == null) {
      return allordersList;
    }

    return allordersList
        .where((order) => order.status == selectedStatus)
        .toList();
  }

  void _syncDisplayedOrders(List<OrderModel> orders) {
    displayedordersList = orders;
  }

  /*------------------------------------------- */
  Future<void> getAllOrders() async {
    selectedStatus = null;
    emit(GetAllOrdersLoadingState());
    try {
      allordersList = await _orderService.getAllOrders();
      _syncDisplayedOrders(_applySearch(allordersList, searchQuery));
      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(GetAllOrdersFailedState(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */

  Future<void> getFilteredOrders({required OrderStatus status}) async {
    selectedStatus = status;
    emit(GetFilteredOrdersLoadingState());
    try {
      final fetchedOrders = await _orderService.getFilteredOrders(status);
      filteredordersList = _applySearch(fetchedOrders, searchQuery);
      _syncDisplayedOrders(filteredordersList);
      emit(GetFilteredOrdersSuccessState(filteredorders: filteredordersList));
    } catch (e) {
      emit(GetFilteredOrdersFailedState(errorMessage: e.toString()));
    }
  }

  void searchOrders(String query) {
    searchQuery = query;

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      final source = _ordersForActiveTab();
      displayedordersList = _applySearch(source, searchQuery);
      if (selectedStatus != null) {
        filteredordersList = displayedordersList;
      }
      emit(SearchOrdersSuccessState(orders: displayedordersList));
    });
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
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
      filteredordersList = _applySearch(_ordersForActiveTab(), searchQuery);
      displayedordersList = _applySearch(_ordersForActiveTab(), searchQuery);
      emit(CancelOrderSuccessState());
      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(CancelOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
}
