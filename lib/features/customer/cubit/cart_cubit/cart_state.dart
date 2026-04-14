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

final class AddcartproductLoadingstate extends CartState {}

final class AddcartproductSuccessedstate extends CartState {}

final class AddcartproductFailedstate extends CartState {
  final String errorMessage;

  AddcartproductFailedstate({required this.errorMessage});
}
/* ------------------------------------------- */

final class DeletecartproductLoadingstate extends CartState {}

final class DeletecartproductSuccessedstate extends CartState {}

final class DeletecartproductFailedstate extends CartState {
  final String errorMessage;

  DeletecartproductFailedstate({required this.errorMessage});
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
