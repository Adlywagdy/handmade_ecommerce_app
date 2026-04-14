part of 'order_cubit.dart';

sealed class OrderState {}

final class OrderInitial extends OrderState {}

/*------------------------------------------- */
final class GetAllOrdersLoadingState extends OrderState {}

final class GetAllOrdersSuccessState extends OrderState {
  final List<OrderModel> orders;
  GetAllOrdersSuccessState({required this.orders});
}

final class GetAllOrdersFailedState extends OrderState {
  final String errorMessage;
  GetAllOrdersFailedState({required this.errorMessage});
}

/*------------------------------------------- */
final class GetFilteredOrdersLoadingState extends OrderState {}

final class GetFilteredOrdersSuccessState extends OrderState {
  final List<OrderModel> filteredorders;
  GetFilteredOrdersSuccessState({required this.filteredorders});
}

final class GetFilteredOrdersFailedState extends OrderState {
  final String errorMessage;
  GetFilteredOrdersFailedState({required this.errorMessage});
}

/*------------------------------------------- */
final class GetOrderDetailsLoadingState extends OrderState {}

final class GetOrderDetailsSuccessState extends OrderState {}

final class GetOrderDetailsFailedState extends OrderState {
  final String errorMessage;
  GetOrderDetailsFailedState({required this.errorMessage});
}

/*------------------------------------------- */
final class GenerateNewOrderLoadingState extends OrderState {}

final class GenerateNewOrderSuccessState extends OrderState {}

final class GenerateNewOrderFailedState extends OrderState {
  final String errorMessage;
  GenerateNewOrderFailedState({required this.errorMessage});
}

/*------------------------------------------- */
final class CancelOrderLoadingState extends OrderState {}

final class CancelOrderSuccessState extends OrderState {}

final class CancelOrderFailedState extends OrderState {
  final String errorMessage;
  CancelOrderFailedState({required this.errorMessage});
}
