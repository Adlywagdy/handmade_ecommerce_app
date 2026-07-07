abstract class AppRoutes {
  AppRoutes._();

  static const String onboarding = '/onboarding';

  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';
  static const String verifyPassword = '/verifyPassword';
  static const String resetPassword = '/resetPassword';

  static const String customerLayout = '/customer/layout';

  static const String customerSearch = '/customer/search';
  static const String customerNotifications = '/customer/notifications';
  static const String customerCart = '/customer/cart';
  static const String customerProductDetails = '/customer/product-details';
  static const String customerShopDetails = '/customer/shop-details';
  static const String customerOrderDetails = '/customer/order-details';
  static const String customerWriteReview = '/customer/write-review';
  static const String customerRecommendationChatbot =
      '/customer/recommendation-chatbot';

  static const String sellerDashboard = '/sellerdashboard';
  static const String sellerPending = '/seller/pending';
  static const String sellerAddProduct = '/seller/add-product';
  static const String sellerAddOrEditProduct = '/seller/add-or-edit-product';
  static const String sellerOrders = '/seller/orders';
  static const String sellerManageProducts = '/seller/manage-products';
  static const String sellerRegistration = '/seller/registration';

  static const String adminBottomBar = '/admin';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminSellers = '/admin/sellers';
  static const String notifications = '/notifications';
  static const String adminProducts = '/admin/products';
  static const String adminOrders = '/admin/orders';
  static const String adminSettings = '/admin/settings';
}
