import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<PermissionStatus> requestPermission(Permission permission) async {
    PermissionStatus _permissionStatus = PermissionStatus.denied;
    _permissionStatus = await permission.request();
    return _permissionStatus;
  }
}
