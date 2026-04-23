
import 'package:hive/hive.dart';

class HiveHelper {
  static const onboardingBox = "onboardingBox";
  static const login = "login";

  static void setOnboardingBoxValue() {
    Hive.box(onboardingBox).put(onboardingBox, true);
  }

  static bool getOnboardingBoxValue() {
    if (Hive.box(onboardingBox).isNotEmpty) {
      return Hive.box(onboardingBox).get(onboardingBox);
    } else {
      return false;
    }
  }

static void setTokenBox() {
    Hive.box(login).put(login, true);
  }

  static bool getTokenBox() {
    if (Hive.box(login).isNotEmpty) {
      return Hive.box(login).get(login);
    } else {
      return false;
    }
  }
}
