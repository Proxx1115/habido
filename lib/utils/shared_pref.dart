import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'func.dart';
import 'globals.dart';

SharedPreferences? sharedPref;

class SharedPrefKey {
  static const String theme = 'theme';
  static const String introLimit = 'introLimit';

  /// Auth
  static const String phoneNumber = 'phoneNumber';
  static const String password = 'password';
  static const String rememberMe = 'rememberMe';
  static const String biometricAuth = 'useBiometric';
  static const String sessionToken = 'sessionToken'; // Session token

  /// Push notification
  static const String pushNotifToken = 'pushNotifToken'; // Google firebase push notification token
  static const String registeredPushNotifToken = 'registeredPushNotifToken'; // Өмнө нь server рүү бүртгүүлсэн эсэх

  /// Habit
  static const String habitProgressValue = 'habitProgressValue'; // Ус уусан тоо etc...

  /// Showcase
  static const String showcase = 'showcase'; // Showcase харуулсан эсэх
}

class SharedPref {
  static String getSessionToken() {
    // return '';
    return sharedPref?.getString(SharedPrefKey.sessionToken) ?? '';
  }

  static void setSessionToken(String? sessionToken) {
    sharedPref?.setString(SharedPrefKey.sessionToken, Func.toStr(sessionToken));
  }

  static bool checkIntroLimit() {
    // sharedPref?.clear();

    // Intro 1 удаа харуулсан эсэхийг шалгана
    var res = (sharedPref?.getInt(SharedPrefKey.introLimit) ?? 0) < 1;

    // Intro харуулсан тоог ахиулах
    int introCount = sharedPref?.getInt(SharedPrefKey.introLimit) ?? 0;
    introCount++;
    sharedPref?.setInt(SharedPrefKey.introLimit, introCount);

    return res;
  }

  static String getPhoneNumber() {
    return sharedPref?.getString(SharedPrefKey.phoneNumber) ?? '';
  }

  static void setPhoneNumber(String? phoneNumber) {
    sharedPref?.setString(SharedPrefKey.phoneNumber, phoneNumber ?? '');
  }

  static void setBiometricAuth(bool? value) {
    sharedPref?.setBool(SharedPrefKey.biometricAuth, value ?? false);
  }

  static bool getBiometricAuth() {
    return sharedPref?.getBool(SharedPrefKey.biometricAuth) ?? false;
  }

  static void setUseBiometrics(bool? useBiometric) {
    sharedPref?.setBool(SharedPrefKey.biometricAuth, useBiometric ?? false);
  }

  static bool getShowcaseHasShown(String showcaseName) {
    // return false;
    return sharedPref?.getBool(SharedPrefKey.showcase + '_$showcaseName') ?? false;
  }

  static void setShowcaseHasShown(String showcaseName, bool hasShown) {
    sharedPref?.setBool(SharedPrefKey.showcase + '_$showcaseName', hasShown);
  }

  // static String getPassword() {
  //   return Func.fromBase64Str(sharedPref?.getString(SharedPrefKey.password) ?? '');
  // }
  //
  // static void setPassword(String? password) {
  //   sharedPref?.setString(SharedPrefKey.password, Func.toBase64Str(password ?? ''));
  // }

  static String getPushNotifToken() {
    return sharedPref?.getString(SharedPrefKey.pushNotifToken) ?? '';
  }

  static void setPushNotifToken(String? pushNotifToken) {
    sharedPref?.setString(SharedPrefKey.pushNotifToken, pushNotifToken ?? '');
  }

  static bool getRegisteredPushNotifToken() {
    if (Func.isNotEmpty(globals.userData?.phone)) {
      return sharedPref?.getBool(SharedPrefKey.registeredPushNotifToken + '_${globals.userData!.phone!}') ?? false;
    }

    return false;
  }

  static void setRegisteredPushNotifToken(bool value) {
    if (Func.isNotEmpty(globals.userData?.phone)) {
      sharedPref?.setBool(SharedPrefKey.registeredPushNotifToken + '_${globals.userData!.phone!}', value);
    }
  }

  static String getHabitProgressValue(int userHabitId) {
    var today = Func.toDateStr(DateTime.now());
    return sharedPref?.getString('${Func.toStr(userHabitId)}_${today}_${SharedPrefKey.habitProgressValue}') ?? '';
  }

  static void setHabitProgressValue(int? userHabitId, String? value) {
    if (userHabitId != null && value != null) {
      var today = Func.toDateStr(DateTime.now());
      sharedPref?.setString('${Func.toStr(userHabitId)}_${today}_${SharedPrefKey.habitProgressValue}', value);
    }
  }
}
