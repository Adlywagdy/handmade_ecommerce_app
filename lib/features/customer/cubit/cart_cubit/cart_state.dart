part of 'cart_cubit.dart';

sealed class CartState {}

final class CartInitial extends CartState {}

/* ------------------------------------------- */

final class GetcartLoadingstate extends CartState {}

final class GetcartSuccessedstate extends CartState {
  final List<ProductModel> cartproducts;

  GetcartSuccessedstate({required this.cartproducts});
}

final class GetcartFailedstate extends CartState {
  final String errorMessage;

  GetcartFailedstate({required this.errorMessage});
}
/* ------------------------------------------- */

final class AddcartLoadingstate extends CartState {}

final class AddcartSuccessedstate extends CartState {}

final class AddcartFailedstate extends CartState {
  final String errorMessage;

  AddcartFailedstate({required this.errorMessage});
}
/* ------------------------------------------- */

final class DeletecartLoadingstate extends CartState {}

final class DeletecartSuccessedstate extends CartState {}

final class DeletecartFailedstate extends CartState {
  final String errorMessage;

  DeletecartFailedstate({required this.errorMessage});
}
/*------------------------------------------- */

final class GetOrderSummaryLoadingState extends CartState {}

final class GetOrderSummarySuccessState extends CartState {
  final PaymentDetailsModel orderSummary;
  GetOrderSummarySuccessState({required this.orderSummary});
}

final class GetOrderSummaryFailedState extends CartState {
  final String errorMessage;
  GetOrderSummaryFailedState({required this.errorMessage});
}
