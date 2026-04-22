import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  void login({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());

    try {
      await authService.login(
        email: email,
        password: password,
      );

      print('LOGIN SUCCESS');
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      print('FIREBASE CODE: ${e.code}');
      print('FIREBASE MESSAGE: ${e.message}');
      emit(LoginErrorState(e.message ?? 'Login failed'));
    } catch (e) {
      print('GENERAL ERROR: $e');
      emit(LoginErrorState('Something went wrong'));
    }
  }

  void signInWithGoogle() async {
    emit(AuthLoading());

    try {
      await authService.signInWithGoogle();
      emit(GoogleLoginSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(GoogleLoginErrorState(e.message ?? 'Google sign in failed'));
    } catch (e) {
      emit(GoogleLoginErrorState(e.toString()));
    }
  }

  void register({
    required String fullName,
    required String email,
    required String password,
    required String role,
  }) async {
    emit(AuthLoading());

    try {
      await authService.register(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );

      emit(RegisterSuccessState(role));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState('Password is too weak'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState('Email is already in use'));
      } else {
        emit(RegisterErrorState(e.message ?? 'Register failed'));
      }
    } catch (e) {
      emit(RegisterErrorState('Something went wrong'));
    }
  }

  void registerWithGoogle({
    required String selectedRole,
  }) async {
    emit(AuthLoading());

    try {
      final String finalRole = await authService.registerWithGoogle(
        selectedRole: selectedRole,
      );

      emit(RegisterSuccessState(finalRole));
    } on FirebaseAuthException catch (e) {
      emit(RegisterErrorState(e.message ?? 'Google register failed'));
    } catch (e) {
      emit(RegisterErrorState('Something went wrong'));
    }
  }

  void otp({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
  }
}