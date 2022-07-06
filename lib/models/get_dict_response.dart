import 'package:habido_app/utils/api/api_helper.dart';

import 'base_response.dart';
import 'dictionary.dart';

class GetDictResponse extends BaseResponse {
  List<DictData>? dict;

  GetDictResponse({this.dict});

  GetDictResponse.fromJson(Map<String, dynamic> json) {
    try {
      // dict = List<DictData>();
      if (json['data'] != null) {
        json['data'].forEach((v) {
          dict!.add(DictData.fromJson(v));
        });
      }

      if (dict != null && dict!.isNotEmpty) {
        code = ResponseCode.Success;
        message = 'Success';
      }
    } catch (e) {
      code = ResponseCode.Failed;
      message = 'Өгөгдөл байхгүй байна';
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
