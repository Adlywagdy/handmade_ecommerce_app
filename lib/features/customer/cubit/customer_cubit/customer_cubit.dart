import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_customer_service.dart';
import 'package:handmade_ecommerce_app/features/customer/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/models/customer_model.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit({FirebaseCustomerService? customerService})
    : _customerService = customerService ?? FirebaseCustomerService(),
      super(CustomerInitial());

  final FirebaseCustomerService _customerService;
  CustomerModel customerData = CustomerModel(
    name: "Adly",
    email: "adly.wagdy@ayady.com",
    image: "assets/images/unknown_user_icon.svg",
    password: "561651",
    phone: "0651616161681",
  ); /* ------------------------------------------- */

  Future<void> getCustomerdata() async {
    emit(GetCustomerdataLoadingstate());
    try {
      final firebaseCustomer = await _customerService.getCustomerData();
      if (firebaseCustomer != null) {
        customerData = firebaseCustomer;
      }
      emit(GetCustomerdataSuccessedstate(customer: customerData));
    } catch (e) {
      emit(GetCustomerdataFailedstate(errorMessage: e.toString()));
    }
  }
  /* ------------------------------------------- */

  Future<void> getNotifications() async {
    emit(NotificationsLoadingstate());
    try {
      final notificationslist = await _customerService.getNotifications();
      emit(NotificationsSuccessedstate(notifications: notificationslist));
    } catch (e) {
      emit(NotificationsFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
  Future<void> setDefaultAddress(AddressModel address) async {
    try {
      await _customerService.setDefaultAddress(address);
      customerData.address = address;
      emit(GetCustomerdataSuccessedstate(customer: customerData));
    } catch (e) {
      emit(GetCustomerdataFailedstate(errorMessage: e.toString()));
    }
  }

  /* ------------------------------------------- */
}
