import 'package:handmade_ecommerce_app/core/constants/user_roles.dart';

class AuthSession {
  const AuthSession({required this.role, this.status});

  final String role;
  final String? status;

  bool get isAdmin => role.trim().toLowerCase() == UserRoles.admin;
}
