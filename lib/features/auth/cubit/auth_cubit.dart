import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/firebase_auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  void login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signInWithEmailAndPassword(email, password);
      final uid = credential.user?.uid;
      
      if (uid != null) {
        // Fetch user role from Firestore to decide where to navigate
        final role = await _authService.getUserRole(uid);
        emit(AuthAuthenticated(uid: uid, role: role ?? 'customer'));
      } else {
        emit(AuthError("Login failed: User ID is null"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void registerCustomer({required String email, required String password, required String name}) async {
    emit(AuthLoading());
    try {
      await _authService.registerCustomer(email, password, name);
      emit(RegisterSuccessState());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void registerSeller({
    required String email, 
    required String password,
    required String shopName,
    required String specialty,
    required String bio,
  }) async {
    emit(AuthLoading());
    try {
      await _authService.registerSeller(
        email: email, 
        password: password, 
        shopName: shopName, 
        specialty: specialty, 
        bio: bio
      );
      emit(RegisterSuccessState());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void otp({required String email, required String password}) async {
    emit(AuthInitial());
    emit(OtpSuccessState());
    emit(OtpErorrState(email.toString()));
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _authService.signOut();
    emit(AuthInitial());
  }
}
