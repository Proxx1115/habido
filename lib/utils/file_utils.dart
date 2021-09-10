import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class FileUtils {
  static String? fileToBase64(File? imageFile) {
    String? res;
    try {
      if (imageFile != null) {
        res = base64.encode(imageFile.readAsBytesSync());
      }
    } catch (e) {
      print(e);
    }

    return res;
  }

  static String bytesToBase64(Uint8List? bytes) {
    var res = '';
    try {
      if (bytes != null) {
        res = base64.encode(bytes);
      }
    } catch (e) {
      print(e);
    }

    return res;
  }
}
