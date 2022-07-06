import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/utils/api/api_helper.dart';

import 'dictionary.dart';

class GetDictListResponse extends BaseResponse {
  List<Dict>? dictList;

  GetDictListResponse({this.dictList});

  GetDictListResponse.fromJson(Map<String, dynamic> json) {
    try {
      dictList = <Dict>[];
      if (json[ResponseHelper.data] != null) {
        json[ResponseHelper.data].forEach((v) {
          dictList!.add(Dict.fromJson(v));
        });
      }

      if (dictList != null && dictList!.isNotEmpty) {
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

class Dict {
  String? dictCode;
  List<DictData>? items;

  Dict({this.dictCode, this.items});

  Dict.fromJson(Map<String, dynamic> json) {
    dictCode = json['dictCode'];
    if (json['items'] != null) {
      items = <DictData>[];
      json['items'].forEach((v) {
        items!.add(new DictData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dictCode'] = this.dictCode;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
