part of 'auth_cubit.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class LoginSuccessState extends AuthState {
  final String role;
  LoginSuccessState(this.role);
}

final class LoginErrorState extends AuthState {
  final String message;
  LoginErrorState(this.message);
}

final class GoogleLoginSuccessState extends AuthState {
  final String role;
  GoogleLoginSuccessState(this.role);
}

final class GoogleLoginErrorState extends AuthState {
  final String message;
  GoogleLoginErrorState(this.message);
}

final class RegisterSuccessState extends AuthState {
  final String role;
  RegisterSuccessState(this.role);
}

final class RegisterErrorState extends AuthState {
  final String message;
  RegisterErrorState(this.message);
}

final class ForgotPasswordSuccessState extends AuthState {}

final class ForgotPasswordErrorState extends AuthState {
  final String message;
  ForgotPasswordErrorState(this.message);
}