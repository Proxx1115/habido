import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:habido_app/models/register_device_request.dart';
import 'package:habido_app/utils/api/api_manager.dart';
import 'package:habido_app/utils/localization/localization.dart';
import 'package:habido_app/utils/shared_pref.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'func.dart';

class DeviceHelper {
  static String? deviceId;
  static String? deviceName;
  static String? pushNotifToken;

  static Future init() async {
    try {
      /// Device Id
      DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        var androidInfo = await deviceInfoPlugin.androidInfo;
        deviceId = androidInfo.androidId;
        deviceName = androidInfo.model;
      } else if (Platform.isIOS) {
        var iosInfo = await deviceInfoPlugin.iosInfo;
        deviceId = iosInfo.identifierForVendor;
        deviceName = DeviceHelper.getIosDeviceName(iosInfo.model);
      }

      /// Push notif token
      pushNotifToken = SharedPref.getPushNotifToken();
    } catch (e) {
      print(e);
    }
  }

  /// Register device
  static Future<void> registerDeviceToken() async {
    DeviceHelper.pushNotifToken = SharedPref.getPushNotifToken();

    // Validation
    if (Func.isEmpty(DeviceHelper.deviceId) || Func.isEmpty(DeviceHelper.pushNotifToken)) {
      print('empty');
      return;
    }

    bool isRegistered = SharedPref.getRegisteredPushNotifToken();
    if (isRegistered) {
      print('Already registered');
      return;
    }

    // Register device
    var request = RegisterDeviceRequest()
      ..deviceId = DeviceHelper.deviceId
      ..deviceName = DeviceHelper.deviceName
      ..appName = LocaleKeys.appName
      ..appVersion = await DeviceHelper.getAppVersion()
      ..pushNotifToken = DeviceHelper.pushNotifToken
      ..expireTime = '2030-01-01'
      // ..otherData = ''
      ..isBiometric = false;

    ApiManager.registerDevice(request);
  }

//   else {
//   print('failed');
//   }
// }

  static String getDeviceType() {
    if (Platform.isAndroid)
      return "A";
    else if (Platform.isIOS)
      return 'I';
    else
      return '';
  }

  static String getDeviceName() {
    if (Platform.isAndroid)
      return "Android device";
    else if (Platform.isIOS)
      return 'iOS device';
    else
      return '';
  }

  static Future<String> getAppVersion() async {
    var res = '';
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      res = packageInfo.version;
    } catch (e) {
      print(e);
    }
    return res;
  }

  static Future<String> getBuildNumber() async {
    var res = '';
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      res = packageInfo.buildNumber;
    } catch (e) {
      print(e);
    }
    return res;
  }

  static String getIosDeviceName(String identifier) {
// https://gist.github.com/adamawolf/3048717

    switch (identifier) {

      /// iPod
      case 'iPod5,1':
        return 'iPod Touch 5';

      case 'iPod7,1':
        return 'iPod Touch 6';

      /// iPhone
      case 'iPhone3,1':
      case 'iPhone3,2':
      case 'iPhone3,3':
        return 'iPhone 4';

      case 'iPhone4,1':
        return 'iPhone 4s';

      case 'iPhone5,1':
      case 'iPhone5,2':
        return 'iPhone 5';

      case 'iPhone5,3':
      case 'iPhone5,4':
        return 'iPhone 5c';

      case 'iPhone6,1':
      case 'iPhone6,2':
        return 'iPhone 5s';

      case 'iPhone7,2':
        return 'iPhone 6';

      case 'iPhone7,1':
        return 'iPhone 6 Plus';

      case 'iPhone8,1':
        return 'iPhone 6s';

      case 'iPhone8,2':
        return 'iPhone 6s Plus';

      case 'iPhone8,4':
        return 'iPhone SE';

      case 'iPhone9,1':
      case 'iPhone9,3':
        return 'iPhone 7';

      case 'iPhone9,2':
      case 'iPhone9,4':
        return 'iPhone 7 Plus';

      case 'iPhone10,1':
      case 'iPhone10,4':
        return 'iPhone 8';

      case 'iPhone10,2':
      case 'iPhone10,5':
        return 'iPhone 8 Plus';

      case 'iPhone10,3':
      case 'iPhone10,6':
        return 'iPhone X';

      case 'iPhone11,2':
        return 'iPhone XS';

      case 'iPhone11,4':
      case 'iPhone11,6':
        return 'iPhone XS Max';

      case 'iPhone11,8':
        return 'iPhone XR';

      case 'iPhone12,1':
        return 'iPhone 11';

      case 'iPhone12,3':
        return 'iPhone 11 Pro';

      case 'iPhone12,5':
        return 'iPhone 11 Pro Max';

      case 'iPhone12,8':
        return 'iPhone SE 2nd Gen';

      case 'iPhone13,1':
        return 'iPhone 12 Mini';

      case 'iPhone13,2':
        return 'iPhone 12';

      case 'iPhone13,3':
        return 'iPhone 12 Pro';

      case 'iPhone13,4':
        return 'iPhone 12 Pro Max';

      /// iPad
      case 'iPad1,1':
        return 'iPad';

      case 'iPad2,1':
      case 'iPad2,2':
      case 'iPad2,3':
      case 'iPad2,4':
        return 'iPad 2';

      case 'iPad3,1':
      case 'iPad3,2':
      case 'iPad3,3':
        return 'iPad 3';

      case 'iPad3,4':
      case 'iPad3,5':
      case 'iPad3,6':
        return 'iPad 4';

      case 'iPad4,1':
      case 'iPad4,2':
      case 'iPad4,3':
        return 'iPad Air';

      case 'iPad5,3':
      case 'iPad5,4':
        return 'iPad Air 2';

      case 'iPad2,5':
      case 'iPad2,6':
      case 'iPad2,7':
        return 'iPad Mini';

      case 'iPad4,4':
      case 'iPad4,5':
      case 'iPad4,6':
        return 'iPad Mini 2';

      case 'iPad4,7':
      case 'iPad4,8':
      case 'iPad4,9':
        return 'iPad Mini 3';

      case 'iPad5,1':
      case 'iPad5,2':
        return 'iPad Mini 4';

      case 'iPad6,11':
      case 'iPad6,12':
        return 'iPad';

      case 'iPad7,1':
      case 'iPad7,2':
      case 'iPad7,3':
      case 'iPad7,4':
      case 'iPad6,3':
      case 'iPad6,4':
      case 'iPad6,7':
      case 'iPad6,8':
        return 'iPad Pro';

      case 'iPad7,5':
      case 'iPad7,6':
        return 'iPad (6th generation)';

      /// AppleTv
      case 'AppleTV5,3':
        return 'Apple TV';

      /// Simulator
      case 'i386':
      case 'x86_64':
        return 'Simulator';

      default:
        return identifier;
    }
  }
}
