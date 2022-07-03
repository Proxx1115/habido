import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/tip%20category.dart';

class TipResponse extends BaseResponse {
  List<TipCategory>? tipList;

  TipResponse({this.tipList});

  TipResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      tipList = [];
      json['data'].forEach((v) {
        tipList?.add(TipCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (tipList != null) {
      map['data'] = tipList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
