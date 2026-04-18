import 'package:dio/dio.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/constants.dart';

class PaymobManager {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://accept.paymob.com/api",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ),
  );

  Future<String> getPaymentKey({
    required int amount,
    required String currency,
    required int integrationId,
  }) async {
    try {
      final authToken = await _getAuthToken();

      final orderId = await _createOrder(
        authToken: authToken,
        amount: (amount * 100).toString(),
        currency: currency,
      );

      final paymentKey = await _getPaymentKey(
        authToken: authToken,
        orderId: orderId.toString(),
        amount: (amount * 100).toString(),
        currency: currency,
        integrationId: integrationId,
      );

      return paymentKey;
    } catch (e) {
      throw Exception("Payment Error: $e");
    }
  }

  Future<String> _getAuthToken() async {
    final response = await _dio.post(
      "/auth/tokens",
      data: {
        "api_key": Constants.apiKey, 
        
      },
    );

    return response.data["token"];
  }

  Future<int> _createOrder({
    required String authToken,
    required String amount,
    required String currency,
  }) async {
    final response = await _dio.post(
      "/ecommerce/orders",
      data: {
        "auth_token": authToken,
        "amount_cents": amount,
        "currency": currency,
        "delivery_needed": false,
        "items": [],
      },
    );

    return response.data["id"];
  }

  Future<String> _getPaymentKey({
    required String authToken,
    required String orderId,
    required String amount,
    required String currency,
    required int integrationId,
  }) async {
    final response = await _dio.post(
      "/acceptance/payment_keys",
      data: {
        "expiration": 3600,
        "auth_token": authToken,
        "order_id": orderId,
        "integration_id": integrationId,
        "amount_cents": amount,
        "currency": currency,
        "billing_data": {
          "first_name": "Ahmed",
          "last_name": "Elsaify",
          "email": "test@test.com",
          "phone_number": "+201021417663",

          // معلومات user
          "apartment": "NA",
          "floor": "NA",
          "street": "NA",
          "building": "NA",
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "Cairo",
          "country": "EG",
          "state": "Cairo",
        },
      },
    );

    return response.data["token"];
  }

  // Wallet
  Future<String> payWithWallet({
    required String paymentKey,
    required String phone,
  }) async {
    final response = await _dio.post(
      "/acceptance/payments/pay",
      data: {
        "source": {
          "identifier": phone,
          "subtype": "WALLET",
        },
        "payment_token": paymentKey,
      },
    );

    return response.data["redirect_url"];
  }
}