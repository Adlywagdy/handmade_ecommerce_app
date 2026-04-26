import 'package:handmade_ecommerce_app/core/constants/seller_status.dart';
import 'package:handmade_ecommerce_app/core/constants/user_roles.dart';
import 'package:handmade_ecommerce_app/core/routes/routes.dart';

abstract class AuthRedirectService {
  AuthRedirectService._();

  static String routeForRole(String? role) {
    switch (role?.trim().toLowerCase()) {
      case UserRoles.admin:
        return AppRoutes.adminBottomBar;
      case UserRoles.seller:
        return AppRoutes.sellerdashboard;
      case UserRoles.customer:
      default:
        return AppRoutes.customerlayout;
    }
  }

  /// Resolves a route taking the seller approval [status] into account.
  /// Sellers whose status is anything other than `approved` (e.g. pending,
  /// rejected, missing) are sent to the under-review screen.
  static String routeForRoleAndStatus(String? role, String? status) {
    final normalizedRole = role?.trim().toLowerCase();
    if (normalizedRole == UserRoles.seller &&
        !SellerStatus.isApproved(status)) {
      return AppRoutes.sellerPending;
    }
    return routeForRole(role);
  }
}
