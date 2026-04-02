part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class LoadingSuccessState extends AuthState {}

final class LoadingErrorState extends AuthState {
   final String message;
  LoadingErrorState(this.message);
}
final class RegisterSuccessState extends AuthState {}

final class RegisterErrorState extends AuthState {
  final String massege;
  RegisterErrorState(this.massege);
}

final class OtpSuccessState extends AuthState {}

final class OtpErorrState extends AuthState {
  final String massege;
  OtpErorrState(this.massege);
}




