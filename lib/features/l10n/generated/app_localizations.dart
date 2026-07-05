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
