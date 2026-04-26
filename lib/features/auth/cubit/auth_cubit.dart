import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/core/constants/seller_status.dart';
import 'package:handmade_ecommerce_app/core/constants/user_roles.dart';
import 'package:handmade_ecommerce_app/core/services/hivehelper_service.dart';
import 'package:handmade_ecommerce_app/features/auth/models/auth_session.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  void login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
      final AuthSession session =
          await authService.login(email: email, password: password);
      _persistSession(email: email, session: session);
      emit(LoginSuccessState(session.role));
    } on FirebaseAuthException catch (e) {
      debugPrint('[AuthCubit.login] FirebaseAuthException: ${e.code} - ${e.message}');
      emit(LoginErrorState(e.message ?? 'Login failed'));
    } catch (e, stack) {
      debugPrint('[AuthCubit.login] $e\n$stack');
      emit(LoginErrorState('Login failed: $e'));
    }
  }

  void signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final AuthSession session = await authService.signInWithGoogle();
      _persistSession(
        email: FirebaseAuth.instance.currentUser?.email,
        session: session,
      );
      emit(GoogleLoginSuccessState(session.role));
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

      _persistSession(
        email: email,
        session: AuthSession(
          role: role,
          status: role == UserRoles.seller ? SellerStatus.pending : null,
        ),
      );
      emit(RegisterSuccessState(role));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterErrorState('Password is too weak'));
      } else if (e.code == 'email-already-in-use') {
        emit(
          RegisterErrorState(
            'You are already registered with this email. Please log in instead.',
          ),
        );
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

      _persistSession(
        email: FirebaseAuth.instance.currentUser?.email,
        session: AuthSession(
          role: finalRole,
          status: finalRole == UserRoles.seller ? SellerStatus.pending : null,
        ),
      );
      emit(RegisterSuccessState(finalRole));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        emit(
          RegisterErrorState(
            'Please check your internet connection and try again',
          ),
        );
      } else if (e.code == 'google-sign-in-cancelled') {
        emit(RegisterErrorState('Google sign-in was cancelled'));
      } else if (e.code == 'account-already-exists') {
        emit(
          RegisterErrorState(
            'You are already registered. Please log in instead.',
          ),
        );
      } else {
        emit(RegisterErrorState(e.message ?? 'Google register failed'));
      }
    } catch (e) {
      emit(RegisterErrorState('Something went wrong'));
    }
  }

  void _persistSession({
    required String? email,
    required AuthSession session,
  }) {
    HiveHelper.setLoginBox(value: true);
    HiveHelper.setRoleBoxValue(session.role);
    if (email != null && email.isNotEmpty) {
      HiveHelper.setEmailBoxValue(email);
    }
    final status = session.status;
    if (status != null && status.isNotEmpty) {
      HiveHelper.setStatusBoxValue(status);
    } else {
      HiveHelper.clearStatusBox();
    }
  }

  void forgotPassword({required String email}) async {
    emit(AuthLoading());

    try {
      await authService.sendPasswordReset(email: email);
      emit(ForgotPasswordSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(ForgotPasswordErrorState('${e.code} - ${e.message}'));
    } catch (e) {
      emit(ForgotPasswordErrorState(e.toString()));
    }
  }
}
