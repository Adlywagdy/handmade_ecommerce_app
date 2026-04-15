import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit() : super(CustomerInitial());
  CustomerModel customerData = CustomerModel(
    name: "Adly",
    email: "adly.wagdy@ayady.com",
    image: "assets/images/splash.jpeg",
    password: "561651",
    phone: "0651616161681",
  ); /* ------------------------------------------- */

  void getCustomerdata() async {
    emit(GetCustomerdataLoadingstate());
    try {
      // Simulate a delay for loading featured products
      await Future.delayed(const Duration(seconds: 2), () {});

      // should trigger to get customer data logic here
      customerData = CustomerModel(
        name: "Adly",
        email: "adly.wagdy@ayady.com",
        image: "assets/images/splash.jpeg",
        password: "561651",
        phone: "0651616161681",
      );
      emit(GetCustomerdataSuccessedstate(customer: customerData));
    } catch (e) {
      emit(GetCustomerdataFailedstate(errorMessage: e.toString()));
    }
  }
  /* ------------------------------------------- */

  void getNotifications() async {
    emit(NotificationsLoadingstate());
    try {
      // Simulate a delay for loading top-rated products
      await Future.delayed(const Duration(seconds: 2), () {});

      // should trigger get top-rated products logic here
      List<String> notificationslist = [
        "Your order #1234 has been shipped!",
        "Your order #5678 has been delivered!",
        "Your order #9012 has been cancelled.",
      ]; // replace with actual data
      emit(
        NotificationsSuccessedstate(notifications: notificationslist),
      ); // replace with actual data
    } catch (e) {
      emit(NotificationsFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
}
