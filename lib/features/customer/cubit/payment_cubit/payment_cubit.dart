import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/customer/cubit/cart_cubit/cart_cubit.dart';
import 'package:handmade_ecommerce_app/features/customer/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_models.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_service.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit() : super(PaymentInitial());

  Future<void> makePayment(
    PaymentDetailsModel paymentmethoddetails,
    BuildContext context,
  ) async {
    emit(MakePaymentLoadingState());

    try {
      await Future.delayed(const Duration(seconds: 2), () {});

      switch (paymentmethoddetails.paymentMethod) {
        case 'Credit Card':
          // Handle Credit Card payment logic here
          break;
        case 'PayPal':
          PayPAlService.makePayPalpayment(
            context,
            AmountPaymentModel(
              total: paymentmethoddetails.totalPrice.toString(),
              currency: "USD",
              details: Details(
                subtotal: paymentmethoddetails.subtotalPrice.toString(),
                shipping: paymentmethoddetails.deliveryFee.toString(),
                shippingDiscount: paymentmethoddetails.discount!.toInt(),
              ),
            ),
            ItemListModel(
              orderslist: BlocProvider.of<CartCubit>(context).cartProductsList
                  .map(
                    (e) => OrderItemModel(
                      name: e.name,
                      quantity: e.quantity,
                      price: e.price.toString(),
                      currency: "USD",
                    ),
                  )
                  .toList(),
            ),
          );

          break;
        case 'Mobile Wallets':
          // Handle Mobile Wallets payment logic here
          break;
        default:
          throw Exception('Unsupported payment method');
      }

      emit(MakePaymentSuccessState());
    } catch (e) {
      emit(MakePaymentFailedState(e.toString()));
    }
  }
}
