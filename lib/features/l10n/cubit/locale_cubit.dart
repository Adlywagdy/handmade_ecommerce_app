import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../core/services/hivehelper_service.dart';

/// The selected language is persisted in Hive so it survives restarts and
/// applies to every user type (admin / seller / customer) on this device.
class LocaleCubit extends Cubit<Locale?> {
  LocaleCubit() : super(null);

  void loadSavedLocale() {
    final saved = HiveHelper.getLanguageBoxValue();
    if (saved == null || saved.isEmpty) {
      emit(null);
    } else {
      emit(Locale(saved));
    }
  }

  void switchToEnglish() {
    HiveHelper.setLanguageBoxValue('en');
    emit(const Locale('en'));
    Get.updateLocale(const Locale('en'));
  }

  void switchToArabic() {
    HiveHelper.setLanguageBoxValue('ar');
    emit(const Locale('ar'));
    Get.updateLocale(const Locale('ar'));
  }

  void followDeviceLanguage() {
    HiveHelper.clearLanguageBox();
    emit(null);
    final device = Get.deviceLocale;
    if (device != null) Get.updateLocale(device);
  }
}
