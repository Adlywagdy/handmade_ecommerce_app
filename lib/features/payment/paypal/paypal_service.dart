import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_models.dart';

class PayPAlService {
  static void makePayPalpayment(
    BuildContext context,
    AmountPaymentModel amount,
    ItemListModel orderItems,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true, //testingmode
          clientId:
              "AeV7F4kmJMM5jGe7eEXzxwOm74Fd6Rbq6lmhqHH8dAZDwmlqhncdUKu2ALrfgnY3owDvnVkvJTlwSSjl",
          secretKey:
              "EAp_Ir8B5vsuZQ3vxF2YosC3t45j9t9b7fL2Qw07-AxaIl2eZpqkkWhf8m-awnLWUZVuspV-E4ZZCIMM",
          transactions: [
            {
              "amount": amount.toJson(),
              "description": "The payment transaction description.",
              "item_list": orderItems.toJson(),
            },
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            log("onSuccess: $params");
            Navigator.pop(context);
          },
          onError: (error) {
            log("onError: $error");
            Navigator.pop(context);
          },
          onCancel: () {
            log('cancelled:');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
