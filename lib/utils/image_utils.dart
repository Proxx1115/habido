import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'file_utils.dart';
import 'permission_utils.dart';

class ImageUtils {
  static Future<String> getBase64Image(BuildContext context) async {
    String res = '';

    // Ask permission
    var status = await Permission.camera.status;
    if (status.isDenied) {
      await PermissionUtils.requestPermission(Permission.camera);
    }

    // Check permission
    if (await Permission.camera.request().isGranted) {
      try {
        // Зураг авах
        ImagePicker imagePicker = new ImagePicker();
        var pickedFile = await imagePicker.pickImage(
          source: ImageSource.camera,
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
