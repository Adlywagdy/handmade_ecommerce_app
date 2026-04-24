import 'package:hive/hive.dart';

class HiveHelper {
  static const onboardingBox = "onboardingBox";
  static const login = "login";
  static const email = "email";

  static void setOnboardingBox() {
    Hive.box(onboardingBox).put(onboardingBox, true);
  }

  static bool getOnboardingBox() {
    return Hive.box(onboardingBox).get(onboardingBox, defaultValue: false);
  }

  static void setLoginBox({required bool value}) {
    Hive.box(login).put(login, value);
  }

  static bool getLoginBox() {
    return Hive.box(login).get(login, defaultValue: false);
  }

  static void setEmailBoxValue(String mail) {
    Hive.box(email).put(email, mail);
  }

  static String getEmailBoxValue() {
    return Hive.box(email).get(email, defaultValue: '');
  }

  static void clearEmailBox() {
    Hive.box(email).delete(email);
  }
}

/// Generic Hive helper service for opening and managing Hive boxes
class HiveHelperService {
  HiveHelperService._();

  /// Box name constants
  static const String notificationsBox = 'notifications';
  static const String loginBoxName = 'loginBox';
  static const String emailBoxName = 'emailBox';

  /// Specific Methods for App Logic
  
  /// Set the login status
  static Future<void> setLoginBox({required bool value}) async {
    var box = await openBox(loginBoxName);
    await box.put('isLoggedIn', value);
  }

  /// Get the login status
  static Future<bool> getLoginBox() async {
    var box = await openBox(loginBoxName);
    return box.get('isLoggedIn', defaultValue: false);
  }

  /// Save email
  static Future<void> setEmailBox(String email) async {
    var box = await openBox(emailBoxName);
    await box.put('email', email);
  }

  /// Clear email
  static Future<void> clearEmailBox() async {
    var box = await openBox(emailBoxName);
    await box.delete('email');
  }

  /// Get saved email
  static Future<String?> getEmailBox() async {
    var box = await openBox(emailBoxName);
    return box.get('email');
  }

  /// Generic Methods
  static Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }
    return await Hive.openBox<T>(boxName);
  }

  /// Get an already opened box
  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Check if a box is open
  static bool isBoxOpen(String boxName) {
    return Hive.isBoxOpen(boxName);
  }

  /// Close a specific box
  static Future<void> closeBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
  }

  /// Close all open boxes
  static Future<void> closeAll() async {
    await Hive.close();
  }
}
