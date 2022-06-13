import 'package:habido_app/models/base_response.dart';
import 'package:habido_app/models/content_tag_v2.dart';
import 'base_response.dart';
import 'content.dart';

class ContentTagsResponse extends BaseResponse {
  List<ContentTagV2>? contentTags;

  ContentTagsResponse({this.contentTags});

  ContentTagsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    if (json['data'] != null) {
      contentTags = [];
      json['data'].forEach((v) {
        contentTags?.add(ContentTagV2.fromJson(v));
        // print('test');
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (contentTags != null) {
      map['data'] = contentTags?.map((v) => v.toJson()).toList();
    }

    return map;
  }
}
