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
  /// **'Email'**
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

  /// No description provided for @admGreetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get admGreetingMorning;

  /// No description provided for @admStatLabelTotalUsers.
  ///
  /// In en, this message translates to:
  /// **'TOTAL USERS'**
  String get admStatLabelTotalUsers;

  /// No description provided for @admStatLabelTotalSellers.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SELLERS'**
  String get admStatLabelTotalSellers;

  /// No description provided for @admStatLabelTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'TOTAL ORDERS'**
  String get admStatLabelTotalOrders;

  /// No description provided for @admStatLabelRevenue.
  ///
  /// In en, this message translates to:
  /// **'REVENUE'**
  String get admStatLabelRevenue;

  /// No description provided for @admLabelPlatformCommission.
  ///
  /// In en, this message translates to:
  /// **'Platform Commission'**
  String get admLabelPlatformCommission;

  /// No description provided for @admSectionPendingActions.
  ///
  /// In en, this message translates to:
  /// **'Pending Actions'**
  String get admSectionPendingActions;

  /// No description provided for @admPendingSellersTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} Sellers awaiting approval'**
  String admPendingSellersTitle(int count);

  /// No description provided for @admPendingSellersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New artisan registrations'**
  String get admPendingSellersSubtitle;

  /// No description provided for @admPendingProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'{count} Products awaiting review'**
  String admPendingProductsTitle(int count);

  /// No description provided for @admPendingProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quality control check required'**
  String get admPendingProductsSubtitle;

  /// No description provided for @admButtonReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get admButtonReview;

  /// No description provided for @admDialogTitleCommission.
  ///
  /// In en, this message translates to:
  /// **'Platform Commission'**
  String get admDialogTitleCommission;

  /// No description provided for @admCommissionHintText.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15'**
  String get admCommissionHintText;

  /// No description provided for @admButtonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admButtonCancel;

  /// No description provided for @admButtonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get admButtonSave;

  /// No description provided for @admSellerApprovals.
  ///
  /// In en, this message translates to:
  /// **'Seller Approvals'**
  String get admSellerApprovals;

  /// No description provided for @admStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admStatusPending;

  /// No description provided for @admStatusApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get admStatusApproved;

  /// No description provided for @admStatusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get admStatusRejected;

  /// No description provided for @admSearchSellersHint.
  ///
  /// In en, this message translates to:
  /// **'Search sellers...'**
  String get admSearchSellersHint;

  /// No description provided for @admNoSellersFound.
  ///
  /// In en, this message translates to:
  /// **'No sellers found'**
  String get admNoSellersFound;

  /// No description provided for @admSubmittedLabel.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String admSubmittedLabel(String date);

  /// No description provided for @admApproveBtn.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get admApproveBtn;

  /// No description provided for @admRejectBtn.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get admRejectBtn;

  /// No description provided for @admSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get admSeller;

  /// No description provided for @admSellerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Seller not found'**
  String get admSellerNotFound;

  /// No description provided for @admSellerDetails.
  ///
  /// In en, this message translates to:
  /// **'Seller Details'**
  String get admSellerDetails;

  /// No description provided for @admContactSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get admContactSectionTitle;

  /// No description provided for @admBusinessSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get admBusinessSectionTitle;

  /// No description provided for @admTimelineSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get admTimelineSectionTitle;

  /// No description provided for @admEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get admEmailLabel;

  /// No description provided for @admPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get admPhoneLabel;

  /// No description provided for @admLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get admLocationLabel;

  /// No description provided for @admSpecialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get admSpecialtyLabel;

  /// No description provided for @admRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get admRatingLabel;

  /// No description provided for @admTotalSalesLabel.
  ///
  /// In en, this message translates to:
  /// **'Total sales'**
  String get admTotalSalesLabel;

  /// No description provided for @admTotalProductsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total products'**
  String get admTotalProductsLabel;

  /// No description provided for @admWalletBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance'**
  String get admWalletBalanceLabel;

  /// No description provided for @admCommissionRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Commission rate'**
  String get admCommissionRateLabel;

  /// No description provided for @admSubmittedDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get admSubmittedDateLabel;

  /// No description provided for @admApprovedDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get admApprovedDateLabel;

  /// No description provided for @admStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get admStatusLabel;

  /// No description provided for @admApproveProducts.
  ///
  /// In en, this message translates to:
  /// **'Approve Products'**
  String get admApproveProducts;

  /// No description provided for @admPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admPending;

  /// No description provided for @admApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get admApproved;

  /// No description provided for @admRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get admRejected;

  /// No description provided for @admSearchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get admSearchProductsHint;

  /// No description provided for @admNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get admNoProductsFound;

  /// No description provided for @admApproveAction.
  ///
  /// In en, this message translates to:
  /// **'APPROVE'**
  String get admApproveAction;

  /// No description provided for @admRejectAction.
  ///
  /// In en, this message translates to:
  /// **'REJECT'**
  String get admRejectAction;

  /// No description provided for @admProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get admProduct;

  /// No description provided for @admProductNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get admProductNotFound;

  /// No description provided for @admProductDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get admProductDetails;

  /// No description provided for @admInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get admInventory;

  /// No description provided for @admStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get admStock;

  /// No description provided for @admCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get admCategory;

  /// No description provided for @admActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admActive;

  /// No description provided for @admYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get admYes;

  /// No description provided for @admNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get admNo;

  /// No description provided for @admStats.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get admStats;

  /// No description provided for @admRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get admRating;

  /// No description provided for @admReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get admReviews;

  /// No description provided for @admSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get admSales;

  /// No description provided for @admDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get admDescription;

  /// No description provided for @admApproveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get admApproveButtonLabel;

  /// No description provided for @admRejectButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get admRejectButtonLabel;

  /// No description provided for @admOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get admOrders;

  /// No description provided for @admOrdersTabAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get admOrdersTabAll;

  /// No description provided for @admOrdersTabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get admOrdersTabPending;

  /// No description provided for @admOrdersTabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get admOrdersTabActive;

  /// No description provided for @admOrdersTabDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get admOrdersTabDelivered;

  /// No description provided for @admOrdersTabCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get admOrdersTabCancelled;

  /// No description provided for @admSearchOrderPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search order ID or name'**
  String get admSearchOrderPlaceholder;

  /// No description provided for @admNoOrdersFound.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get admNoOrdersFound;

  /// No description provided for @admSellerLabel.
  ///
  /// In en, this message translates to:
  /// **'Seller: {sellerName}'**
  String admSellerLabel(String sellerName);

  /// No description provided for @admOrderTitle.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get admOrderTitle;

  /// No description provided for @admOrderNotFound.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get admOrderNotFound;

  /// No description provided for @admSectionParties.
  ///
  /// In en, this message translates to:
  /// **'Parties'**
  String get admSectionParties;

  /// No description provided for @admCustomerLabel.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get admCustomerLabel;

  /// No description provided for @admSellerLabelDetails.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get admSellerLabelDetails;

  /// No description provided for @admCreatedLabel.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get admCreatedLabel;

  /// No description provided for @admLastUpdateLabel.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get admLastUpdateLabel;

  /// No description provided for @admSectionTotals.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get admSectionTotals;

  /// No description provided for @admSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get admSubtotalLabel;

  /// No description provided for @admDeliveryFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get admDeliveryFeeLabel;

  /// No description provided for @admCommissionLabel.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get admCommissionLabel;

  /// No description provided for @admSellerEarningLabel.
  ///
  /// In en, this message translates to:
  /// **'Seller earning'**
  String get admSellerEarningLabel;

  /// No description provided for @admTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get admTotalLabel;

  /// No description provided for @admSectionPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get admSectionPayment;

  /// No description provided for @admPaymentMethodLabel.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get admPaymentMethodLabel;

  /// No description provided for @admPaymentStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get admPaymentStatusLabel;

  /// No description provided for @admSectionShipping.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get admSectionShipping;

  /// No description provided for @admStreetLabel.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get admStreetLabel;

  /// No description provided for @admCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get admCityLabel;

  /// No description provided for @admGovernorateLabel.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get admGovernorateLabel;

  /// No description provided for @admCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get admCountryLabel;

  /// No description provided for @admZipLabel.
  ///
  /// In en, this message translates to:
  /// **'Zip'**
  String get admZipLabel;

  /// No description provided for @admItemsLabel.
  ///
  /// In en, this message translates to:
  /// **'Items ({count})'**
  String admItemsLabel(int count);

  /// No description provided for @admNoLineItems.
  ///
  /// In en, this message translates to:
  /// **'No line items'**
  String get admNoLineItems;

  /// No description provided for @admStatusHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{price} • {count} items'**
  String admStatusHeaderSubtitle(String price, int count);

  /// No description provided for @admUpdateStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Update status'**
  String get admUpdateStatusLabel;

  /// No description provided for @admNoFurtherActions.
  ///
  /// In en, this message translates to:
  /// **'No further actions — {status}'**
  String admNoFurtherActions(String status);

  /// No description provided for @admSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get admSettings;

  /// No description provided for @admPlatformCommission.
  ///
  /// In en, this message translates to:
  /// **'Platform Commission'**
  String get admPlatformCommission;

  /// No description provided for @admDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get admDeliveryFee;

  /// No description provided for @admMinimumOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order Value'**
  String get admMinimumOrderValue;

  /// No description provided for @admSupportEmail.
  ///
  /// In en, this message translates to:
  /// **'Support Email'**
  String get admSupportEmail;

  /// No description provided for @admLanguageRegion.
  ///
  /// In en, this message translates to:
  /// **'Language & Region'**
  String get admLanguageRegion;

  /// No description provided for @admLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get admLogoutTitle;

  /// No description provided for @admLogoutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get admLogoutConfirmation;

  /// No description provided for @admCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get admCancel;

  /// No description provided for @admLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get admLogout;

  /// No description provided for @admDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get admDashboard;

  /// No description provided for @admSellers.
  ///
  /// In en, this message translates to:
  /// **'Sellers'**
  String get admSellers;

  /// No description provided for @admProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get admProducts;

  /// No description provided for @admSettingsNav.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get admSettingsNav;

  /// No description provided for @sellerDetailsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Seller details'**
  String get sellerDetailsSectionTitle;

  /// No description provided for @sellerDetailsSectionHint.
  ///
  /// In en, this message translates to:
  /// **'Complete your details so we can review your application.'**
  String get sellerDetailsSectionHint;

  /// No description provided for @specialtyLabel.
  ///
  /// In en, this message translates to:
  /// **'Specialty / Craft'**
  String get specialtyLabel;

  /// No description provided for @specialtyHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Handmade pottery'**
  String get specialtyHint;

  /// No description provided for @specialtyIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Specialty is required'**
  String get specialtyIsRequired;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// No description provided for @phoneNumberHint.
  ///
  /// In en, this message translates to:
  /// **'+20 1XX XXX XXXX'**
  String get phoneNumberHint;

  /// No description provided for @phoneIsRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneIsRequired;

  /// No description provided for @cityLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'City (optional)'**
  String get cityLabelOptional;

  /// No description provided for @countryLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'Country (optional)'**
  String get countryLabelOptional;
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
