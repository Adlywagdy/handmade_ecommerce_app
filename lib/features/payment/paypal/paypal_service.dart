import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_models.dart';

class PayPAlService {
  static Future<bool> makePayPalpayment(
    BuildContext context,
    AmountPaymentModel amount,
    ItemListModel orderItems,
  ) async {
    final completer = Completer<bool>();

    void completeAndClose(bool isSuccess) {
      if (!completer.isCompleted) {
        completer.complete(isSuccess);
      }
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }

    final checkoutRoute = Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true, //testingmode
          clientId:
              "AeV7F4kmJMM5jGe7eEXzxwOm74Fd6Rbq6lmhqHH8dAZDwmlqhncdUKu2ALrfgnY3owDvnVkvJTlwSSjl",
          secretKey:
              "EJxaQFcQozr0MC5uhwjGUoyYtvmG2PSe3H1a8zJpUafruKW9t8Fv0EoT5TGMYCBT7MMObYbmgGHZPA82",
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
            completeAndClose(true);
          },
          onError: (error) {
            log("onError: $error");
            completeAndClose(false);
          },
          onCancel: () {
            log('cancelled:');
            completeAndClose(false);
          },
        ),
      ),
    );

    checkoutRoute.whenComplete(() {
      if (!completer.isCompleted) {
        completer.complete(false);
      }
    });

    return completer.future;
  }
}
