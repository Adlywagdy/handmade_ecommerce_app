import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/payment_cubit/payment_cubit.dart';

import 'package:handmade_ecommerce_app/features/customer/models/data/test_orderslistdata.dart';
import 'package:handmade_ecommerce_app/features/customer/models/order_model.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());
  List<OrderModel> allordersList = [];
  List<OrderModel> filteredordersList = [];
  /*------------------------------------------- */
  void getAllOrders() async {
    emit(GetAllOrdersLoadingState());
    try {
      // Simulate a delay for loading orders
      await Future.delayed(const Duration(seconds: 2));
      allordersList = ordersListdata; // Replace with actual data from Firestore
      emit(GetAllOrdersSuccessState(orders: allordersList));
    } catch (e) {
      emit(GetAllOrdersFailedState(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */

  void getFilteredOrders({required OrderStatus status}) {
    emit(GetFilteredOrdersLoadingState());
    try {
      // Simulate a delay for loading orders
      Future.delayed(const Duration(seconds: 2), () {});
      filteredordersList = allordersList.where((order) {
        return order.status == status;
      }).toList();
      emit(GetFilteredOrdersSuccessState(filteredorders: filteredordersList));
    } catch (e) {
      emit(GetFilteredOrdersFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  void getOrderDetails(String orderId) async {
    emit(GetOrderDetailsLoadingState());
    try {
      // Simulate a delay for loading order details
      await Future.delayed(const Duration(seconds: 2));
      // Replace with actual logic to fetch order details from Firestore
      emit(GetOrderDetailsSuccessState());
    } catch (e) {
      emit(GetOrderDetailsFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  Future<void> placeNewOrder(OrderModel newOrder, BuildContext context) async {
    emit(PlaceOrderLoadingState());
    try {
      // Simulate a delay
      await Future.delayed(const Duration(seconds: 2), () {});
      await BlocProvider.of<PaymentCubit>(
        context,
      ).makePayment(newOrder.payment, context);
      allordersList.add(
        newOrder,
      ); // Replace with actual logic to add order to orderslist in Firestore
      emit(PlaceOrderSuccessState());
    } catch (e) {
      emit(PlaceOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
  void cancelOrder(String orderId) async {
    emit(CancelOrderLoadingState());
    try {
      // Simulate a delay
      await Future.delayed(const Duration(seconds: 2), () {});
      allordersList.removeWhere((order) => order.orderid == orderId);
      emit(CancelOrderSuccessState());
    } catch (e) {
      emit(CancelOrderFailedState(errorMessage: e.toString()));
    }
  }

  /*------------------------------------------- */
}
