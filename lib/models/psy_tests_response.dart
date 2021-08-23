import 'package:habido_app/models/base_response.dart';

import 'content.dart';
import 'psy_test.dart';

class PsyTestsResponse extends BaseResponse {
  Content? content;
  List<PsyTest>? psyTestList;

  PsyTestsResponse({
    this.psyTestList,
  });

  PsyTestsResponse.fromJson(dynamic json) {
    parseBaseParams(json);

    content = json['content'] != null ? Content.fromJson(json['content']) : null;

    if (json['tests'] != null) {
      psyTestList = [];
      json['tests'].forEach((v) {
        psyTestList?.add(PsyTest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};

    if (psyTestList != null) {
      map['data'] = psyTestList?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
