import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/cloudinary_service.dart';
import 'package:handmade_ecommerce_app/features/customer/profile/data/firebase_customer_service.dart';
import 'package:handmade_ecommerce_app/core/models/address_model.dart';
import 'package:handmade_ecommerce_app/features/customer/home/data/customer_model.dart';

part 'customer_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  CustomerCubit({
    FirebaseCustomerService? customerService,
    CloudinaryService? cloudinaryService,
  })  : _customerService = customerService ?? FirebaseCustomerService(),
        _cloudinaryService = cloudinaryService ?? CloudinaryService(),
        super(CustomerInitial());

  final FirebaseCustomerService _customerService;
  final CloudinaryService _cloudinaryService;
  CustomerModel customerData = CustomerModel.empty();

  Future<void> getCustomerdata() async {
    emit(GetCustomerdataLoadingstate());
    try {
      customerData = await _customerService.getCustomerData() ?? customerData;
      emit(GetCustomerdataSuccessedstate(customer: customerData));
    } catch (e) {
      emit(GetCustomerdataFailedstate(errorMessage: e.toString()));
    }
  }

  Future<void> getNotifications() async {
    emit(NotificationsLoadingstate());
    try {
      final notificationslist = await _customerService.getNotifications();
      emit(NotificationsSuccessedstate(notifications: notificationslist));
    } catch (e) {
      emit(NotificationsFailedstate(errorMessage: e.toString()));
    }
  }

  Future<void> setDefaultAddress(AddressModel address) async {
    try {
      await _customerService.setDefaultAddress(address);
      customerData.address = address;
      emit(GetCustomerdataSuccessedstate(customer: customerData));
    } catch (e) {
      emit(GetCustomerdataFailedstate(errorMessage: e.toString()));
    }
  }

  Future<void> updateCustomerProfile({
    required String name,
    String? phone,
    String? image,
  }) async {
    emit(GetCustomerdataLoadingstate());
    try {
      await _customerService.updateCustomerProfile(
        name: name,
        phone: phone ?? customerData.phone,
        image: image,
      );
      await getCustomerdata();
    } catch (e) {
      emit(GetCustomerdataFailedstate(errorMessage: e.toString()));
    }
  }

  Future<void> uploadAndSaveProfileImage(File imageFile) async {
    emit(ImageUploadLoadingstate());
    try {
      final imageUrl = await _cloudinaryService.uploadImage(imageFile);

      await _customerService.updateCustomerProfile(
        name: customerData.name,
        phone: customerData.phone,
        image: imageUrl,
      );

      customerData = CustomerModel(
        id: customerData.id,
        name: customerData.name,
        email: customerData.email,
        phone: customerData.phone,
        role: customerData.role,
        provider: customerData.provider,
        image: imageUrl,
        address: customerData.address,
      );

      emit(ImageUploadSuccessedstate(customer: customerData));
    } catch (e) {
      emit(ImageUploadFailedstate(errorMessage: e.toString()));
    }
  }
}
