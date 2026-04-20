import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void login({required String email, required String password}) async {
    emit(AuthInitial());

    emit(LoadingSuccessState());

    emit(LoadingErrorState(email.toString()));
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
