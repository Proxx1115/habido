import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/dictionary.dart';

class DataDictResponse extends BaseResponse {
  List<DictData>? dictList;

  DataDictResponse({
    this.dictList,
  });

  DataDictResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    if (json['data'] != null) {
      dictList = [];
      json['data'].forEach((v) {
        dictList?.add(DictData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (dictList != null) {
      map['data'] = dictList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
