import 'dart:io';
import 'package:local_auth/auth_strings.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

class BiometricHelper {
  var localAuth = LocalAuthentication();
  bool canCheckBiometrics = false;
  int availableBiometricsCount = 0;

  static const iosStrings = const IOSAuthMessages(
    cancelButton: 'cancel',
    goToSettingsButton: 'settings',
    goToSettingsDescription: 'Please set up your Touch ID.',
    lockOut: 'Please re-enable your Touch ID',
  );

  BiometricHelper() {
    initBiometrics();
  }

  initBiometrics() async {
    try {
      // Тухайн төхөөрөмж biometric-тэй эсэх
      canCheckBiometrics = await localAuth.canCheckBiometrics;

      // Тухайн төхөөрөмжид идэвхтэй ажиллаж байгаа биометр байгаа эсэх
      if (canCheckBiometrics) {
        List<BiometricType> availableBiometricList = <BiometricType>[];
        availableBiometricList = await localAuth.getAvailableBiometrics();
        availableBiometricsCount = availableBiometricList.length;
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Indicates the device does not have a Touch ID/fingerprint scanner.
      }
    }
  }

  Future<bool> checkBiometrics() async {
    bool isAuthenticated = false;

    try {
      isAuthenticated = await localAuth.authenticateWithBiometrics(
        localizedReason: 'Biometric auth',
        useErrorDialogs: true,
        // stickyAuth state нь хэзээ ч дуусдаггүй. өмнө нь прогресс ажиллаж байсан бол түүнийг дахиж дуудна. хэрэв давхар дуудвал алдаа гарна.
        stickyAuth: true,
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        // Indicates the device does not have a Touch ID/fingerprint scanner.
      }
    }

    return isAuthenticated;
  }

  void _cancelAuthentication() {
    localAuth.stopAuthentication();
  }
}

// Strings
//  var androidStrings = AndroidAuthMessages(
//    fingerprintHint: ' ',
//    //Touch sensor
//    fingerprintNotRecognized: loc.fpnotrecognized(),
//    //Fingerprint not recognized. Try again
//    fingerprintSuccess: loc.success(),
//    //Fingerprint recognized.
//    cancelButton: loc.btnCancel(),
//    signInTitle: loc.loginByBiometric(),
//    //Fingerprint Authentication
//    fingerprintRequiredTitle: loc.fpRequired(),
//    //Fingerprint required
//    goToSettingsButton: loc.goToSettings(),
//    // Go to settings
//    goToSettingsDescription: loc.goToSettingsDescription(),
//  );
//
//  var iosStrings = IOSAuthMessages(
//    lockOut: loc.lockOut(),
//    goToSettingsButton: loc.goToSettings(),
//    goToSettingsDescription: loc.goToSettingsDescriptionIOS(),
//    cancelButton: loc.btnOk(),
//  );
