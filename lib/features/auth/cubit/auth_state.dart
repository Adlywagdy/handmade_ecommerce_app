part of 'auth_cubit.dart';

abstract class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthAuthenticated extends AuthState {
  final String uid;
  final String role; // 'seller' or 'customer'
  
  AuthAuthenticated({required this.uid, required this.role});
}

final class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

final class RegisterSuccessState extends AuthState {}

// Legacy states kept temporarily if needed by other screens
final class LoadingSuccessState extends AuthState {}
final class OtpSuccessState extends AuthState {}
final class OtpErorrState extends AuthState {
  final String massege;
  OtpErorrState(this.massege);
}
