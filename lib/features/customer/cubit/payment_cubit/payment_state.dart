part of 'payment_cubit.dart';

sealed class PaymentState {}

final class PaymentInitial extends PaymentState {}
/*--------------------------------------- */

/*--------------------------------------- */
final class MakePaymentLoadingState extends PaymentState {}

final class MakePaymentSuccessState extends PaymentState {}

final class MakePaymentFailedState extends PaymentState {
  final String error;
  MakePaymentFailedState(this.error);
}
/*--------------------------------------- */