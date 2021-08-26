import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'func.dart';

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

}

class SharedPref {
  static String getSessionToken() {
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

  static String getPassword() {
    return Func.fromBase64Str(sharedPref?.getString(SharedPrefKey.password) ?? '');
  }

  static void setPassword(String? password) {
    sharedPref?.setString(SharedPrefKey.password, Func.toBase64Str(password ?? ''));
  }

  static String getPushNotifToken() {
    return sharedPref?.getString(SharedPrefKey.pushNotifToken) ?? '';
  }

  static void setPushNotifToken(String? pushNotifToken) {
    sharedPref?.setString(SharedPrefKey.pushNotifToken, pushNotifToken ?? '');
  }

  static bool getRegisteredPushNotifToken() {
    return sharedPref?.getBool(SharedPrefKey.registeredPushNotifToken) ?? false;
  }

  static void setRegisteredPushNotifToken(bool value) {
    sharedPref?.setBool(SharedPrefKey.registeredPushNotifToken, value);
  }
}
