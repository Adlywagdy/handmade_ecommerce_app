import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:handmade_ecommerce_app/features/auth/services/auth_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit(this.authService) : super(AuthInitial());

  void login({required String email, required String password}) async {
    emit(AuthLoading());

    try {
    await authService.login(email: email, password: password);
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

  //  try 
  //     await authService.login(email: email, password: password);
  //     emit(LoginSuccessState());
  //   } on FirebaseAuthException catch (e) {
  //     emit(LoginErrorState(e.message ?? 'Login failed'));
  //   } catch (e) {
  //     emit(LoginErrorState('Something went wrong'));
  //   }
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
    
  void register({required String email, required String password}) async {
    emit(AuthInitial());

    emit(RegisterSuccessState());

    emit(RegisterErrorState(email.toString()));
  }

  void otp({required String email, required String password}) async {
    emit(AuthInitial());

    emit(OtpSuccessState());

    emit(OtpErorrState(email.toString()));
  }
}
