import 'package:habido_app/models/base_response.dart';
import 'content.dart';

class ContentListResponse extends BaseResponse {
  List<Content>? contentList;

  ContentListResponse({this.contentList});

  ContentListResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      contentList = [];
      json['data'].forEach((v) {
        contentList?.add(Content.fromJson(v));
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
