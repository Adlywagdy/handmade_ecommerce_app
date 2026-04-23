import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/customer/services/contact_seller_service.dart';

part 'contact_seller_state.dart';

class ContactSellerCubit extends Cubit<ContactSellerState> {
  ContactSellerCubit({ContactSellerService? contactSellerService})
    : _contactSellerService = contactSellerService ?? ContactSellerService(),
      super(ContactSellerInitial());

  final ContactSellerService _contactSellerService;

  Future<void> sendEmail({
    required String email,
    required String sellerName,
    required String subject,
    required String message,
  }) async {
    emit(ContactSellerLoading());

    try {
      await _contactSellerService.sendEmail(
        email: email,
        sellerName: sellerName,
        subject: subject,
        message: message,
      );
      emit(ContactSellerSuccess());
    } catch (e) {
      emit(ContactSellerFailure(e.toString()));
    }
  }

  void reset() {
    emit(ContactSellerInitial());
  }
}
