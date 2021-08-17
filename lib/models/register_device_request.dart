import 'package:habido_app/models/base_request.dart';

class RegisterDeviceRequest extends BaseRequest {
  String? deviceId;
  String? deviceName;
  String? appName;
  String? appVersion;
  String? pushNotifToken;
  String? expireTime;
  String? otherData;
  bool? isBiometric;

  RegisterDeviceRequest(
      {this.deviceId,
      this.deviceName,
      this.appName,
      this.appVersion,
      this.pushNotifToken,
      this.expireTime,
      this.otherData,
      this.isBiometric});

  RegisterDeviceRequest.fromJson(dynamic json) {
    deviceId = json['deviceId'];
    deviceName = json['deviceName'];
    appName = json['appName'];
    appVersion = json['appVersion'];
    pushNotifToken = json['pushNotifToken'];
    expireTime = json['expireTime'];
    otherData = json['otherData'];
    isBiometric = json['isBiometric'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['deviceId'] = deviceId;
    map['deviceName'] = deviceName;
    map['appName'] = appName;
    map['appVersion'] = appVersion;
    map['pushNotifToken'] = pushNotifToken;
    map['expireTime'] = expireTime;
    map['otherData'] = otherData;
    map['isBiometric'] = isBiometric;
    return map;
  }
}
