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
