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

  /// No description provided for @earnings.
  ///
  /// In en, this message translates to:
  /// **'Earnings'**
  String get earnings;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, '**
  String get welcomeBack;

  /// No description provided for @hereWhatIsHappeningWithYourShopToday.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s happening with your shop today.'**
  String get hereWhatIsHappeningWithYourShopToday;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @premiumArtisan.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM ARTISAN'**
  String get premiumArtisan;

  /// Message shown when there are no orders for a specific tab.
  ///
  /// In en, this message translates to:
  /// **'No {tapname} orders'**
  String noTapnameOrders(String tapname);

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @withdrawFunds.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Funds'**
  String get withdrawFunds;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All ›'**
  String get viewAll;

  /// No description provided for @noRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions'**
  String get noRecentTransactions;

  /// No description provided for @revenueStatistics.
  ///
  /// In en, this message translates to:
  /// **'Revenue Statistics'**
  String get revenueStatistics;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @weeklyEarnings.
  ///
  /// In en, this message translates to:
  /// **'Weekly Earnings'**
  String get weeklyEarnings;

  /// No description provided for @monthlyEarnings.
  ///
  /// In en, this message translates to:
  /// **'Monthly Earnings'**
  String get monthlyEarnings;

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

  /// No description provided for @startTypingToSeeMatchingProducts.
  ///
  /// In en, this message translates to:
  /// **'Start typing to see matching products'**
  String get startTypingToSeeMatchingProducts;

  /// No description provided for @resultsFound.
  ///
  /// In en, this message translates to:
  /// **'results found'**
  String get resultsFound;

  /// No description provided for @noOrdersFoundInThisTab.
  ///
  /// In en, this message translates to:
  /// **'No orders found in this tab.'**
  String get noOrdersFoundInThisTab;

  /// No description provided for @failedToLoadOrders.
  ///
  /// In en, this message translates to:
  /// **'Failed to load orders. Pull to refresh.'**
  String get failedToLoadOrders;

  /// No description provided for @confirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmed;

  /// No description provided for @preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get preparing;

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// No description provided for @noLineItems.
  ///
  /// In en, this message translates to:
  /// **'No line items'**
  String get noLineItems;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @productDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get productDetails;

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

  /// Section title for seller registration details.
  ///
  /// In en, this message translates to:
  /// **'Seller details'**
  String get sellerDetailsSectionTitle;

  /// Hint text for seller details section.
  ///
  /// In en, this message translates to:
  /// **'Complete your details so we can review your application.'**
  String get sellerDetailsSectionHint;

  /// Label for specialty field.
  ///
  /// In en, this message translates to:
  /// **'Specialty / Craft'**
  String get specialtyLabel;

  /// Hint text for specialty field.
  ///
  /// In en, this message translates to:
  /// **'e.g. Handmade pottery'**
  String get specialtyHint;

  /// Validation message for missing specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty is required'**
  String get specialtyIsRequired;

  /// Label for phone number field.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumberLabel;

  /// Hint text for phone number field.
  ///
  /// In en, this message translates to:
  /// **'+20 1XX XXX XXXX'**
  String get phoneNumberHint;

  /// Validation message for missing phone.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneIsRequired;

  /// Label for optional city field.
  ///
  /// In en, this message translates to:
  /// **'City (optional)'**
  String get cityLabelOptional;

  /// Label for optional country field.
  ///
  /// In en, this message translates to:
  /// **'Country (optional)'**
  String get countryLabelOptional;

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

  /// App title displayed in the home screen app bar.
  ///
  /// In en, this message translates to:
  /// **'Ayady'**
  String get ayady;

  /// Hint text for the search field on the home screen.
  ///
  /// In en, this message translates to:
  /// **'Search unique handmade crafts'**
  String get searchUniqueHandmadeCrafts;

  /// Section title for the categories list.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Button text to view all items in a section.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// Section title for featured products.
  ///
  /// In en, this message translates to:
  /// **'Featured Products'**
  String get featuredProducts;

  /// Subtitle for the featured products section.
  ///
  /// In en, this message translates to:
  /// **'Handpicked for your style'**
  String get handpickedForYourStyle;

  /// Section title for top rated products.
  ///
  /// In en, this message translates to:
  /// **'Top Rated'**
  String get topRated;

  /// Button text to explore all items in a section.
  ///
  /// In en, this message translates to:
  /// **'Explore All'**
  String get exploreAll;

  /// Generic error title for snackbar messages.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Hint text for the search field in the search screen.
  ///
  /// In en, this message translates to:
  /// **'Search for products'**
  String get searchForProducts;

  /// Title for snackbar when trying to filter without search criteria.
  ///
  /// In en, this message translates to:
  /// **'No filters'**
  String get noFilters;

  /// Message shown when trying to filter without proper criteria.
  ///
  /// In en, this message translates to:
  /// **'Please enter a search query or select a category to filter.'**
  String get pleaseEnterSearchQueryOrSelectCategory;

  /// Title for the edit profile bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Label for name input field.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Button text to save profile changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// Button text and dialog title for logout action.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Confirmation message in logout dialog.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get areYouSureYouWantToLogout;

  /// Title for the profile screen.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Menu item title for orders section.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get myOrders;

  /// Subtitle for the orders menu item.
  ///
  /// In en, this message translates to:
  /// **'Track and manage your purchases'**
  String get trackAndManageYourPurchases;

  /// Menu item title for favorites section.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// Subtitle for the favorites menu item.
  ///
  /// In en, this message translates to:
  /// **'Items you\'ve saved for later'**
  String get itemsYouHaveSavedForLater;

  /// Menu item title for settings section.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Subtitle for the settings menu item.
  ///
  /// In en, this message translates to:
  /// **'Notifications and privacy'**
  String get notificationsAndPrivacy;

  /// Subtitle for the edit profile menu item.
  ///
  /// In en, this message translates to:
  /// **'Name, bio '**
  String get nameBio;

  /// Bottom navigation bar label for home tab.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Bottom navigation bar label for wishlist tab.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// Bottom navigation bar label for cart tab.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// Success message when product is updated.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get productUpdatedSuccessfully;

  /// Error message when saving product fails.
  ///
  /// In en, this message translates to:
  /// **'Error saving product'**
  String get errorSavingProduct;

  /// Button text to prepare an order.
  ///
  /// In en, this message translates to:
  /// **'Prepare'**
  String get prepare;

  /// Button text to ship an order.
  ///
  /// In en, this message translates to:
  /// **'Ship'**
  String get ship;

  /// Button text to deliver an order.
  ///
  /// In en, this message translates to:
  /// **'Deliver'**
  String get deliver;

  /// Label for platform commission setting.
  ///
  /// In en, this message translates to:
  /// **'Platform Commission'**
  String get platformCommission;

  /// Example hint text for commission input.
  ///
  /// In en, this message translates to:
  /// **'e.g. 15'**
  String get eg15;

  /// Button text to save changes.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Error message for terms agreement.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms of Service'**
  String get pleaseAgreeToTermsOfService;

  /// Default hint text for numeric input.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get zeroPointZeroZero;

  /// Label for delivery fee setting.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryFee;

  /// Label for minimum order value setting.
  ///
  /// In en, this message translates to:
  /// **'Minimum Order Value'**
  String get minimumOrderValue;

  /// Label for support email setting.
  ///
  /// In en, this message translates to:
  /// **'Support Email'**
  String get supportEmail;

  /// Button text to approve something.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// Button text to reject something.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get reject;

  /// Hint text for seller search field.
  ///
  /// In en, this message translates to:
  /// **'Search sellers...'**
  String get searchSellers;

  /// Label for phone number field.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// Label for location field.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// Label for specialty field.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// Label for total sales count.
  ///
  /// In en, this message translates to:
  /// **'Total sales'**
  String get totalSales;

  /// Label for total products count.
  ///
  /// In en, this message translates to:
  /// **'Total products'**
  String get totalProducts;

  /// Label for wallet balance field.
  ///
  /// In en, this message translates to:
  /// **'Wallet balance'**
  String get walletBalance;

  /// Label for commission rate field.
  ///
  /// In en, this message translates to:
  /// **'Commission rate'**
  String get commissionRate;

  /// Label for submitted date/status.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get submitted;

  /// Tab/status label for active items.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Status label for delivered orders.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// Hint text for order search field.
  ///
  /// In en, this message translates to:
  /// **'Search order ID or name'**
  String get searchOrderIdOrName;

  /// Error message when seller is not found.
  ///
  /// In en, this message translates to:
  /// **'Seller not found'**
  String get sellerNotFound;

  /// Button text to approve in uppercase.
  ///
  /// In en, this message translates to:
  /// **'APPROVE'**
  String get approveCaps;

  /// Button text to reject in uppercase.
  ///
  /// In en, this message translates to:
  /// **'REJECT'**
  String get rejectCaps;

  /// Label for creation date.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// Label for last update date.
  ///
  /// In en, this message translates to:
  /// **'Last update'**
  String get lastUpdate;

  /// Label for order subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// Label for delivery fee in order details.
  ///
  /// In en, this message translates to:
  /// **'Delivery fee'**
  String get deliveryFeeLower;

  /// Label for commission amount.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// Label for seller earning amount.
  ///
  /// In en, this message translates to:
  /// **'Seller earning'**
  String get sellerEarning;

  /// Label for total amount.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Label for payment method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// Label for street address.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// Label for the city form field.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// Label for governorate field.
  ///
  /// In en, this message translates to:
  /// **'Governorate'**
  String get governorate;

  /// Label for country field.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// Label for zip code field.
  ///
  /// In en, this message translates to:
  /// **'Zip'**
  String get zip;

  /// Hint text for product search field.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get searchProducts;

  /// Title for order screen.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// Error message when order is not found.
  ///
  /// In en, this message translates to:
  /// **'Order not found'**
  String get orderNotFound;

  /// Title for product screen.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// Error message when product is not found.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get productNotFound;

  /// Dashboard stat label for total users.
  ///
  /// In en, this message translates to:
  /// **'TOTAL USERS'**
  String get totalUsers;

  /// Dashboard stat label for total sellers.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SELLERS'**
  String get totalSellers;

  /// Dashboard stat label for total orders.
  ///
  /// In en, this message translates to:
  /// **'TOTAL ORDERS'**
  String get totalOrders;

  /// Dashboard stat label for revenue.
  ///
  /// In en, this message translates to:
  /// **'REVENUE'**
  String get revenue;

  /// Label for stock quantity.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// Label for product category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// Affirmative response.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Negative response.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Label for reviews count.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// Label for sales count.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get sales;

  /// Bottom navigation label for dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// Bottom navigation label for sellers.
  ///
  /// In en, this message translates to:
  /// **'Sellers'**
  String get sellers;

  /// Bottom navigation label for products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// Title for withdrawal success dialog.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal Requested!'**
  String get withdrawalRequested;

  /// Message for withdrawal success dialog.
  ///
  /// In en, this message translates to:
  /// **'EGP {amount} will be transferred to your account within 2-3 business days.'**
  String withdrawalMessage(String amount);

  /// Generic success title for snackbar messages.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Success message after seller registration.
  ///
  /// In en, this message translates to:
  /// **'Registration complete! Awaiting admin approval.'**
  String get registrationCompleteAwaitingApproval;

  /// Menu item title for shop settings.
  ///
  /// In en, this message translates to:
  /// **'Shop Settings'**
  String get shopSettings;

  /// Subtitle for shop settings menu item.
  ///
  /// In en, this message translates to:
  /// **'View your shop information'**
  String get viewYourShopInformation;

  /// Subtitle for notifications menu item.
  ///
  /// In en, this message translates to:
  /// **'Open your notifications center'**
  String get openYourNotificationsCenter;

  /// Menu item title for help and support.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupport;

  /// Subtitle for help and support menu item.
  ///
  /// In en, this message translates to:
  /// **'Contact support and review help info'**
  String get contactSupportAndReviewHelpInfo;

  /// Label for contact section.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// Label for email field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Title for shop information section.
  ///
  /// In en, this message translates to:
  /// **'Shop Info'**
  String get shopInfo;

  /// Label for shop owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// Label for seller badge.
  ///
  /// In en, this message translates to:
  /// **'Badge'**
  String get badge;

  /// Label for status field.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// Button text to email seller.
  ///
  /// In en, this message translates to:
  /// **'Email Seller'**
  String get emailSeller;

  /// Default subject for custom order email.
  ///
  /// In en, this message translates to:
  /// **'Custom Order Request'**
  String get customOrderRequestSubject;

  /// Default message template for custom order email.
  ///
  /// In en, this message translates to:
  /// **'Hello {sellerName},\n\nI am interested in placing a custom order. Please contact me to discuss the details.\n\nThank you!'**
  String customOrderRequestMessage(String sellerName);

  /// Button text to send email.
  ///
  /// In en, this message translates to:
  /// **'Send Email'**
  String get sendEmail;

  /// Instruction text for custom order email.
  ///
  /// In en, this message translates to:
  /// **'Write your custom request and continue in your email app'**
  String get writeYourCustomRequestAndContinueInYourEmailApp;

  /// Placeholder text for price input field.
  ///
  /// In en, this message translates to:
  /// **'Enter price'**
  String get pricePlaceholder;

  /// Validation message for missing price.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get priceIsRequired;

  /// Validation message for invalid price format.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get invalidPrice;

  /// Placeholder text for stock input field.
  ///
  /// In en, this message translates to:
  /// **'Enter stock quantity'**
  String get stockPlaceholder;

  /// Validation message for missing stock.
  ///
  /// In en, this message translates to:
  /// **'Stock is required'**
  String get stockIsRequired;

  /// Validation message for invalid number format.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get invalidNumber;

  /// Placeholder text for category selection.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// Validation message for unselected category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get pleaseSelectCategory;

  /// Validation message for missing description.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionIsRequired;

  /// Status label for pending items.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Status label for approved items.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// Status label for rejected items.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// Status label for cancelled items.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// Button or title for editing a product.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get editProduct;

  /// Label for product name field.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get productName;

  /// Hint text for the product name input field.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get enterProductName;

  /// Validation message shown when the product name is empty.
  ///
  /// In en, this message translates to:
  /// **'Product name is required'**
  String get productNameIsRequired;

  /// Label text for the price field.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// Button text to discard changes.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// Title for the manage products screen.
  ///
  /// In en, this message translates to:
  /// **'Manage Products'**
  String get manageProducts;

  /// Message shown when there are no products available.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get noProductsFound;

  /// Label text for the unit count display.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// Button text to delete an item.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Button text to mark an order as shipped.
  ///
  /// In en, this message translates to:
  /// **'Mark as Shipped'**
  String get markAsShipped;

  /// Button text to mark an order as completed.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// Status text for a completed order.
  ///
  /// In en, this message translates to:
  /// **'Order Completed'**
  String get orderCompleted;

  /// Status label for shipped orders.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// Status label for completed orders.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Message shown when an order status changes.
  ///
  /// In en, this message translates to:
  /// **'Order status updated to {status}'**
  String orderStatusUpdatedTo(String status);

  /// Title for the best selling item card.
  ///
  /// In en, this message translates to:
  /// **'Best Selling Item'**
  String get bestSellingItem;

  /// Title for the quick actions section.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Button text to add a new product.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get addProduct;

  /// Button text to view products list.
  ///
  /// In en, this message translates to:
  /// **'View Products'**
  String get viewProducts;

  /// Button text to view orders list.
  ///
  /// In en, this message translates to:
  /// **'View Orders'**
  String get viewOrders;

  /// Section title for recent orders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get recentOrders;

  /// Message shown when there are no recent orders.
  ///
  /// In en, this message translates to:
  /// **'No recent orders'**
  String get noRecentOrders;

  /// Label for an order item in the details list.
  ///
  /// In en, this message translates to:
  /// **'Order Item'**
  String get orderItem;

  /// Message shown when the state is unexpected.
  ///
  /// In en, this message translates to:
  /// **'Unexpected state'**
  String get unexpectedState;

  /// Section title for inventory details.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// Section title for product statistics.
  ///
  /// In en, this message translates to:
  /// **'Stats'**
  String get stats;

  /// Section title for business information.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// Section title for timeline information.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// Section title for parties involved.
  ///
  /// In en, this message translates to:
  /// **'Parties'**
  String get parties;

  /// Section title for totals information.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get totals;

  /// Section title for payment information.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// Section title for shipping information.
  ///
  /// In en, this message translates to:
  /// **'Shipping'**
  String get shipping;

  /// Subtitle for new artisan registrations notification.
  ///
  /// In en, this message translates to:
  /// **'New artisan registrations'**
  String get newArtisanRegistrations;

  /// Subtitle for quality control check notification.
  ///
  /// In en, this message translates to:
  /// **'Quality control check required'**
  String get qualityControlCheckRequired;

  /// Screen title for notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Button label to mark all notifications as read.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllAsRead;

  /// Button label to clear all notifications.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// Filter label for all notifications.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Filter label for unread notifications.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get unread;

  /// Filter label for order notifications.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// Filter label for message notifications.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// Filter label for offer notifications.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get offers;

  /// Message shown when a notification is deleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notificationDeleted;

  /// Date label for notifications from today.
  ///
  /// In en, this message translates to:
  /// **'TODAY'**
  String get today;

  /// Date label for notifications from yesterday.
  ///
  /// In en, this message translates to:
  /// **'YESTERDAY'**
  String get yesterday;

  /// Date label for notifications from earlier.
  ///
  /// In en, this message translates to:
  /// **'EARLIER'**
  String get earlier;

  /// Dialog title for clearing all notifications.
  ///
  /// In en, this message translates to:
  /// **'Clear All Notifications'**
  String get clearAllNotifications;

  /// Dialog message for clearing all notifications.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete all notifications? This action cannot be undone.'**
  String get clearAllNotificationsMessage;

  /// Empty state message for notifications.
  ///
  /// In en, this message translates to:
  /// **'When you receive notifications, they\'ll appear here. Stay tuned!'**
  String get noNotificationsMessage;

  /// Title for payment completion screen.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get completePayment;

  /// Description for payment transaction.
  ///
  /// In en, this message translates to:
  /// **'The payment transaction description.'**
  String get paymentTransactionDescription;

  /// Note for payment transaction.
  ///
  /// In en, this message translates to:
  /// **'Contact us for any questions on your order.'**
  String get contactUsForQuestions;

  /// Error message prefix for payment failures.
  ///
  /// In en, this message translates to:
  /// **'Payment Error'**
  String get paymentError;

  /// Success message for password reset email.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get passwordResetLinkSent;

  /// Section title for payment method selection.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// Success message when email app opens.
  ///
  /// In en, this message translates to:
  /// **'Email app opened successfully'**
  String get emailAppOpenedSuccessfully;

  /// Error message for order cancellation.
  ///
  /// In en, this message translates to:
  /// **'Only pending orders can be cancelled.'**
  String get onlyPendingOrdersCanBeCancelled;

  /// Section title for review details input.
  ///
  /// In en, this message translates to:
  /// **'Review Details'**
  String get reviewDetails;

  /// Section title for product description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Section title for order summary.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get orderSummary;

  /// Screen title for all reviews.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get allReviews;

  /// Button label for adding photos.
  ///
  /// In en, this message translates to:
  /// **'Add Photos'**
  String get addPhotos;

  /// Screen title for cart screen.
  ///
  /// In en, this message translates to:
  /// **'Your Cart'**
  String get yourCart;

  /// Hint text for promo code input field.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get promoCode;

  /// Error message when cart fails to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cart. Please try again.'**
  String get failedToLoadCart;

  /// Message when cart is empty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty.'**
  String get yourCartIsEmpty;

  /// Suggestion message when cart is empty.
  ///
  /// In en, this message translates to:
  /// **'Start adding your favorite products!'**
  String get startAddingYourFavoriteProducts;

  /// Error message when order summary fails to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load order summary. Please try again.'**
  String get failedToLoadOrderSummary;

  /// Terms agreement text for checkout.
  ///
  /// In en, this message translates to:
  /// **'By clicking confirm, you agree to our Terms of Service and Privacy Policy.'**
  String get byClickingConfirmYouAgreeToOurTermsOfServiceAndPrivacyPolicy;

  /// Error message for failed checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout Failed. Try Again.'**
  String get checkoutFailed;

  /// Success message for successful checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout Successful!'**
  String get checkoutSuccessful;

  /// Button label for checkout action.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Checkout'**
  String get proceedToCheckout;

  /// Message when there are no notifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotificationsYet;

  /// Subtitle message for empty notifications.
  ///
  /// In en, this message translates to:
  /// **'We will notify you about orders, offers and updates.'**
  String get weWillNotifyYouAboutOrdersOffersAndUpdates;

  /// Error message when notifications fail to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load notifications'**
  String get failedToLoadNotifications;

  /// Time label for recent notifications.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Title for feature under development.
  ///
  /// In en, this message translates to:
  /// **'Coming Soon'**
  String get comingSoon;

  /// Subtitle for notifications under development.
  ///
  /// In en, this message translates to:
  /// **'Notifications feature is under development.'**
  String get notificationsUnderDevelopment;

  /// Label for language settings.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Subtitle for language settings.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get changeLanguage;

  /// Card title for becoming a seller.
  ///
  /// In en, this message translates to:
  /// **'Become a Seller'**
  String get becomeASeller;

  /// Card subtitle for becoming a seller.
  ///
  /// In en, this message translates to:
  /// **'Start selling your handcrafted products today.'**
  String get startSellingYourHandcraftedProductsToday;

  /// Error message for image recovery failure.
  ///
  /// In en, this message translates to:
  /// **'Failed to recover image.'**
  String get failedToRecoverImage;

  /// Error message for image picker unavailability.
  ///
  /// In en, this message translates to:
  /// **'Image picker is unavailable now. Restart the app and try again.'**
  String get imagePickerIsUnavailableNowRestartTheAppAndTryAgain;

  /// Screen title for wishlist screen.
  ///
  /// In en, this message translates to:
  /// **'Your Wishlist'**
  String get yourWishlist;

  /// Label for count of saved items.
  ///
  /// In en, this message translates to:
  /// **'saved items'**
  String get savedItems;

  /// Subtitle for wishlist.
  ///
  /// In en, this message translates to:
  /// **'Your favorite products are ready anytime.'**
  String get yourFavoriteProductsAreReadyAnytime;

  /// Error message when wishlist fails to load.
  ///
  /// In en, this message translates to:
  /// **'Failed to load wishlist. Please try again.'**
  String get failedToLoadWishlist;

  /// Message when wishlist is empty.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty. \nStart adding your favorite products!'**
  String get yourWishlistIsEmpty;

  /// Title for password reset verification screen.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkYourEmail;

  /// Message prefix for password reset email.
  ///
  /// In en, this message translates to:
  /// **'We sent a password reset link to'**
  String get weSentAPasswordResetLinkTo;

  /// Instruction message for password reset.
  ///
  /// In en, this message translates to:
  /// **'Please open your email and follow the instructions.'**
  String get pleaseOpenYourEmailAndFollowTheInstructions;

  /// Additional instruction for password reset.
  ///
  /// In en, this message translates to:
  /// **'If you don\'t see the email, check your spam or junk folder.'**
  String get ifYouDontSeeTheEmailCheckYourSpamOrJunkFolder;

  /// Button label to return to login screen.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// Label for customer name in order details.
  ///
  /// In en, this message translates to:
  /// **'Customer:'**
  String get customerLabel;

  /// Singular form of item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get item;

  /// Plural form of items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get items;

  /// Label for total amount.
  ///
  /// In en, this message translates to:
  /// **'Total:'**
  String get totalLabel;

  /// Egyptian Pound currency code.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// Instruction text for file upload area.
  ///
  /// In en, this message translates to:
  /// **'Click to upload or drag and drop'**
  String get clickToUploadOrDragAndDrop;

  /// Screen title for seller registration.
  ///
  /// In en, this message translates to:
  /// **'Seller Registration'**
  String get sellerRegistration;

  /// Support feature title.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get support247;

  /// Support feature subtitle.
  ///
  /// In en, this message translates to:
  /// **'Dedicated artisan assistance'**
  String get dedicatedArtisanAssistance;

  /// Section title for account details.
  ///
  /// In en, this message translates to:
  /// **'Account Details'**
  String get accountDetails;

  /// Section title for shop profile.
  ///
  /// In en, this message translates to:
  /// **'Shop Profile'**
  String get shopProfile;

  /// Label for shop name field.
  ///
  /// In en, this message translates to:
  /// **'Shop Name'**
  String get shopName;

  /// Footer text explaining the review process.
  ///
  /// In en, this message translates to:
  /// **'Our curation team will review your application within 3–5\nbusiness days.'**
  String get curationTeamReview;

  /// Title for the best-selling product section.
  ///
  /// In en, this message translates to:
  /// **'Best-Selling Product'**
  String get bestSellingProduct;

  /// Dashboard greeting for the admin user.
  ///
  /// In en, this message translates to:
  /// **'Good morning, Admin'**
  String get goodMorningAdmin;

  /// Section title for pending admin actions.
  ///
  /// In en, this message translates to:
  /// **'Pending Actions'**
  String get pendingActions;

  /// Label showing number of pending seller approvals.
  ///
  /// In en, this message translates to:
  /// **'{count} sellers awaiting approval'**
  String sellersAwaitingApproval(int count);

  /// Label showing number of products awaiting review.
  ///
  /// In en, this message translates to:
  /// **'{count} products awaiting review'**
  String productsAwaitingReview(int count);

  /// Button text to review pending items.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// App bar title for seller approvals screen.
  ///
  /// In en, this message translates to:
  /// **'Seller Approvals'**
  String get sellerApprovals;

  /// App bar title for approve products screen.
  ///
  /// In en, this message translates to:
  /// **'Approve Products'**
  String get approveProducts;

  /// Text shown when there are no sellers in the list.
  ///
  /// In en, this message translates to:
  /// **'No sellers found'**
  String get noSellersFound;

  /// Text shown when there are no orders in the list.
  ///
  /// In en, this message translates to:
  /// **'No orders found'**
  String get noOrdersFound;

  /// Vendor attribution text for product cards.
  ///
  /// In en, this message translates to:
  /// **'by {vendor}'**
  String byVendor(String vendor);

  /// Submitted date label for seller cards.
  ///
  /// In en, this message translates to:
  /// **'Submitted: {date}'**
  String submittedOn(String date);

  /// Title for the seller details screen.
  ///
  /// In en, this message translates to:
  /// **'Seller Details'**
  String get sellerDetails;

  /// Label to show seller name on an order card.
  ///
  /// In en, this message translates to:
  /// **'Seller: {name}'**
  String sellerLabel(String name);

  /// Text shown when no further actions are available for an order.
  ///
  /// In en, this message translates to:
  /// **'No further actions — {status}'**
  String noFurtherActions(String status);

  /// Label for product title field.
  ///
  /// In en, this message translates to:
  /// **'Product Title'**
  String get productTitle;

  /// Label for product images section.
  ///
  /// In en, this message translates to:
  /// **'Product Images'**
  String get productImages;

  /// Text shown on the add photo button.
  ///
  /// In en, this message translates to:
  /// **'ADD PHOTO'**
  String get addPhoto;

  /// Label for price field in EGP.
  ///
  /// In en, this message translates to:
  /// **'Price (EGP)'**
  String get priceEgp;

  /// Placeholder text for product description field.
  ///
  /// In en, this message translates to:
  /// **'Describe your product...'**
  String get describeYourProduct;

  /// Label for active listing toggle.
  ///
  /// In en, this message translates to:
  /// **'Active Listing'**
  String get activeListing;

  /// Description of active listing toggle.
  ///
  /// In en, this message translates to:
  /// **'Visible to customers in the marketplace'**
  String get visibleToCustomersInTheMarketplace;

  /// Button text to save a new product.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get saveProduct;

  /// Button text to discard product changes.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get discardChanges;

  /// Error message when no product images are added.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one product image'**
  String get pleaseAddAtLeastOneProductImage;

  /// Success message after adding a product.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully'**
  String get productAddedSuccessfully;

  /// Validation message for empty fields.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get thisFieldIsRequired;

  /// Hint text for product title input field.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hand-painted Ceramic Serving Dish'**
  String get hintHandPaintedCeramicServingDish;

  /// Button label for purchasing a product immediately.
  ///
  /// In en, this message translates to:
  /// **'Buy Now'**
  String get buyNow;

  /// Button state text shown after adding item to cart.
  ///
  /// In en, this message translates to:
  /// **'Added'**
  String get added;

  /// Button label for adding a product to the shopping cart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get addToCart;

  /// Button label to navigate to the seller's shop page.
  ///
  /// In en, this message translates to:
  /// **'View Shop'**
  String get viewShop;

  /// Error message when reviews fail to load on product details.
  ///
  /// In en, this message translates to:
  /// **'Unable to load reviews right now.'**
  String get unableToLoadReviews;

  /// Empty state message for product reviews section.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet for this product. Be the first to share your thoughts!'**
  String get noReviewsYetForProduct;

  /// Hint text for the review comment field.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with the craftsmanship, delivery, and overall quality...'**
  String get shareYourExperience;

  /// Prompt text shown when no rating has been selected.
  ///
  /// In en, this message translates to:
  /// **'TAP TO RATE'**
  String get tapToRate;

  /// Share text template for sharing a product link.
  ///
  /// In en, this message translates to:
  /// **'Check out this product: {productName} for {productPrice} at our store!'**
  String checkOutThisProduct(String productName, String productPrice);

  /// Section title for delivery address on cart and order screens.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddress;

  /// Button text to change an existing address.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// Label for the address title form field.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get formTitle;

  /// Hint text for the address title field.
  ///
  /// In en, this message translates to:
  /// **'Home / Work'**
  String get homeWork;

  /// Label for the street address form field.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// Hint text for the street address field.
  ///
  /// In en, this message translates to:
  /// **'Street, building'**
  String get streetBuilding;

  /// Hint text for the city field.
  ///
  /// In en, this message translates to:
  /// **'Cairo'**
  String get cairo;

  /// Label for the ZIP code form field.
  ///
  /// In en, this message translates to:
  /// **'ZIP Code'**
  String get zipCode;

  /// Hint text for the ZIP code field.
  ///
  /// In en, this message translates to:
  /// **'12345'**
  String get zipCodeHint;

  /// Validation error for invalid ZIP code input.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid ZIP code'**
  String get pleaseEnterValidZipCode;

  /// Checkbox label to mark an address as default.
  ///
  /// In en, this message translates to:
  /// **'Set as default address'**
  String get setAsDefaultAddress;

  /// Subtitle text for the default address checkbox.
  ///
  /// In en, this message translates to:
  /// **'Tap to use this address for future orders.'**
  String get tapToUseThisAddress;

  /// Toggle state label for enabled state.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get toggleOn;

  /// Toggle state label for disabled state.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get toggleOff;

  /// Button label to save an address.
  ///
  /// In en, this message translates to:
  /// **'Save Address'**
  String get saveAddress;

  /// Hint text for mobile wallet phone number input.
  ///
  /// In en, this message translates to:
  /// **'Enter wallet phone (e.g. +201xxxxxxxxx)'**
  String get enterWalletPhone;

  /// Payment method name for Visa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get visa;

  /// Payment method name for PayPal.
  ///
  /// In en, this message translates to:
  /// **'PayPal'**
  String get paypal;

  /// Payment method name for mobile wallets.
  ///
  /// In en, this message translates to:
  /// **'Mobile Wallets'**
  String get mobileWallets;

  /// Snackbar message when promo code field is empty.
  ///
  /// In en, this message translates to:
  /// **'Please enter a promo code'**
  String get pleaseEnterPromoCode;

  /// Snackbar title when a product is removed from cart.
  ///
  /// In en, this message translates to:
  /// **'Product Deleted'**
  String get productDeleted;

  /// Snackbar message when a product is removed from cart.
  ///
  /// In en, this message translates to:
  /// **'{productName} has been removed from your cart.'**
  String productRemovedFromCart(String productName);

  /// Snackbar title when payment is cancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled'**
  String get paymentCancelled;

  /// Snackbar message when payment was cancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment was cancelled. Complete payment to place the order.'**
  String get paymentWasCancelled;

  /// Snackbar title when address is missing.
  ///
  /// In en, this message translates to:
  /// **'Address required'**
  String get addressRequired;

  /// Snackbar message when address is missing.
  ///
  /// In en, this message translates to:
  /// **'Please add an address to proceed to checkout.'**
  String get pleaseAddAnAddress;

  /// Snackbar title when payment details are missing.
  ///
  /// In en, this message translates to:
  /// **'Payment details missing'**
  String get paymentDetailsMissing;

  /// Snackbar message for missing payment details.
  ///
  /// In en, this message translates to:
  /// **'Please wait for the order summary to load.'**
  String get pleaseWaitForOrderSummary;

  /// Bottom navigation bar label for orders tab.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTab;

  /// FAB button label to open AI recommendation assistant.
  ///
  /// In en, this message translates to:
  /// **'AI Help'**
  String get aiHelp;

  /// Label showing the date an order was placed.
  ///
  /// In en, this message translates to:
  /// **'Placed on {date}'**
  String placedOn(String date);

  /// Section title showing number of items in an order.
  ///
  /// In en, this message translates to:
  /// **'Order Items ({count})'**
  String orderItems(int count);

  /// Section title for delivery address in order details.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get deliveryAddressSection;

  /// Button label to cancel an order.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get cancelOrder;

  /// Info message about order cancellation eligibility.
  ///
  /// In en, this message translates to:
  /// **'Orders can only be cancelled while in \'Pending\' status.'**
  String get ordersCanOnlyBeCancelledWhenPending;

  /// Alert dialog title for order cancellation confirmation.
  ///
  /// In en, this message translates to:
  /// **'Cancel order?'**
  String get cancelOrderQuestion;

  /// Alert dialog content for order cancellation confirmation.
  ///
  /// In en, this message translates to:
  /// **'This order will be cancelled and cannot be restored.'**
  String get cancelOrderWarning;

  /// Fallback label when customer name is not available.
  ///
  /// In en, this message translates to:
  /// **'Unknown Customer'**
  String get unknownCustomer;

  /// Label for discount amount in order summary.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// Label for total amount in order summary.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// Seller attribution label on product cards.
  ///
  /// In en, this message translates to:
  /// **'Sold by {sellerName}'**
  String soldBy(String sellerName);

  /// Label for product quantity display.
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity}'**
  String qty(int quantity);

  /// Info message when user tries to review an undelivered product.
  ///
  /// In en, this message translates to:
  /// **'You can review this product after delivery'**
  String get reviewAfterDelivery;

  /// Button text to write a review for a delivered product.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get writeReview;

  /// Snackbar message when order is placed.
  ///
  /// In en, this message translates to:
  /// **'Order placed successfully.'**
  String get orderPlacedSuccessfully;

  /// Snackbar title when review submission is missing data.
  ///
  /// In en, this message translates to:
  /// **'Review Missing'**
  String get reviewMissing;

  /// Snackbar message when no rating is selected.
  ///
  /// In en, this message translates to:
  /// **'Please select a star rating before submitting.'**
  String get pleaseSelectStarRating;

  /// Snackbar message when no comment is written.
  ///
  /// In en, this message translates to:
  /// **'Please write a short comment before submitting.'**
  String get pleaseWriteShortComment;

  /// Snackbar title on successful review submission.
  ///
  /// In en, this message translates to:
  /// **'Thank You'**
  String get thankYou;

  /// Snackbar message on successful review submission.
  ///
  /// In en, this message translates to:
  /// **'Your review was submitted successfully.'**
  String get reviewSubmittedSuccessfully;

  /// Snackbar title when review submission fails.
  ///
  /// In en, this message translates to:
  /// **'Submit Failed'**
  String get submitFailed;

  /// Prompt text on the review screen.
  ///
  /// In en, this message translates to:
  /// **'How was your experience?'**
  String get howWasYourExperience;

  /// Subtitle text on the review screen.
  ///
  /// In en, this message translates to:
  /// **'Your feedback helps our artisan community grow.'**
  String get yourFeedbackHelps;

  /// Button label for submitting a review.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get submitReview;

  /// Legal disclaimer text on the review screen.
  ///
  /// In en, this message translates to:
  /// **'By submitting, you agree to Ayady\'s Terms of Service and Privacy Policy.'**
  String get bySubmittingYouAgree;

  /// Empty state message for reviews.
  ///
  /// In en, this message translates to:
  /// **'No reviews available.'**
  String get noReviewsAvailable;

  /// Fallback display name for anonymous users.
  ///
  /// In en, this message translates to:
  /// **'User {userId}'**
  String anonymousUser(String userId);

  /// Button label to view all reviews.
  ///
  /// In en, this message translates to:
  /// **'View all {count} reviews'**
  String viewAllReviews(int count);

  /// Error message when not logged in.
  ///
  /// In en, this message translates to:
  /// **'You need to login before submitting a review'**
  String get youNeedToLoginBeforeReviewing;

  /// Validation message for rating selection.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating between 1 and 5.'**
  String get pleaseSelectRating;

  /// Snackbar message when no subcategories exist.
  ///
  /// In en, this message translates to:
  /// **'No subcategories found. Showing all items in this category.'**
  String get noSubcategoriesFound;

  /// Screen title for shop details.
  ///
  /// In en, this message translates to:
  /// **'Shop Details'**
  String get shopDetails;

  /// Error message when shop is not found.
  ///
  /// In en, this message translates to:
  /// **'Shop not found'**
  String get shopNotFound;

  /// Subtitle when shop fails to load.
  ///
  /// In en, this message translates to:
  /// **'We could not load this seller right now.'**
  String get weCouldNotLoadThisSeller;

  /// Fallback text when data is not available.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get notAvailable;

  /// Button label to continue to email app.
  ///
  /// In en, this message translates to:
  /// **'Continue to Email'**
  String get continueToEmail;

  /// Label for email subject field.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get subject;

  /// Snackbar message when product is removed from wishlist.
  ///
  /// In en, this message translates to:
  /// **'{productName} has been removed from your wishlist.'**
  String productRemovedFromWishlist(String productName);

  /// Snackbar message when product is added to wishlist.
  ///
  /// In en, this message translates to:
  /// **'{productName} has been added to your wishlist.'**
  String productAddedToWishlist(String productName);

  /// Initial welcome message from the AI chatbot.
  ///
  /// In en, this message translates to:
  /// **'Hi! Tell me about your room size, colors, style, and what handmade product you are looking for.'**
  String get chatbotWelcomeMessage;

  /// Temporary typing indicator shown while the chatbot processes.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// Bot reply when no preferences could be extracted.
  ///
  /// In en, this message translates to:
  /// **'I need more details. Please tell me the room type, size, colors, or product type you want.'**
  String get needMoreDetails;

  /// Bot reply when no products match the user's preferences.
  ///
  /// In en, this message translates to:
  /// **'I understood your preferences:\n\n{preferences}\n\nSorry, I could not find an exact matching product right now. Try changing the color, room type, or product category.'**
  String noMatchingProductFound(String preferences);

  /// Bot reply when matching products are found.
  ///
  /// In en, this message translates to:
  /// **'Great! I found {count} handmade products that may match your room:\n\n{preferences}'**
  String productsFound(int count, String preferences);

  /// Example message shown as a suggestion in the chatbot.
  ///
  /// In en, this message translates to:
  /// **'I need a delicate product for a small bedroom, in pink and white, with a romantic style.'**
  String get exampleMessage;

  /// App bar title for the chatbot screen.
  ///
  /// In en, this message translates to:
  /// **'Recommendation Chatbot'**
  String get recommendationChatbot;

  /// Hint text for the chatbot input field.
  ///
  /// In en, this message translates to:
  /// **'Describe your room...'**
  String get describeYourRoom;

  /// Button label to view a recommended product.
  ///
  /// In en, this message translates to:
  /// **'View Product'**
  String get viewProduct;

  /// Snackbar message when a product is added to cart.
  ///
  /// In en, this message translates to:
  /// **'{productName} has been added to your cart.'**
  String productAddedToCart(String productName);

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

  /// Info card title for seller registration.
  ///
  /// In en, this message translates to:
  /// **'Global Reach'**
  String get selGlobalReach;

  /// Info card subtitle for seller registration.
  ///
  /// In en, this message translates to:
  /// **'Sell to customers worldwide'**
  String get selSellToCustomersWorldwide;

  /// Info card title for seller registration.
  ///
  /// In en, this message translates to:
  /// **'Secure Sales'**
  String get selSecureSales;

  /// Info card subtitle for seller registration.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed safe payments'**
  String get selGuaranteedSafePayments;

  /// Info card title for seller registration.
  ///
  /// In en, this message translates to:
  /// **'24/7 Support'**
  String get selSupport247;

  /// Hint text for email field in seller registration.
  ///
  /// In en, this message translates to:
  /// **'e.g. seller@mail.com'**
  String get selEmailHint;

  /// Validation message for invalid email in seller registration.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get selPleaseEnterValidEmail;

  /// Hint text for password field in seller registration.
  ///
  /// In en, this message translates to:
  /// **'Min 6 characters'**
  String get selPasswordHint;

  /// Validation message for short password in seller registration.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get selPasswordMin6Chars;

  /// Hint text for shop name field in seller registration.
  ///
  /// In en, this message translates to:
  /// **'e.g. Damascus Woodcrafts'**
  String get selShopNameHint;

  /// Label for craft specialty field in seller registration.
  ///
  /// In en, this message translates to:
  /// **'Craft Specialty'**
  String get selCraftSpecialty;

  /// Hint text for craft specialty field.
  ///
  /// In en, this message translates to:
  /// **'Select your primary craft'**
  String get selSelectYourPrimaryCraft;

  /// Label for artisan bio field in seller registration.
  ///
  /// In en, this message translates to:
  /// **'Artisan Bio'**
  String get selArtisanBio;

  /// Hint text for artisan bio field.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your journey, your craft, and\nwhat makes your products unique...'**
  String get selArtisanBioHint;

  /// Label for portfolio section in seller registration.
  ///
  /// In en, this message translates to:
  /// **'Portfolio & Product Samples'**
  String get selPortfolioAndProductSamples;

  /// Subtitle text for upload area in seller registration.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPG or PDF (max. 10MB)'**
  String get selPngJpgOrPdfMax10Mb;

  /// Link text for seller terms of service.
  ///
  /// In en, this message translates to:
  /// **'Seller Terms of Service'**
  String get selISellerTermsOfService;

  /// Text after seller terms link in registration.
  ///
  /// In en, this message translates to:
  /// **' and acknowledge\nthe platform commission rates on sales.'**
  String get selAndAcknowledgeCommissionRates;

  /// Button text for seller registration submission.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get selSubmitRequest;

  /// AppBar title for order details screen.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get selOrderDetails;

  /// Section heading for order items list.
  ///
  /// In en, this message translates to:
  /// **'Order Items'**
  String get selOrderItems;

  /// Label for total earnings in order details.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get selTotalEarnings;

  /// Button text to mark an order as shipped.
  ///
  /// In en, this message translates to:
  /// **'Mark as Shipped'**
  String get selMarkAsShipped;

  /// Button text to mark an order as completed.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get selMarkAsCompleted;

  /// Button text to archive a completed order.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get selArchive;

  /// Dialog title for order cancellation.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get selCancelOrderTitle;

  /// Dialog content for order cancellation confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel order {orderId}?'**
  String selCancelOrderContent(String orderId);

  /// Button text to confirm order cancellation.
  ///
  /// In en, this message translates to:
  /// **'Yes, Cancel'**
  String get selYesCancel;

  /// Snackbar message after order cancellation.
  ///
  /// In en, this message translates to:
  /// **'Order has been cancelled and stock restored'**
  String get selOrderCancelledAndStockRestored;

  /// Snackbar message when order cancellation fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to cancel order: {error}'**
  String selFailedToCancelOrder(String error);

  /// Snackbar message after order archival.
  ///
  /// In en, this message translates to:
  /// **'Order archived successfully'**
  String get selOrderArchivedSuccessfully;

  /// Snackbar message after order status update.
  ///
  /// In en, this message translates to:
  /// **'Order status updated to {status}'**
  String selOrderStatusUpdatedTo(String status);

  /// Empty state text when no orders in a tab.
  ///
  /// In en, this message translates to:
  /// **'No {tabName} Orders'**
  String selNoTabOrders(String tabName);

  /// Label for quantity display.
  ///
  /// In en, this message translates to:
  /// **'Qty: {quantity}'**
  String selQtyLabel(int quantity);

  /// Fallback customer name when not available.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get selCustomerFallback;

  /// Prefix for order ID display.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get selOrderPrefix;

  /// Singular form of item.
  ///
  /// In en, this message translates to:
  /// **'item'**
  String get selItemSingular;

  /// Plural form of items.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get selItemPlural;

  /// Subtitle showing available balance in withdraw sheet.
  ///
  /// In en, this message translates to:
  /// **'Available balance: EGP {amount}'**
  String selAvailableBalance(String amount);

  /// Section label for withdraw destination.
  ///
  /// In en, this message translates to:
  /// **'Withdraw to'**
  String get selWithdrawTo;

  /// Button text for withdraw confirmation.
  ///
  /// In en, this message translates to:
  /// **'Withdraw EGP {amount}'**
  String selWithdrawAmount(String amount);

  /// Button text when no amount is entered.
  ///
  /// In en, this message translates to:
  /// **'Enter amount'**
  String get selEnterAmount;

  /// Button text in withdrawal success dialog.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get selDone;

  /// Title for rejected seller application.
  ///
  /// In en, this message translates to:
  /// **'Application Not Approved'**
  String get selApplicationNotApproved;

  /// Title for pending seller application.
  ///
  /// In en, this message translates to:
  /// **'Account Under Review'**
  String get selAccountUnderReview;

  /// Description for rejected seller application.
  ///
  /// In en, this message translates to:
  /// **'We were unable to approve your seller application at this time. Reach out to our team if you\'d like to know more.'**
  String get selApplicationRejectedMessage;

  /// Description for pending seller application.
  ///
  /// In en, this message translates to:
  /// **'Thanks for joining Ayady. Our curation team is reviewing your application — you\'ll be notified the moment it\'s approved.'**
  String get selApplicationPendingMessage;

  /// Button text to sign out from pending screen.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get selSignOut;

  /// Info text for estimated review time.
  ///
  /// In en, this message translates to:
  /// **'Estimated review time: 3–5 business days'**
  String get selEstimatedReviewTime;

  /// Button text to refresh seller status.
  ///
  /// In en, this message translates to:
  /// **'Refresh Status'**
  String get selRefreshStatus;

  /// Status pill label for rejected application.
  ///
  /// In en, this message translates to:
  /// **'NOT APPROVED'**
  String get selNotApproved;

  /// Status pill label for pending application.
  ///
  /// In en, this message translates to:
  /// **'PENDING APPROVAL'**
  String get selPendingApproval;

  /// Timeline step label for submitted application.
  ///
  /// In en, this message translates to:
  /// **'Application submitted'**
  String get selApplicationSubmitted;

  /// Timeline step label for reviewed application (rejected).
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get selReviewed;

  /// Timeline step label for under review application.
  ///
  /// In en, this message translates to:
  /// **'Under review'**
  String get selUnderReview;

  /// Timeline step label for approved application.
  ///
  /// In en, this message translates to:
  /// **'Approved — welcome aboard'**
  String get selApprovedWelcomeAboard;

  /// Timeline step label for approved application.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get selApproved;

  /// Snackbar message for rejected application.
  ///
  /// In en, this message translates to:
  /// **'Your application was not approved. Please contact support.'**
  String get selApplicationNotApprovedSnack;

  /// Snackbar message for pending application.
  ///
  /// In en, this message translates to:
  /// **'You\'re still under review. We\'ll notify you soon.'**
  String get selStillUnderReview;

  /// Snackbar message when status refresh fails.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh status: {error}'**
  String selCouldNotRefreshStatus(String error);

  /// Dialog title for product deletion.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get selDeleteProduct;

  /// Dialog content for product deletion confirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this product? This action cannot be undone.'**
  String get selDeleteProductConfirm;

  /// Snackbar message after product deletion.
  ///
  /// In en, this message translates to:
  /// **'Product deleted successfully'**
  String get selProductDeletedSuccessfully;

  /// Snackbar message when product deletion fails.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete product: {error}'**
  String selFailedToDeleteProduct(String error);

  /// Popup menu item and AppBar title for editing product.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get selEditProduct;

  /// Popup menu item for deleting product.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get selDelete;

  /// Label showing stock quantity.
  ///
  /// In en, this message translates to:
  /// **'Stock: {stock} units'**
  String selStockUnits(int stock);

  /// Label for active listing toggle.
  ///
  /// In en, this message translates to:
  /// **'Active Listing'**
  String get selActiveListing;

  /// Description for active listing toggle.
  ///
  /// In en, this message translates to:
  /// **'Visible to customers in the marketplace'**
  String get selVisibleToCustomers;

  /// Label for price field in EGP.
  ///
  /// In en, this message translates to:
  /// **'Price (EGP)'**
  String get selPriceEgp;

  /// Label for product title field.
  ///
  /// In en, this message translates to:
  /// **'Product Title'**
  String get selProductTitle;

  /// Hint text for product title field.
  ///
  /// In en, this message translates to:
  /// **'e.g. Hand-painted Ceramic Serving Dish'**
  String get selProductTitleHint;

  /// Validation message for missing product title.
  ///
  /// In en, this message translates to:
  /// **'Product title is required'**
  String get selProductTitleRequired;

  /// Validation message for short product title.
  ///
  /// In en, this message translates to:
  /// **'Title must be at least 3 characters'**
  String get selTitleMin3Chars;

  /// Validation message for missing price.
  ///
  /// In en, this message translates to:
  /// **'Price is required'**
  String get selPriceRequired;

  /// Validation message for invalid number format.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get selEnterValidNumber;

  /// Validation message for negative price.
  ///
  /// In en, this message translates to:
  /// **'Price cannot be negative'**
  String get selPriceCannotBeNegative;

  /// Validation message for missing stock.
  ///
  /// In en, this message translates to:
  /// **'Stock is required'**
  String get selStockRequired;

  /// Validation message for invalid integer format.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid integer'**
  String get selEnterValidInteger;

  /// Validation message for negative stock.
  ///
  /// In en, this message translates to:
  /// **'Stock cannot be negative'**
  String get selStockCannotBeNegative;

  /// Validation message for missing description.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get selDescriptionRequired;

  /// Validation message for short description.
  ///
  /// In en, this message translates to:
  /// **'Description must be at least 10 characters'**
  String get selDescriptionMin10Chars;

  /// Section heading for product images.
  ///
  /// In en, this message translates to:
  /// **'Product Images'**
  String get selProductImages;

  /// Text on add photo button.
  ///
  /// In en, this message translates to:
  /// **'ADD PHOTO'**
  String get selAddPhoto;

  /// Snackbar message when no images added.
  ///
  /// In en, this message translates to:
  /// **'Please add at least one product image'**
  String get selPleaseAddAtLeastOneImage;

  /// Snackbar message after product creation.
  ///
  /// In en, this message translates to:
  /// **'Product added successfully!'**
  String get selProductAddedSuccessfully;

  /// Button text to save a product.
  ///
  /// In en, this message translates to:
  /// **'Save Product'**
  String get selSaveProduct;

  /// Button text to discard product changes.
  ///
  /// In en, this message translates to:
  /// **'Discard Changes'**
  String get selDiscardChanges;

  /// Product stock status when stock is zero.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get selOutOfStock;

  /// Product stock status when stock is low.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get selLowStock;

  /// Product stock status when stock is available.
  ///
  /// In en, this message translates to:
  /// **'In Stock'**
  String get selInStock;

  /// Validation message for short product name.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get selNameMin3Chars;

  /// Validation message for invalid price.
  ///
  /// In en, this message translates to:
  /// **'Invalid price'**
  String get selInvalidPrice;

  /// Validation message for invalid number.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get selInvalidNumber;

  /// Validation message for unselected category.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selPleaseSelectCategory;

  /// Hint text for category selection.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selSelectCategory;

  /// Snackbar message after product update.
  ///
  /// In en, this message translates to:
  /// **'Product updated successfully'**
  String get selProductUpdatedSuccessfully;

  /// Snackbar message when product save fails.
  ///
  /// In en, this message translates to:
  /// **'Error saving product: {error}'**
  String selErrorSavingProduct(String error);

  /// Button text to discard changes.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get selDiscard;

  /// Instruction text for file upload area.
  ///
  /// In en, this message translates to:
  /// **'Click to upload or drag and drop'**
  String get selClickToUpload;

  /// Subtitle text for upload area in edit product.
  ///
  /// In en, this message translates to:
  /// **'PNG, JPG or PDF (max. 5MB)'**
  String get selPngJpgOrPdfMax5Mb;

  /// Welcome message for seller dashboard.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {name}'**
  String selWelcomeSeller(String name);

  /// Subtitle for seller dashboard.
  ///
  /// In en, this message translates to:
  /// **'Here\'s what\'s happening with your shop today.'**
  String get selHereWhatIsHappening;

  /// Stat card title for total orders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get selTotalOrders;

  /// Empty state text for no recent orders.
  ///
  /// In en, this message translates to:
  /// **'No recent orders'**
  String get selNoRecentOrders;

  /// Fallback order item name.
  ///
  /// In en, this message translates to:
  /// **'Order Item'**
  String get selOrderItem;

  /// Text shown when state is unexpected.
  ///
  /// In en, this message translates to:
  /// **'Unexpected State'**
  String get selUnexpectedState;

  /// Fallback seller display name.
  ///
  /// In en, this message translates to:
  /// **'Ayady Seller'**
  String get selAyadySeller;

  /// Snackbar message when terms not accepted.
  ///
  /// In en, this message translates to:
  /// **'Please agree to the Terms of Service'**
  String get selPleaseAgreeToTerms;

  /// Default validation message for required fields.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get selThisFieldIsRequired;

  /// AppBar title for manage products screen.
  ///
  /// In en, this message translates to:
  /// **'Manage Products'**
  String get selManageProducts;

  /// Empty state text when no products found.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get selNoProductsFound;
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
