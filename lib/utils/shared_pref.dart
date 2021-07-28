import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'func.dart';

SharedPreferences? sharedPref;

class SharedPrefKey {
  static const String theme = 'theme';
  static const String introLimit = 'introLimit';
  static const String pushNotificationToken = 'pushNotificationToken'; // Google firebase push notification token

  /// Auth
  static const String phoneNumber = 'phoneNumber';
  static const String password = 'password';
  static const String rememberMe = 'rememberMe';
  static const String biometricAuth = 'useBiometric';
  static const String sessionToken = 'sessionToken'; // Session token
}

class SharedPref {
  static String getSessionToken() {
    return sharedPref?.getString(SharedPrefKey.sessionToken) ?? '';
  }

  static void saveSessionToken(String? sessionToken) {
    sharedPref?.setString(SharedPrefKey.sessionToken, Func.toStr(sessionToken));
  }

  static void clearSessionToken() {
    sharedPref?.setString(SharedPrefKey.sessionToken, '');
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

  static void saveBiometricAuth(bool? value) {
    sharedPref?.setBool(SharedPrefKey.biometricAuth, value ?? false);
  }

  static bool getBiometricAuth() {
    return sharedPref?.getBool(SharedPrefKey.biometricAuth) ?? false;
  }

  static void saveUseBiometrics(bool? useBiometric) {
    sharedPref?.setBool(SharedPrefKey.biometricAuth, useBiometric ?? false);
  }

  static String getPassword() {
    return Func.fromBase64Str(sharedPref?.getString(SharedPrefKey.password) ?? '');
  }

  static void savePassword(String? password) {
    sharedPref?.setString(SharedPrefKey.password, Func.toBase64Str(password ?? ''));
  }
}
