abstract class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyPassword = '/verifyPassword';
  static const String resetPassword = '/resetPassword';

  static const String customerlayout = '/customer/layout';

  static const String customerSearch = '/customer/search';
  static const String customerCart = '/customer/cart';
  static const String customerProductDetails = '/customer/product-details';
  static const String customerOrderDetails = '/customer/order-details';
  static const String customerWriteReview = '/customer/write-review';

  static const String sellerdashboard = '/sellerdashboard';
  static const String selleraddproduct = '/seller/add-product';
  static const String selleraddoreditproduct = '/seller/add-or-edit-product';
  static const String sellerorders = '/seller/orders';
  static const String sellermanageproducts = '/seller/manage-products';
  static const String sellerregisteation = '/seller/registeration';

  static const String adminDashboard = '/admin/dashboard';
  static const String adminSellers = '/admin/sellers';

  static const String notifications = '/notifications';
}
