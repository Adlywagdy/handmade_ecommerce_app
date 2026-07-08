import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @discoverUniqueHandmadeItems.
  ///
  /// In en, this message translates to:
  /// **'Discover Unique Handmade Items'**
  String get discoverUniqueHandmadeItems;

  /// No description provided for @supportLocalArtisans.
  ///
  /// In en, this message translates to:
  /// **'Support Local Artisans'**
  String get supportLocalArtisans;

  /// No description provided for @shopWithConfidence.
  ///
  /// In en, this message translates to:
  /// **'Shop with Confidence'**
  String get shopWithConfidence;

  /// No description provided for @exploreThousandsHandcraftedProducts.
  ///
  /// In en, this message translates to:
  /// **'Explore thousands of handcrafted products made by talented artisans from around the world.'**
  String get exploreThousandsHandcraftedProducts;

  /// No description provided for @connectDirectlyWithMakers.
  ///
  /// In en, this message translates to:
  /// **'Connect directly with makers and support their craft. Every purchase makes a difference.'**
  String get connectDirectlyWithMakers;

  /// No description provided for @securePaymentsVerifiedSellers.
  ///
  /// In en, this message translates to:
  /// **'Secure payments, verified sellers, and authentic reviews. Your satisfaction guaranteed.'**
  String get securePaymentsVerifiedSellers;

  /// No description provided for @filterAndSort.
  ///
  /// In en, this message translates to:
  /// **'Filter & Sort'**
  String get filterAndSort;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @priceSort.
  ///
  /// In en, this message translates to:
  /// **'Price sort'**
  String get priceSort;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @min.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get min;

  /// No description provided for @max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get max;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @mustBePositive.
  ///
  /// In en, this message translates to:
  /// **'Must be positive'**
  String get mustBePositive;

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @pleaseUpdateAppToContinue.
  ///
  /// In en, this message translates to:
  /// **'Please update the app to continue.'**
  String get pleaseUpdateAppToContinue;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @technicalDifficulties.
  ///
  /// In en, this message translates to:
  /// **'We\'re experiencing technical difficulties on our end. Our team is working on it.'**
  String get technicalDifficulties;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Message shown when the user is offline.
  ///
  /// In en, this message translates to:
  /// **'It looks like you\'re offline. Please check your network settings and try again.'**
  String get offlineMessage;

  /// Button label to retry a failed network request.
  ///
  /// In en, this message translates to:
  /// **'Retry Connection'**
  String get retryConnection;

  /// Welcome message shown on the login screen.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ayady'**
  String get welcomeToAyady;

  /// Hint text shown on the login screen explaining how to proceed.
  ///
  /// In en, this message translates to:
  /// **'Please enter your details to continue'**
  String get pleaseEnterYourDetailsToContinue;

  /// Label text for the email input field.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailAddress;

  /// Validation message shown when the email input is invalid.
  ///
  /// In en, this message translates to:
  /// **'Email isn\'t valid'**
  String get emailIsntValid;

  /// Label text for the password input field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Link text used to navigate to password recovery.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Snack bar message shown after successful login.
  ///
  /// In en, this message translates to:
  /// **'Login Success'**
  String get loginSuccess;

  /// Snack bar message shown after successful Google login.
  ///
  /// In en, this message translates to:
  /// **'Google Sign In Success'**
  String get googleSignInSuccess;

  /// Button text used to sign in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Text shown between a divider and social login buttons.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// Label for Google sign-in button.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get google;

  /// Text shown before the sign up link on the login screen.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAnAccount;

  /// Text used for the sign up action.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Title text shown on the register screen.
  ///
  /// In en, this message translates to:
  /// **'Join Ayady'**
  String get joinAyady;

  /// Button text for the register screen.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Subtitle text shown on the register screen.
  ///
  /// In en, this message translates to:
  /// **'Experience the elegance of handcrafted items'**
  String get experienceTheEleganceOfHandcraftedItems;

  /// Label text for the full name input field.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Placeholder text for the full name input field.
  ///
  /// In en, this message translates to:
  /// **'John Doe'**
  String get johnDoe;

  /// Validation message shown when the name field is empty.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameIsRequired;

  /// Validation message shown when the email field is empty.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailIsRequired;

  /// Validation message shown when the password field is empty.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordIsRequired;

  /// Validation message shown when the password is too short.
  ///
  /// In en, this message translates to:
  /// **'Password should be more than 5 letters'**
  String get passwordShouldBeMoreThan5Letters;

  /// Label text shown before choices of customer or seller during registration.
  ///
  /// In en, this message translates to:
  /// **'Register as:'**
  String get registerAs;

  /// Role selection option text for customer registration.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// Role selection option text for seller registration.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get seller;

  /// Text shown next to the terms and privacy checkbox.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms of Service and Privacy Policy.'**
  String get agreeToTerms;

  /// Snack bar text shown after successful account creation.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully'**
  String get accountCreatedSuccessfully;

  /// Error message shown when terms are not accepted.
  ///
  /// In en, this message translates to:
  /// **'You must agree to the terms first'**
  String get youMustAgreeToTheTermsFirst;

  /// Error message shown when a registration role is not selected.
  ///
  /// In en, this message translates to:
  /// **'Please choose Customer or Seller first'**
  String get pleaseChooseCustomerOrSellerFirst;

  /// Text shown before the login link on the register screen.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAnAccount;

  /// Text used for the login action.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// Title text for the password recovery screen.
  ///
  /// In en, this message translates to:
  /// **'Password recovery'**
  String get passwordRecovery;

  /// Subtitle text for the password recovery screen.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email address to send to a password recovery email.'**
  String get passwordRecoveryDescription;

  /// Button text used to request a password reset code.
  ///
  /// In en, this message translates to:
  /// **'Send Code'**
  String get sendCode;

  /// Title text shown on the verification code screen.
  ///
  /// In en, this message translates to:
  /// **'Verify it’s you'**
  String get verifyItsYou;

  /// Explanation text shown above the verification code field.
  ///
  /// In en, this message translates to:
  /// **'We have sent a verification code to your email. Please enter it below.'**
  String get verificationCodeSentToEmail;

  /// Notice text shown when the verification code has been sent.
  ///
  /// In en, this message translates to:
  /// **'You can resend the code after 1 minute.'**
  String get youCanResendCodeAfterOneMinute;

  /// Button text used to confirm the verification code.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Title text for the reset password screen.
  ///
  /// In en, this message translates to:
  /// **'Create new password'**
  String get createNewPassword;

  /// Subtitle text for the reset password screen.
  ///
  /// In en, this message translates to:
  /// **'Please create a secure password for your account to ensure security of the account.'**
  String get createNewPasswordDescription;

  /// Label text for the confirm password field.
  ///
  /// In en, this message translates to:
  /// **'Re-type Password'**
  String get retypePassword;

  /// Validation message shown when the password is too short during reset.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// Validation message shown when the confirm password field is empty.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get pleaseConfirmYourPassword;

  /// Validation message shown when password and confirm password do not match.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Button text used to save the new password.
  ///
  /// In en, this message translates to:
  /// **'Set Password'**
  String get setPassword;

  /// No description provided for @productUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdatedSuccessfully;

  /// No description provided for @errorSavingProduct.
  ///
  /// In en, this message translates to:
  /// **'Error saving product: {error}'**
  String errorSavingProduct(String error);

  /// No description provided for @unexpectedState.
  ///
  /// In en, this message translates to:
  /// **'Unexpected State'**
  String get unexpectedState;

  /// No description provided for @noProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// No description provided for @deleteProduct.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get deleteProduct;

  /// No description provided for @deleteProductConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product? This action cannot be undone.'**
  String get deleteProductConfirmation;

  /// No description provided for @editProduct.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// No description provided for @cancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// No description provided for @cancelOrderConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel order {orderId}?'**
  String cancelOrderConfirmation(String orderId);

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @orderCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Order has been cancelled and stock restored'**
  String get orderCancelledSuccess;

  /// No description provided for @failedToCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order: {error}'**
  String failedToCancelOrder(String error);

  /// No description provided for @yesCancel.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get yesCancel;

  /// No description provided for @orderArchivedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Order archived successfully'**
  String get orderArchivedSuccessfully;

  /// No description provided for @orderStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Order status updated to {newStatus}'**
  String orderStatusUpdated(String newStatus);

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirmation;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// No description provided for @priceWithCurrency.
  ///
  /// In en, this message translates to:
  /// **'Price (\$)'**
  String get priceWithCurrency;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @addProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// No description provided for @viewProducts.
  ///
  /// In en, this message translates to:
  /// **'View Products'**
  String get viewProducts;

  /// No description provided for @viewOrders.
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get viewOrders;

  /// No description provided for @enterProductName.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// No description provided for @zeroPriceHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get zeroPriceHint;

  /// No description provided for @zeroStockHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get zeroStockHint;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @describeYourProduct.
  ///
  /// In en, this message translates to:
  /// **'Describe your product...'**
  String get describeYourProduct;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @totalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get totalOrders;

  /// No description provided for @bestSellingItem.
  ///
  /// In en, this message translates to:
  /// **'Best selling item'**
  String get bestSellingItem;

  /// No description provided for @ordersProcessed.
  ///
  /// In en, this message translates to:
  /// **'Orders Processed'**
  String get ordersProcessed;

  /// No description provided for @avgOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Avg. Order Value'**
  String get avgOrderValue;

  /// No description provided for @shopSettings.
  ///
  /// In en, this message translates to:
  /// **'Shop Settings'**
  String get shopSettings;

  /// No description provided for @viewShopInformation.
  ///
  /// In en, this message translates to:
  /// **'View your shop information'**
  String get viewShopInformation;

  /// No description provided for @notificationsCenter.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsCenter;

  /// No description provided for @openNotificationsCenter.
  ///
  /// In en, this message translates to:
  /// **'Open your notifications center'**
  String get openNotificationsCenter;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support and review help info'**
  String get contactSupport;

  /// No description provided for @globalReach.
  ///
  /// In en, this message translates to:
  /// **'Global Reach'**
  String get globalReach;

  /// No description provided for @sellWorldwide.
  ///
  /// In en, this message translates to:
  /// **'Sell to customers worldwide'**
  String get sellWorldwide;

  /// No description provided for @secureSales.
  ///
  /// In en, this message translates to:
  /// **'Secure Sales'**
  String get secureSales;

  /// No description provided for @guaranteedSafePayments.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed safe payments'**
  String get guaranteedSafePayments;

  /// No description provided for @support247.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get support247;

  /// No description provided for @dedicatedArtisanAssistance.
  ///
  /// In en, this message translates to:
  /// **'Dedicated artisan assistance'**
  String get dedicatedArtisanAssistance;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @markAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// No description provided for @clearAllNotifications.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllNotifications;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get filterUnread;

  /// No description provided for @filterOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get filterOrders;

  /// No description provided for @filterMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get filterMessages;

  /// No description provided for @filterOffers.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get filterOffers;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterday;

  /// No description provided for @earlier.
  ///
  /// In en, this message translates to:
  /// **'EARLIER'**
  String get earlier;

  /// No description provided for @clearNotificationsDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear All Notifications'**
  String get clearNotificationsDialogTitle;

  /// No description provided for @clearNotificationsConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all notifications? This action cannot be undone.'**
  String get clearNotificationsConfirmation;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// No description provided for @notificationDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// No description provided for @noNotificationsYet.
  ///
  /// In en, this message translates to:
  /// **'No Notifications Yet'**
  String get noNotificationsYet;

  /// No description provided for @noNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'When you receive notifications, they\'ll appear here. Stay tuned!'**
  String get noNotificationsDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
