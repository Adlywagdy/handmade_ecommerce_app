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

  String get skip;
  String get next;
  String get getStarted;
  String get discoverUniqueHandmadeItems;
  String get supportLocalArtisans;
  String get shopWithConfidence;
  String get exploreThousandsHandcraftedProducts;
  String get connectDirectlyWithMakers;
  String get securePaymentsVerifiedSellers;
  String get filterAndSort;
  String get rating;
  String get priceSort;
  String get any;
  String get to;
  String get min;
  String get max;
  String get cancel;
  String get apply;
  String get mustBePositive;
  String get updateRequired;
  String get pleaseUpdateAppToContinue;
  String get update;
  String get somethingWentWrong;
  String get technicalDifficulties;
  String get goBack;
  String get noInternetConnection;
  String get offlineMessage;
  String get retryConnection;
  String get welcomeToAyady;
  String get pleaseEnterYourDetailsToContinue;
  String get emailAddress;

  String get emailIsntValid;
  String get password;
  String get forgotPassword;
  String get loginSuccess;
  String get googleSignInSuccess;
  String get signIn;
  String get orContinueWith;
  String get google;
  String get dontHaveAnAccount;
  String get signUp;
  String get createAccount;
  String get experienceTheEleganceOfHandcraftedItems;
  String get fullName;
  String get johnDoe;
  String get nameIsRequired;
  String get emailIsRequired;
  String get passwordIsRequired;
  String get passwordShouldBeMoreThan5Letters;
  String get registerAs;
  String get customer;
  String get seller;
  String get agreeToTerms;
  String get accountCreatedSuccessfully;
  String get youMustAgreeToTheTermsFirst;
  String get pleaseChooseCustomerOrSellerFirst;
  String get alreadyHaveAnAccount;
  String get logIn;
  String get joinAyady;
  String get passwordRecovery;
  String get passwordRecoveryDescription;
  String get sendCode;
  String get createNewPassword;
  String get createNewPasswordDescription;
  String get verifyItsYou;
  String get verificationCodeSentToEmail;
  String get youCanResendCodeAfterOneMinute;
  String get confirm;
  String get retypePassword;
  String get passwordMustBeAtLeast6Characters;
  String get pleaseConfirmYourPassword;
  String get passwordsDoNotMatch;
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
