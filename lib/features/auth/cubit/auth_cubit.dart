import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';
import 'package:hive/hive.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  void login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      await authService.login(email: email, password: password);

      emit(LoginSuccessState());
      HiveHelper.setLoginBox(value: true);
      HiveHelper.setEmailBoxValue(email);
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(e.message ?? 'Login failed'));
    } catch (e) {
      emit(LoginErrorState('Something went wrong'));
    }
  }

  void signInWithGoogle() async {
    emit(AuthLoading());

    try {
      await authService.signInWithGoogle();
      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      emit(GoogleLoginSuccessState());
      HiveHelper.setLoginBox(value: true);

      if (email != null) {
        HiveHelper.setEmailBoxValue(email);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        emit(
          GoogleLoginErrorState(
            'Please check your internet connection and try again',
          ),
        );
      } else if (e.code == 'google-sign-in-cancelled') {
        emit(GoogleLoginErrorState('Google sign-in was cancelled'));
      } else {
        emit(GoogleLoginErrorState(e.message ?? 'Google sign in failed'));
      }
    } catch (e) {
      emit(GoogleLoginErrorState('Something went wrong'));
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
      HiveHelper.setLoginBox(value: true );
      HiveHelper.setEmailBoxValue(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState('Password is too weak'));
      } else if (e.code == 'email-already-in-use') {
        emit(RegisterErrorState('Email is already in use'));
      } else if (e.code == 'network-request-failed') {
        emit(
          RegisterErrorState(
            'Please check your internet connection and try again',
          ),
        );
      } else {
        emit(RegisterErrorState(e.message ?? 'Register failed'));
      }
    } catch (e) {
      emit(RegisterErrorState('Something went wrong'));
    }
  }

  void registerWithGoogle({required String selectedRole}) async {
    emit(AuthLoading());

    try {
      final String finalRole = await authService.registerWithGoogle(
        selectedRole: selectedRole,
      );

      final user = FirebaseAuth.instance.currentUser;
      final email = user?.email;

      emit(RegisterSuccessState(finalRole));
      HiveHelper.setLoginBox(value: true);

      if (email != null) {
        HiveHelper.setEmailBoxValue(email);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        emit(
          RegisterErrorState(
            'Please check your internet connection and try again',
          ),
        );
      } else if (e.code == 'google-sign-in-cancelled') {
        emit(RegisterErrorState('Google sign-in was cancelled'));
      } else {
        emit(RegisterErrorState(e.message ?? 'Google register failed'));
      }
    } catch (e) {
      emit(RegisterErrorState('Something went wrong'));
    }
  }

  void otp({required String email, required String password}) async {
    emit(AuthLoading());
  }
}