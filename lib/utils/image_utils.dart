import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'file_utils.dart';
import 'permission_utils.dart';

class ImageUtils {
  static Future<String> getBase64Image(BuildContext context, ImageSource imageSource) async {
    String res = '';

    // Permission
    PermissionStatus? permissionStatus;
    if (imageSource == ImageSource.camera) {
      permissionStatus = await Permission.camera.status;
      if (permissionStatus.isDenied) {
        permissionStatus = await PermissionUtils.requestPermission(Permission.camera);
      }
    } else if (imageSource == ImageSource.gallery) {
      permissionStatus = await Permission.camera.status;
      if (permissionStatus.isDenied) {
        permissionStatus = await PermissionUtils.requestPermission(Permission.storage);
      }
    }

    if (permissionStatus?.isGranted ?? false) {
      try {
        // Зураг авах
        ImagePicker imagePicker = new ImagePicker();
        var pickedFile = await imagePicker.pickImage(
          source: imageSource,
          maxHeight: 500.0,
          maxWidth: 500.0,
          imageQuality: 100,
        );

        // Convert base64
        if (pickedFile != null) {
          var imageFile = File(pickedFile.path);
          res = FileUtils.fileToBase64(imageFile) ?? '';
        }
      } catch (e) {
        print(e);
      }
    }

    return res;
  }

  static Image base64ToImage(String base64String, {BoxFit? fit, double? height, double? width}) {
    return Image.memory(
      base64Decode(base64String),
      fit: fit,
      height: height,
      width: width,
    );
  }
}
