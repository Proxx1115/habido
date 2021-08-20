import 'package:habido_app/models/base_response.dart';

import 'content.dart';
import 'test.dart';

class CategoryTestsResponse extends BaseResponse {
  Content? content;
  List<Test>? tests;

  CategoryTestsResponse({this.content, this.tests});

  CategoryTestsResponse.fromJson(dynamic json) {
    parseBaseParams(json);
    content = json['content'] != null ? Content.fromJson(json['content']) : null;
    if (json['tests'] != null) {
      tests = [];
      json['tests'].forEach((v) {
        tests?.add(Test.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (content != null) {
      map['content'] = content?.toJson();
    }
    if (tests != null) {
      map['tests'] = tests?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
