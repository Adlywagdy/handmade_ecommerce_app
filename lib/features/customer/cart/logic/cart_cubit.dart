import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/functions/get_snackbar_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/is_already_exicted_fun.dart';
import 'package:handmade_ecommerce_app/core/functions/orderpayment_functions.dart';
import 'package:handmade_ecommerce_app/core/models/product_model.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/data/services/firebase_cart_service.dart';
import 'package:handmade_ecommerce_app/core/models/coupon_model.dart';
import 'package:handmade_ecommerce_app/core/theme/colors.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/logic/customer_cubit.dart';
import 'package:handmade_ecommerce_app/core/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/cart/data/models/payment_model.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/constants.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/payment_webview.dart';
import 'package:handmade_ecommerce_app/features/payment/paymob/paymob_manager/paymob_manager.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_models.dart';
import 'package:handmade_ecommerce_app/features/payment/paypal/paypal_service.dart';
part 'cart_state.dart';

/// Manages cart state: add/remove products, order summary, payment, coupons.
class CartCubit extends Cubit<CartState> {
  CartCubit({FirebaseCartService? cartService})
    : _cartService = cartService ?? FirebaseCartService(),
      super(CartInitial());

  final FirebaseCartService _cartService;

  List<ProductModel> cartProductsList = [];
  AddressModel? selectedOrderAddress;
  String selectedPaymentMethod = "Visa";
  PaymentDetailsModel? currentOrderSummary;
  String walletPhonenumber = "";
  String selectedOrderPhone = "";
  String _appliedCoupon = "";
  List<CouponModel> _coupons = [];

  /// Loads cart products from Firestore and emits success/error state.
  Future<void> getcartProducts() async {
    emit(CartLoading());
    try {
      cartProductsList = await _cartService.getCartProducts();
<<<<<<< HEAD
      if (isClosed) return;
      emit(GetcartSuccessedstate(cartproducts: cartProductsList));
      getOrderSummary(products: cartProductsList);
    } catch (e) {
      if (isClosed) return;
      emit(GetcartFailedstate(errorMessage: e.toString()));
=======
      emit(CartSuccess(products: cartProductsList));
      getOrderSummary(products: cartProductsList);
    } catch (e) {
      emit(CartError(message: e.toString()));
>>>>>>> main
    }
  }

  /// Adds a product to the cart, shows snackbar feedback, and refreshes list.
  Future<void> addCartProducts(ProductModel product) async {
    emit(AddProductLoading());
    try {
      final alreadyExists = isItemExictedFun(
        productslist: cartProductsList,
        productID: product.id,
      );

      await _cartService.addToCart(product);
      cartProductsList = await _cartService.getCartProducts();

      if (!alreadyExists) {
        showSnack(
          title: "Success",
          message: "${product.name} has been added to your cart.",
          bgColor: Colors.green,
          icon: Icons.check_circle_outline,
        );
      }
<<<<<<< HEAD
      if (isClosed) return;
      emit(AddcartproductSuccessedstate());
      emit(GetcartSuccessedstate(cartproducts: cartProductsList));
      getOrderSummary(products: cartProductsList);
    } catch (e) {
      if (isClosed) return;
      emit(AddcartproductFailedstate(errorMessage: e.toString()));
=======
      emit(AddProductSuccess());
      emit(CartSuccess(products: cartProductsList));
      getOrderSummary(products: cartProductsList);
    } catch (e) {
      showSnack(
        title: "Error",
        message: e.toString().replaceAll('Exception: ', ''),
        bgColor: Colors.red,
        icon: Icons.error_outline,
      );
      emit(AddProductError(message: e.toString()));
>>>>>>> main
    }
  }

  /// Removes a product (decreases qty or deletes) and shows feedback.
  Future<void> deleteCartProducts(ProductModel product) async {
    emit(DeleteProductLoading());
    try {
      if (!isItemExictedFun(
        productslist: cartProductsList,
        productID: product.id,
      )) {
<<<<<<< HEAD
        await _cartService.removeFromCart(product.id);
        final previousLength = cartProductsList.length;
        cartProductsList = await _cartService.getCartProducts();

        if (cartProductsList.length < previousLength &&
            !isItemExictedFun(
              productslist: cartProductsList,
              productID: product.id,
            )) {
          showSnack(
            title: "Product Deleted",
            message: "${product.name} has been removed from your cart.",
            bgColor: redDegree,
            icon: CupertinoIcons.delete,
          );
        }
        if (isClosed) return;
        emit(DeletecartproductSuccessedstate());
        emit(GetcartSuccessedstate(cartproducts: cartProductsList));
        getOrderSummary(products: cartProductsList);
      }
    } catch (e) {
      if (isClosed) return;
      emit(DeletecartproductFailedstate(errorMessage: e.toString()));
    }
  } /*------------------------------------------- */
=======
        return;
      }
>>>>>>> main

      final previousLength = cartProductsList.length;
      await _cartService.removeFromCart(product.id);
      cartProductsList = await _cartService.getCartProducts();

      if (cartProductsList.length < previousLength &&
          !isItemExictedFun(
            productslist: cartProductsList,
            productID: product.id,
          )) {
        showSnack(
          title: "Product Deleted",
          message: "${product.name} has been removed from your cart.",
          bgColor: redDegree,
          icon: CupertinoIcons.delete,
        );
      }
      emit(DeleteProductSuccess());
      emit(CartSuccess(products: cartProductsList));
      getOrderSummary(products: cartProductsList);
    } catch (e) {
      emit(DeleteProductError(message: e.toString()));
    }
  }

  /// Calculates subtotal, applies coupon discount, and builds order summary.
  Future<void> getOrderSummary({
    required List<ProductModel> products,
    String? coupon,
    double deliveryFee = 0,
    bool showCouponFeedback = false,
  }) async {
    emit(OrderSummaryLoading());
    try {
      final effectiveCoupon = (coupon ?? _appliedCoupon).trim();
      _appliedCoupon = effectiveCoupon;

      if (_coupons.isEmpty) {
        _coupons = await _cartService.fetchCoupons();
      }

      final ordersubtotalPrice = calculateOrdersubTotalPrice(
        cartproducts: products,
      );
      final double discount = showCouponFeedback
          ? applyCoupon(effectiveCoupon, _coupons, subtotal: ordersubtotalPrice)
          : getCouponDiscount(
              effectiveCoupon,
              _coupons,
              subtotal: ordersubtotalPrice,
            );
      final totalPrice = ordersubtotalPrice + deliveryFee - discount;

      currentOrderSummary = PaymentDetailsModel(
        subtotalPrice: ordersubtotalPrice,
        totalPrice: totalPrice,
        deliveryFee: deliveryFee,
        discount: discount,
        paymentMethod: selectedPaymentMethod,
        currency: "EGP",
      );
      emit(
        OrderSummarySuccess(
          subtotalPrice: ordersubtotalPrice,
          totalPrice: totalPrice,
          deliveryFee: deliveryFee,
          discount: discount,
        ),
      );
    } catch (e) {
      emit(OrderSummaryError(message: e.toString()));
    }
  }

  /// Stores the selected delivery address.
  void getOrderaddress({required AddressModel address}) {
    selectedOrderAddress = address;
    emit(OrderAddressSuccess(address: address));
  }

  /// Stores the customer's phone number for the order.
  void setOrderPhone(String phone) {
    selectedOrderPhone = phone;
  }

  /// Processes payment via Visa, PayPal, Mobile Wallet, or Cash on Delivery.
  Future<void> makePayment(
    PaymentDetailsModel paymentmethoddetails,
    BuildContext context,
  ) async {
    final manager = PaymobManager();
    final paymentMethod =
        paymentmethoddetails.paymentMethod ?? selectedPaymentMethod;
    final amount = paymentmethoddetails.totalPrice?.round();

    if (amount == null) throw Exception("Payment amount is missing");

    switch (paymentMethod) {
      case 'Visa':
        final paymentKey = await manager.getPaymentKey(
          amount: amount,
          currency: "EGP",
          integrationId: Constants.integrationIdCard,
        );
        final url =
            "https://accept.paymob.com/api/acceptance/iframes/${Constants.iframeId}?payment_token=$paymentKey";

        if (!context.mounted) {
          throw Exception("Payment screen is no longer available");
        }
        final paymentResult = await Navigator.of(context).push<bool>(
          MaterialPageRoute(builder: (_) => PaymentWebView(paymentUrl: url)),
        );
        if (paymentResult != true) {
          throw Exception("Visa payment was not completed");
        }
        break;

      case 'PayPal':
        const double conversionRate = 50;
        final convertedSubtotal =
            paymentmethoddetails.subtotalPrice! / conversionRate;
        final convertedShipping =
            paymentmethoddetails.deliveryFee! / conversionRate;
        final convertedDiscount =
            paymentmethoddetails.discount! / conversionRate;
        final convertedTotal =
            paymentmethoddetails.totalPrice! / conversionRate;

        final paypalSuccess = await PayPAlService.makePayPalpayment(
          context,
          AmountPaymentModel(
            total: convertedTotal.toStringAsFixed(2),
            currency: "USD",
            details: Details(
              subtotal: convertedSubtotal.toStringAsFixed(2),
              shipping: convertedShipping.toStringAsFixed(2),
              shippingDiscount: convertedDiscount.toStringAsFixed(2),
            ),
          ),
          ItemListModel(
            orderslist: cartProductsList
                .map(
                  (e) => OrderItemModel(
                    name: e.name,
                    quantity: e.quantity,
                    price: (e.price / conversionRate).toStringAsFixed(2),
                    currency: "USD",
                  ),
                )
                .toList(),
          ),
        );
        if (!paypalSuccess) throw Exception("PayPal payment was not completed");
        break;

      case 'Mobile Wallets':
        final customerPhone = walletPhonenumber.trim().isNotEmpty
            ? walletPhonenumber.trim()
            : BlocProvider.of<CustomerCubit>(context).customerData.phone.trim();

        if (customerPhone.isEmpty) {
          throw Exception(
            "Customer phone number is required for wallet payment",
          );
        }
        final phoneRegex = RegExp(r'^(\+201|01)[0-9]{9}$');
        if (!phoneRegex.hasMatch(customerPhone)) {
          throw Exception(
            "Customer phone number is invalid for wallet payment",
          );
        }

        final paymentKey = await manager.getPaymentKey(
          amount: amount,
          currency: "EGP",
          integrationId: Constants.integrationIdWallet,
        );
        final redirectUrl = await manager.payWithWallet(
          paymentKey: paymentKey,
          phone: customerPhone,
        );

        if (!context.mounted) {
          throw Exception("Payment screen is no longer available");
        }
        final paymentResult = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
            builder: (_) => PaymentWebView(paymentUrl: redirectUrl),
          ),
        );
        if (paymentResult != true) {
          throw Exception("Wallet payment was not completed");
        }
        break;

      case 'Cash on Delivery':
        break;

<<<<<<< HEAD
          if (paymentResult != true) {
            throw Exception("Wallet payment was not completed");
          }
          break;
        default:
          throw Exception("Unsupported payment method: $paymentMethod");
      }

      if (isClosed) return;
      emit(MakePaymentSuccessState());

      emit(GetcartSuccessedstate(cartproducts: cartProductsList));
    } catch (e) {
      // Guard the emit but always rethrow so the caller (placeNewOrder) still
      // sees the failure and its own error handling runs.
      if (!isClosed) emit(MakePaymentFailedState(e.toString()));
      rethrow;
=======
      default:
        throw Exception("Unsupported payment method: $paymentMethod");
>>>>>>> main
    }
  }

  /// Clears cart, products, and all order-related state.
  Future<void> clearCart() async {
    await _cartService.clearCart();
    cartProductsList.clear();
    currentOrderSummary = null;
    selectedOrderAddress = null;
    selectedPaymentMethod = "Visa";
    walletPhonenumber = "";
    selectedOrderPhone = "";
    _appliedCoupon = "";
<<<<<<< HEAD
    if (isClosed) return;
    emit(GetcartSuccessedstate(cartproducts: cartProductsList));
=======
    _coupons = [];
    emit(CartSuccess(products: cartProductsList));
>>>>>>> main
  }
}
