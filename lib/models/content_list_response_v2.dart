import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/content_v2.dart';

class ContentListResponseV2 extends BaseResponse {
  List<ContentV2>? contentList;

  ContentListResponseV2({this.contentList});

  ContentListResponseV2.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      contentList = [];
      json['data'].forEach((v) {
        contentList?.add(ContentV2.fromJson(v));
        // print('test');
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (contentList != null) {
      map['data'] = contentList?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
