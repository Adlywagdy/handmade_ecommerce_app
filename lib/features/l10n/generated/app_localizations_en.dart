// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get skip => 'Skip';

  @override
  String get next => 'Next';

  @override
  String get getStarted => 'Get Started';

  @override
  String get discoverUniqueHandmadeItems => 'Discover Unique Handmade Items';

  @override
  String get supportLocalArtisans => 'Support Local Artisans';

  @override
  String get shopWithConfidence => 'Shop with Confidence';

  @override
  String get exploreThousandsHandcraftedProducts =>
      'Explore thousands of handcrafted products made by talented artisans from around the world.';

  @override
  String get connectDirectlyWithMakers =>
      'Connect directly with makers and support their craft. Every purchase makes a difference.';

  @override
  String get securePaymentsVerifiedSellers =>
      'Secure payments, verified sellers, and authentic reviews. Your satisfaction guaranteed.';

  @override
  String get filterAndSort => 'Filter & Sort';

  @override
  String get rating => 'Rating';

  @override
  String get priceSort => 'Price sort';

  @override
  String get any => 'Any';

  @override
  String get to => 'to';

  @override
  String get min => 'Min';

  @override
  String get max => 'Max';

  @override
  String get cancel => 'Cancel';

  @override
  String get apply => 'Apply';

  @override
  String get mustBePositive => 'Must be positive';

  @override
  String get updateRequired => 'Update Required';

  @override
  String get pleaseUpdateAppToContinue => 'Please update the app to continue.';

  @override
  String get update => 'Update';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get technicalDifficulties =>
      'We\'re experiencing technical difficulties on our end. Our team is working on it.';

  @override
  String get goBack => 'Go Back';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get offlineMessage =>
      'It looks like you\'re offline. Please check your network settings and try again.';

  @override
  String get retryConnection => 'Retry Connection';

  @override
  String get welcomeToAyady => 'Welcome to Ayady';

  @override
  String get pleaseEnterYourDetailsToContinue =>
      'Please enter your details to continue';

  @override
  String get emailAddress => 'EMAIL ADDRESS';

  @override
  String get emailIsntValid => 'Email isn\'t valid';

  @override
  String get password => 'Password';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get loginSuccess => 'Login Success';

  @override
  String get googleSignInSuccess => 'Google Sign In Success';

  @override
  String get signIn => 'Sign In';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get google => 'Google';

  @override
  String get dontHaveAnAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get joinAyady => 'Join Ayady';

  @override
  String get createAccount => 'Create Account';

  @override
  String get experienceTheEleganceOfHandcraftedItems =>
      'Experience the elegance of handcrafted items';

  @override
  String get fullName => 'Full Name';

  @override
  String get johnDoe => 'John Doe';

  @override
  String get nameIsRequired => 'Name is required';

  @override
  String get emailIsRequired => 'Email is required';

  @override
  String get passwordIsRequired => 'Password is required';

  @override
  String get passwordShouldBeMoreThan5Letters =>
      'Password should be more than 5 letters';

  @override
  String get registerAs => 'Register as:';

  @override
  String get customer => 'Customer';

  @override
  String get seller => 'Seller';

  @override
  String get agreeToTerms =>
      'I agree to the Terms of Service and Privacy Policy.';

  @override
  String get accountCreatedSuccessfully => 'Account created successfully';

  @override
  String get youMustAgreeToTheTermsFirst => 'You must agree to the terms first';

  @override
  String get pleaseChooseCustomerOrSellerFirst =>
      'Please choose Customer or Seller first';

  @override
  String get alreadyHaveAnAccount => 'Already have an account?';

  @override
  String get logIn => 'Log In';

  @override
  String get passwordRecovery => 'Password recovery';

  @override
  String get passwordRecoveryDescription =>
      'Please enter your email address to send to a password recovery email.';

  @override
  String get sendCode => 'Send Code';

  @override
  String get verifyItsYou => 'Verify it’s you';

  @override
  String get verificationCodeSentToEmail =>
      'We have sent a verification code to your email. Please enter it below.';

  @override
  String get youCanResendCodeAfterOneMinute =>
      'You can resend the code after 1 minute.';

  @override
  String get confirm => 'Confirm';

  @override
  String get createNewPassword => 'Create new password';

  @override
  String get createNewPasswordDescription =>
      'Please create a secure password for your account to ensure security of the account.';

  @override
  String get retypePassword => 'Re-type Password';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'Password must be at least 6 characters';

  @override
  String get pleaseConfirmYourPassword => 'Please confirm your password';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get setPassword => 'Set Password';

  @override
  String get productUpdatedSuccessfully => 'Product updated successfully';

  @override
  String errorSavingProduct(String error) {
    return 'Error saving product: $error';
  }

  @override
  String get unexpectedState => 'Unexpected State';

  @override
  String get noProductsFound => 'No products found';

  @override
  String get deleteProduct => 'Delete Product';

  @override
  String get deleteProductConfirmation =>
      'Are you sure you want to delete this product? This action cannot be undone.';

  @override
  String get editProduct => 'Edit Product';

  @override
  String get cancelOrder => 'Cancel Order';

  @override
  String cancelOrderConfirmation(String orderId) {
    return 'Are you sure you want to cancel order $orderId?';
  }

  @override
  String get no => 'No';

  @override
  String get orderCancelledSuccess =>
      'Order has been cancelled and stock restored';

  @override
  String failedToCancelOrder(String error) {
    return 'Failed to cancel order: $error';
  }

  @override
  String get yesCancel => 'Yes, Cancel';

  @override
  String get orderArchivedSuccessfully => 'Order archived successfully';

  @override
  String orderStatusUpdated(String newStatus) {
    return 'Order status updated to $newStatus';
  }

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get profile => 'Profile';

  @override
  String get productName => 'Product Name';

  @override
  String get priceWithCurrency => 'Price (\$)';

  @override
  String get stock => 'Stock';

  @override
  String get description => 'Description';

  @override
  String get addProduct => 'Add Product';

  @override
  String get viewProducts => 'View Products';

  @override
  String get viewOrders => 'View Orders';

  @override
  String get enterProductName => 'Enter product name';

  @override
  String get zeroPriceHint => '0.00';

  @override
  String get zeroStockHint => '0';

  @override
  String get selectCategory => 'Select category';

  @override
  String get describeYourProduct => 'Describe your product...';

  @override
  String get totalRevenue => 'Total Revenue';

  @override
  String get totalOrders => 'Total Orders';

  @override
  String get bestSellingItem => 'Best selling item';

  @override
  String get ordersProcessed => 'Orders Processed';

  @override
  String get avgOrderValue => 'Avg. Order Value';

  @override
  String get shopSettings => 'Shop Settings';

  @override
  String get viewShopInformation => 'View your shop information';

  @override
  String get notificationsCenter => 'Notifications';

  @override
  String get openNotificationsCenter => 'Open your notifications center';

  @override
  String get helpAndSupport => 'Help & Support';

  @override
  String get contactSupport => 'Contact support and review help info';

  @override
  String get globalReach => 'Global Reach';

  @override
  String get sellWorldwide => 'Sell to customers worldwide';

  @override
  String get secureSales => 'Secure Sales';

  @override
  String get guaranteedSafePayments => 'Guaranteed safe payments';

  @override
  String get support247 => '24/7 Support';

  @override
  String get dedicatedArtisanAssistance => 'Dedicated artisan assistance';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get markAllAsRead => 'Mark all as read';

  @override
  String get clearAllNotifications => 'Clear all';

  @override
  String get filterAll => 'All';

  @override
  String get filterUnread => 'Unread';

  @override
  String get filterOrders => 'Orders';

  @override
  String get filterMessages => 'Messages';

  @override
  String get filterOffers => 'Offers';

  @override
  String get today => 'TODAY';

  @override
  String get yesterday => 'YESTERDAY';

  @override
  String get earlier => 'EARLIER';

  @override
  String get clearNotificationsDialogTitle => 'Clear All Notifications';

  @override
  String get clearNotificationsConfirmation =>
      'Are you sure you want to delete all notifications? This action cannot be undone.';

  @override
  String get clearAll => 'Clear All';

  @override
  String get notificationDeleted => 'Notification deleted';

  @override
  String get noNotificationsYet => 'No Notifications Yet';

  @override
  String get noNotificationsDescription =>
      'When you receive notifications, they\'ll appear here. Stay tuned!';
}
