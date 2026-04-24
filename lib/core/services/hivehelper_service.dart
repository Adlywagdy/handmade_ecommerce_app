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

  /// Open a Hive box by name
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
